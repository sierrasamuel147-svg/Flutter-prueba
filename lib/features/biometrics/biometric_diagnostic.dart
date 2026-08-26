import 'package:local_auth/local_auth.dart';

class BiometricDiagnostic {
  final LocalAuthentication _auth = LocalAuthentication();

  bool available = false;
  bool authenticated = false;

  String message = 'No probado';

  Future<void> test() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();

      available = canCheck && supported;

      if (!available) {
        message = 'No hay biometría disponible';
        authenticated = false;
        return;
      }

      final success = await _auth.authenticate(
        localizedReason:
            'Confirma tu identidad para probar la biometría',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      authenticated = success;

      if (success) {
        message = 'Biometría funcionando correctamente';
      } else {
        message = 'La autenticación biométrica no fue completada';
      }
    } catch (e) {
      available = false;
      authenticated = false;
      message = 'Error al probar la biometría: $e';
    }
  }
}