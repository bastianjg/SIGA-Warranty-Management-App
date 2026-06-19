import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {

  static const String notifKey =
      "notificaciones_activadas";

  static const String darkModeKey =
      "modo_oscuro";

  // GUARDAR NOTIFICACIONES

  static Future<void>
      guardarNotificaciones(bool value) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(notifKey, value);
  }

  // LEER NOTIFICACIONES

  static Future<bool>
      obtenerNotificaciones() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(notifKey) ?? true;
  }

  // GUARDAR DARK MODE

  static Future<void>
      guardarDarkMode(bool value) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(darkModeKey, value);
  }

  // LEER DARK MODE

  static Future<bool>
    obtenerDarkMode() async {

      final prefs =
          await SharedPreferences.getInstance();

      return prefs.getBool(darkModeKey) ?? false;
    }

  static Future<bool>
    notificacionYaEnviada(
      int boletaId,
      int dias,
    ) async {

      final prefs =
          await SharedPreferences.getInstance();

      return prefs.getBool(
            'notif_${boletaId}_$dias',
          ) ??
          false;
    }

  static Future<void>
    marcarNotificacionEnviada(
      int boletaId,
      int dias,
    ) async {

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setBool(
        'notif_${boletaId}_$dias',
        true,
      );
    }
}