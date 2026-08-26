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

  @override
  void initState() {
    super.initState();

    _runTest();
  }

  Future<void> _runTest() async {
    if (testing) return;

    setState(() {
      testing = true;
    });

    await service.resetTest();

    final result =
        await service.initialize();

    if (!mounted) return;

    setState(() {
      testing = false;
    });

    // Dejamos visible el resultado.
    await Future.delayed(
      const Duration(milliseconds: 1200),
    );

    if (!mounted) return;

    Navigator.pop(
      context,
      result,
    );
  }

  Future<void> _retryTest() async {
    await _runTest();
  }

  void _skipTest() {
    Navigator.pop(
      context,
      null,
    );
  }

  @override
  void dispose() {
    service.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final success =
        !testing && service.initialized;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notificaciones',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            10,
            24,
            20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),

              _buildNotificationIcon(
                success,
              ),

              const SizedBox(height: 25),

              const Text(
                'Probando notificaciones',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF20233A),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                testing
                    ? 'Comprobando Firebase Cloud Messaging...'
                    : service.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF777C92),
                ),
              ),

              const SizedBox(height: 30),

              if (testing)
                _buildTestingCard(),

              if (!testing &&
                  service.initialized)
                _buildSuccessCard(),

              if (!testing &&
                  !service.initialized)
                _buildErrorCard(),

              const Spacer(),

              if (!testing &&
                  !service.initialized)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _retryTest,
                    icon: const Icon(
                      Icons.refresh_rounded,
                    ),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Text(
                        'Reintentar prueba',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

              if (!testing)
                TextButton(
                  onPressed: _skipTest,
                  child: const Text(
                    'Omitir prueba',
                  ),
                ),

              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(
    bool success,
  ) {
    final color =
        success ? Colors.green : const Color(0xFF5B5FEF);

    return AnimatedContainer(
      duration:
          const Duration(milliseconds: 400),
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(
          alpha: 0.11,
        ),
      ),
      child: Center(
        child: Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(
              alpha: 0.16,
            ),
          ),
          child: Icon(
            success
                ? Icons.notifications_active_rounded
                : Icons.notifications_none_rounded,
            size: 43,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _buildTestingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(26),
        color: const Color(0xFFEFEFFF),
        border: Border.all(
          color: const Color(0xFF5B5FEF)
              .withValues(alpha: 0.18),
        ),
      ),
      child: const Column(
        children: [
          SizedBox(
            width: 46,
            height: 46,
            child: CircularProgressIndicator(
              strokeWidth: 4,
            ),
          ),

          SizedBox(height: 20),

          Text(
            'Configurando FCM',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Solicitando permisos y verificando '
            'la conexión con Firebase.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF777C92),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(26),
        color: Colors.green.withValues(
          alpha: 0.09,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 65,
            color: Colors.green,
          ),

          const SizedBox(height: 15),

          const Text(
            '¡Notificaciones disponibles!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            'Firebase Cloud Messaging fue '
            'configurado correctamente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF62677F),
            ),
          ),

          const SizedBox(height: 20),

          _StatusRow(
            title: 'Permiso',
            value: service.permissionGranted
                ? 'Concedido'
                : 'No concedido',
            success:
                service.permissionGranted,
          ),

          const SizedBox(height: 10),

          _StatusRow(
            title: 'FCM',
            value: service.initialized
                ? 'Configurado'
                : 'No configurado',
            success: service.initialized,
          ),

          const SizedBox(height: 10),

          _StatusRow(
            title: 'Token',
            value: service.token != null
                ? 'Obtenido'
                : 'No obtenido',
            success: service.token != null,
          ),

          if (service.token != null) ...[
            const SizedBox(height: 15),

            ExpansionTile(
              title: const Text(
                'Ver token FCM',
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(12),
                  child: SelectableText(
                    service.token!,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(26),
        color: Colors.red.withValues(
          alpha: 0.09,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_rounded,
            size: 65,
            color: Colors.red,
          ),

          const SizedBox(height: 15),

          const Text(
            'La prueba falló',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Color(0xFF20233A),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            service.message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF62677F),
            ),
          ),
        ],
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
          success
              ? Icons.check_circle_rounded
              : Icons.warning_rounded,
          size: 21,
          color: success
              ? Colors.green
              : Colors.orange,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF62677F),
          ),
        ),
      ],
    );
  }
}