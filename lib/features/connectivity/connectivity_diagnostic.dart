import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class ConnectivityDiagnostic {
  final Connectivity _connectivity = Connectivity();

  List<ConnectivityResult> connectionTypes = [];

  bool hasNetwork = false;
  bool hasInternet = false;
  bool working = false;

  String message = 'No probado';

  Future<void> test() async {
    try {
      connectionTypes =
          await _connectivity.checkConnectivity();

      hasNetwork =
          connectionTypes.isNotEmpty &&
          !connectionTypes.contains(
            ConnectivityResult.none,
          );

      if (!hasNetwork) {
        hasInternet = false;
        working = false;
        message = 'No hay conexión de red disponible';
        return;
      }

      try {
        final response = await http
            .get(
              Uri.parse('https://www.google.com/generate_204'),
            )
            .timeout(
              const Duration(seconds: 5),
            );

        hasInternet =
            response.statusCode == 204 ||
            response.statusCode == 200;
      } catch (_) {
        hasInternet = false;
      }

      working = hasNetwork;

      if (hasInternet) {
        message =
            'Red e Internet funcionando correctamente';
      } else {
        message =
            'Hay conexión de red, pero no se pudo verificar Internet';
      }
    } catch (e) {
      working = false;
      hasNetwork = false;
      hasInternet = false;
      message = 'Error al comprobar conectividad';
    }
  }

  String get connectionText {
    if (connectionTypes.isEmpty) {
      return 'Desconocida';
    }

    return connectionTypes
        .map(_formatConnectionType)
        .join(', ');
  }

  String _formatConnectionType(
    ConnectivityResult type,
  ) {
    switch (type) {
      case ConnectivityResult.wifi:
        return 'Wi-Fi';

      case ConnectivityResult.mobile:
        return 'Datos móviles';

      case ConnectivityResult.ethernet:
        return 'Ethernet';

      case ConnectivityResult.vpn:
        return 'VPN';

      case ConnectivityResult.bluetooth:
        return 'Bluetooth';

      case ConnectivityResult.satellite:
        return 'Satélite';

      case ConnectivityResult.other:
        return 'Otra';

      case ConnectivityResult.none:
        return 'Sin conexión';
    }
  }
}