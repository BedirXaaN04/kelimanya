import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrutalistTheme {
  static const Color bgBlue = Color(0xFF75cff0);
  static const Color accentYellow = Color(0xFFfcd53f);
  static const Color accentRed = Color(0xFFff4757);
  static const Color accentGreen = Color(0xFF2ed573);
  static const Color white = Color(0xFFffffff);
  static const Color black = Color(0xFF000000);

  static const double borderWidth = 4.0;
  static const double shadowOffset = 6.0;

  static ThemeData get theme {
    return ThemeData(
      primaryColor: bgBlue,
      scaffoldBackgroundColor: bgBlue,
      textTheme: GoogleFonts.poppinsTextTheme().apply(
        bodyColor: black,
        displayColor: black,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: bgBlue,
        secondary: accentYellow,
        error: accentRed,
      ),
    );
  }
}

class BrutalistBox extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color borderColor;
  final BorderStyle borderStyle;

  const BrutalistBox({
    Key? key,
    required this.child,
    this.backgroundColor = BrutalistTheme.white,
    this.padding = 20.0,
    this.margin,
    this.borderRadius = 12.0,
    this.borderColor = BrutalistTheme.black,
    this.borderStyle = BorderStyle.solid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderStyle == BorderStyle.none ? null : Border(
          top: BorderSide(color: borderColor, width: BrutalistTheme.borderWidth, style: borderStyle),
          bottom: BorderSide(color: borderColor, width: BrutalistTheme.borderWidth, style: borderStyle),
          left: BorderSide(color: borderColor, width: BrutalistTheme.borderWidth, style: borderStyle),
          right: BorderSide(color: borderColor, width: BrutalistTheme.borderWidth, style: borderStyle),
        ),
        boxShadow: const [
          BoxShadow(
            color: BrutalistTheme.black,
            offset: Offset(BrutalistTheme.shadowOffset, BrutalistTheme.shadowOffset),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

class BrutalistButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double padding;

  const BrutalistButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.backgroundColor = BrutalistTheme.white,
    this.padding = 15.0,
  }) : super(key: key);

  @override
  _BrutalistButtonState createState() => _BrutalistButtonState();
}

class _BrutalistButtonState extends State<BrutalistButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          _isPressed ? BrutalistTheme.shadowOffset : 0.0,
          _isPressed ? BrutalistTheme.shadowOffset : 0.0,
          0.0,
        ),
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: BrutalistTheme.black,
            width: BrutalistTheme.borderWidth,
          ),
          boxShadow: [
            if (!_isPressed)
              const BoxShadow(
                color: BrutalistTheme.black,
                offset: Offset(BrutalistTheme.shadowOffset, BrutalistTheme.shadowOffset),
                blurRadius: 0,
                spreadRadius: 0,
              ),
          ],
        ),
        padding: EdgeInsets.all(widget.padding),
        child: widget.child,
      ),
    );
  }
}
