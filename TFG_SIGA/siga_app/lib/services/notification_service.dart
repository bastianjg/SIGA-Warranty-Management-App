import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  static final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {

    const AndroidInitializationSettings
        androidSettings =
        AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        );

    const InitializationSettings
        settings =
        InitializationSettings(
          android: androidSettings,
        );

    await flutterLocalNotificationsPlugin
        .initialize(settings);

    await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();
  }

  static Future<void> mostrarNotificacion({
    required String titulo,
    required String mensaje,
  }) async {

    const AndroidNotificationDetails
        androidDetails =
        AndroidNotificationDetails(
          'garantias_channel',
          'Garantías',

          channelDescription:
              'Notificaciones de garantías',

          importance: Importance.max,
          priority: Priority.high,
        );

    const NotificationDetails
        notificationDetails =
        NotificationDetails(
          android: androidDetails,
        );

    await flutterLocalNotificationsPlugin.show(

      DateTime.now().millisecondsSinceEpoch ~/ 1000,

      titulo,
      mensaje,
      notificationDetails,
    );
  }
}