import 'package:camera/camera.dart';

class CameraDiagnostic {
  List<CameraDescription> cameras = [];

  CameraController? controller;

  bool detected = false;
  bool initialized = false;
  bool photoTaken = false;

  String message = 'No probado';

  Future<void> initialize() async {
    try {
      cameras = await availableCameras();

      if (cameras.isEmpty) {
        detected = false;
        message = 'No se detectaron cámaras';
        return;
      }

      detected = true;

      final backCamera = cameras.firstWhere(
        (camera) =>
            camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller!.initialize();

      initialized = true;
      message = 'Cámara funcionando correctamente';
    } catch (e) {
      detected = false;
      initialized = false;
      message = 'Error al inicializar la cámara';
    }
  }

  Future<bool> takePhoto() async {
    if (controller == null ||
        !controller!.value.isInitialized) {
      return false;
    }

    try {
      await controller!.takePicture();

      photoTaken = true;
      message = 'Fotografía capturada correctamente';

      return true;
    } catch (e) {
      message = 'No se pudo tomar la fotografía';
      return false;
    }
  }

  Future<void> dispose() async {
    await controller?.dispose();
    controller = null;
  }
}