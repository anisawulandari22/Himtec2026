import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../models/disease_detection_model.dart';

class ScanResultSheet extends StatelessWidget {
  final DiseaseDetectionResult result;
  final VoidCallback onScanAgain;

  const ScanResultSheet({
    super.key,
    required this.result,
    required this.onScanAgain,
  });

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'kritis':
        return const Color(0xFFBA1A1A);
      case 'tinggi':
      case 'sedang':
        return const Color(0xFFC26D00);
      case 'rendah':
        return const Color(0xFF2E7D32);
      case 'normal':
      case 'sehat':
        return const Color(0xFF196B4A);
      default:
        return const Color(0xFF526921);
    }
  }

  Color _getSeverityBgColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'kritis':
        return const Color(0xFFFFDAD6);
      case 'tinggi':
      case 'sedang':
        return const Color(0xFFFFE0B2);
      case 'rendah':
      case 'normal':
      case 'sehat':
        return const Color(0xFFEAF3E7);
      default:
        return const Color(0xFFEFF4DA);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final severityColor = _getSeverityColor(result.severity);
    final severityBgColor = _getSeverityBgColor(result.severity);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HASIL DIAGNOSA GEMINI AI',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      result.cropName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: severityBgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: severityColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    result.severity.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: severityColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: colorScheme.outlineVariant),

          // Scrollable Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              children: [
                // Image preview if available
                if (result.imagePath != null && File(result.imagePath!).existsSync())
                  Container(
                    height: 170,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: DecorationImage(
                        image: FileImage(File(result.imagePath!)),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                  ),

                // Main Disease Alert Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: severityBgColor.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: severityColor.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              result.diseaseName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: severityColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.auto_awesome, size: 12, color: Color(0xFF196B4A)),
                                const SizedBox(width: 4),
                                Text(
                                  '${result.confidence}% Yakin',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF196B4A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result.condition,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.summary,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Symptoms Section
                if (result.symptoms.isNotEmpty) ...[
                  _buildSectionHeader('GEJALA VISUAL TERDETEKSI', colorScheme),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Column(
                      children: result.symptoms.map((symptom) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.lens, size: 7, color: Color(0xFF196B4A)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  symptom,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurface,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Organic Solutions Section
                if (result.organicSolutions.isNotEmpty) ...[
                  _buildSectionHeader('SOLUSI ORGANIK & PENANGANAN SEGERA', colorScheme),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF3E7),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFDFE6DA)),
                    ),
                    child: Column(
                      children: result.organicSolutions.map((sol) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.check_circle_outline, size: 16, color: Color(0xFF196B4A)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  sol,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF17352B),
                                    fontWeight: FontWeight.w600,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Prevention Tips Section
                if (result.preventionTips.isNotEmpty) ...[
                  _buildSectionHeader('LANGKAH PENCEGAHAN JANGKA PANJANG', colorScheme),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colorScheme.outlineVariant),
                    ),
                    child: Column(
                      children: result.preventionTips.map((tip) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.shield_outlined, size: 16, color: Color(0xFF72827C)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  tip,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Bottom Action Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onScanAgain();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Pindai Ulang', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Diagnosa disimpan ke catatan pengamatan kebun.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                    label: const Text('Simpan Diagnosa', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 1.0,
      ),
    );
  }
}

