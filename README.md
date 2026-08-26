#  Phone Diagnostic

Phone Diagnostic es una aplicación móvil desarrollada en Flutter que permite realizar un diagnóstico general del funcionamiento de un dispositivo Android. La aplicación reúne diferentes pruebas de hardware, sensores y servicios del teléfono en una sola plataforma, permitiendo identificar rápidamente si los principales componentes del dispositivo están funcionando correctamente.

La aplicación cuenta con un sistema de autenticación mediante Google y permite almacenar los resultados de los diagnósticos realizados por cada usuario utilizando Firebase. De esta forma, los usuarios pueden consultar posteriormente su historial y revisar en detalle los resultados de cada diagnóstico.

##  Funcionalidades principales

-  Inicio de sesión mediante cuenta de Google.
-  Diagnóstico completo del dispositivo.
-  Pruebas individuales de los diferentes componentes.
-  Prueba de GPS/GNSS.
-  Prueba de cámara.
-  Prueba de micrófono.
-  Prueba de altavoz y reproducción de audio.
-  Prueba de vibración.
-  Prueba de sensores del dispositivo.
-  Prueba de podómetro.
-  Prueba de Bluetooth.
-  Prueba de NFC.
-  Consulta del estado y nivel de batería.
-  Prueba de conectividad e Internet.
-  Prueba de autenticación biométrica.
-  Diagnóstico de notificaciones mediante Firebase Cloud Messaging.
-  Historial de diagnósticos.
-  Consulta detallada de los resultados de diagnósticos anteriores.
-  Almacenamiento de resultados mediante Cloud Firestore.

##  Diagnóstico completo

La aplicación cuenta con un motor de diagnóstico que permite ejecutar varias pruebas de manera organizada y presentar un resumen general del estado del dispositivo.

Al finalizar un diagnóstico se muestran los resultados de las pruebas realizadas, incluyendo pruebas exitosas, pruebas con advertencias, componentes no disponibles y pruebas que no pudieron realizarse.

##  Historial

Cada diagnóstico puede almacenarse en Cloud Firestore asociado al usuario autenticado. El historial permite consultar los diagnósticos realizados anteriormente y acceder a una vista detallada de cada resultado.

Esto permite mantener un registro de las pruebas realizadas y facilita la comparación del estado del dispositivo a lo largo del tiempo.

##  Autenticación

La aplicación utiliza Firebase Authentication para gestionar el acceso de los usuarios. Actualmente se utiliza autenticación mediante Google, permitiendo iniciar y cerrar sesión de forma sencilla.

Los resultados almacenados en Firestore se relacionan con el usuario autenticado para mantener separado el historial de cada cuenta.

##  Firebase

El proyecto utiliza diferentes servicios de Firebase:

- **Firebase Authentication:** gestión de usuarios e inicio de sesión con Google.
- **Cloud Firestore:** almacenamiento del historial y resultados de diagnósticos.
- **Firebase Cloud Messaging:** configuración y diagnóstico de notificaciones push.
- **Firebase Core:** inicialización y configuración de Firebase dentro de la aplicación.

##  Tecnologías utilizadas

- **Flutter**
- **Dart**
- **Firebase**
- **Firebase Authentication**
- **Cloud Firestore**
- **Firebase Cloud Messaging**
- **FlutterFire**
- **Android SDK**

La aplicación utiliza diferentes paquetes de Flutter para acceder a las capacidades específicas del dispositivo, como sensores, Bluetooth, NFC, biometría, batería, GPS, cámara, audio, vibración y conectividad.

##  Estructura del proyecto

El proyecto está organizado de forma modular, separando las pantallas de usuario de la lógica encargada de realizar cada diagnóstico.

```text
lib/
├── features/
│   ├── auth/
│   ├── battery/
│   ├── bluetooth/
│   ├── camera/
│   ├── connectivity/
│   ├── gps/
│   ├── microphone/
│   ├── nfc/
│   ├── notifications/
│   ├── sensors/
│   ├── vibration/
│   └── ...
│
├── screens/
│   ├── home_screen.dart
│   ├── diagnostic_screen.dart
│   ├── full_diagnostic_screen.dart
│   ├── history_screen.dart
│   └── ...
│
├── theme/
│   └── app_theme.dart
│
├── firebase_options.dart
└── main.dart
