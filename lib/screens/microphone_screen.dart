import 'package:flutter/material.dart';

import '../features/microphone/microphone_diagnostic.dart';

class MicrophoneScreen extends StatefulWidget {
  const MicrophoneScreen({super.key});

  @override
  State<MicrophoneScreen> createState() =>
      _MicrophoneScreenState();
}

class _MicrophoneScreenState extends State<MicrophoneScreen> {
  final MicrophoneDiagnostic diagnostic =
      MicrophoneDiagnostic();

  @override
  void dispose() {
    diagnostic.dispose();

    super.dispose();
  }

  Future<void> _startRecording() async {
    await diagnostic.startRecording();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _stopRecording() async {
    await diagnostic.stopRecording();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Micrófono'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.mic,
              size: 80,
            ),

            const SizedBox(height: 20),

            const Text(
              'Diagnóstico del micrófono',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              diagnostic.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
              ),
            ),

            const SizedBox(height: 30),

            if (diagnostic.recording)
              const Column(
                children: [
                  CircularProgressIndicator(),

                  SizedBox(height: 20),

                  Text(
                    'Grabando...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Habla durante unos segundos',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

            const Spacer(),

            if (!diagnostic.recording)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startRecording,
                  icon: const Icon(Icons.mic),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Iniciar prueba',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),

            if (diagnostic.recording)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _stopRecording,
                  icon: const Icon(Icons.stop),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Detener grabación',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 15),

            if (diagnostic.working)
              const Text(
                '✓ MICRÓFONO FUNCIONANDO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}