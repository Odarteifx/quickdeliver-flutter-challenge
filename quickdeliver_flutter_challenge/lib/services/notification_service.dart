import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:quickdeliver_flutter_challenge/main.dart';

Future<bool> _ensureLocalNotificationPermissions() async {
  try {
    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final bool areEnabled =
          await androidPlugin?.areNotificationsEnabled() ?? false;
      if (!areEnabled) {
        final bool? granted = await androidPlugin?.requestNotificationsPermission();
        return granted ?? false;
      }
      return true;
    }

    if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      final iosPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      final macPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>();
      final iosGranted = await iosPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
      final macGranted = await macPlugin?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
      return iosGranted || macGranted;
    }
  } catch (e) {
    debugPrint('Notification permission check/request failed: $e');
  }
  return true;
}

Future<void> showNotification() async {
  final hasPermission = await _ensureLocalNotificationPermissions();
  if (!hasPermission) {
    debugPrint('Local notifications permission not granted');
    return;
  }
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails('channel_id', 'channel_name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high);

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    presentBanner: true,
    presentList: true,
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);

  await flutterLocalNotificationsPlugin.show(
    0, 
    'QuickDeliver', 
    'Order has been scheduled 🎉', 
    platformDetails,
  );
}

Future<void> showStatusNotification({
  required String title,
  required String body,
}) async {
  final hasPermission = await _ensureLocalNotificationPermissions();
  if (!hasPermission) {
    debugPrint('Local notifications permission not granted');
    return;
  }

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    presentBanner: true,
    presentList: true,
  );

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);

  final int notificationId =
      DateTime.now().millisecondsSinceEpoch.remainder(1000000);

  await flutterLocalNotificationsPlugin.show(
    notificationId,
    title,
    body,
    platformDetails,
  );
}

