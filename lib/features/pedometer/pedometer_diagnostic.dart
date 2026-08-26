import 'dart:async';

import 'package:pedometer/pedometer.dart';

class PedometerDiagnostic {
  StreamSubscription<StepCount>? _subscription;

  int steps = 0;

  bool detected = false;
  bool working = false;

  String message = 'No probado';

  void start() {
    try {
      _subscription = Pedometer.stepCountStream.listen(
        (event) {
          detected = true;
          steps = event.steps;
          working = true;
          message = 'Podómetro funcionando correctamente';
        },
        onError: (_) {
          detected = false;
          working = false;
          message = 'No se pudo acceder al podómetro';
        },
      );
    } catch (e) {
      detected = false;
      working = false;
      message = 'Podómetro no disponible';
    }
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    stop();
  }
}