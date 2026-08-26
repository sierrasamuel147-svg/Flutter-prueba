import 'package:vibration/vibration.dart';

class VibrationDiagnostic {
  bool hasVibrator = false;
  bool hasAmplitudeControl = false;
  bool tested = false;
  bool working = false;

  String message = 'No probado';

  Future<bool> runAutomaticTest() async {
    try {
      tested = false;
      working = false;

      message =
          'Comprobando vibrador...';

      hasVibrator =
          await Vibration.hasVibrator();

      if (!hasVibrator) {
        tested = true;
        working = false;

        message =
            'El dispositivo no tiene vibrador disponible';

        return false;
      }

      hasAmplitudeControl =
          await Vibration.hasAmplitudeControl();

      message =
          'Activando vibración...';

      // Primera vibración.
      await Vibration.vibrate(
        duration: 350,
        amplitude:
            hasAmplitudeControl ? 180 : -1,
      );

      await Future.delayed(
        const Duration(milliseconds: 250),
      );

      // Segunda vibración para asegurarnos
      // de que el motor responde.
      await Vibration.vibrate(
        duration: 500,
        amplitude:
            hasAmplitudeControl ? 220 : -1,
      );

      await Future.delayed(
        const Duration(milliseconds: 300),
      );

      await Vibration.cancel();

      tested = true;
      working = true;

      message =
          'Vibración ejecutada correctamente';

      return true;
    } catch (e) {
      tested = true;
      working = false;

      message =
          'No se pudo ejecutar la vibración';

      return false;
    }
  }
}