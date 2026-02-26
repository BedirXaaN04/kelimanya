import 'package:flutter/material.dart';
import '../theme/brutalist_theme.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void _login(BuildContext context, String method) async {
    debugPrint("$method girişi yapıldı");
    
    if (method == 'Google') {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        }
      } catch (e) {
        debugPrint("Google Sign-In Error: $e");
        if (context.mounted) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Giriş başarısız: $e')));
        }
      }
    } else {
       // Misafir veya Email
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (_) => const HomeScreen()),
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: -0.035, // -2 degrees in radians approx
                child: const BrutalistBox(
                  backgroundColor: BrutalistTheme.accentYellow,
                  padding: 25.0,
                  child: Text(
                    "KELİMANYA",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Bulmaca dünyasına hoş geldin!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 320,
                child: BrutalistButton(
                  backgroundColor: BrutalistTheme.white,
                  onPressed: () => _login(context, 'Google'),
                  padding: 18.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("🌐", style: TextStyle(fontSize: 24)),
                      SizedBox(width: 12),
                      Text("Google ile Hızlı Giriş", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 320,
                child: BrutalistButton(
                  backgroundColor: BrutalistTheme.black,
                  onPressed: () => _login(context, 'Email'),
                  padding: 18.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("✉️", style: TextStyle(fontSize: 24)),
                      SizedBox(width: 12),
                      Text("E-Posta ile Giriş", style: TextStyle(fontSize: 16, color: BrutalistTheme.white)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => _login(context, 'Misafir'),
                child: const Text(
                  "KAYIT OLMADAN OYNA",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Giriş yaparak tüm şartlarımızı kabul etmiş sayılırsınız.",
                style: TextStyle(fontSize: 11, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
