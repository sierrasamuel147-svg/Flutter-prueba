import 'package:flutter/material.dart';

import '../features/nfc/nfc_diagnostic.dart';

class NfcScreen extends StatefulWidget {
  const NfcScreen({super.key});

  @override
  State<NfcScreen> createState() =>
      _NfcScreenState();
}

class _NfcScreenState extends State<NfcScreen> {
  final NfcDiagnostic diagnostic =
      NfcDiagnostic();

  bool loading = true;

  @override
  void initState() {
    super.initState();

    _checkNfc();
  }

  Future<void> _checkNfc() async {
    await diagnostic.checkAvailability();

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  Future<void> _startScan() async {
    if (diagnostic.scanning) return;

    setState(() {});

    await diagnostic.startScan();

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _stopScan() async {
    await diagnostic.stopScan();

    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() {
    diagnostic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detected = diagnostic.tagDetected;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC'),
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
            _buildHeader(detected),

            const SizedBox(height: 25),

            if (loading)
              _buildLoadingCard()
            else ...[
              _buildAvailabilityCard(),

              const SizedBox(height: 18),

              if (diagnostic.scanning)
                _buildScanningCard()
              else if (detected)
                _buildSuccessCard()
              else
                _buildInstructionCard(),

              const SizedBox(height: 25),

              _buildActionButton(),
            ],

            const SizedBox(height: 15),

            const Text(
              'Para comprobar NFC necesitas acercar '
              'el teléfono a una etiqueta o tarjeta NFC.',
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

  Widget _buildHeader(bool detected) {
    final color = detected
        ? Colors.green
        : const Color(0xFF7C3AED);

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
              Icons.nfc_rounded,
              size: 48,
              color: color,
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Diagnóstico NFC',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            color: Color(0xFF20233A),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Comprueba que el teléfono pueda '
          'detectar y leer dispositivos NFC cercanos.',
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
            'Comprobando NFC...',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Estamos comprobando si el dispositivo '
            'dispone de NFC.',
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
  // DISPONIBILIDAD
  // ============================================================

  Widget _buildAvailabilityCard() {
    final available =
        diagnostic.available;

    final color = available
        ? const Color(0xFF7C3AED)
        : Colors.red;

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
            available
                ? Icons.nfc_rounded
                : Icons.nfc_outlined,
            color: color,
            size: 25,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  available
                      ? 'NFC disponible'
                      : 'NFC no disponible',
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

          Icon(
            available
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: color,
            size: 24,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INSTRUCCIONES
  // ============================================================

  Widget _buildInstructionCard() {
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
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color:
                  const Color(0xFF7C3AED)
                      .withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.contactless_rounded,
              color: Color(0xFF7C3AED),
              size: 36,
            ),
          ),

          const SizedBox(height: 17),

          const Text(
            '¿Listo para probar NFC?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Pulsa "Iniciar prueba" y acerca la parte '
            'trasera del teléfono a una etiqueta NFC.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: Color(0xFF777C92),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color:
                  const Color(0xFFF7F7FC),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color:
                      Color(0xFFF59E0B),
                  size: 21,
                ),

                SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'Normalmente la antena NFC está '
                    'en la parte trasera del teléfono.',
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
  // ESCANEANDO
  // ============================================================

  Widget _buildScanningCard() {
    return Container(
      padding:
          const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(26),
        border: Border.all(
          color:
              const Color(0xFF7C3AED)
                  .withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:
                  const Color(0xFF7C3AED)
                      .withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.nfc_rounded,
              color: Color(0xFF7C3AED),
              size: 42,
            ),
          ),

          const SizedBox(height: 20),

          const CircularProgressIndicator(),

          const SizedBox(height: 20),

          const Text(
            'Buscando etiqueta NFC...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Acerca el teléfono lentamente a una '
            'etiqueta o tarjeta NFC.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Color(0xFF777C92),
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color:
                  const Color(0xFF7C3AED)
                      .withValues(
                alpha: 0.08,
              ),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  Icons.sensors_rounded,
                  color: Color(0xFF7C3AED),
                  size: 18,
                ),
                SizedBox(width: 7),
                Text(
                  'Esperando NFC',
                  style: TextStyle(
                    color:
                        Color(0xFF7C3AED),
                    fontWeight:
                        FontWeight.w700,
                    fontSize: 12,
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
            width: 80,
            height: 80,
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
              size: 48,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'NFC funcionando',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 7),

          Text(
            diagnostic.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
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
  // BOTÓN
  // ============================================================

  Widget _buildActionButton() {
    if (!diagnostic.available) {
      return const SizedBox.shrink();
    }

    if (diagnostic.scanning) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _stopScan,
          icon: const Icon(
            Icons.stop_rounded,
          ),
          label: const Padding(
            padding:
                EdgeInsets.symmetric(
              vertical: 2,
            ),
            child: Text(
              'Cancelar prueba',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w800,
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _startScan,
        icon: const Icon(
          Icons.nfc_rounded,
        ),
        label: const Padding(
          padding:
              EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: Text(
            'Iniciar prueba NFC',
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}