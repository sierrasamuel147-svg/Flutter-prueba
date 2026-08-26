import 'package:flutter/material.dart';

import '../features/microphone/microphone_diagnostic.dart';

class MicrophoneScreen extends StatefulWidget {
  const MicrophoneScreen({super.key});

  @override
  State<MicrophoneScreen> createState() =>
      _MicrophoneScreenState();
}

class _MicrophoneScreenState
    extends State<MicrophoneScreen> {
  final MicrophoneDiagnostic diagnostic =
      MicrophoneDiagnostic();

  bool testing = false;

  @override
  void initState() {
    super.initState();

    _runTest();
  }

  Future<void> _runTest() async {
    if (testing) return;

    setState(() {
      testing = true;
    });

    final result =
        await diagnostic.runAutomaticTest();

    if (!mounted) return;

    setState(() {
      testing = false;
    });

    // Dejamos que el usuario vea el resultado.
    await Future.delayed(
      const Duration(milliseconds: 1200),
    );

    if (!mounted) return;

    Navigator.pop(
      context,
      result,
    );
  }

  Future<void> _retryTest() async {
    await _runTest();
  }

  void _skipTest() {
    diagnostic.stopRecording();

    Navigator.pop(
      context,
      null,
    );
  }

  @override
  void dispose() {
    diagnostic.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Micrófono'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            10,
            24,
            20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // =================================================
              // ICONO PRINCIPAL
              // =================================================

              _buildMicrophoneIcon(primary),

              const SizedBox(height: 25),

              const Text(
                'Probando tu micrófono',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF20233A),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                testing
                    ? 'Habla normalmente durante la prueba.'
                    : diagnostic.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF777C92),
                ),
              ),

              const SizedBox(height: 28),

              // =================================================
              // ESTADO DE LA PRUEBA
              // =================================================

              if (testing)
                _buildRecordingCard(),

              if (!testing &&
                  diagnostic.tested)
                _buildResultCard(),

              const Spacer(),

              // =================================================
              // REINTENTAR
              // =================================================

              if (!testing &&
                  diagnostic.tested &&
                  !diagnostic.working)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _retryTest,
                    icon: const Icon(
                      Icons.refresh_rounded,
                    ),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Text(
                        'Reintentar prueba',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              // =================================================
              // OMITIR
              // =================================================

              if (!testing)
                TextButton(
                  onPressed: _skipTest,
                  child: const Text(
                    'Omitir prueba',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ICONO
  // ============================================================

  Widget _buildMicrophoneIcon(Color primary) {
    final isWorking =
        !testing && diagnostic.working;

    final color =
        isWorking ? Colors.green : primary;

    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 400),
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(
          alpha: 0.11,
        ),
      ),
      child: Center(
        child: Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(
              alpha: 0.16,
            ),
          ),
          child: Icon(
            isWorking
                ? Icons.mic_rounded
                : Icons.mic_none_rounded,
            size: 42,
            color: color,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GRABANDO
  // ============================================================

  Widget _buildRecordingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: const Color(0xFFEFEFFF),
        border: Border.all(
          color: const Color(0xFF5B5FEF)
              .withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 42,
            height: 42,
            child: CircularProgressIndicator(
              strokeWidth: 4,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Grabando y analizando',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Habla cerca del micrófono durante '
            'los próximos 5 segundos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF777C92),
            ),
          ),

          const SizedBox(height: 22),

          _buildAudioLevel(),

          const SizedBox(height: 10),

          Text(
            'Nivel actual: '
            '${diagnostic.currentLevel.toStringAsFixed(1)} dB',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF62677F),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NIVEL DE AUDIO
  // ============================================================

  Widget _buildAudioLevel() {
    // Convertimos aproximadamente el rango
    // -80 dB → 0%
    // -10 dB → 100%.
    final normalized =
        ((diagnostic.currentLevel + 80) /
                70)
            .clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            20,
            (index) {
              final threshold =
                  (index + 1) / 20;

              final active =
                  normalized >= threshold;

              return Expanded(
                child: Container(
                  height: 10,
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10),
                    color: active
                        ? const Color(0xFF5B5FEF)
                        : const Color(0xFFDCDDF2),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RESULTADO
  // ============================================================

  Widget _buildResultCard() {
    final success =
        diagnostic.working;

    final color =
        success ? Colors.green : Colors.orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        color: color.withValues(
          alpha: 0.09,
        ),
      ),
      child: Column(
        children: [
          Icon(
            success
                ? Icons.check_circle_rounded
                : Icons.warning_amber_rounded,
            size: 62,
            color: color,
          ),

          const SizedBox(height: 14),

          Text(
            success
                ? '¡Micrófono funcionando!'
                : 'No detectamos suficiente sonido',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            diagnostic.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF62677F),
            ),
          ),

          if (diagnostic.soundDetected) ...[
            const SizedBox(height: 18),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(14),
                color: Colors.white,
              ),
              child: Text(
                'Nivel máximo: '
                '${diagnostic.maxLevel.toStringAsFixed(1)} dB',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}