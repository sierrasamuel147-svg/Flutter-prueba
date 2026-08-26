import 'package:flutter/material.dart';

import '../features/battery/battery_diagnostic.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({super.key});

  @override
  State<BatteryScreen> createState() =>
      _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  final BatteryDiagnostic diagnostic =
      BatteryDiagnostic();

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
        title: const Text('Batería'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.battery_full,
              size: 90,
            ),

            const SizedBox(height: 20),

            const Text(
              'Diagnóstico de batería',
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
                '${diagnostic.level}%',
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'Estado: ${diagnostic.stateText}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                diagnostic.powerSaveMode
                    ? 'Modo ahorro: ACTIVADO'
                    : 'Modo ahorro: DESACTIVADO',
              ),
            ],

            const SizedBox(height: 20),

            Text(
              diagnostic.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17),
            ),

            const Spacer(),

            if (!testing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _test,
                  icon: const Icon(Icons.battery_full),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Consultar batería',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            if (diagnostic.working)
              const Text(
                '✓ BATERÍA ACCESIBLE',
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