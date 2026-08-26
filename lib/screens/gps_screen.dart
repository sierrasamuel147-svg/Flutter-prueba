import 'package:flutter/material.dart';

import '../features/gps/gps_diagnostic.dart';

class GpsScreen extends StatefulWidget {
  const GpsScreen({super.key});

  @override
  State<GpsScreen> createState() =>
      _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
  final GpsDiagnostic diagnostic =
      GpsDiagnostic();

  bool testing = false;

  Future<void> _runTest() async {
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
    final position = diagnostic.position;

    final bool success =
        diagnostic.working &&
        position != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('GPS / GNSS'),
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
            _buildHeader(success),

            const SizedBox(height: 25),

            if (testing)
              _buildLoadingCard(),

            if (!testing && position != null)
              _buildLocationCard(position),

            const SizedBox(height: 18),

            _buildStatusCard(),

            const SizedBox(height: 25),

            _buildTestButton(),

            const SizedBox(height: 15),

            const Text(
              'El GPS necesita permiso de ubicación '
              'para realizar esta prueba.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
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

  Widget _buildHeader(bool success) {
    final Color color = success
        ? Colors.green
        : const Color(0xFF10B981);

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
              success
                  ? Icons.gps_fixed_rounded
                  : Icons.location_on_rounded,
              size: 46,
              color: color,
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Diagnóstico de ubicación',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            color: Color(0xFF20233A),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Comprueba que el sistema de ubicación '
          'pueda determinar correctamente dónde estás.',
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
            'Buscando ubicación...',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Puede tardar unos segundos. '
            'Mantén el teléfono quieto mientras se obtiene la ubicación.',
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
  // UBICACIÓN
  // ============================================================

  Widget _buildLocationCard(
    dynamic position,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFFEDEEF5),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color:
                      Colors.green.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  color: Colors.green,
                  size: 26,
                ),
              ),

              const SizedBox(width: 13),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubicación obtenida',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            Color(0xFF20233A),
                      ),
                    ),

                    SizedBox(height: 3),

                    Text(
                      'El GPS respondió correctamente',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            Color(0xFF777C92),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 27,
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildCoordinate(
                  label: 'LATITUD',
                  value:
                      position.latitude
                          .toStringAsFixed(6),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildCoordinate(
                  label: 'LONGITUD',
                  value:
                      position.longitude
                          .toStringAsFixed(6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

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
            child: Row(
              children: [
                const Icon(
                  Icons.gps_not_fixed_rounded,
                  size: 21,
                  color: Color(0xFF10B981),
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    'Precisión',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.w700,
                      color:
                          Color(0xFF20233A),
                    ),
                  ),
                ),

                Text(
                  '${position.accuracy.toStringAsFixed(2)} m',
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w800,
                    color:
                        Color(0xFF10B981),
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
  // COORDENADA
  // ============================================================

  Widget _buildCoordinate({
    required String label,
    required String value,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            const Color(0xFFF7F7FC),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight:
                  FontWeight.w800,
              color:
                  Color(0xFF10B981),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w700,
              color:
                  Color(0xFF20233A),
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
    final bool success =
        diagnostic.working &&
        diagnostic.position != null;

    final Color color = success
        ? Colors.green
        : const Color(0xFF10B981);

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
                      ? 'GPS funcionando correctamente'
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
            testing ? null : _runTest,
        icon: Icon(
          testing
              ? Icons.hourglass_top_rounded
              : Icons.gps_fixed_rounded,
        ),
        label: Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: Text(
            testing
                ? 'Obteniendo ubicación...'
                : 'Probar GPS',
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