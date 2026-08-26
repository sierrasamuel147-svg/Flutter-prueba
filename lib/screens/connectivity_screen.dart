import 'package:flutter/material.dart';

import '../features/connectivity/connectivity_diagnostic.dart';

class ConnectivityScreen extends StatefulWidget {
  const ConnectivityScreen({super.key});

  @override
  State<ConnectivityScreen> createState() =>
      _ConnectivityScreenState();
}

class _ConnectivityScreenState
    extends State<ConnectivityScreen> {
  final ConnectivityDiagnostic diagnostic =
      ConnectivityDiagnostic();

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
    final hasResult =
        !testing && diagnostic.working;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectividad'),
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
            _buildHeader(),

            const SizedBox(height: 25),

            if (testing)
              _buildLoadingCard(),

            if (hasResult)
              _buildConnectionCard(),

            const SizedBox(height: 18),

            _buildStatusCard(),

            const SizedBox(height: 25),

            _buildTestButton(),

            const SizedBox(height: 15),

            const Text(
              'La prueba comprueba la conexión de red '
              'y verifica si existe acceso a Internet.',
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

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 94,
          height: 94,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(31),
            color:
                const Color(0xFF06B6D4)
                    .withValues(
              alpha: 0.10,
            ),
          ),
          child: Container(
            margin:
                const EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(24),
              color:
                  const Color(0xFF06B6D4)
                      .withValues(
                alpha: 0.15,
              ),
            ),
            child: const Icon(
              Icons.wifi_rounded,
              size: 48,
              color: Color(0xFF06B6D4),
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Diagnóstico de conectividad',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            color: Color(0xFF20233A),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Comprueba la conexión de red y el acceso '
          'a Internet de tu dispositivo.',
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
            width: 45,
            height: 45,
            child:
                CircularProgressIndicator(
              strokeWidth: 4,
            ),
          ),

          SizedBox(height: 18),

          Text(
            'Comprobando conexión...',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Estamos verificando tu red y '
            'el acceso a Internet.',
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
  // CONEXIÓN
  // ============================================================

  Widget _buildConnectionCard() {
    final internet =
        diagnostic.hasInternet;

    final color = internet
        ? const Color(0xFF22C55E)
        : const Color(0xFFF59E0B);

    return Container(
      padding:
          const EdgeInsets.all(20),
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
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: color.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              internet
                  ? Icons.wifi_rounded
                  : Icons.wifi_off_rounded,
              color: color,
              size: 42,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            diagnostic.connectionText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            internet
                ? 'Con acceso a Internet'
                : 'Conexión detectada, pero sin '
                    'acceso confirmado a Internet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: color,
            ),
          ),

          const SizedBox(height: 20),

          _buildInfoRow(
            icon: Icons.network_check_rounded,
            title: 'Red',
            value:
                diagnostic.connectionText,
          ),

          const SizedBox(height: 10),

          _buildInfoRow(
            icon: internet
                ? Icons.public_rounded
                : Icons.public_off_rounded,
            title: 'Internet',
            value: internet
                ? 'Disponible'
                : 'No confirmado',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILA DE INFORMACIÓN
  // ============================================================

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            const Color(0xFFF7F7FC),
        borderRadius:
            BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color:
                const Color(0xFF06B6D4),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight:
                    FontWeight.w700,
                color:
                    Color(0xFF20233A),
              ),
            ),
          ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight.w700,
                color:
                    Color(0xFF777C92),
              ),
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
        diagnostic.hasInternet;

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
                : Icons.info_rounded,
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
                      ? 'Conectividad funcionando'
                      : 'Resultado de la prueba',
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
              : Icons.network_check_rounded,
        ),
        label: Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: Text(
            testing
                ? 'Comprobando...'
                : 'Probar conectividad',
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