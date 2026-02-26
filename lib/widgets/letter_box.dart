import 'package:flutter/material.dart';
import '../theme/brutalist_theme.dart';

class LetterBox extends StatelessWidget {
  final String letter;
  final bool isFound;
  final bool isHinted;

  const LetterBox({
    Key? key,
    required this.letter,
    this.isFound = false,
    this.isHinted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 46x46 box with 3px border and 3.5x offset. 
    // We'll use our BrutalistBox or custom AnimatedContainer.
    
    Color bgColor = isFound ? BrutalistTheme.accentYellow : BrutalistTheme.white;
    Color textColor = isFound || isHinted ? BrutalistTheme.black : Colors.transparent;
    double scale = isFound ? 1.05 : 1.0;
    BorderStyle bStyle = isHinted && !isFound ? BorderStyle.values[1] : BorderStyle.solid; // fake dashed using solid or custom if needed

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      transform: Matrix4.identity()..scale(scale),
      transformAlignment: Alignment.center,
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: BrutalistTheme.black,
          width: 3.0,
          // Flutter doesn't support dashed borders out of the box easily, falling back to solid
        ),
        boxShadow: const [
          BoxShadow(
            color: BrutalistTheme.black,
            offset: Offset(3.5, 3.5),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
