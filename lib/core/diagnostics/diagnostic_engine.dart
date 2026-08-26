import '../../features/battery/battery_diagnostic.dart';
import '../../features/biometrics/biometric_diagnostic.dart';
import '../../features/bluetooth/bluetooth_diagnostic.dart';
import '../../features/connectivity/connectivity_diagnostic.dart';
import '../../features/gps/gps_diagnostic.dart';
import '../../features/nfc/nfc_diagnostic.dart';
import '../../features/notifications/push_notification_service.dart';
import '../../features/sensors/sensor_diagnostic.dart';

import 'diagnostic_result.dart';
import 'diagnostic_status.dart';

class DiagnosticEngine {
  final List<DiagnosticResult> results = [];

  final BatteryDiagnostic _battery =
      BatteryDiagnostic();

  final ConnectivityDiagnostic _connectivity =
      ConnectivityDiagnostic();

  final GpsDiagnostic _gps =
      GpsDiagnostic();

  final SensorDiagnostic _sensors =
      SensorDiagnostic();

  final BluetoothDiagnostic _bluetooth =
      BluetoothDiagnostic();

  final NfcDiagnostic _nfc =
      NfcDiagnostic();

  final BiometricDiagnostic _biometric =
      BiometricDiagnostic();

  final PushNotificationService _notifications =
      PushNotificationService();

  // ============================================================
  // DIAGNÓSTICO AUTOMÁTICO
  // ============================================================

  Future<List<DiagnosticResult>>
      runAutomaticDiagnostics() async {
    results.clear();

    await _testSensors();
    await _testBattery();
    await _testConnectivity();
    await _testGps();
    await _testBluetooth();
    await _testNfc();
    await _testBiometrics();

    return List.unmodifiable(results);
  }

  // ============================================================
  // SENSORES
  // ============================================================

  Future<void> _testSensors() async {
    try {
      _sensors.start();

      await Future.delayed(
        const Duration(seconds: 2),
      );

      final accelerometer =
          _sensors.accelerometerDetected;

      final gyroscope =
          _sensors.gyroscopeDetected;

      final magnetometer =
          _sensors.magnetometerDetected;

      final detectedCount = [
        accelerometer,
        gyroscope,
        magnetometer,
      ].where((value) => value).length;

      final DiagnosticStatus status;

      if (detectedCount == 3) {
        status = DiagnosticStatus.ok;
      } else if (detectedCount > 0) {
        status = DiagnosticStatus.warning;
      } else {
        status = DiagnosticStatus.failed;
      }

      results.add(
        DiagnosticResult(
          component: 'Sensores',
          status: status,
          message: _sensorMessage(
            accelerometer,
            gyroscope,
            magnetometer,
          ),
          details: {
            'accelerometer': accelerometer,
            'gyroscope': gyroscope,
            'magnetometer': magnetometer,
          },
        ),
      );
    } catch (e) {
      results.add(
        DiagnosticResult(
          component: 'Sensores',
          status: DiagnosticStatus.failed,
          message: 'Error al comprobar sensores',
          details: {
            'error': e.toString(),
          },
        ),
      );
    } finally {
      _sensors.stop();
    }
  }

  String _sensorMessage(
    bool accelerometer,
    bool gyroscope,
    bool magnetometer,
  ) {
    final missing = <String>[];

    if (!accelerometer) {
      missing.add('acelerómetro');
    }

    if (!gyroscope) {
      missing.add('giroscopio');
    }

    if (!magnetometer) {
      missing.add('magnetómetro');
    }

    if (missing.isEmpty) {
      return 'Acelerómetro, giroscopio y magnetómetro detectados';
    }

    return 'Sensores no detectados: ${missing.join(', ')}';
  }

  // ============================================================
  // BATERÍA
  // ============================================================

  Future<void> _testBattery() async {
    await _battery.test();

    results.add(
      DiagnosticResult(
        component: 'Batería',
        status: _battery.working
            ? DiagnosticStatus.ok
            : DiagnosticStatus.failed,
        message: _battery.message,
        details: {
          'level': _battery.level,
          'state': _battery.stateText,
          'powerSaveMode':
              _battery.powerSaveMode,
        },
      ),
    );
  }

  // ============================================================
  // CONECTIVIDAD
  // ============================================================

  Future<void> _testConnectivity() async {
    await _connectivity.test();

    final DiagnosticStatus status;

    if (_connectivity.hasInternet) {
      status = DiagnosticStatus.ok;
    } else if (_connectivity.hasNetwork) {
      status = DiagnosticStatus.warning;
    } else {
      status = DiagnosticStatus.failed;
    }

    results.add(
      DiagnosticResult(
        component: 'Conectividad',
        status: status,
        message: _connectivity.message,
        details: {
          'connection':
              _connectivity.connectionText,
          'hasNetwork':
              _connectivity.hasNetwork,
          'hasInternet':
              _connectivity.hasInternet,
        },
      ),
    );
  }

  // ============================================================
  // GPS
  // ============================================================

  Future<void> _testGps() async {
    await _gps.test();

    final DiagnosticStatus status;

    if (_gps.working) {
      status = DiagnosticStatus.ok;
    } else if (!_gps.serviceEnabled) {
      status = DiagnosticStatus.warning;
    } else {
      status = DiagnosticStatus.failed;
    }

    results.add(
      DiagnosticResult(
        component: 'GPS / GNSS',
        status: status,
        message: _gps.message,
        details: {
          'serviceEnabled':
              _gps.serviceEnabled,
          'permissionGranted':
              _gps.permissionGranted,
          'latitude':
              _gps.position?.latitude,
          'longitude':
              _gps.position?.longitude,
        },
      ),
    );
  }

  // ============================================================
  // BLUETOOTH
  // ============================================================

  Future<void> _testBluetooth() async {
    try {
      await _bluetooth.test();

      final DiagnosticStatus status;

      if (!_bluetooth.supported) {
        status = DiagnosticStatus.unavailable;
      } else {
        status = DiagnosticStatus.ok;
      }

      results.add(
        DiagnosticResult(
          component: 'Bluetooth',
          status: status,
          message: _bluetooth.message,
          details: {
            'supported':
                _bluetooth.supported,
            'foundDevice':
                _bluetooth.foundDevice,
            'devicesFound':
                _bluetooth.devices.length,
          },
        ),
      );
    } catch (e) {
      results.add(
        DiagnosticResult(
          component: 'Bluetooth',
          status: DiagnosticStatus.failed,
          message:
              'Error al comprobar Bluetooth',
          details: {
            'error': e.toString(),
          },
        ),
      );
    } finally {
      await _bluetooth.dispose();
    }
  }

  // ============================================================
  // NFC
  // ============================================================

  Future<void> _testNfc() async {
    await _nfc.checkAvailability();

    results.add(
      DiagnosticResult(
        component: 'NFC',
        status: _nfc.available
            ? DiagnosticStatus.ok
            : DiagnosticStatus.unavailable,
        message: _nfc.message,
        details: {
          'available': _nfc.available,
        },
      ),
    );
  }

  // ============================================================
  // BIOMETRÍA
  // ============================================================

  Future<void> _testBiometrics() async {
    await _biometric.test();

    final DiagnosticStatus status;

    if (!_biometric.available) {
      status = DiagnosticStatus.unavailable;
    } else if (_biometric.authenticated) {
      status = DiagnosticStatus.ok;
    } else {
      status = DiagnosticStatus.warning;
    }

    results.add(
      DiagnosticResult(
        component: 'Biometría',
        status: status,
        message: _biometric.message,
        details: {
          'available':
              _biometric.available,
          'authenticated':
              _biometric.authenticated,
        },
      ),
    );
  }

  // ============================================================
  // NOTIFICACIONES
  // ============================================================

  Future<DiagnosticResult>
      testNotifications() async {
    try {
      await _notifications.initialize();

      return DiagnosticResult(
        component: 'Notificaciones',
        status: _notifications.initialized
            ? DiagnosticStatus.ok
            : DiagnosticStatus.failed,
        message: _notifications.message,
        details: {
          'permissionGranted':
              _notifications.permissionGranted,
          'tokenAvailable':
              _notifications.token != null &&
                  _notifications.token!.isNotEmpty,
        },
      );
    } catch (e) {
      return DiagnosticResult(
        component: 'Notificaciones',
        status: DiagnosticStatus.failed,
        message:
            'Error al configurar notificaciones',
        details: {
          'error': e.toString(),
        },
      );
    }
  }

  // ============================================================
  // LIMPIEZA
  // ============================================================

  Future<void> dispose() async {
    _sensors.dispose();

    await _bluetooth.dispose();

    await _nfc.dispose();

    await _notifications.dispose();
  }
}