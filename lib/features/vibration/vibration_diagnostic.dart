import 'package:vibration/vibration.dart';

class VibrationDiagnostic {
  bool hasVibrator = false;
  bool hasAmplitudeControl = false;
  bool working = false;

  String message = 'No probado';

  Future<void> test() async {
    try {
      hasVibrator = await Vibration.hasVibrator();

      if (!hasVibrator) {
        working = false;
        message = 'El dispositivo no tiene vibrador disponible';
        return;
      }

      hasAmplitudeControl =
          await Vibration.hasAmplitudeControl();

      message = 'Activando vibración...';

      await Vibration.vibrate(
        duration: 700,
        amplitude: hasAmplitudeControl ? 180 : -1,
      );

      working = true;
      message = 'Vibración funcionando correctamente';
    } catch (e) {
      working = false;
      message = 'Error al probar la vibración';
    }
  }
}