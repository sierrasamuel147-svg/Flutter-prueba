import 'package:flutter/material.dart';

import '../features/connectivity/connectivity_diagnostic.dart';

class ConnectivityScreen extends StatefulWidget {
  const ConnectivityScreen({super.key});

  @override
  State<ConnectivityScreen> createState() =>
      _ConnectivityScreenState();
}

class _ConnectivityScreenState
    extends State<ConnectivityScreen> {
  final ConnectivityDiagnostic diagnostic =
      ConnectivityDiagnostic();

  bool testing = false;

  Future<void> _test() async {
    setState(() {
      testing = true;
    });

    await diagnostic.test();

    if (mounted) {
      setState(() {
        testing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectividad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.wifi,
              size: 90,
            ),

            const SizedBox(height: 20),

            const Text(
              'Diagnóstico de conectividad',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            if (testing)
              const CircularProgressIndicator(),

            if (!testing && diagnostic.working) ...[
              Text(
                'Red: ${diagnostic.connectionText}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                diagnostic.hasInternet
                    ? '✓ Acceso a Internet'
                    : '⚠ Sin acceso confirmado a Internet',
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ],

            const SizedBox(height: 20),

            Text(
              diagnostic.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),

            const Spacer(),

            if (!testing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _test,
                  icon: const Icon(Icons.network_check),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Probar conectividad',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            if (diagnostic.hasInternet)
              const Text(
                '✓ CONECTIVIDAD FUNCIONANDO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}