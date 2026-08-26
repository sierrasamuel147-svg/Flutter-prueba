import 'package:flutter/material.dart';

import '../features/audio/audio_diagnostic.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() =>
      _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final AudioDiagnostic diagnostic =
      AudioDiagnostic();

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

    // Mostramos brevemente el resultado.
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
    diagnostic.stop();

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
        title: const Text('Altavoz'),
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
              // ICONO
              // =================================================

              _buildSpeakerIcon(primary),

              const SizedBox(height: 25),

              const Text(
                'Probando el altavoz',
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
                    ? 'Estamos comprobando la salida de audio del teléfono.'
                    : diagnostic.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF777C92),
                ),
              ),

              const SizedBox(height: 30),

              // =================================================
              // PRUEBA EN CURSO
              // =================================================

              if (testing)
                _buildTestingCard(),

              // =================================================
              // RESULTADO
              // =================================================

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

              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ICONO DEL ALTAVOZ
  // ============================================================

  Widget _buildSpeakerIcon(Color primary) {
    final success =
        !testing && diagnostic.working;

    final color =
        success ? Colors.green : primary;

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
            success
                ? Icons.volume_up_rounded
                : Icons.volume_up_outlined,
            size: 43,
            color: color,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PRUEBA EN CURSO
  // ============================================================

  Widget _buildTestingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(26),
        color: const Color(0xFFEFEFFF),
        border: Border.all(
          color: const Color(0xFF5B5FEF)
              .withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 46,
            height: 46,
            child: CircularProgressIndicator(
              strokeWidth: 4,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Reproduciendo sonido',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'La prueba terminará automáticamente '
            'en unos segundos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF777C92),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              _buildSoundWave(0.45),
              _buildSoundWave(0.75),
              _buildSoundWave(1.0),
              _buildSoundWave(0.65),
              _buildSoundWave(0.35),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundWave(double height) {
    return Container(
      width: 8,
      height: 45 * height,
      margin:
          const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF5B5FEF),
        borderRadius:
            BorderRadius.circular(10),
      ),
    );
  }

  // ============================================================
  // RESULTADO
  // ============================================================

  Widget _buildResultCard() {
    final success =
        diagnostic.working;

    final color =
        success ? Colors.green : Colors.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(26),
        color: color.withValues(
          alpha: 0.09,
        ),
      ),
      child: Column(
        children: [
          Icon(
            success
                ? Icons.check_circle_rounded
                : Icons.error_rounded,
            size: 65,
            color: color,
          ),

          const SizedBox(height: 15),

          Text(
            success
                ? '¡Salida de audio disponible!'
                : 'No se pudo reproducir el audio',
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

          if (success) ...[
            const SizedBox(height: 18),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Icon(
                    Icons.volume_up_rounded,
                    size: 20,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Audio reproducido correctamente',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}