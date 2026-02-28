import 'package:flutter/material.dart';
import '../theme/brutalist_theme.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import '../widgets/animated_owl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoginTab = true;
  bool _isPasswordFocused = false;
  bool _isHappy = false;
  bool _isAngry = false;
  bool _isLoading = false;
  String _message = '';
  Color _messageColor = BrutalistTheme.accentGreen;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signupNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _signupNameFocus = FocusNode();
  final _signupEmailFocus = FocusNode();
  final _signupPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _passwordFocus.addListener(_onPasswordFocusChange);
    _signupPasswordFocus.addListener(_onPasswordFocusChange);
  }

  void _onPasswordFocusChange() {
    setState(() {
      _isPasswordFocused = _passwordFocus.hasFocus || _signupPasswordFocus.hasFocus;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signupNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _signupNameFocus.dispose();
    _signupEmailFocus.dispose();
    _signupPasswordFocus.dispose();
    super.dispose();
  }

  void _switchTab(bool isLogin) {
    setState(() {
      _isLoginTab = isLogin;
      _message = '';
      _isHappy = false;
      _isAngry = false;
    });
  }

  void _goHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _doLogin() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        _isAngry = true;
        _messageColor = BrutalistTheme.accentRed;
        _message = '✗ Lütfen tüm alanları doldurun.';
      });
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _isAngry = false);
      });
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    final result = await AuthService.signInWithEmail(email, pass);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (result.success) {
        _isHappy = true;
        _isAngry = false;
        _messageColor = BrutalistTheme.accentGreen;
        _message = result.message;
      } else {
        _isAngry = true;
        _isHappy = false;
        _messageColor = BrutalistTheme.accentRed;
        _message = result.message;
      }
    });

    if (result.success) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _goHome();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _isAngry = false);
      });
    }
  }

  Future<void> _doSignup() async {
    final name = _signupNameController.text.trim();
    final email = _signupEmailController.text.trim();
    final pass = _signupPasswordController.text;

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      setState(() {
        _isAngry = true;
        _messageColor = BrutalistTheme.accentRed;
        _message = '✗ Lütfen tüm alanları doldurun.';
      });
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _isAngry = false);
      });
      return;
    }

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    final result = await AuthService.signUpWithEmail(email, pass, name);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (result.success) {
        _isHappy = true;
        _isAngry = false;
        _messageColor = BrutalistTheme.accentGreen;
        _message = result.message;
      } else {
        _isAngry = true;
        _isHappy = false;
        _messageColor = BrutalistTheme.accentRed;
        _message = result.message;
      }
    });

    if (result.success) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _goHome();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _isAngry = false);
      });
    }
  }

  Future<void> _googleLogin() async {
    setState(() => _isLoading = true);

    final result = await AuthService.signInWithGoogle();

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (result.success) {
        _isHappy = true;
        _isAngry = false;
        _messageColor = BrutalistTheme.accentGreen;
        _message = result.message;
      } else {
        _isAngry = true;
        _isHappy = false;
        _messageColor = BrutalistTheme.accentRed;
        _message = result.message;
      }
    });

    if (result.success) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _goHome();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) setState(() => _isAngry = false);
      });
    }
  }

  Future<void> _guestLogin() async {
    setState(() => _isLoading = true);

    final result = await AuthService.signInAsGuest();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      _goHome();
    } else {
      setState(() {
        _messageColor = BrutalistTheme.accentRed;
        _message = result.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: BrutalistTheme.nightBg),
        child: Stack(
          children: [
            Positioned.fill(child: CustomPaint(painter: DottedBackgroundPainter())),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildLoginBox(),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.4),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(BrutalistTheme.accentYellow),
                    strokeWidth: 4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginBox() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 370),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: BrutalistTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BrutalistTheme.black, width: 4),
        boxShadow: const [
          BoxShadow(color: BrutalistTheme.black, offset: Offset(6, 6), blurRadius: 0),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("KELİMANYA 🦉", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),

          // Tabs
          Row(
            children: [
              Expanded(child: _buildTab("Giriş Yap", _isLoginTab, () => _switchTab(true))),
              const SizedBox(width: 10),
              Expanded(child: _buildTab("Kayıt Ol", !_isLoginTab, () => _switchTab(false))),
            ],
          ),
          const SizedBox(height: 16),

          // Owl
          SizedBox(
            width: 115,
            height: 85,
            child: AnimatedOwl(isHappy: _isHappy, isAngry: _isAngry, baseEyeClosed: _isPasswordFocused),
          ),
          const SizedBox(height: 10),

          // Form
          if (_isLoginTab) _buildLoginPane() else _buildSignupPane(),

          // Message
          if (_message.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(_message, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: _messageColor), textAlign: TextAlign.center),
          ],

          const SizedBox(height: 12),

          // Google Sign-In button
          _buildGoogleButton(),

          const SizedBox(height: 8),

          // Guest button
          _buildGuestButton(),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? BrutalistTheme.accentYellow : BrutalistTheme.grey,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: BrutalistTheme.black, width: 3),
          boxShadow: isActive ? [] : const [BoxShadow(color: BrutalistTheme.black, offset: Offset(3, 3))],
        ),
        transform: isActive ? Matrix4.translationValues(3, 3, 0) : Matrix4.identity(),
        child: Center(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14))),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String placeholder,
    bool isPassword = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: isPassword,
        autocorrect: false,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFF1F2F6),
          contentPadding: const EdgeInsets.all(13),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: BrutalistTheme.black, width: 3)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: BrutalistTheme.black, width: 3)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: BrutalistTheme.black, width: 3)),
        ),
      ),
    );
  }

  Widget _buildLoginPane() {
    return Column(
      children: [
        _buildInput(controller: _emailController, focusNode: _emailFocus, placeholder: "E-Posta"),
        _buildInput(controller: _passwordController, focusNode: _passwordFocus, placeholder: "Şifre", isPassword: true),
        _buildActionButton("GİRİŞ YAP", BrutalistTheme.accentYellow, Colors.black, _doLogin),
      ],
    );
  }

  Widget _buildSignupPane() {
    return Column(
      children: [
        _buildInput(controller: _signupNameController, focusNode: _signupNameFocus, placeholder: "Kullanıcı Adı Seç"),
        _buildInput(controller: _signupEmailController, focusNode: _signupEmailFocus, placeholder: "E-Posta"),
        _buildInput(controller: _signupPasswordController, focusNode: _signupPasswordFocus, placeholder: "Şifre Belirle", isPassword: true),
        _buildActionButton("KAYIT OL", BrutalistTheme.accentGreen, Colors.white, _doSignup),
      ],
    );
  }

  Widget _buildActionButton(String label, Color bg, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BrutalistTheme.black, width: 4),
          boxShadow: const [BoxShadow(color: BrutalistTheme.black, offset: Offset(6, 6))],
        ),
        child: Center(child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textColor))),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _googleLogin,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: const Color(0xFFDB4437),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: BrutalistTheme.black, width: 3),
          boxShadow: const [BoxShadow(color: BrutalistTheme.black, offset: Offset(4, 4))],
        ),
        child: const Center(
          child: Text("G  Google ile Giriş Yap", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildGuestButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _guestLogin,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: BrutalistTheme.nightBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: BrutalistTheme.black, width: 3),
          boxShadow: const [BoxShadow(color: BrutalistTheme.black, offset: Offset(4, 4))],
        ),
        child: const Center(
          child: Text("👤 MİSAFİR OLARAK OYNA", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: BrutalistTheme.white)),
        ),
      ),
    );
  }
}

class DottedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xfffcd53f)
      ..style = PaintingStyle.fill;
    double spacing = 30.0;
    double radius = 1.5;
    for (double i = 0; i < size.width; i += spacing) {
      for (double j = 0; j < size.height; j += spacing) {
        canvas.drawCircle(Offset(i, j), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
