import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Current user (null if not logged in)
  static User? get currentUser => _auth.currentUser;

  /// Whether user is logged in
  static bool get isLoggedIn => _auth.currentUser != null;

  /// Whether user is anonymous
  static bool get isAnonymous => _auth.currentUser?.isAnonymous ?? true;

  /// Display name (returns "Misafir" for anonymous/null)
  static String get displayName {
    final user = _auth.currentUser;
    if (user == null || user.isAnonymous) return 'Misafir';
    return user.displayName ?? user.email?.split('@').first ?? 'Kullanıcı';
  }

  /// Auth state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── E-posta/Şifre ile Giriş ──
  static Future<({bool success, String message})> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return (success: true, message: '✓ Hoş geldin, ${displayName}!');
    } on FirebaseAuthException catch (e) {
      return (success: false, message: '✗ ${_translateError(e.code)}');
    } catch (e) {
      return (success: false, message: '✗ Bir hata oluştu.');
    }
  }

  // ── E-posta/Şifre ile Kayıt ──
  static Future<({bool success, String message})> signUpWithEmail(String email, String password, String displayName) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await cred.user?.updateDisplayName(displayName);
      await cred.user?.reload();
      return (success: true, message: '✓ Kayıt başarılı! Hoş geldin, $displayName!');
    } on FirebaseAuthException catch (e) {
      return (success: false, message: '✗ ${_translateError(e.code)}');
    } catch (e) {
      return (success: false, message: '✗ Bir hata oluştu.');
    }
  }

  // ── Google ile Giriş ──
  static Future<({bool success, String message})> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final provider = GoogleAuthProvider();
        await _auth.signInWithPopup(provider);
      } else {
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          return (success: false, message: '✗ Google girişi iptal edildi.');
        }
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _auth.signInWithCredential(credential);
      }
      return (success: true, message: '✓ Hoş geldin, ${displayName}!');
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      return (success: false, message: '✗ Google girişi başarısız.');
    }
  }

  // ── Misafir (Anonim) Giriş ──
  static Future<({bool success, String message})> signInAsGuest() async {
    try {
      await _auth.signInAnonymously();
      return (success: true, message: '✓ Misafir olarak giriş yapıldı.');
    } catch (e) {
      return (success: false, message: '✗ Giriş başarısız.');
    }
  }

  // ── Çıkış ──
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // ── Firebase hata kodlarını Türkçeye çevir ──
  static String _translateError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Şifre hatalı.';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi.';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmış.';
      case 'email-already-in-use':
        return 'Bu e-posta zaten kullanılıyor.';
      case 'weak-password':
        return 'Şifre çok zayıf (en az 6 karakter).';
      case 'operation-not-allowed':
        return 'Bu giriş yöntemi etkin değil.';
      case 'too-many-requests':
        return 'Çok fazla deneme. Lütfen bekleyin.';
      case 'invalid-credential':
        return 'E-posta veya şifre hatalı.';
      default:
        return 'Bir hata oluştu ($code).';
    }
  }
}
