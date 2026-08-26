import 'package:flutter/material.dart';

import '../features/vibration/vibration_diagnostic.dart';

class VibrationScreen extends StatefulWidget {
  const VibrationScreen({super.key});

  @override
  State<VibrationScreen> createState() =>
      _VibrationScreenState();
}

class _VibrationScreenState extends State<VibrationScreen> {
  final VibrationDiagnostic diagnostic =
      VibrationDiagnostic();

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
        title: const Text('Vibración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.vibration,
              size: 90,
            ),

            const SizedBox(height: 20),

            const Text(
              'Diagnóstico de vibración',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              diagnostic.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17),
            ),

            const SizedBox(height: 20),

            if (diagnostic.hasVibrator)
              const Text(
                '✓ Vibrador detectado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

            if (diagnostic.hasAmplitudeControl)
              const Text(
                '✓ Control de amplitud disponible',
              ),

            const Spacer(),

            if (testing)
              const CircularProgressIndicator(),

            if (!testing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _test,
                  icon: const Icon(Icons.vibration),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Probar vibración',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            if (diagnostic.working)
              const Text(
                '✓ VIBRACIÓN FUNCIONANDO',
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