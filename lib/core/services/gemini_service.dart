import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../../models/disease_detection_model.dart';

class GeminiService {
  GeminiService._();

  // Pengguna dapat mengganti API key langsung dari UI atau di sini.
  // API key gratis diperoleh dari https://aistudio.google.com/
  static String _apiKey = '';

  static String get apiKey => _apiKey;
  static bool get hasCustomKey => _apiKey.trim().isNotEmpty;

  static void setApiKey(String key) {
    _apiKey = key.trim();
  }

  static const String _model = 'gemini-1.5-flash';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  /// Menganalisis gambar tanaman untuk mendeteksi hama / penyakit / defisiensi nutrisi
  static Future<DiseaseDetectionResult> analyzeCropDisease({
    required Uint8List imageBytes,
    String mimeType = 'image/jpeg',
    String? imagePath,
  }) async {
    final keyToUse = _apiKey.trim();

    if (keyToUse.isEmpty) {
      // Jika user belum memasukkan API key, berikan hasil sampel diagnosa
      // beserta instruksi ramah untuk memasukkan API key gratis mereka.
      return _getDemoFallbackResult(
        imagePath: imagePath,
        reason: 'API Key Gemini belum disetel. Masukkan Google AI Studio API Key gratis Anda pada ikon kunci di pojok atas untuk pemindaian langsung berbasis awan.',
      );
    }

    final url = Uri.parse('$_baseUrl/$_model:generateContent?key=$keyToUse');

    final base64Image = base64Encode(imageBytes);

    const systemPrompt = '''
Anda adalah dokter tanaman, agronomis, dan ahli patologi pertanian terkemuka di Indonesia.
Analisis foto daun atau bagian tanaman ini dengan cermat dan mendalam.

Berikan diagnosa dalam format JSON murni tanpa pembungkus teks tambahan, dengan struktur wajib:
{
  "cropName": "Nama tanaman (contoh: Cabai Rawit / Padi / Tomat)",
  "condition": "Sehat / Terinfeksi Jamur / Hama Serangga / Bakteri / Defisiensi Nutrisi",
  "diseaseName": "Nama Penyakit atau Hama (contoh: Antraknosa / Patek (Colletotrichum))",
  "severity": "Normal / Rendah / Sedang / Kritis",
  "confidence": 92,
  "symptoms": [
    "Gejala 1 yang terlihat pada daun/buah",
    "Gejala 2"
  ],
  "organicSolutions": [
    "Langkah penanganan nabati/organik 1",
    "Langkah 2"
  ],
  "preventionTips": [
    "Tips pencegahan jangka panjang 1",
    "Tips pencegahan 2"
  ],
  "summary": "Ringkasan diagnosa 1-2 kalimat jelas dan instruktif."
}
''';

    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': systemPrompt},
            {
              'inline_data': {
                'mime_type': mimeType,
                'data': base64Image,
              }
            }
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.2,
        'responseMimeType': 'application/json',
      }
    };

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final candidates = data['candidates'] as List<dynamic>?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'] as Map<String, dynamic>?;
          final parts = content?['parts'] as List<dynamic>?;
          if (parts != null && parts.isNotEmpty) {
            final rawText = parts[0]['text']?.toString() ?? '{}';
            final cleanJsonText = _cleanMarkdownJson(rawText);
            final jsonMap = jsonDecode(cleanJsonText) as Map<String, dynamic>;
            return DiseaseDetectionResult.fromJson(jsonMap, imagePath: imagePath);
          }
        }
        throw Exception('Format respon Gemini tidak terduga.');
      } else {
        final errorMsg = _parseApiError(response.body);
        throw Exception('Gagal menghubungi Gemini ($errorMsg)');
      }
    } catch (e) {
      // Jika terjadi timeout atau error API, tangani dengan fallback informatif
      return _getDemoFallbackResult(
        imagePath: imagePath,
        reason: 'Gagal terhubung ke Gemini API: ${e.toString().replaceAll('Exception:', '').trim()}',
      );
    }
  }

  static String _cleanMarkdownJson(String text) {
    var result = text.trim();
    if (result.startsWith('```json')) {
      result = result.substring(7);
    } else if (result.startsWith('```')) {
      result = result.substring(3);
    }
    if (result.endsWith('```')) {
      result = result.substring(0, result.length - 3);
    }
    return result.trim();
  }

  static String _parseApiError(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;
      final error = json['error'] as Map<String, dynamic>?;
      if (error != null) {
        return error['message']?.toString() ?? 'Error ${error['code']}';
      }
    } catch (_) {}
    return body.length > 100 ? body.substring(0, 100) : body;
  }

  static DiseaseDetectionResult _getDemoFallbackResult({
    String? imagePath,
    String? reason,
  }) {
    return DiseaseDetectionResult(
      cropName: 'Cabai Rawit Merah (Capsicum frutescens)',
      condition: 'Terdeteksi Gejala Awal Jamur',
      diseaseName: 'Antraknosa / Patek Buah (Colletotrichum capsici)',
      severity: 'Sedang',
      confidence: 89,
      symptoms: [
        'Bercak cekung melingkar kehitaman pada permukaan kulit buah cabai',
        'Tepian bercak berwarna kecokelatan basah dan sedikit mengkerut',
        'Ujung daun menunjukkan sedikit klorosis akibat kelembapan berlebih',
      ],
      organicSolutions: [
        'Petik dan musnahkan segera buah cabai yang terinfeksi agar spora jamur tidak menular',
        'Kocorkan agen hayati Trichoderma harzianum pada lubang tanam pangkal batang',
        'Semprotkan fungisida nabati rebusan daun sirih merah (100 gr/liter air) di sore hari',
      ],
      preventionTips: [
        'Jaga jarak tanam minimal 50-60 cm untuk memperlancar sirkulasi udara bedengan',
        'Gunakan mulsa plastik perak-hitam untuk mencegah percikan tanah basah ke buah',
        'Kurangi pemupukan Nitrogen berlebih saat musim hujan, tingkatkan Kalium & Kalsium',
      ],
      summary: reason ??
          'Hasil diagnosa model pengenalan AI. Gejala antraknosa teridentifikasi pada tingkat keparahan sedang.',
      scannedAt: DateTime.now(),
      imagePath: imagePath,
    );
  }
}

