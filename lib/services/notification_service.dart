import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? _timer;
  int _id = 0;

  Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
      macOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'bloom_channel',
      'Bloom Notifications',
      channelDescription: 'Notificaciones de Bloom Journal',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      _id++,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void startPeriodicNotifications() {
    stopPeriodicNotifications();
    showNotification(
      title: '¡Hola! 🌸',
      body: '¿Cómo te has estado sintiendo el día de hoy? 😊 Recuerda contárnoslo.',
    );
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      showNotification(
        title: '¡Hola! 🌸',
        body: '¿Cómo te has estado sintiendo el día de hoy? 😊 Recuerda contárnoslo.',
      );
    });
  }

  void stopPeriodicNotifications() {
    _timer?.cancel();
    _timer = null;
  }
}
