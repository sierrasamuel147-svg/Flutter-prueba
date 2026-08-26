import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothDiagnostic {
  StreamSubscription<List<ScanResult>>? _subscription;

  final List<ScanResult> devices = [];

  bool supported = false;
  bool scanning = false;
  bool foundDevice = false;

  String message = 'No probado';

  Future<void> test() async {
    try {
      supported = await FlutterBluePlus.isSupported;

      if (!supported) {
        message = 'Bluetooth no disponible';
        return;
      }

      if (await FlutterBluePlus.adapterState.first !=
          BluetoothAdapterState.on) {
        message = 'Activa Bluetooth para realizar la prueba';
        return;
      }

      devices.clear();
      scanning = true;
      message = 'Buscando dispositivos...';

      _subscription = FlutterBluePlus.scanResults.listen(
        (results) {
          devices
            ..clear()
            ..addAll(results);

          foundDevice = results.isNotEmpty;

          if (foundDevice) {
            message =
                'Dispositivo Bluetooth detectado';
          }
        },
      );

      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 5),
      );

      scanning = false;

      if (!foundDevice) {
        message =
            'Bluetooth funciona, pero no se encontraron dispositivos cercanos';
      }
    } catch (e) {
      scanning = false;
      message = 'Error durante la prueba Bluetooth';
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();

    if (scanning) {
      await FlutterBluePlus.stopScan();
    }
  }
}