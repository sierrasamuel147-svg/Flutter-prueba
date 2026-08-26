import 'package:flutter/material.dart';

import '../features/biometrics/biometric_diagnostic.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() =>
      _BiometricScreenState();
}

class _BiometricScreenState
    extends State<BiometricScreen> {
  final BiometricDiagnostic diagnostic =
      BiometricDiagnostic();

  bool testing = false;

  Future<void> _test() async {
    if (testing) return;

    setState(() {
      testing = true;
    });

    await diagnostic.test();

    if (!mounted) return;

    setState(() {
      testing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authenticated =
        diagnostic.authenticated;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometría'),
      ),
      body: SafeArea(
        child: ListView(
          physics:
              const BouncingScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            30,
          ),
          children: [
            _buildHeader(authenticated),

            const SizedBox(height: 25),

            if (testing)
              _buildLoadingCard(),

            if (!testing && authenticated)
              _buildSuccessCard(),

            if (!testing && !authenticated)
              _buildInformationCard(),

            const SizedBox(height: 18),

            _buildStatusCard(),

            const SizedBox(height: 25),

            _buildTestButton(),

            const SizedBox(height: 15),

            const Text(
              'La prueba utiliza el sistema biométrico '
              'del dispositivo para comprobar que puede '
              'realizar una autenticación correctamente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Color(0xFF8A8EA3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(bool authenticated) {
    final color = authenticated
        ? const Color(0xFF22C55E)
        : const Color(0xFF6366F1);

    return Column(
      children: [
        Container(
          width: 94,
          height: 94,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(31),
            color: color.withValues(
              alpha: 0.10,
            ),
          ),
          child: Container(
            margin:
                const EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(24),
              color: color.withValues(
                alpha: 0.15,
              ),
            ),
            child: Icon(
              authenticated
                  ? Icons.fingerprint_rounded
                  : Icons.fingerprint,
              size: 52,
              color: color,
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Diagnóstico biométrico',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            color: Color(0xFF20233A),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Comprueba la autenticación mediante '
          'huella, rostro u otro método biométrico.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.45,
            color: Color(0xFF777C92),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARGANDO
  // ============================================================

  Widget _buildLoadingCard() {
    return Container(
      padding:
          const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFEDEEF5),
        ),
      ),
      child: const Column(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child:
                CircularProgressIndicator(
              strokeWidth: 4,
            ),
          ),

          SizedBox(height: 20),

          Text(
            'Comprobando biometría...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Sigue las instrucciones que aparezcan '
            'en la pantalla del teléfono.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xFF777C92),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFORMACIÓN
  // ============================================================

  Widget _buildInformationCard() {
    return Container(
      padding:
          const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFEDEEF5),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color:
                  const Color(0xFF6366F1)
                      .withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fingerprint,
              size: 42,
              color: Color(0xFF6366F1),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Listo para comprobar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Pulsa el botón para iniciar una '
            'autenticación biométrica.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF777C92),
            ),
          ),

          const SizedBox(height: 17),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF7F7FC),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color:
                      Color(0xFF6366F1),
                  size: 21,
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'El sistema puede solicitar tu '
                    'huella, rostro o PIN de respaldo.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color:
                          Color(0xFF777C92),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ÉXITO
  // ============================================================

  Widget _buildSuccessCard() {
    return Container(
      padding:
          const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(26),
        border: Border.all(
          color: Colors.green.withValues(
            alpha: 0.20,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color:
                  Colors.green.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.green,
              size: 50,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Biometría funcionando',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'La autenticación biométrica '
            'se realizó correctamente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xFF777C92),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ESTADO
  // ============================================================

  Widget _buildStatusCard() {
    final success =
        diagnostic.authenticated;

    final color = success
        ? const Color(0xFF22C55E)
        : const Color(0xFF6366F1);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.08,
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            success
                ? Icons.check_circle_rounded
                : Icons.fingerprint,
            color: color,
            size: 24,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  success
                      ? 'Autenticación correcta'
                      : 'Estado de la prueba',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w800,
                    color: color,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  diagnostic.message,
                  style: const TextStyle(
                    fontSize: 12,
                    color:
                        Color(0xFF777C92),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTÓN
  // ============================================================

  Widget _buildTestButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
            testing ? null : _test,
        icon: Icon(
          testing
              ? Icons.hourglass_top_rounded
              : Icons.fingerprint_rounded,
        ),
        label: Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: Text(
            testing
                ? 'Autenticando...'
                : 'Probar biometría',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}