import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/auth/auth_service.dart';

import 'diagnostic_screen.dart';
import 'gps_screen.dart';
import 'camera_screen.dart';
import 'microphone_screen.dart';
import 'biometric_screen.dart';
import 'pedometer_screen.dart';
import 'bluetooth_screen.dart';
import 'nfc_screen.dart';
import 'vibration_screen.dart';
import 'battery_screen.dart';
import 'connectivity_screen.dart';
import 'notifications_screen.dart';
import 'audio_screen.dart';
import 'full_diagnostic_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ============================================================
  // CERRAR SESIÓN
  // ============================================================

  Future<void> _signOut(
    BuildContext context,
  ) async {
    try {
      await AuthService().signOut();
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo cerrar la sesión',
          ),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics:
              const BouncingScrollPhysics(),
          slivers: [
            // ==================================================
            // PARTE SUPERIOR
            // ==================================================

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                30,
              ),
              sliver: SliverList(
                delegate:
                    SliverChildListDelegate([
                  _buildHeader(context),

                  const SizedBox(height: 24),

                  // DIAGNÓSTICO COMPLETO
                  _buildFullDiagnosticCard(
                    context,
                  ),

                  const SizedBox(height: 12),

                  // HISTORIAL
                  _buildHistoryCard(
                    context,
                  ),

                  const SizedBox(height: 30),

                  _buildSectionTitle(),

                  const SizedBox(height: 14),
                ]),
              ),
            ),

            // ==================================================
            // PRUEBAS INDIVIDUALES
            // ==================================================

            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              sliver: SliverGrid(
                delegate:
                    SliverChildListDelegate(
                  _buildDiagnosticItems(
                    context,
                  ),
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.08,
                ),
              ),
            ),

            const SliverPadding(
              padding:
                  EdgeInsets.only(
                bottom: 30,
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

  Widget _buildHeader(
    BuildContext context,
  ) {
    final User? user =
        FirebaseAuth.instance.currentUser;

    final String displayName =
        user?.displayName?.trim().isNotEmpty ==
                true
            ? user!.displayName!.trim()
            : 'Usuario';

    final String firstName =
        displayName.split(' ').first;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // ==================================================
            // LOGO
            // ==================================================

            Container(
              width: 58,
              height: 58,
              decoration:
                  BoxDecoration(
                borderRadius:
                    BorderRadius.circular(
                  19,
                ),
                gradient:
                    const LinearGradient(
                  begin:
                      Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6366F1),
                    Color(0xFF8B5CF6),
                  ],
                ),
              ),
              child: const Icon(
                Icons.phone_android_rounded,
                color: Colors.white,
                size: 31,
              ),
            ),

            const Spacer(),

            // ==================================================
            // PERFIL
            // ==================================================

            PopupMenuButton<String>(
              tooltip: 'Cuenta',
              offset:
                  const Offset(0, 60),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
              onSelected:
                  (value) async {
                if (value ==
                    'logout') {
                  await _signOut(
                    context,
                  );
                }
              },
              itemBuilder:
                  (context) {
                return [
                  PopupMenuItem<String>(
                    enabled: false,
                    child: SizedBox(
                      width: 230,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Row(
                            children: [
                              _buildUserAvatar(
                                user,
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child:
                                    Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    Text(
                                      displayName,
                                      maxLines:
                                          1,
                                      overflow:
                                          TextOverflow
                                              .ellipsis,
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .w800,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 3,
                                    ),

                                    Text(
                                      user?.email ??
                                          'Cuenta de Google',
                                      maxLines:
                                          1,
                                      overflow:
                                          TextOverflow
                                              .ellipsis,
                                      style:
                                          const TextStyle(
                                        fontSize:
                                            12,
                                        color:
                                            Color(
                                          0xFF777C92,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          const Divider(),

                          const SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(
                          Icons
                              .logout_rounded,
                          size: 21,
                        ),

                        SizedBox(
                          width: 10,
                        ),

                        Text(
                          'Cerrar sesión',
                        ),
                      ],
                    ),
                  ),
                ];
              },
              child:
                  _buildUserAvatar(
                user,
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 25,
        ),

        Text(
          '¡Hola, $firstName! 👋',
          style: const TextStyle(
            fontSize: 17,
            fontWeight:
                FontWeight.w600,
            color:
                Color(0xFF777C92),
          ),
        ),

        const SizedBox(
          height: 5,
        ),

        const Text(
          'Revisemos tu teléfono',
          style: TextStyle(
            fontSize: 31,
            height: 1.1,
            fontWeight:
                FontWeight.w900,
            color:
                Color(0xFF20233A),
          ),
        ),

        const SizedBox(
          height: 10,
        ),

        const Text(
          'Comprueba rápidamente que los '
          'componentes de tu dispositivo '
          'funcionen correctamente.',
          style: TextStyle(
            fontSize: 15,
            height: 1.45,
            color:
                Color(0xFF777C92),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildUserAvatar(
    User? user,
  ) {
    final photoUrl =
        user?.photoURL;

    return Container(
      width: 46,
      height: 46,
      decoration:
          BoxDecoration(
        shape: BoxShape.circle,
        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
        border: Border.all(
          color:
              const Color(0xFFEDEEF5),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: photoUrl != null
            ? Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (
                  context,
                  error,
                  stackTrace,
                ) {
                  return const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 25,
                  );
                },
              )
            : const Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 25,
              ),
      ),
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
            BorderRadius.circular(30),
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
          padding:
              const EdgeInsets.all(23),
          decoration:
              BoxDecoration(
            borderRadius:
                BorderRadius.circular(30),
            gradient:
                const LinearGradient(
              begin:
                  Alignment.topLeft,
              end:
                  Alignment.bottomRight,
              colors: [
                Color(0xFF6366F1),
                Color(0xFF7C3AED),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color:
                    const Color(
                  0xFF6366F1,
                ).withValues(
                  alpha: 0.20,
                ),
                blurRadius: 25,
                offset:
                    const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 66,
                height: 66,
                decoration:
                    BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.16,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    22,
                  ),
                ),
                child: const Icon(
                  Icons
                      .health_and_safety_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),

              const SizedBox(
                width: 17,
              ),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diagnóstico completo',
                      style:
                          TextStyle(
                        color:
                            Colors.white,
                        fontSize: 19,
                        fontWeight:
                            FontWeight
                                .w800,
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Text(
                      'Comprueba todo de una vez',
                      style:
                          TextStyle(
                        color:
                            Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 44,
                height: 44,
                decoration:
                    BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.16,
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child:
                    const Icon(
                  Icons
                      .arrow_forward_rounded,
                  color:
                      Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HISTORIAL
  // ============================================================

  Widget _buildHistoryCard(
    BuildContext context,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(26),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  HistoryScreen(),
            ),
          );
        },
        child: Ink(
          padding:
              const EdgeInsets.all(19),
          decoration:
              BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(26),
            border: Border.all(
              color:
                  const Color(
                0xFFEDEEF5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black
                        .withValues(
                  alpha: 0.025,
                ),
                blurRadius: 15,
                offset:
                    const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFF6366F1,
                  ).withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    17,
                  ),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color:
                      Color(0xFF6366F1),
                  size: 28,
                ),
              ),

              const SizedBox(
                width: 14,
              ),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      'Historial',
                      style:
                          TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight
                                .w800,
                        color:
                            Color(
                          0xFF20233A,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 4,
                    ),

                    Text(
                      'Consulta tus diagnósticos anteriores',
                      maxLines: 1,
                      overflow:
                          TextOverflow
                              .ellipsis,
                      style:
                          TextStyle(
                        fontSize: 13,
                        color:
                            Color(
                          0xFF8A8EA3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons
                    .arrow_forward_ios_rounded,
                size: 17,
                color:
                    Color(0xFFB5B8C7),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TÍTULO DE SECCIÓN
  // ============================================================

  Widget _buildSectionTitle() {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'Pruebas individuales',
            style: TextStyle(
              fontSize: 21,
              fontWeight:
                  FontWeight.w800,
              color:
                  Color(0xFF20233A),
            ),
          ),
        ),

        Text(
          'Explorar',
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                FontWeight.w600,
            color:
                Color(0xFF777C92),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // LISTA DE PRUEBAS
  // ============================================================

  List<Widget> _buildDiagnosticItems(
    BuildContext context,
  ) {
    return [
      _buildDiagnosticCard(
        context,
        icon: Icons.speed_rounded,
        title: 'Sensores',
        description: 'Movimiento',
        color:
            const Color(0xFF6366F1),
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

      _buildDiagnosticCard(
        context,
        icon:
            Icons.location_on_rounded,
        title: 'GPS / GNSS',
        description: 'Ubicación',
        color:
            const Color(0xFF10B981),
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

      _buildDiagnosticCard(
        context,
        icon:
            Icons.camera_alt_rounded,
        title: 'Cámara',
        description: 'Fotografía',
        color:
            const Color(0xFFEC4899),
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

      _buildDiagnosticCard(
        context,
        icon: Icons.mic_rounded,
        title: 'Micrófono',
        description: 'Grabación',
        color:
            const Color(0xFFF97316),
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

      _buildDiagnosticCard(
        context,
        icon:
            Icons.volume_up_rounded,
        title: 'Altavoz',
        description: 'Audio',
        color:
            const Color(0xFF8B5CF6),
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

      _buildDiagnosticCard(
        context,
        icon:
            Icons.fingerprint_rounded,
        title: 'Biometría',
        description:
            'Huella / acceso',
        color:
            const Color(0xFF06B6D4),
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

      _buildDiagnosticCard(
        context,
        icon:
            Icons.directions_walk_rounded,
        title: 'Podómetro',
        description: 'Pasos',
        color:
            const Color(0xFF14B8A6),
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

      _buildDiagnosticCard(
        context,
        icon:
            Icons.bluetooth_rounded,
        title: 'Bluetooth',
        description: 'Conexión',
        color:
            const Color(0xFF3B82F6),
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

      _buildDiagnosticCard(
        context,
        icon: Icons.nfc_rounded,
        title: 'NFC',
        description: 'Comunicación',
        color:
            const Color(0xFF7C3AED),
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

      _buildDiagnosticCard(
        context,
        icon:
            Icons.vibration_rounded,
        title: 'Vibración',
        description:
            'Motor háptico',
        color:
            const Color(0xFFE11D48),
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

      _buildDiagnosticCard(
        context,
        icon:
            Icons.battery_full_rounded,
        title: 'Batería',
        description: 'Energía',
        color:
            const Color(0xFF22C55E),
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

      _buildDiagnosticCard(
        context,
        icon: Icons.wifi_rounded,
        title: 'Conectividad',
        description:
            'Internet / red',
        color:
            const Color(0xFF0EA5E9),
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

      _buildDiagnosticCard(
        context,
        icon: Icons
            .notifications_active_rounded,
        title: 'Notificaciones',
        description:
            'Alertas Push',
        color:
            const Color(0xFFF59E0B),
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
    ];
  }

  // ============================================================
  // TARJETA INDIVIDUAL
  // ============================================================

  Widget _buildDiagnosticCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding:
              const EdgeInsets.all(16),
          decoration:
              BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color:
                  const Color(
                0xFFEDEEF5,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration:
                        BoxDecoration(
                      color:
                          color.withValues(
                        alpha: 0.11,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        16,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 26,
                    ),
                  ),

                  const Spacer(),

                  const Icon(
                    Icons
                        .arrow_outward_rounded,
                    color:
                        Color(0xFFB5B8C7),
                    size: 18,
                  ),
                ],
              ),

              const Spacer(),

              Text(
                title,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    const TextStyle(
                  fontSize: 16,
                  fontWeight:
                      FontWeight.w800,
                  color:
                      Color(0xFF20233A),
                ),
              ),

              const SizedBox(
                height: 4,
              ),

              Text(
                description,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    const TextStyle(
                  fontSize: 12,
                  color:
                      Color(0xFF8A8EA3),
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}