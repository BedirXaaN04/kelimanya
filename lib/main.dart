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
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  if (!kIsWeb) {
    await AdService().initialize();
  }
  
  // Platform bağımsız bildirimleri başlat
  await NotificationService.initialize();
  
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
  const KelimanyaApp({Key? key}) : super(key: key);

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
