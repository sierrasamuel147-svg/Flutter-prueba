import 'dart:async';

import 'package:pedometer/pedometer.dart';

class PedometerDiagnostic {
  StreamSubscription<StepCount>? _subscription;
  Timer? _timeoutTimer;

  int steps = 0;
  int initialSteps = 0;
  int detectedSteps = 0;

  bool detected = false;
  bool working = false;
  bool tested = false;

  String message = 'No probado';

  static const int requiredSteps = 3;
  static const Duration testDuration =
      Duration(seconds: 15);

  Future<bool> runAutomaticTest() async {
    if (_subscription != null) {
      return false;
    }

    final completer = Completer<bool>();

    // Reiniciar estado.
    detected = false;
    working = false;
    tested = false;

    steps = 0;
    initialSteps = 0;
    detectedSteps = 0;

    message =
        'Preparando prueba del podómetro...';

    bool receivedFirstEvent = false;

    try {
      _subscription =
          Pedometer.stepCountStream.listen(
        (event) {
          if (tested) return;

          detected = true;
          steps = event.steps;

          // El primer evento establece el punto
          // de referencia.
          if (!receivedFirstEvent) {
            receivedFirstEvent = true;
            initialSteps = event.steps;
            detectedSteps = 0;

            message =
                'Camina al menos 3 pasos...';

            return;
          }

          detectedSteps =
              event.steps - initialSteps;

          // Evitamos mostrar números negativos.
          if (detectedSteps < 0) {
            detectedSteps = 0;
          }

          message =
              'Pasos detectados: $detectedSteps';

          if (detectedSteps >= requiredSteps) {
            tested = true;
            working = true;

            message =
                'Podómetro funcionando correctamente';

            _stopInternal();

            if (!completer.isCompleted) {
              completer.complete(true);
            }
          }
        },
        onError: (_) {
          if (tested) return;

          tested = true;
          detected = false;
          working = false;

          message =
              'No se pudo acceder al podómetro';

          _stopInternal();

          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
      );

      // Tiempo máximo de la prueba.
      _timeoutTimer = Timer(
        testDuration,
        () {
          if (completer.isCompleted) return;

          tested = true;
          working = false;

          message = receivedFirstEvent
              ? 'No se detectaron suficientes pasos'
              : 'No se recibieron datos del podómetro';

          _stopInternal();

          if (!completer.isCompleted) {
            completer.complete(false);
          }
        },
      );

      return await completer.future;
    } catch (_) {
      tested = true;
      working = false;
      detected = false;

      message =
          'Podómetro no disponible';

      _stopInternal();

      if (!completer.isCompleted) {
        completer.complete(false);
      }

      return completer.future;
    }
  }

  void _stopInternal() {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;

    _subscription?.cancel();
    _subscription = null;
  }

  void stop() {
    _stopInternal();
  }

  void dispose() {
    _stopInternal();
  }
}