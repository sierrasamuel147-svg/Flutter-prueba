import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

void main() => runApp(const MiAppSensores());

class MiAppSensores extends StatelessWidget {
  const MiAppSensores({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Monitor de Sensores')),
        body: const PanelSensores(),
      ),
    );
  }
}

class PanelSensores extends StatefulWidget {
  const PanelSensores({super.key});

  @override
  State<PanelSensores> createState() => _PanelSensoresState();
}

class _PanelSensoresState extends State<PanelSensores> {
  UserAccelerometerEvent? _acelerometro;

  @override
  void initState() {
    super.initState();
    userAccelerometerEventStream().listen((event) {
      setState(() => _acelerometro = event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Lectura del Acelerómetro:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Eje X: ${_acelerometro?.x.toStringAsFixed(2) ?? "0.00"}'),
          Text('Eje Y: ${_acelerometro?.y.toStringAsFixed(2) ?? "0.00"}'),
          Text('Eje Z: ${_acelerometro?.z.toStringAsFixed(2) ?? "0.00"}'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (await Vibration.hasVibrator() ?? false) {
                Vibration.vibrate(duration: 500);
              }
            },
            child: const Text('Probar Vibración Nativa'),
          ),
        ],
      ),
    );
  }
}