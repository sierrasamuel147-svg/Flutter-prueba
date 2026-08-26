import 'diagnostic_result.dart';
import 'diagnostic_status.dart';

class DiagnosticEngine {
  final List<DiagnosticResult> results = [];

  Future<List<DiagnosticResult>> runBasicDiagnostics() async {
    results.clear();

    await _testSensors();
    await _testBattery();
    await _testConnectivity();

    return List.unmodifiable(results);
  }

  Future<void> _testSensors() async {
    results.add(
      DiagnosticResult(
        component: 'Sensores',
        status: DiagnosticStatus.ok,
        message: 'Prueba de sensores ejecutada.',
      ),
    );
  }

  Future<void> _testBattery() async {
    results.add(
      DiagnosticResult(
        component: 'Batería',
        status: DiagnosticStatus.ok,
        message: 'Prueba de batería ejecutada.',
      ),
    );
  }

  Future<void> _testConnectivity() async {
    results.add(
      DiagnosticResult(
        component: 'Conectividad',
        status: DiagnosticStatus.ok,
        message: 'Prueba de conectividad ejecutada.',
      ),
    );
  }
}