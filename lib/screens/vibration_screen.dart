import 'package:flutter/material.dart';

import '../features/vibration/vibration_diagnostic.dart';

class VibrationScreen extends StatefulWidget {
  const VibrationScreen({super.key});

  @override
  State<VibrationScreen> createState() =>
      _VibrationScreenState();
}

class _VibrationScreenState
    extends State<VibrationScreen> {
  final VibrationDiagnostic diagnostic =
      VibrationDiagnostic();

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
    Navigator.pop(
      context,
      null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary =
        Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vibración'),
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

              _buildVibrationIcon(primary),

              const SizedBox(height: 25),

              const Text(
                'Probando la vibración',
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
                    ? 'Estamos comprobando el motor de vibración.'
                    : diagnostic.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF777C92),
                ),
              ),

              const SizedBox(height: 30),

              if (testing)
                _buildTestingCard(),

              if (!testing &&
                  diagnostic.tested)
                _buildResultCard(),

              const Spacer(),

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

  Widget _buildVibrationIcon(Color primary) {
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
                ? Icons.vibration_rounded
                : Icons.vibration,
            size: 43,
            color: color,
          ),
        ),
      ),
    );
  }

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
            'Activando vibración',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'El teléfono ejecutará un pequeño patrón '
            'de vibración automáticamente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF777C92),
            ),
          ),

          const SizedBox(height: 24),

          const Icon(
            Icons.vibration_rounded,
            size: 55,
            color: Color(0xFF5B5FEF),
          ),
        ],
      ),
    );
  }

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
                ? '¡Vibración disponible!'
                : 'La prueba de vibración falló',
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
                    Icons.smartphone_rounded,
                    size: 20,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Motor de vibración disponible',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            if (diagnostic.hasAmplitudeControl) ...[
              const SizedBox(height: 8),

              const Text(
                'Control de amplitud disponible',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777C92),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}