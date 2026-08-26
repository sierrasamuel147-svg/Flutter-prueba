import 'dart:async';

import 'package:flutter/material.dart';

import '../features/sensors/sensor_diagnostic.dart';

class DiagnosticScreen extends StatefulWidget {
  const DiagnosticScreen({super.key});

  @override
  State<DiagnosticScreen> createState() =>
      _DiagnosticScreenState();
}

class _DiagnosticScreenState
    extends State<DiagnosticScreen> {
  final SensorDiagnostic diagnostic =
      SensorDiagnostic();

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    diagnostic.start();

    _timer = Timer.periodic(
      const Duration(milliseconds: 200),
      (_) {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    diagnostic.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allDetected =
        diagnostic.accelerometerDetected &&
        diagnostic.gyroscopeDetected &&
        diagnostic.magnetometerDetected;

    final allResponding =
        diagnostic.accelerometerMoving &&
        diagnostic.gyroscopeMoving &&
        diagnostic.magnetometerResponding;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensores'),
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
            _buildHeader(
              allDetected,
              allResponding,
            ),

            const SizedBox(height: 24),

            _buildInstructionCard(),

            const SizedBox(height: 20),

            _buildAccelerometerCard(),

            const SizedBox(height: 14),

            _buildGyroscopeCard(),

            const SizedBox(height: 14),

            _buildMagnetometerCard(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    bool allDetected,
    bool allResponding,
  ) {
    final Color statusColor;

    if (allResponding) {
      statusColor = Colors.green;
    } else if (allDetected) {
      statusColor = Colors.orange;
    } else {
      statusColor =
          const Color(0xFF6366F1);
    }

    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(30),
            color: statusColor.withValues(
              alpha: 0.10,
            ),
          ),
          child: Container(
            margin:
                const EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(23),
              color: statusColor.withValues(
                alpha: 0.15,
              ),
            ),
            child: Icon(
              Icons.sensors_rounded,
              size: 46,
              color: statusColor,
            ),
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'Diagnóstico de sensores',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 27,
            fontWeight: FontWeight.w900,
            color: Color(0xFF20233A),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Vamos a comprobar que los sensores '
          'de movimiento de tu teléfono respondan correctamente.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            height: 1.45,
            color: Color(0xFF777C92),
          ),
        ),

        const SizedBox(height: 16),

        _buildOverallStatus(
          allDetected,
          allResponding,
        ),
      ],
    );
  }

  // ============================================================
  // ESTADO GENERAL
  // ============================================================

  Widget _buildOverallStatus(
    bool allDetected,
    bool allResponding,
  ) {
    String title;
    String description;
    Color color;
    IconData icon;

    if (allResponding) {
      title = 'Sensores funcionando';
      description =
          'Los tres sensores están respondiendo.';
      color = Colors.green;
      icon = Icons.check_circle_rounded;
    } else if (allDetected) {
      title = 'Sensores detectados';
      description =
          'Mueve el teléfono para completar la prueba.';
      color = Colors.orange;
      icon = Icons.touch_app_rounded;
    } else {
      title = 'Comprobando sensores';
      description =
          'Esperando información del dispositivo.';
      color = const Color(0xFF6366F1);
      icon = Icons.sync_rounded;
    }

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.09,
        ),
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 23,
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight:
                        FontWeight.w800,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF777C92),
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
  // INSTRUCCIONES
  // ============================================================

  Widget _buildInstructionCard() {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFEDEEF5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  const Color(0xFF6366F1)
                      .withValues(
                alpha: 0.10,
              ),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.screen_rotation_alt_rounded,
              color: Color(0xFF6366F1),
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Haz una pequeña prueba',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w800,
                    color: Color(0xFF20233A),
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Mueve y gira el teléfono durante '
                  'unos segundos para comprobar la respuesta.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Color(0xFF777C92),
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
  // ACELERÓMETRO
  // ============================================================

  Widget _buildAccelerometerCard() {
    final sensor =
        diagnostic.lastAccelerometer;

    return _buildSensorCard(
      title: 'Acelerómetro',
      subtitle:
          'Detecta movimiento y aceleración',
      icon: Icons.speed_rounded,
      detected:
          diagnostic.accelerometerDetected,
      working:
          diagnostic.accelerometerMoving,
      values: sensor == null
          ? null
          : {
              'X': sensor.x,
              'Y': sensor.y,
              'Z': sensor.z,
            },
    );
  }

  // ============================================================
  // GIROSCOPIO
  // ============================================================

  Widget _buildGyroscopeCard() {
    final sensor =
        diagnostic.lastGyroscope;

    return _buildSensorCard(
      title: 'Giroscopio',
      subtitle:
          'Detecta rotación del dispositivo',
      icon:
          Icons.screen_rotation_rounded,
      detected:
          diagnostic.gyroscopeDetected,
      working:
          diagnostic.gyroscopeMoving,
      values: sensor == null
          ? null
          : {
              'X': sensor.x,
              'Y': sensor.y,
              'Z': sensor.z,
            },
    );
  }

  // ============================================================
  // MAGNETÓMETRO
  // ============================================================

  Widget _buildMagnetometerCard() {
    final sensor =
        diagnostic.lastMagnetometer;

    return _buildSensorCard(
      title: 'Magnetómetro',
      subtitle:
          'Detecta orientación magnética',
      icon: Icons.explore_rounded,
      detected:
          diagnostic.magnetometerDetected,
      working:
          diagnostic.magnetometerResponding,
      values: sensor == null
          ? null
          : {
              'X': sensor.x,
              'Y': sensor.y,
              'Z': sensor.z,
            },
    );
  }

  // ============================================================
  // TARJETA SENSOR
  // ============================================================

  Widget _buildSensorCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool detected,
    required bool working,
    required Map<String, double>? values,
  }) {
    final Color statusColor;

    if (!detected) {
      statusColor = Colors.grey;
    } else if (working) {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.orange;
    }

    final IconData statusIcon;

    if (!detected) {
      statusIcon =
          Icons.cancel_rounded;
    } else if (working) {
      statusIcon =
          Icons.check_circle_rounded;
    } else {
      statusIcon =
          Icons.hourglass_top_rounded;
    }

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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color:
                      statusColor.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(17),
                ),
                child: Icon(
                  icon,
                  color: statusColor,
                  size: 27,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            Color(0xFF20233A),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color:
                            Color(0xFF8A8EA3),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                statusIcon,
                color: statusColor,
                size: 27,
              ),
            ],
          ),

          const SizedBox(height: 17),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color:
                  statusColor.withValues(
                alpha: 0.07,
              ),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: Text(
              !detected
                  ? 'Sensor no disponible'
                  : working
                      ? '✓ Responde correctamente'
                      : 'Mueve el teléfono para probarlo',
              style: TextStyle(
                color: statusColor,
                fontSize: 13,
                fontWeight:
                    FontWeight.w700,
              ),
            ),
          ),

          if (values != null) ...[
            const SizedBox(height: 17),

            Row(
              children: [
                _buildAxisValue(
                  'X',
                  values['X']!,
                ),
                const SizedBox(width: 8),
                _buildAxisValue(
                  'Y',
                  values['Y']!,
                ),
                const SizedBox(width: 8),
                _buildAxisValue(
                  'Z',
                  values['Z']!,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // VALOR X/Y/Z
  // ============================================================

  Widget _buildAxisValue(
    String axis,
    double value,
  ) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color:
              const Color(0xFFF7F7FC),
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              axis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight:
                    FontWeight.w800,
                color:
                    Color(0xFF6366F1),
              ),
            ),

            const SizedBox(height: 3),

            Text(
              value.toStringAsFixed(2),
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
      ),
    );
  }
}