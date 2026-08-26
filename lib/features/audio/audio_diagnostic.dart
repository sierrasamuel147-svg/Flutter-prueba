import 'package:audioplayers/audioplayers.dart';

class AudioDiagnostic {
  final AudioPlayer _player = AudioPlayer();

  bool playing = false;
  bool tested = false;
  bool userConfirmed = false;

  String message = 'No probado';

  Future<void> playTestTone() async {
    try {
      await _player.stop();

      await _player.setVolume(1.0);

      playing = true;
      tested = true;
      userConfirmed = false;
      message = 'Reproduciendo prueba de altavoz';

      await _player.play(
        AssetSource('audio/test_tone.mp3'),
      );
    } catch (e) {
      playing = false;
      tested = true;
      message = 'No se pudo reproducir el audio: $e';
    }
  }

  Future<void> stop() async {
    await _player.stop();

    playing = false;
  }

  void confirmWorking() {
    userConfirmed = true;
    playing = false;
    message = 'Altavoz funcionando correctamente';
  }

  void reportFailure() {
    userConfirmed = false;
    playing = false;
    message = 'El usuario no escuchó correctamente el audio';
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}