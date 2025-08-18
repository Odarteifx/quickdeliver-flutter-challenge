import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform; 

// Initialize Flutter Local Notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> setupFCM() async {
  // Initialize local notifications first
  await _initializeLocalNotifications();
  
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission with better error handling
  NotificationSettings settings;
  try {
    settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: false,
      announcement: false,
      carPlay: false,
    );
  } catch (e) {
    debugPrint('❌ Error requesting notification permission: $e');
    return;
  }

  debugPrint('✅ User granted permission: ${settings.authorizationStatus}');

  // Handle iOS specific setup
  if (Platform.isIOS) {
    try {
      String? apnsToken = await messaging.getAPNSToken();
      if (apnsToken != null) {
        debugPrint('✅ APNS Token: $apnsToken');
      } else {
        debugPrint('⚠️ APNS Token is null. Push notifications might not work on this iOS device/simulator.');
      }
    } catch (e) {
      debugPrint('❌ Error getting APNS Token: $e');
    }
  }

  // Handle Android specific setup
  if (Platform.isAndroid) {
    try {
      await _createAndroidNotificationChannel();
    } catch (e) {
      debugPrint('❌ Error creating Android notification channel: $e');
    }
  }

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token;
    try {
      token = await messaging.getToken();
      debugPrint('✅ FCM Token: $token');
    } catch (e) {
      debugPrint('❌ Error getting FCM Token: $e');
      return;
    }

    // Save token to Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (token != null && user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('User')
            .doc(user.uid)
            .update({'fcmToken': token});
        debugPrint('✅ FCM Token updated in Firestore for user: ${user.uid}');
      } catch (e) {
        debugPrint('❌ Error updating FCM Token in Firestore: $e');
      }
    } else if (user == null) {
      debugPrint('⚠️ No authenticated user to save FCM token for.');
    } else if (token == null) {
      debugPrint('⚠️ FCM Token is null, cannot save to Firestore.');
    }
  } else {
    debugPrint('🚫 User did not grant notification permissions. FCM token not retrieved.');
  }

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('✅ Got foreground message: ${message.messageId}');
    _showLocalNotification(message);
  });

  // Handle when app is opened from notification
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint('✅ App opened from notification: ${message.messageId}');
    // Handle navigation or other actions when app is opened from notification
  });

  // Handle initial notification when app is launched
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    debugPrint('✅ App launched from notification: ${initialMessage.messageId}');
    // Handle initial notification
  }
}

Future<void> _initializeLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      debugPrint('Notification clicked: ${response.payload}');
      // Handle notification tap
    },
  );
}

Future<void> _createAndroidNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
    enableLights: true,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> _showLocalNotification(RemoteMessage message) async {
  if (message.notification == null) return;

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    enableVibration: true,
    enableLights: true,
    playSound: true,
  );

  const DarwinNotificationDetails iOSPlatformChannelSpecifics =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    categoryIdentifier: 'general',
    threadIdentifier: 'general',
    // iOS specific settings for better notification display
    interruptionLevel: InterruptionLevel.active,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? 'New Message',
    message.notification?.body ?? 'You have a new message',
    platformChannelSpecifics,
    payload: message.data.toString(),
  );
}

// Function to test local notifications
Future<void> testLocalNotification() async {
  debugPrint('🔔 Starting test notification...');
  
  try {
    // Check if we're on iOS simulator
    if (Platform.isIOS) {
      debugPrint('🍎 Running on iOS device - checking notification setup...');
      debugPrint('🍎 iOS device should show notifications properly');
    }
    
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      categoryIdentifier: 'general',
      threadIdentifier: 'general',
      // iOS specific settings for better notification display
      interruptionLevel: InterruptionLevel.active,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    debugPrint('🔔 Showing notification with ID: 0');
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification to verify the setup is working.',
      platformChannelSpecifics,
    );
    debugPrint('✅ Test notification sent successfully');
    
    // For iOS, also try a second notification with different settings
    if (Platform.isIOS) {
      debugPrint('🍎 iOS: First notification sent. Sending second notification...');
      
      // Try a second notification with minimal settings
      try {
        await flutterLocalNotificationsPlugin.show(
          1,
          'iOS Test 2',
          'Second test notification with minimal settings.',
          const NotificationDetails(
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: false,
              presentSound: false,
              interruptionLevel: InterruptionLevel.active,
            ),
          ),
        );
        debugPrint('🍎 iOS: Second notification sent successfully');
      } catch (e) {
        debugPrint('🍎 iOS: Second notification failed: $e');
      }
      
      debugPrint('🍎 iOS: Both notifications sent. Check your notification center!');
      debugPrint('🍎 💡 If notifications don\'t appear:');
      debugPrint('🍎   1. Swipe down from top to open notification center');
      debugPrint('🍎   2. Check iOS Settings > Notifications > QuickDeliver');
      debugPrint('🍎   3. Ensure Do Not Disturb is off');
    }
  } catch (e) {
    debugPrint('❌ Error sending test notification: $e');
    rethrow;
  }
}

// Function to check notification permissions and status
Future<void> checkNotificationStatus() async {
  debugPrint('🔍 Checking notification status...');
  
  try {
    // Check if notifications are supported
    final bool? isSupported = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    
    debugPrint('📱 Notifications supported: $isSupported');
    
    // Check iOS specific permissions
    if (Platform.isIOS) {
      debugPrint('🍎 Checking iOS notification status...');
      
      final bool? iOSSupported = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      debugPrint('🍎 iOS notification permissions: $iOSSupported');
      
      // Also check if we can request permissions again
      debugPrint('🍎 Requesting iOS permissions again...');
      final bool? permissionsGranted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      debugPrint('🍎 iOS permissions after re-request: $permissionsGranted');
      
      // Provide iOS-specific guidance
      if (permissionsGranted == true) {
        debugPrint('🍎 ✅ iOS notifications are enabled and should work');
        debugPrint('🍎 💡 If notifications still don\'t appear, check:');
        debugPrint('🍎   1. iOS Settings > Notifications > QuickDeliver > Allow Notifications');
        debugPrint('🍎   2. iOS Settings > Focus > Do Not Disturb (should be off)');
        debugPrint('🍎   3. iOS Settings > Focus > Focus Status (should be off)');
      } else {
        debugPrint('🍎 ❌ iOS notifications are not enabled');
        debugPrint('🍎 💡 Go to iOS Settings > Notifications > QuickDeliver and enable notifications');
      }
    }
    
    // Check Android specific permissions
    if (Platform.isAndroid) {
      final bool? androidSupported = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
      debugPrint('🤖 Android notifications enabled: $androidSupported');
    }
    
  } catch (e) {
    debugPrint('❌ Error checking notification status: $e');
  }
}

// Function to explicitly request iOS permissions
Future<void> requestIOSPermissions() async {
  if (Platform.isIOS) {
    debugPrint('🍎 Explicitly requesting iOS notification permissions...');
    try {
      // First, check current permission status
      final bool? currentStatus = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      debugPrint('🍎 iOS current permissions: $currentStatus');
      
      // Request permissions again to ensure they're granted
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      debugPrint('🍎 iOS permissions after request: $result');
      
      // Also check if we can show notifications
      if (result == true) {
        debugPrint('🍎 iOS: Permissions granted, notifications should work');
      } else {
        debugPrint('🍎 iOS: Permissions not granted, check iOS Settings > Notifications');
      }
    } catch (e) {
      debugPrint('🍎 Error requesting iOS permissions: $e');
    }
  }
}

// Function to test iOS notifications with different settings
Future<void> testIOSNotifications() async {
  if (Platform.isIOS) {
    debugPrint('🍎 Testing iOS notifications with different settings...');
    
    try {
      // Test 1: Basic notification
      await flutterLocalNotificationsPlugin.show(
        100,
        'iOS Basic Test',
        'Basic notification test',
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: false,
            presentSound: false,
          ),
        ),
      );
      debugPrint('🍎 iOS: Basic notification sent');
      
      // Test 2: Notification with sound
      await flutterLocalNotificationsPlugin.show(
        101,
        'iOS Sound Test',
        'Notification with sound',
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: false,
            presentSound: true,
          ),
        ),
      );
      debugPrint('🍎 iOS: Sound notification sent');
      
      // Test 3: High priority notification
      await flutterLocalNotificationsPlugin.show(
        102,
        'iOS High Priority',
        'High priority notification test',
        const NotificationDetails(
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.critical,
          ),
        ),
      );
      debugPrint('🍎 iOS: High priority notification sent');
      
      debugPrint('🍎 iOS: All test notifications sent. Check notification center!');
    } catch (e) {
      debugPrint('🍎 Error testing iOS notifications: $e');
    }
  }
}