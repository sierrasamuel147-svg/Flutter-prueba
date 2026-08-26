import 'package:battery_plus/battery_plus.dart';

class BatteryDiagnostic {
  final Battery _battery = Battery();

  int level = 0;

  BatteryState? state;

  bool powerSaveMode = false;
  bool working = false;

  String message = 'No probado';

  Future<void> test() async {
    try {
      level = await _battery.batteryLevel;
      state = await _battery.batteryState;

      try {
        powerSaveMode = await _battery.isInBatterySaveMode;
      } catch (_) {
        powerSaveMode = false;
      }

      working = level >= 0 && level <= 100;

      message = working
          ? 'Estado de batería obtenido correctamente'
          : 'No se pudo obtener el estado de batería';
    } catch (e) {
      working = false;
      message = 'Error al consultar la batería';
    }
  }

  String get stateText {
    switch (state) {
      case BatteryState.charging:
        return 'Cargando';

      case BatteryState.full:
        return 'Carga completa';

      case BatteryState.discharging:
        return 'Descargando';

      case BatteryState.connectedNotCharging:
        return 'Conectada sin cargar';

      case BatteryState.unknown:
        return 'Desconocido';

      default:
        return 'No disponible';
    }
  }
}