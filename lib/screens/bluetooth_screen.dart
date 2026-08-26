import 'package:flutter/material.dart';

import '../features/bluetooth/bluetooth_diagnostic.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() =>
      _BluetoothScreenState();
}

class _BluetoothScreenState
    extends State<BluetoothScreen> {
  final BluetoothDiagnostic diagnostic =
      BluetoothDiagnostic();

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
  void dispose() {
    diagnostic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasDevices =
        diagnostic.devices.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth'),
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
            _buildHeader(hasDevices),

            const SizedBox(height: 25),

            _buildStatusCard(hasDevices),

            const SizedBox(height: 20),

            if (hasDevices)
              _buildDevicesSection()
            else
              _buildEmptyState(),

            const SizedBox(height: 25),

            _buildTestButton(),

            const SizedBox(height: 15),

            const Text(
              'La búsqueda puede requerir que Bluetooth '
              'y los permisos correspondientes estén habilitados.',
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

  Widget _buildHeader(bool hasDevices) {
    final color = hasDevices
        ? const Color(0xFF3B82F6)
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
              Icons.bluetooth_rounded,
              size: 47,
              color: color,
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Diagnóstico Bluetooth',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            color: Color(0xFF20233A),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Comprueba que Bluetooth pueda detectar '
          'dispositivos cercanos correctamente.',
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
  // ESTADO
  // ============================================================

  Widget _buildStatusCard(bool hasDevices) {
    final Color color;
    final IconData icon;
    final String title;

    if (testing) {
      color = const Color(0xFF6366F1);
      icon = Icons.bluetooth_searching_rounded;
      title = 'Buscando dispositivos...';
    } else if (hasDevices) {
      color = Colors.green;
      icon = Icons.check_circle_rounded;
      title =
          '${diagnostic.devices.length} dispositivo'
          '${diagnostic.devices.length == 1 ? '' : 's'} encontrado'
          '${diagnostic.devices.length == 1 ? '' : 's'}';
    } else {
      color = const Color(0xFF3B82F6);
      icon = Icons.bluetooth_rounded;
      title = 'Bluetooth listo para probar';
    }

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
            icon,
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
                  title,
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
  // DISPOSITIVOS
  // ============================================================

  Widget _buildDevicesSection() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Padding(
          padding:
              EdgeInsets.only(left: 3),
          child: Text(
            'Dispositivos encontrados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),
        ),

        const SizedBox(height: 12),

        ...diagnostic.devices.map(
          (device) {
            final name =
                device.device.platformName
                        .isNotEmpty
                    ? device.device.platformName
                    : 'Dispositivo desconocido';

            final id =
                device.device.remoteId
                    .toString();

            return Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 10,
              ),
              child: _buildDeviceCard(
                name: name,
                id: id,
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // TARJETA DE DISPOSITIVO
  // ============================================================

  Widget _buildDeviceCard({
    required String name,
    required String id,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(23),
        border: Border.all(
          color: const Color(0xFFEDEEF5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              color:
                  const Color(0xFF3B82F6)
                      .withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.bluetooth_rounded,
              color: Color(0xFF3B82F6),
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        Color(0xFF20233A),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  id,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color:
                        Color(0xFF8A8EA3),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 23,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIN DISPOSITIVOS
  // ============================================================

  Widget _buildEmptyState() {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 28,
      ),
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
          Icon(
            Icons.bluetooth_disabled_rounded,
            size: 52,
            color: Color(0xFF8A8EA3),
          ),

          SizedBox(height: 15),

          Text(
            'Todavía no hay dispositivos',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          SizedBox(height: 7),

          Text(
            'Pulsa el botón para iniciar una '
            'búsqueda de dispositivos Bluetooth cercanos.',
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
              : Icons.bluetooth_searching_rounded,
        ),
        label: Padding(
          padding:
              const EdgeInsets.symmetric(
            vertical: 2,
          ),
          child: Text(
            testing
                ? 'Buscando...'
                : 'Buscar dispositivos',
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