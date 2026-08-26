import 'package:flutter/material.dart';

import '../features/camera/camera_diagnostic.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() =>
      _CameraScreenState();
}

class _CameraScreenState
    extends State<CameraScreen> {
  final CameraDiagnostic diagnostic =
      CameraDiagnostic();

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
        title: const Text('Cámara'),
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

              _buildCameraIcon(primary),

              const SizedBox(height: 25),

              const Text(
                'Probando la cámara',
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
                    ? 'Estamos comprobando la cámara automáticamente.'
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
  // ICONO
  // ============================================================

  Widget _buildCameraIcon(Color primary) {
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
                ? Icons.camera_alt_rounded
                : Icons.camera_alt_outlined,
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
            'Capturando imagen',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            diagnostic.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF777C92),
            ),
          ),

          const SizedBox(height: 24),

          Container(
            width: 90,
            height: 70,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(18),
              color: const Color(0xFF5B5FEF)
                  .withValues(alpha: 0.10),
            ),
            child: const Icon(
              Icons.camera_rounded,
              size: 38,
              color: Color(0xFF5B5FEF),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'La fotografía se validará automáticamente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF777C92),
            ),
          ),
        ],
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
                ? '¡Cámara funcionando!'
                : 'La prueba de cámara falló',
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
                    Icons.photo_camera_rounded,
                    size: 20,
                    color: Colors.green,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Captura generada correctamente',
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