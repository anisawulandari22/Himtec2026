import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/gemini_service.dart';
import '../../../models/disease_detection_model.dart';
import 'widgets/scan_result_sheet.dart';

class DiseaseScanScreen extends StatefulWidget {
  const DiseaseScanScreen({super.key});

  @override
  State<DiseaseScanScreen> createState() => _DiseaseScanScreenState();
}

class _DiseaseScanScreenState extends State<DiseaseScanScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription> _availableCameras = [];
  bool _isCameraInitialized = false;
  bool _isAnalyzing = false;
  FlashMode _currentFlashMode = FlashMode.off;
  final ImagePicker _imagePicker = ImagePicker();

  late AnimationController _scannerAnimController;
  late Animation<double> _scannerAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();

    _scannerAnimController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(reverse: true);

    _scannerAnimation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(
        parent: _scannerAnimController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerAnimController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _availableCameras = await availableCameras();
      if (_availableCameras.isEmpty) {
        if (mounted) setState(() => _isCameraInitialized = false);
        return;
      }

      // Cari kamera belakang
      final backCamera = _availableCameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => _availableCameras.first,
      );

      final controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      if (!mounted) return;

      setState(() {
        _cameraController = controller;
        _isCameraInitialized = true;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _isCameraInitialized = false);
      }
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      FlashMode nextMode;
      if (_currentFlashMode == FlashMode.off) {
        nextMode = FlashMode.torch;
      } else {
        nextMode = FlashMode.off;
      }
      await _cameraController!.setFlashMode(nextMode);
      setState(() => _currentFlashMode = nextMode);
    } catch (_) {}
  }

  Future<void> _captureAndAnalyze() async {
    if (_isAnalyzing) return;

    Uint8List? imageBytes;
    String? imagePath;

    setState(() => _isAnalyzing = true);

    try {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        final XFile photo = await _cameraController!.takePicture();
        imagePath = photo.path;
        imageBytes = await photo.readAsBytes();
      } else {
        // Fallback jika live camera belum terhubung
        final XFile? photo = await _imagePicker.pickImage(
          source: ImageSource.camera,
          imageQuality: 85,
        );
        if (photo == null) {
          setState(() => _isAnalyzing = false);
          return;
        }
        imagePath = photo.path;
        imageBytes = await photo.readAsBytes();
      }

      final result = await GeminiService.analyzeCropDisease(
        imageBytes: imageBytes,
        imagePath: imagePath,
      );

      if (mounted) {
        _showResultSheet(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kendala saat menganalisis: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    if (_isAnalyzing) return;

    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (photo == null) return;

      setState(() => _isAnalyzing = true);

      final bytes = await photo.readAsBytes();
      final result = await GeminiService.analyzeCropDisease(
        imageBytes: bytes,
        imagePath: photo.path,
      );

      if (mounted) {
        _showResultSheet(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membaca gambar galeri: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  void _showResultSheet(DiseaseDetectionResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ScanResultSheet(
        result: result,
        onScanAgain: () {
          // Siap memindai kembali
        },
      ),
    );
  }

  void _showApiKeyDialog() {
    final controller = TextEditingController(text: GeminiService.apiKey);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.key_rounded, color: Color(0xFF196B4A), size: 22),
            SizedBox(width: 8),
            Text('API Key Gemini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aplikasi telah aktif dengan Real-Time Vision AI Engine bawaan. Anda juga dapat menghubungkan Google Gemini API Key gratis sebagai opsi cloud tambahan:',
              style: TextStyle(fontSize: 12, color: Color(0xFF56625D)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Tempel AIzaSy...',
                labelText: 'Gemini API Key',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tips: Dapatkan kunci gratis tanpa kartu kredit di https://aistudio.google.com/',
              style: TextStyle(fontSize: 10.5, color: Color(0xFF72827C)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF196B4A),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              GeminiService.setApiKey(controller.text);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('API Key Gemini berhasil diperbarui!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              setState(() {});
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Live Camera Preview / Fallback
          if (_isCameraInitialized && _cameraController != null)
            Center(
              child: CameraPreview(_cameraController!),
            )
          else
            Container(
              color: const Color(0xFF121714),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B4D3E).withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_outlined, color: Color(0xFF7CD9B5), size: 48),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Kamera Siap Digunakan',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ketuk tombol shutter di bawah untuk memotret atau pilih foto dari galeri.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFA1ADA5), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 2. Viewfinder Target Frame Overlay
          Center(
            child: Container(
              width: size.width * 0.78,
              height: size.width * 0.78,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  // Corner brackets
                  Positioned(
                    top: -2,
                    left: -2,
                    child: _buildCorner(isTop: true, isLeft: true),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: _buildCorner(isTop: true, isLeft: false),
                  ),
                  Positioned(
                    bottom: -2,
                    left: -2,
                    child: _buildCorner(isTop: false, isLeft: true),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: _buildCorner(isTop: false, isLeft: false),
                  ),

                  // Real-Time Animated Laser Scanner Bar
                  AnimatedBuilder(
                    animation: _scannerAnimation,
                    builder: (context, child) {
                      final boxHeight = size.width * 0.78;
                      return Positioned(
                        top: _scannerAnimation.value * (boxHeight - 6),
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 2.5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xFF7CD9B5),
                                Colors.white,
                                Color(0xFF7CD9B5),
                                Colors.transparent,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7CD9B5).withValues(alpha: 0.8),
                                blurRadius: 8,
                                spreadRadius: 1.5,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 3. Top Controls (Back, Flash, Real-Time AI Badge)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.black.withValues(alpha: 0.5),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF196B4A),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF7CD9B5),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            GeminiService.hasCustomKey ? 'Gemini 1.5 Flash Aktif' : 'AI Real-Time Vision Aktif',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.5),
                          child: IconButton(
                            icon: Icon(
                              _currentFlashMode == FlashMode.torch
                                  ? Icons.flash_on_rounded
                                  : Icons.flash_off_rounded,
                              color: _currentFlashMode == FlashMode.torch
                                  ? Colors.amberAccent
                                  : Colors.white,
                              size: 20,
                            ),
                            onPressed: _toggleFlash,
                          ),
                        ),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          backgroundColor: Colors.black.withValues(alpha: 0.5),
                          child: IconButton(
                            icon: const Icon(Icons.key_rounded, color: Colors.white, size: 20),
                            onPressed: _showApiKeyDialog,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Instructional Banner
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Arahkan daun atau bagian tanaman bergejala ke dalam kotak pemindai',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // 5. Analyzing Loading Indicator Overlay
          if (_isAnalyzing)
            Container(
              color: Colors.black.withValues(alpha: 0.75),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF17201B),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF196B4A)),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: CircularProgressIndicator(
                          color: Color(0xFF7CD9B5),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Mendiagnosa dengan Gemini AI...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Menganalisis tanda bercak, hama, & patogen daun',
                        style: TextStyle(color: Color(0xFFA1ADA5), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 6. Bottom Controls Bar
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Tombol Galeri
                    InkWell(
                      onTap: _pickFromGallery,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.photo_library_outlined, color: Colors.white, size: 24),
                      ),
                    ),

                    // Tombol Shutter Utama
                    GestureDetector(
                      onTap: _captureAndAnalyze,
                      child: Container(
                        width: 82,
                        height: 82,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF196B4A),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.document_scanner_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Tombol Kamera Ulang / Info
                    InkWell(
                      onTap: () {
                        if (_cameraController != null) {
                          _initializeCamera();
                        } else {
                          _captureAndAnalyze();
                        }
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.flip_camera_ios_outlined, color: Colors.white, size: 24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Color(0xFF7CD9B5), width: 3.5)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Color(0xFF7CD9B5), width: 3.5)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Color(0xFF7CD9B5), width: 3.5)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Color(0xFF7CD9B5), width: 3.5)
              : BorderSide.none,
        ),
      ),
    );
  }
}

