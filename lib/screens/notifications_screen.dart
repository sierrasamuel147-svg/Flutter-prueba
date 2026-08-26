import 'package:flutter/material.dart';

import '../features/notifications/push_notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  final PushNotificationService service =
      PushNotificationService();

  bool testing = false;

  Future<void> _test() async {
    setState(() {
      testing = true;
    });

    await service.initialize();

    if (mounted) {
      setState(() {
        testing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones Push'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.notifications_active,
              size: 90,
            ),

            const SizedBox(height: 20),

            const Text(
              'Diagnóstico de notificaciones',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            _StatusRow(
              title: 'Permiso',
              value: service.permissionGranted
                  ? 'Concedido'
                  : 'No comprobado',
              success: service.permissionGranted,
            ),

            const SizedBox(height: 15),

            _StatusRow(
              title: 'Firebase Cloud Messaging',
              value: service.initialized
                  ? 'Configurado'
                  : 'No configurado',
              success: service.initialized,
            ),

            const SizedBox(height: 15),

            _StatusRow(
              title: 'Token FCM',
              value: service.token != null
                  ? 'Obtenido'
                  : 'No obtenido',
              success: service.token != null,
            ),

            const SizedBox(height: 25),

            if (service.token != null)
              ExpansionTile(
                title: const Text('Ver token FCM'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SelectableText(
                      service.token!,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            Text(
              service.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),

            const Spacer(),

            if (testing)
              const CircularProgressIndicator(),

            if (!testing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _test,
                  icon: const Icon(
                    Icons.notifications_active,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'Probar notificaciones',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            if (service.initialized)
              const Text(
                '✓ FCM DISPONIBLE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String title;
  final String value;
  final bool success;

  const _StatusRow({
    required this.title,
    required this.value,
    required this.success,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          success ? Icons.check_circle : Icons.warning,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(value),
      ],
    );
  }
}