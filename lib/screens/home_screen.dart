import 'package:flutter/material.dart';

import 'audio_screen.dart';
import 'battery_screen.dart';
import 'biometric_screen.dart';
import 'bluetooth_screen.dart';
import 'camera_screen.dart';
import 'connectivity_screen.dart';
import 'diagnostic_screen.dart';
import 'full_diagnostic_screen.dart';
import 'gps_screen.dart';
import 'microphone_screen.dart';
import 'nfc_screen.dart';
import 'notifications_screen.dart';
import 'pedometer_screen.dart';
import 'vibration_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                30,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildSectionTitle(
                      'Diagnóstico',
                      'Una revisión rápida de tu teléfono',
                    ),

                    const SizedBox(height: 14),

                    _buildFullDiagnosticCard(
                      context,
                    ),

                    const SizedBox(height: 28),

                    _buildSectionTitle(
                      'Pruebas individuales',
                      'Comprueba cada componente por separado',
                    ),

                    const SizedBox(height: 14),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.speed_rounded,
                      title: 'Sensores',
                      description:
                          'Acelerómetro, giroscopio y magnetómetro',
                      iconColor: const Color(0xFF5B5FEF),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const DiagnosticScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.location_on_rounded,
                      title: 'GPS / GNSS',
                      description:
                          'Ubicación y precisión',
                      iconColor: const Color(0xFF36A269),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const GpsScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.camera_alt_rounded,
                      title: 'Cámara',
                      description:
                          'Cámara frontal y trasera',
                      iconColor: const Color(0xFFE56B6F),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const CameraScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.mic_rounded,
                      title: 'Micrófono',
                      description:
                          'Grabación y detección de sonido',
                      iconColor: const Color(0xFF9B5DE5),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const MicrophoneScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.volume_up_rounded,
                      title: 'Altavoz',
                      description:
                          'Salida de audio del dispositivo',
                      iconColor: const Color(0xFFFF9F43),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const AudioScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.fingerprint_rounded,
                      title: 'Biometría',
                      description:
                          'Huella y autenticación',
                      iconColor: const Color(0xFF00A8A8),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const BiometricScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.directions_walk_rounded,
                      title: 'Podómetro',
                      description:
                          'Detección y conteo de pasos',
                      iconColor: const Color(0xFF43AA8B),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PedometerScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.bluetooth_rounded,
                      title: 'Bluetooth',
                      description:
                          'Detección y conectividad Bluetooth',
                      iconColor: const Color(0xFF4285F4),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const BluetoothScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.nfc_rounded,
                      title: 'NFC',
                      description:
                          'Detección y lectura NFC',
                      iconColor: const Color(0xFF6C63FF),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const NfcScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.vibration_rounded,
                      title: 'Vibración',
                      description:
                          'Motor de vibración',
                      iconColor: const Color(0xFFFF6B6B),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const VibrationScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.battery_full_rounded,
                      title: 'Batería',
                      description:
                          'Nivel y estado de batería',
                      iconColor: const Color(0xFF35B779),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const BatteryScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon: Icons.wifi_rounded,
                      title: 'Conectividad',
                      description:
                          'Wi-Fi, Internet y red',
                      iconColor: const Color(0xFF3A86FF),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const ConnectivityScreen(),
                          ),
                        );
                      },
                    ),

                    _buildDiagnosticButton(
                      context,
                      icon:
                          Icons.notifications_active_rounded,
                      title: 'Notificaciones',
                      description:
                          'Firebase Cloud Messaging',
                      iconColor: const Color(0xFFFFB703),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        20,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xFFE9E9FF),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.phone_android_rounded,
              size: 32,
              color: Color(0xFF5B5FEF),
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Phone Diagnostic',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF20233A),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Tu teléfono, bajo revisión.',
                  style: TextStyle(
                    fontSize: 14,
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
  // SECCIÓN
  // ============================================================

  Widget _buildSectionTitle(
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: Color(0xFF20233A),
          ),
        ),

        const SizedBox(height: 3),

        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF777C92),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DIAGNÓSTICO COMPLETO
  // ============================================================

  Widget _buildFullDiagnosticCard(
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(28),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const FullDiagnosticScreen(),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF5B5FEF),
                Color(0xFF7478F5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
                BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color:
                        Colors.white.withValues(
                      alpha: 0.18,
                    ),
                    borderRadius:
                        BorderRadius.circular(22),
                  ),
                  child: const Icon(
                    Icons.health_and_safety_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),

                const SizedBox(width: 18),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Diagnóstico completo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Revisa automáticamente '
                        'los componentes del teléfono.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // BOTÓN DE DIAGNÓSTICO
  // ============================================================

  Widget _buildDiagnosticButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A20233A),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(
                      alpha: 0.11,
                    ),
                    borderRadius:
                        BorderRadius.circular(17),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 27,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w700,
                          color:
                              Color(0xFF20233A),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          color:
                              Color(0xFF777C92),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFB7BBCB),
                  size: 27,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}