import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Mobil veya desteklenen tarayıcı farketmeksizin izinleri iste
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("Kullanıcı bildirim izni verdi.");
      await updateFcmToken();

      // For handling foreground messages while app is open
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        debugPrint('Message data: ${message.data}');

        if (message.notification != null) {
          debugPrint('Message also contained a notification: ${message.notification}');
          // In a real app we might show a ScaffoldMessenger or LocalNotification
        }
      });
      
      // Token yenilendiğinde dinle
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
         _saveTokenToFirestore(newToken);
      });

      // Kullanıcı giriş yaptıktan sonra da token'ı veritabanına işlemesi için dinle
      FirebaseAuth.instance.authStateChanges().listen((user) {
         if (user != null) {
            updateFcmToken();
         }
      });
    } else {
      debugPrint("Kullanıcı bildirim iznini reddetti veya desteklenmiyor.");
    }
  }

  static Future<void> updateFcmToken() async {
    try {
      String? token;

      if (kIsWeb) {
        // Web platformu için VAPID key gereklidir, proje ayarlarındaki Cloud Messaging sekmesinden alınmış bir örnek (Bunu projenizin asıl VAPID key'iyle değiştirmelisiniz).
        // For demonstration, assuming default or skipping token request if no explicit VAPID key is given
        token = await _messaging.getToken(vapidKey: 'BHX6SzRp1uGY9SvV63rwACM8wiuef3LPfV2ykGNB_SQUmKFD91aRwP23kTsoJ9O3xpS1fytE6Im6UVX4cwjdUkw'); 
      } else {
        token = await _messaging.getToken();
      }

      if (token != null) {
        debugPrint("Bulunan ve Kaydedilen FCM Token: $token");
        await _saveTokenToFirestore(token);
      }
    } catch (e) {
      debugPrint("FCM error on getting token: $e");
    }
  }

  static Future<void> _saveTokenToFirestore(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fcmToken': token,
        'fcmPlatform': kIsWeb ? 'web' : 'mobile',
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}
