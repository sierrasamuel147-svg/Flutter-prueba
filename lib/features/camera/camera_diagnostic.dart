import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';

class CameraDiagnostic {
  List<CameraDescription> cameras = [];

  CameraController? controller;

  bool detected = false;
  bool initialized = false;
  bool photoTaken = false;
  bool tested = false;
  bool working = false;

  String? photoPath;

  String message = 'No probado';

  Future<bool> runAutomaticTest() async {
    if (initialized) {
      return false;
    }

    try {
      // Reiniciamos el estado.
      detected = false;
      initialized = false;
      photoTaken = false;
      tested = false;
      working = false;
      photoPath = null;

      message = 'Detectando cámaras...';

      // ==========================================================
      // 1. DETECTAR CÁMARAS
      // ==========================================================

      cameras = await availableCameras().timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          throw TimeoutException(
            'Tiempo agotado al detectar cámaras',
          );
        },
      );

      if (cameras.isEmpty) {
        tested = true;
        working = false;
        message = 'No se detectaron cámaras';
        return false;
      }

      detected = true;

      // ==========================================================
      // 2. SELECCIONAR CÁMARA
      // ==========================================================

      final camera = cameras.firstWhere(
        (camera) =>
            camera.lensDirection ==
            CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      message = 'Inicializando cámara...';

      // ==========================================================
      // 3. INICIALIZAR
      // ==========================================================

      controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(
            'Tiempo agotado al inicializar la cámara',
          );
        },
      );

      initialized = true;

      message =
          'Cámara lista. Preparando captura...';

      // ==========================================================
      // 4. ESTABILIZAR CÁMARA
      // ==========================================================

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      if (controller == null ||
          !controller!.value.isInitialized) {
        throw Exception(
          'La cámara dejó de estar disponible',
        );
      }

      // ==========================================================
      // 5. TOMAR FOTOGRAFÍA
      // ==========================================================

      message = 'Tomando fotografía...';

      final XFile photo =
          await controller!.takePicture().timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          throw TimeoutException(
            'Tiempo agotado al tomar la fotografía',
          );
        },
      );

      photoPath = photo.path;

      // ==========================================================
      // 6. VALIDAR ARCHIVO
      // ==========================================================

      final file = File(photo.path);

      if (!await file.exists()) {
        throw Exception(
          'La fotografía no fue creada',
        );
      }

      final fileSize = await file.length();

      if (fileSize <= 0) {
        throw Exception(
          'La fotografía está vacía',
        );
      }

      // ==========================================================
      // 7. RESULTADO
      // ==========================================================

      photoTaken = true;
      tested = true;
      working = true;

      message =
          'Cámara funcionando correctamente';

      return true;
    } catch (e) {
      tested = true;
      working = false;
      photoTaken = false;

      if (e is TimeoutException) {
        message =
            'La cámara tardó demasiado en responder';
      } else {
        message =
            'No se pudo completar la prueba de cámara';
      }

      return false;
    } finally {
      // MUY IMPORTANTE:
      // Liberamos el hardware antes de volver
      // al diagnóstico general.
      await dispose();
    }
  }

  Future<void> dispose() async {
    try {
      await controller?.dispose();
    } catch (_) {}

    controller = null;
    initialized = false;
  }
}