import 'dart:async';

import 'package:flutter/material.dart';

import '../features/sensors/sensor_diagnostic.dart';

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() => _DiagnosticScreenState();
}

class _DiagnosticScreenState extends State<DiagnosticScreen> {
  final SensorDiagnostic diagnostic = SensorDiagnostic();

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    diagnostic.start();

    _timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    diagnostic.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensores'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Diagnóstico de sensores',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Mueve y gira el teléfono para comprobar '
            'la respuesta de los sensores.',
          ),

          const SizedBox(height: 20),

          _buildAccelerometerCard(),
          const SizedBox(height: 12),

          _buildGyroscopeCard(),
          const SizedBox(height: 12),

          _buildMagnetometerCard(),
        ],
      ),
    );
  }

  Widget _buildAccelerometerCard() {
    final sensor = diagnostic.lastAccelerometer;

    return _buildSensorCard(
      title: 'Acelerómetro',
      icon: Icons.speed,
      detected: diagnostic.accelerometerDetected,
      working: diagnostic.accelerometerMoving,
      values: sensor == null
          ? null
          : {
              'X': sensor.x,
              'Y': sensor.y,
              'Z': sensor.z,
            },
    );
  }

  Widget _buildGyroscopeCard() {
    final sensor = diagnostic.lastGyroscope;

    return _buildSensorCard(
      title: 'Giroscopio',
      icon: Icons.screen_rotation,
      detected: diagnostic.gyroscopeDetected,
      working: diagnostic.gyroscopeMoving,
      values: sensor == null
          ? null
          : {
              'X': sensor.x,
              'Y': sensor.y,
              'Z': sensor.z,
            },
    );
  }

  Widget _buildMagnetometerCard() {
    final sensor = diagnostic.lastMagnetometer;

    return _buildSensorCard(
      title: 'Magnetómetro',
      icon: Icons.explore,
      detected: diagnostic.magnetometerDetected,
      working: diagnostic.magnetometerResponding,
      values: sensor == null
          ? null
          : {
              'X': sensor.x,
              'Y': sensor.y,
              'Z': sensor.z,
            },
    );
  }

  Widget _buildSensorCard({
    required String title,
    required IconData icon,
    required bool detected,
    required bool working,
    required Map<String, double>? values,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Icon(
                  detected && working
                      ? Icons.check_circle
                      : detected
                          ? Icons.help
                          : Icons.cancel,
                  size: 28,
                ),
              ],
            ),

            const SizedBox(height: 15),

            Text(
              detected
                  ? 'Sensor detectado'
                  : 'Sensor no detectado',
            ),

            if (values != null) ...[
              const SizedBox(height: 12),

              ...values.entries.map(
                (entry) {
                  return Text(
                    '${entry.key}: ${entry.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 12),

            Text(
              !detected
                  ? 'No disponible'
                  : working
                      ? '✓ Responde al movimiento'
                      : '○ Esperando movimiento...',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}