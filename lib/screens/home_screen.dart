import 'package:flutter/material.dart';

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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Diagnostic'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          const Icon(
            Icons.phone_android,
            size: 80,
          ),

          const SizedBox(height: 20),

          const Text(
            'Diagnóstico del dispositivo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Comprueba el funcionamiento de los componentes '
            'y funciones de tu teléfono.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 30),

          _buildDiagnosticButton(
  context,
  icon: Icons.health_and_safety,
  title: 'Diagnóstico completo',
  description:
      'Ejecuta todas las pruebas del dispositivo',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const FullDiagnosticScreen(),
      ),
    );
  },
),

          _buildDiagnosticButton(
            context,
            icon: Icons.speed,
            title: 'Sensores',
            description: 'Acelerómetro, giroscopio y magnetómetro',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const DiagnosticScreen(),
                ),
              );
            },
          ),

          

          _buildDiagnosticButton(
            context,
            icon: Icons.location_on,
            title: 'GPS / GNSS',
            description: 'Prueba de ubicación y precisión',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const GpsScreen(),
    ),
  );
},
          ),

          _buildDiagnosticButton(
            context,
            icon: Icons.camera_alt,
            title: 'Cámara',
            description: 'Cámara frontal y trasera',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const CameraScreen(),
    ),
  );
},
          ),

          _buildDiagnosticButton(
            context,
            icon: Icons.mic,
            title: 'Micrófono',
            description: 'Prueba de grabación de audio',
           onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const MicrophoneScreen(),
    ),
  );
},
          ),

          _buildDiagnosticButton(
  context,
  icon: Icons.volume_up,
  title: 'Altavoz',
  description: 'Prueba de salida de audio del dispositivo',
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AudioScreen(),
      ),
    );
  },
),

          _buildDiagnosticButton(
            context,
            icon: Icons.fingerprint,
            title: 'Biometría',
            description: 'Huella digital y autenticación',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const BiometricScreen(),
    ),
  );
},
          ),

          _buildDiagnosticButton(
            context,
            icon: Icons.directions_walk,
            title: 'Podómetro',
            description: 'Detección y conteo de pasos',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const PedometerScreen(),
    ),
  );
},
          ),

          _buildDiagnosticButton(
            context,
            icon: Icons.bluetooth,
            title: 'Bluetooth',
            description: 'Detección y conexión Bluetooth',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const BluetoothScreen(),
    ),
  );
},
          ),

          _buildDiagnosticButton(
            context,
            icon: Icons.nfc,
            title: 'NFC',
            description: 'Detección y lectura NFC',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const NfcScreen(),
    ),
  );
},
          ),

          _buildDiagnosticButton(
            context,
            icon: Icons.vibration,
            title: 'Vibración',
            description: 'Prueba del motor de vibración',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const VibrationScreen(),
    ),
  );
},
          ),

          _buildDiagnosticButton(
            context,
            icon: Icons.battery_full,
            title: 'Batería',
            description: 'Estado y nivel de batería',
           onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const BatteryScreen(),
    ),
  );
},
          ),

          _buildDiagnosticButton(
            context,
            icon: Icons.wifi,
            title: 'Conectividad',
            description: 'Wi-Fi, Internet y red',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ConnectivityScreen(),
    ),
  );
},
          ),

          _buildDiagnosticButton(
            context,
            icon: Icons.notifications,
            title: 'Notificaciones',
            description: 'Prueba de notificaciones',
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const NotificationsScreen(),
    ),
  );
},
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 35,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}