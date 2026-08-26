import 'package:audioplayers/audioplayers.dart';

class AudioDiagnostic {
  final AudioPlayer _player = AudioPlayer();

  bool playing = false;
  bool tested = false;
  bool working = false;

  String message = 'No probado';

  static const Duration testDuration =
      Duration(seconds: 3);

  Future<bool> runAutomaticTest() async {
    if (playing) {
      return false;
    }

    try {
      tested = false;
      working = false;
      playing = true;

      message =
          'Preparando salida de audio...';

      await _player.stop();

      await _player.setVolume(1.0);

      await _player.setSource(
        AssetSource('audio/test_tone.mp3'),
      );

      message =
          'Reproduciendo tono de prueba...';

      await _player.resume();

      await Future.delayed(
        testDuration,
      );

      await _player.stop();

      playing = false;
      tested = true;
      working = true;

      message =
          'Salida de audio disponible';

      return true;
    } catch (e) {
      playing = false;
      tested = true;
      working = false;

      message =
          'No se pudo reproducir el audio';

      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {}

    playing = false;
  }

  Future<void> dispose() async {
    try {
      await _player.stop();
    } catch (_) {}

    await _player.dispose();
  }
}