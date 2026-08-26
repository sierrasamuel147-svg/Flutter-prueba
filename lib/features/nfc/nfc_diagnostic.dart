import 'package:nfc_manager/nfc_manager.dart';

class NfcDiagnostic {
  bool available = false;
  bool tagDetected = false;
  bool scanning = false;

  String message = 'No probado';

  Future<void> checkAvailability() async {
    try {
      final availability =
          await NfcManager.instance.checkAvailability();

      available = availability == NfcAvailability.enabled;

      if (!available) {
        message = 'NFC no disponible o desactivado';
      } else {
        message = 'NFC disponible';
      }
    } catch (e) {
      available = false;
      message = 'Error al comprobar NFC';
    }
  }

  Future<void> startScan() async {
    if (!available) {
      await checkAvailability();
    }

    if (!available) {
      return;
    }

    scanning = true;
    tagDetected = false;
    message = 'Acerca una tarjeta o etiqueta NFC al teléfono';

    try {
      await NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
        onDiscovered: (tag) async {
          tagDetected = true;
          scanning = false;
          message = 'Etiqueta NFC detectada correctamente';

          await NfcManager.instance.stopSession();
        },
      );
    } catch (e) {
      scanning = false;
      message = 'Error durante la lectura NFC';
    }
  }

  Future<void> stopScan() async {
    try {
      await NfcManager.instance.stopSession();
    } catch (_) {}

    scanning = false;
  }

  Future<void> dispose() async {
    await stopScan();
  }
}