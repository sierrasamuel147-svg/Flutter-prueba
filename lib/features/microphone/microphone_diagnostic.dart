import 'dart:io';

import 'package:record/record.dart';

class MicrophoneDiagnostic {
  final AudioRecorder _recorder = AudioRecorder();

  bool permissionGranted = false;
  bool recording = false;
  bool working = false;

  String? recordedFilePath;

  String message = 'No probado';

  Future<void> startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();

      if (!hasPermission) {
        permissionGranted = false;
        working = false;
        message = 'Permiso de micrófono denegado';
        return;
      }

      permissionGranted = true;

      final directory = Directory.systemTemp;

      recordedFilePath =
          '${directory.path}/phone_diagnostic_test.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
        ),
        path: recordedFilePath!,
      );

      recording = true;
      working = false;
      message = 'Grabando... habla durante unos segundos';
    } catch (e) {
      recording = false;
      working = false;
      message = 'No se pudo iniciar la grabación';
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _recorder.stop();

      recording = false;

      if (path != null && File(path).existsSync()) {
        recordedFilePath = path;
        working = true;
        message = 'Micrófono funcionando correctamente';
      } else {
        working = false;
        message = 'No se generó el archivo de audio';
      }
    } catch (e) {
      recording = false;
      working = false;
      message = 'Error al detener la grabación';
    }
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}