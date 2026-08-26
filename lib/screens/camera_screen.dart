import 'package:flutter/material.dart';

import '../features/camera/camera_diagnostic.dart';

import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final CameraDiagnostic diagnostic = CameraDiagnostic();

  bool loading = true;

  @override
  void initState() {
    super.initState();

    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    await diagnostic.initialize();

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    await diagnostic.takePhoto();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    diagnostic.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cámara'),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (!diagnostic.detected) {
      return const Center(
        child: Text(
          'No se detectó ninguna cámara',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Diagnóstico de cámara',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          'Cámaras detectadas: ${diagnostic.cameras.length}',
          style: const TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 20),

        if (diagnostic.controller != null &&
            diagnostic.controller!.value.isInitialized)
          AspectRatio(
            aspectRatio:
                diagnostic.controller!.value.aspectRatio,
            child: CameraPreview(
              diagnostic.controller!,
            ),
          ),

        const SizedBox(height: 20),

        Text(
          diagnostic.message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          onPressed: diagnostic.initialized
              ? _takePhoto
              : null,
          icon: const Icon(Icons.camera_alt),
          label: const Padding(
            padding: EdgeInsets.all(14),
            child: Text(
              'Tomar fotografía',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),

        if (diagnostic.photoTaken) ...[
          const SizedBox(height: 15),
          const Text(
            '✓ Cámara: captura realizada correctamente',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}