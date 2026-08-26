import 'dart:async';

import 'package:flutter/material.dart';

import '../features/pedometer/pedometer_diagnostic.dart';

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({super.key});

  @override
  State<PedometerScreen> createState() =>
      _PedometerScreenState();
}

class _PedometerScreenState extends State<PedometerScreen> {
  final PedometerDiagnostic diagnostic =
      PedometerDiagnostic();

  Timer? timer;

  @override
  void initState() {
    super.initState();

    diagnostic.start();

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    diagnostic.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podómetro'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.directions_walk,
                size: 90,
              ),

              const SizedBox(height: 30),

              const Text(
                'Pasos detectados',
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 10),

              Text(
                '${diagnostic.steps}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                diagnostic.message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17),
              ),

              const SizedBox(height: 30),

              Text(
                diagnostic.working
                    ? '✓ PODÓMETRO FUNCIONANDO'
                    : '○ Camina unos pasos para probarlo',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}