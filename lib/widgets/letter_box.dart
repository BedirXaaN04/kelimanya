import 'package:flutter/material.dart';
import '../theme/brutalist_theme.dart';

class LetterBox extends StatelessWidget {
  final String letter;
  final bool isFound;
  final bool isHinted;
  final bool isSurpriseTile;

  const LetterBox({
    super.key,
    required this.letter,
    this.isFound = false,
    this.isHinted = false,
    this.isSurpriseTile = false,
  });

  @override
  Widget build(BuildContext context) {
    // 46x46 box with 3px border and 3.5x offset. 
    // We'll use our BrutalistBox or custom AnimatedContainer.
    
    Color bgColor = isFound ? BrutalistTheme.accentYellow : BrutalistTheme.white;
    Color textColor = isFound || isHinted ? BrutalistTheme.black : Colors.transparent;
    double scale = isFound ? 1.05 : 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: BrutalistTheme.black, width: BrutalistTheme.borderWidth,
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
      child: Transform.scale(
        scale: scale,
        child: Center(
          child: _buildContent(textColor),
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    if (isSurpriseTile && !isFound && !isHinted) {
      return const Text(
        "💎",
        style: TextStyle(fontSize: 22),
      );
    }
    return Text(
      letter.toUpperCase(),
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w900,
        color: textColor,
      ),
    );
  }
}
