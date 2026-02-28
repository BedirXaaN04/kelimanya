import 'package:flutter/material.dart';
import '../theme/brutalist_theme.dart';

class ToastNotification extends StatelessWidget {
  final String? message;

  const ToastNotification({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 68,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedOpacity(
          opacity: message != null ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
              decoration: BoxDecoration(
                color: BrutalistTheme.accentPurple,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: BrutalistTheme.black, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: BrutalistTheme.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Text(
                message ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
