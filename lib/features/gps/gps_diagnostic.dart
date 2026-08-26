import 'package:geolocator/geolocator.dart';

class GpsDiagnostic {
  Position? position;

  bool serviceEnabled = false;
  bool permissionGranted = false;
  bool working = false;

  String message = 'No probado';

  Future<void> test() async {
    message = 'Comprobando GPS...';

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      message = 'El servicio de ubicación está desactivado';
      working = false;
      return;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      message = 'Permiso de ubicación denegado';
      permissionGranted = false;
      working = false;
      return;
    }

    permissionGranted = true;

    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      working = true;
      message = 'GPS funcionando correctamente';
    } catch (e) {
      working = false;
      message = 'No se pudo obtener la ubicación';
    }
  }
}