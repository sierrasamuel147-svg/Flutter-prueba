import 'package:flutter/material.dart';

import '../features/audio/audio_diagnostic.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final AudioDiagnostic diagnostic = AudioDiagnostic();

  Future<void> _playTest() async {
    await diagnostic.playTestTone();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _stopTest() async {
    await diagnostic.stop();

    if (mounted) {
      setState(() {});
    }
  }

  void _confirmWorking() {
    diagnostic.confirmWorking();

    setState(() {});
  }

  void _reportFailure() {
    diagnostic.reportFailure();

    setState(() {});
  }

  @override
  void dispose() {
    diagnostic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Altavoz'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Icon(
                Icons.volume_up,
                size: 100,
              ),

              const SizedBox(height: 24),

              const Text(
                'Diagnóstico de altavoz',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Reproduce un tono para comprobar '
                'la salida de audio del teléfono.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Estado',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      diagnostic.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              if (!diagnostic.playing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _playTest,
                    icon: const Icon(
                      Icons.play_arrow,
                    ),
                    label: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Reproducir prueba',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),

              if (diagnostic.playing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _stopTest,
                    icon: const Icon(
                      Icons.stop,
                    ),
                    label: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Detener prueba',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              if (diagnostic.tested &&
                  !diagnostic.playing) ...[
                const Text(
                  '¿Escuchaste el sonido correctamente?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _confirmWorking,
                        icon: const Icon(
                          Icons.check,
                        ),
                        label: const Text(
                          'Sí, funciona',
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _reportFailure,
                        icon: const Icon(
                          Icons.close,
                        ),
                        label: const Text(
                          'No funciona',
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              if (diagnostic.userConfirmed)
                const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'ALTAVOZ FUNCIONANDO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}