import 'dart:async';
import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

class SensorDiagnostic {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<MagnetometerEvent>? _magnetometerSubscription;

  bool accelerometerDetected = false;
  bool gyroscopeDetected = false;
  bool magnetometerDetected = false;

  bool accelerometerMoving = false;
  bool gyroscopeMoving = false;
  bool magnetometerResponding = false;

  AccelerometerEvent? lastAccelerometer;
  GyroscopeEvent? lastGyroscope;
  MagnetometerEvent? lastMagnetometer;

  void start() {
    _startAccelerometer();
    _startGyroscope();
    _startMagnetometer();
  }

  void _startAccelerometer() {
    _accelerometerSubscription =
        accelerometerEventStream().listen((event) {
      lastAccelerometer = event;
      accelerometerDetected = true;

      final magnitude = sqrt(
        event.x * event.x +
        event.y * event.y +
        event.z * event.z,
      );

      // La gravedad terrestre está aproximadamente alrededor de 9.8 m/s².
      // Si la magnitud se aleja significativamente, probablemente
      // el dispositivo está siendo movido.
      accelerometerMoving =
          (magnitude - 9.81).abs() > 1.5;
    });
  }

  void _startGyroscope() {
    _gyroscopeSubscription =
        gyroscopeEventStream().listen((event) {
      lastGyroscope = event;
      gyroscopeDetected = true;

      final rotationMagnitude = sqrt(
        event.x * event.x +
        event.y * event.y +
        event.z * event.z,
      );

      gyroscopeMoving = rotationMagnitude > 0.15;
    });
  }

  void _startMagnetometer() {
    _magnetometerSubscription =
        magnetometerEventStream().listen((event) {
      lastMagnetometer = event;
      magnetometerDetected = true;

      final magneticMagnitude = sqrt(
        event.x * event.x +
        event.y * event.y +
        event.z * event.z,
      );

      magnetometerResponding =
          magneticMagnitude > 5;
    });
  }

  void stop() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _magnetometerSubscription?.cancel();

    _accelerometerSubscription = null;
    _gyroscopeSubscription = null;
    _magnetometerSubscription = null;
  }

  void dispose() {
    stop();
  }
}