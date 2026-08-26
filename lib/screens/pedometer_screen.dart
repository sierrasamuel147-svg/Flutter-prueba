import 'package:flutter/material.dart';

import '../features/pedometer/pedometer_diagnostic.dart';

class PedometerScreen extends StatefulWidget {
  const PedometerScreen({super.key});

  @override
  State<PedometerScreen> createState() =>
      _PedometerScreenState();
}

class _PedometerScreenState
    extends State<PedometerScreen> {
  final PedometerDiagnostic diagnostic =
      PedometerDiagnostic();

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

    final success =
        !testing && diagnostic.working;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Podómetro'),
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

              _buildWalkingIcon(
                primary,
                success,
              ),

              const SizedBox(height: 25),

              const Text(
                'Probando el podómetro',
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
                    ? 'Camina al menos 3 pasos para comprobar el sensor.'
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

  Widget _buildWalkingIcon(
    Color primary,
    bool success,
  ) {
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
                ? Icons.directions_walk_rounded
                : Icons.directions_walk_outlined,
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
          Text(
            '${diagnostic.detectedSteps}',
            style: const TextStyle(
              fontSize: 58,
              fontWeight: FontWeight.w800,
              color: Color(0xFF5B5FEF),
            ),
          ),

          const Text(
            'pasos detectados',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF777C92),
            ),
          ),

          const SizedBox(height: 22),

          const CircularProgressIndicator(
            strokeWidth: 4,
          ),

          const SizedBox(height: 20),

          const Text(
            'Camina normalmente',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'La prueba terminará automáticamente '
            'al detectar 3 pasos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF777C92),
            ),
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
                ? '¡Podómetro funcionando!'
                : 'La prueba del podómetro falló',
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
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.directions_walk_rounded,
                    size: 20,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${diagnostic.detectedSteps} pasos detectados',
                    style: const TextStyle(
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