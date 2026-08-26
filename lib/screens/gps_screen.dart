import 'package:flutter/material.dart';

import '../features/gps/gps_diagnostic.dart';

class GpsScreen extends StatefulWidget {
  const GpsScreen({super.key});

  @override
  State<GpsScreen> createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
  final GpsDiagnostic diagnostic = GpsDiagnostic();

  bool testing = false;

  Future<void> _runTest() async {
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
    final position = diagnostic.position;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS / GNSS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.location_on,
              size: 70,
            ),

            const SizedBox(height: 20),

            const Text(
              'Prueba de ubicación',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            if (testing)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (!testing && position != null) ...[
              Text(
                'Latitud: ${position.latitude}',
                style: const TextStyle(fontSize: 17),
              ),

              const SizedBox(height: 8),

              Text(
                'Longitud: ${position.longitude}',
                style: const TextStyle(fontSize: 17),
              ),

              const SizedBox(height: 8),

              Text(
                'Precisión: ${position.accuracy.toStringAsFixed(2)} m',
                style: const TextStyle(fontSize: 17),
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

            ElevatedButton.icon(
              onPressed: testing ? null : _runTest,
              icon: const Icon(Icons.gps_fixed),
              label: const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Probar GPS',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}