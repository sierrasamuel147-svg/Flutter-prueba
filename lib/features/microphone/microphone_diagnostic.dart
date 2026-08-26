import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:record/record.dart';

class MicrophoneDiagnostic {
  final AudioRecorder _recorder = AudioRecorder();

  Timer? _levelTimer;

  bool permissionGranted = false;
  bool recording = false;
  bool tested = false;
  bool working = false;
  bool soundDetected = false;

  String? recordedFilePath;

  String message = 'No probado';

  double currentLevel = 0;
  double maxLevel = 0;
  double averageLevel = 0;

  int _samples = 0;
  double _totalLevel = 0;

  static const Duration testDuration =
      Duration(seconds: 5);

  // Umbral aproximado de señal.
  //
  // getAmplitude() devuelve dBFS:
  // 0 dB = máximo
  // valores negativos = menor volumen
  //
  // -45 dB es un umbral razonable para
  // distinguir silencio de voz/sonido.
  static const double soundThreshold = -45.0;

  Future<bool> runAutomaticTest() async {
    if (recording) {
      return false;
    }

    try {
      _reset();

      message =
          'Comprobando permiso del micrófono...';

      final hasPermission =
          await _recorder.hasPermission();

      if (!hasPermission) {
        permissionGranted = false;
        tested = true;
        working = false;

        message =
            'Permiso de micrófono denegado';

        return false;
      }

      permissionGranted = true;

      final directory = Directory.systemTemp;

      final filePath =
          '${directory.path}/phone_diagnostic_mic_test.m4a';

      final oldFile = File(filePath);

      if (await oldFile.exists()) {
        await oldFile.delete();
      }

      recordedFilePath = filePath;

      message =
          'Habla durante los próximos 5 segundos...';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          numChannels: 1,
        ),
        path: filePath,
      );

      recording = true;

      _startLevelMonitoring();

      await Future.delayed(testDuration);

      _stopLevelMonitoring();

      final path =
          await _recorder.stop();

      recording = false;

      if (path == null || path.isEmpty) {
        tested = true;
        working = false;

        message =
            'No se generó la grabación';

        return false;
      }

      recordedFilePath = path;

      final file = File(path);

      if (!await file.exists()) {
        tested = true;
        working = false;

        message =
            'El archivo de grabación no existe';

        return false;
      }

      final fileSize = await file.length();

      if (fileSize <= 0) {
        tested = true;
        working = false;

        message =
            'La grabación está vacía';

        return false;
      }

      tested = true;

      // --------------------------------------------------------
      // ANÁLISIS DE AUDIO
      // --------------------------------------------------------

      if (_samples == 0) {
        working = false;
        soundDetected = false;

        message =
            'No se pudo medir la señal del micrófono';

        return false;
      }

      averageLevel =
          _totalLevel / _samples;

      soundDetected =
          maxLevel >= soundThreshold;

      if (soundDetected) {
        working = true;

        message =
            'Micrófono funcionando correctamente';

        return true;
      }

      working = false;

      message =
          'No se detectó suficiente señal de audio. '
          'Habla más cerca del micrófono durante la prueba.';

      return false;
    } catch (e) {
      _stopLevelMonitoring();

      try {
        if (recording) {
          await _recorder.stop();
        }
      } catch (_) {}

      recording = false;
      tested = true;
      working = false;

      message =
          'No se pudo completar la prueba del micrófono';

      return false;
    }
  }

  void _startLevelMonitoring() {
    _levelTimer?.cancel();

    _levelTimer = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) async {
        if (!recording) {
          return;
        }

        try {
          final amplitude =
              await _recorder.getAmplitude();

          final current =
              amplitude.current;

          if (current.isNaN ||
              current.isInfinite) {
            return;
          }

          currentLevel = current;

          maxLevel =
              max(maxLevel, current);

          _totalLevel += current;
          _samples++;
        } catch (_) {
          // No detenemos la grabación por un error
          // puntual de lectura del nivel.
        }
      },
    );
  }

  void _stopLevelMonitoring() {
    _levelTimer?.cancel();
    _levelTimer = null;
  }

  void _reset() {
    _stopLevelMonitoring();

    permissionGranted = false;
    recording = false;
    tested = false;
    working = false;
    soundDetected = false;

    recordedFilePath = null;

    message = 'No probado';

    currentLevel = 0;
    maxLevel = -100;
    averageLevel = 0;

    _samples = 0;
    _totalLevel = 0;
  }

  Future<void> stopRecording() async {
    if (!recording) {
      return;
    }

    _stopLevelMonitoring();

    try {
      final path =
          await _recorder.stop();

      recording = false;

      if (path != null && path.isNotEmpty) {
        recordedFilePath = path;
      }
    } catch (_) {
      recording = false;
    }
  }

  Future<void> dispose() async {
    _stopLevelMonitoring();

    try {
      if (recording) {
        await _recorder.stop();
      }
    } catch (_) {}

    await _recorder.dispose();
  }
}