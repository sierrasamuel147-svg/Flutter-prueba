import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  debugPrint(
    'Notificación recibida en segundo plano: ${message.messageId}',
  );
}

class PushNotificationService {
  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  String? token;

  bool permissionGranted = false;
  bool initialized = false;

  String message = 'No probado';

  Future<void> initialize() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      permissionGranted =
          settings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          settings.authorizationStatus ==
              AuthorizationStatus.provisional;

      if (!permissionGranted) {
        message =
            'Permiso de notificaciones no concedido';
        return;
      }

      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      token = await _messaging.getToken();

      if (token == null || token!.isEmpty) {
        message = 'No se pudo obtener el token FCM';
        initialized = false;
        return;
      }

      FirebaseMessaging.onMessage.listen(
        (RemoteMessage remoteMessage) {
          debugPrint(
            'Push recibida: ${remoteMessage.messageId}',
          );

          debugPrint(
            'Título: ${remoteMessage.notification?.title}',
          );

          debugPrint(
            'Contenido: ${remoteMessage.notification?.body}',
          );
        },
      );

      initialized = true;
      message = 'FCM configurado correctamente';
    } catch (e) {
      initialized = false;
      message = 'Error configurando FCM: $e';
    }
  }
}