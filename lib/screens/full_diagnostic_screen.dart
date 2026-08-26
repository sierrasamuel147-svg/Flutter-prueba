import 'package:flutter/material.dart';

import '../core/diagnostics/diagnostic_engine.dart';
import '../core/diagnostics/diagnostic_result.dart';
import '../core/diagnostics/diagnostic_status.dart';

class FullDiagnosticScreen extends StatefulWidget {
  const FullDiagnosticScreen({super.key});

  @override
  State<FullDiagnosticScreen> createState() =>
      _FullDiagnosticScreenState();
}

class _FullDiagnosticScreenState
    extends State<FullDiagnosticScreen> {
  final DiagnosticEngine engine =
      DiagnosticEngine();

  List<DiagnosticResult> results = [];

  bool running = false;

  Future<void> _startDiagnostic() async {
    setState(() {
      running = true;
      results = [];
    });

    final diagnosticResults =
        await engine.runBasicDiagnostics();

    if (!mounted) return;

    setState(() {
      results = diagnosticResults;
      running = false;
    });
  }

  int get successfulTests {
    return results
        .where(
          (result) =>
              result.status == DiagnosticStatus.ok,
        )
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Diagnóstico completo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.health_and_safety,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              'Diagnóstico del dispositivo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              results.isEmpty
                  ? 'Ejecuta una prueba completa'
                  : '$successfulTests de '
                      '${results.length} pruebas correctas',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            if (running)
              const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 15),
                  Text(
                    'Analizando dispositivo...',
                  ),
                ],
              ),

            if (!running && results.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    final result =
                        results[index];

                    return Card(
                      child: ListTile(
                        leading: Icon(
                          result.status ==
                                  DiagnosticStatus.ok
                              ? Icons.check_circle
                              : Icons.warning,
                        ),
                        title: Text(
                          result.component,
                        ),
                        subtitle: Text(
                          result.message,
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (!running && results.isEmpty)
              const Spacer(),

            if (!running)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startDiagnostic,
                  icon: const Icon(
                    Icons.play_arrow,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'Iniciar diagnóstico',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}