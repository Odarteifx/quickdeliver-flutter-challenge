import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform; 

Future<void> setupFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint('✅ User granted permission: ${settings.authorizationStatus}');

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

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    String? token;
    try {
      token = await messaging.getToken();
      debugPrint('✅ FCM Token: $token');
    } catch (e) {
      debugPrint('❌ Error getting FCM Token: $e');
    }


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

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('✅ Got foreground message: ${message.messageId}');
    if (message.notification != null) {
      debugPrint('📢 Notification Title: ${message.notification!.title}');
      debugPrint('📢 Notification Body: ${message.notification!.body}');
    }
    if (message.data != null) {
      debugPrint('📦 Message Data: ${message.data}');
    }
  });
}