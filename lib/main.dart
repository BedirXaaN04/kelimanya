import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/splash_screen.dart';
import 'theme/brutalist_theme.dart';
import 'services/ad_service.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: \$e");
  }
  
  if (!kIsWeb) {
    try {
      await AdService().initialize();
    } catch (e) {
      debugPrint("AdMob initialization failed: \$e");
    }
  }
  
  // Platform bağımsız bildirimleri başlat
  try {
    await NotificationService.initialize();
  } catch (e) {
    debugPrint("Notification initialization failed: \$e");
  }
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const KelimanyaApp(),
    ),
  );
}

class KelimanyaApp extends StatelessWidget {
  const KelimanyaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kelimanya',
      theme: BrutalistTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
