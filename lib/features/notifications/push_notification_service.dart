import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  debugPrint(
    'Notificación recibida en segundo plano: '
    '${message.messageId}',
  );
}

class PushNotificationService {
  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  String? token;

  bool permissionGranted = false;
  bool initialized = false;
  bool notificationReceived = false;

  String? lastNotificationTitle;
  String? lastNotificationBody;

  String message = 'No probado';

  StreamSubscription<RemoteMessage>?
      _messageSubscription;

  Future<bool> initialize() async {
    try {
      permissionGranted = false;
      initialized = false;
      notificationReceived = false;

      token = null;
      lastNotificationTitle = null;
      lastNotificationBody = null;

      message =
          'Solicitando permiso de notificaciones...';

      // ==========================================================
      // 1. PERMISOS
      // ==========================================================

      final settings =
          await _messaging.requestPermission(
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

        return false;
      }

      // ==========================================================
      // 2. BACKGROUND HANDLER
      // ==========================================================

      FirebaseMessaging.onBackgroundMessage(
        firebaseMessagingBackgroundHandler,
      );

      // ==========================================================
      // 3. TOKEN FCM
      // ==========================================================

      message =
          'Obteniendo token FCM...';

      token = await _messaging.getToken();

      if (token == null || token!.isEmpty) {
        message =
            'No se pudo obtener el token FCM';

        return false;
      }

      // ==========================================================
      // 4. EVITAR LISTENERS DUPLICADOS
      // ==========================================================

      await _messageSubscription?.cancel();

      // ==========================================================
      // 5. ESCUCHAR MENSAJES EN PRIMER PLANO
      // ==========================================================

      _messageSubscription =
          FirebaseMessaging.onMessage.listen(
        (RemoteMessage remoteMessage) {
          notificationReceived = true;

          lastNotificationTitle =
              remoteMessage.notification?.title;

          lastNotificationBody =
              remoteMessage.notification?.body;

          message =
              'Notificación Push recibida correctamente';

          debugPrint(
            'Push recibida: '
            '${remoteMessage.messageId}',
          );
        },
      );

      // ==========================================================
      // 6. FCM CONFIGURADO
      // ==========================================================

      initialized = true;

      message =
          'FCM configurado correctamente';

      return true;
    } catch (e) {
      initialized = false;

      message =
          'Error configurando FCM';

      debugPrint(
        'Error FCM: $e',
      );

      return false;
    }
  }

  Future<void> resetTest() async {
    notificationReceived = false;

    lastNotificationTitle = null;
    lastNotificationBody = null;

    message = 'No probado';
  }

  Future<void> dispose() async {
    await _messageSubscription?.cancel();

    _messageSubscription = null;
  }
}