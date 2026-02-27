import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../theme/brutalist_theme.dart';

class InteractiveWheel extends StatefulWidget {
  final List<String> letters;
  const InteractiveWheel({Key? key, required this.letters}) : super(key: key);

  @override
  State<InteractiveWheel> createState() => _InteractiveWheelState();
}

class _InteractiveWheelState extends State<InteractiveWheel> {
  final GlobalKey _wheelKey = GlobalKey();
  List<Offset> _letterPositions = [];
  List<int> _selectedIndices = [];
  Offset? _currentDragPos;
  bool _isDrawing = false;
  bool _showPreview = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculatePositions());
  }

  @override
  void didUpdateWidget(covariant InteractiveWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.letters != widget.letters) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _calculatePositions());
    }
  }

  void _calculatePositions() {
    if (_wheelKey.currentContext == null) return;
    
    final RenderBox renderBox = _wheelKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 40; // 40 is button radius approx
    
    List<Offset> positions = [];
    double step = (2 * pi) / widget.letters.length;
    
    for (int i = 0; i < widget.letters.length; i++) {
      double angle = i * step - (pi / 2);
      double x = center.dx + radius * cos(angle);
      double y = center.dy + radius * sin(angle);
      positions.add(Offset(x, y));
    }
    
    setState(() {
      _letterPositions = positions;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (!_isDrawing) {
      setState(() => _isDrawing = true);
    }
    
    RenderBox box = _wheelKey.currentContext!.findRenderObject() as RenderBox;
    Offset localPos = box.globalToLocal(details.globalPosition);
    
    setState(() {
      _currentDragPos = localPos;
      _checkIntersection(localPos);
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    _endDrag();
  }

  void _checkIntersection(Offset pos) {
    for (int i = 0; i < _letterPositions.length; i++) {
      if ((_letterPositions[i] - pos).distance < 40) {
        if (!_selectedIndices.contains(i)) {
          setState(() {
            _selectedIndices.add(i);
            _showPreview = true;
          });
        }
      }
    }
  }

  void _endDrag() {
    if (_selectedIndices.isNotEmpty) {
      String word = _selectedIndices.map((i) => widget.letters[i]).join();
      final provider = context.read<GameProvider>();
      provider.checkWordSelection(word);
    }
    
    setState(() {
      _isDrawing = false;
      _selectedIndices.clear();
      _currentDragPos = null;
      _showPreview = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String previewWord = _selectedIndices.map((i) => widget.letters[i]).join();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          opacity: _showPreview ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 150),
          child: BrutalistBox(
            padding: 10,
            child: Text(
              previewWord,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 330,
          height: 330,
          child: Stack(
            key: _wheelKey,
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Background circle
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: BrutalistTheme.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
                  boxShadow: const [
                    BoxShadow(color: BrutalistTheme.black, offset: Offset(7, 7)),
                  ],
                ),
              ),
              
              // Custom Painter for lines
              RepaintBoundary(
                child: CustomPaint(
                  size: const Size(330, 330),
                  painter: LinePainter(
                    letterPositions: _letterPositions,
                    selectedIndices: _selectedIndices,
                    currentDragPos: _currentDragPos,
                  ),
                ),
              ),

              // Gesture Detector over the whole area
              Positioned.fill(
                child: GestureDetector(
                  onPanDown: (details) {
                     setState(() {
                      _isDrawing = true;
                     });
                     _handlePanUpdate(DragUpdateDetails(globalPosition: details.globalPosition));
                  },
                  onPanUpdate: _handlePanUpdate,
                  onPanEnd: _handlePanEnd,
                  behavior: HitTestBehavior.opaque,
                ),
              ),

              // Letter Buttons
              ...List.generate(_letterPositions.length, (i) {
                bool isSelected = _selectedIndices.contains(i);
                return Positioned(
                  left: _letterPositions[i].dx - 33,
                  top: _letterPositions[i].dy - 33,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      color: isSelected ? BrutalistTheme.white : BrutalistTheme.accentYellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: BrutalistTheme.black, width: BrutalistTheme.borderWidth),
                      boxShadow: isSelected ? [] : const [
                        BoxShadow(color: BrutalistTheme.black, offset: Offset(4, 4)),
                      ],
                    ),
                    transform: isSelected ? Matrix4.translationValues(4.0, 4.0, 0.0) : Matrix4.identity(),
                    child: Center(
                      child: Text(
                        widget.letters[i],
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class LinePainter extends CustomPainter {
  final List<Offset> letterPositions;
  final List<int> selectedIndices;
  final Offset? currentDragPos;

  LinePainter({
    required this.letterPositions,
    required this.selectedIndices,
    this.currentDragPos,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedIndices.isEmpty) return;

    Paint borderPaint = Paint()
      ..color = BrutalistTheme.black
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    Paint fillPaint = Paint()
      ..color = BrutalistTheme.accentYellow
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.moveTo(letterPositions[selectedIndices[0]].dx, letterPositions[selectedIndices[0]].dy);

    for (int i = 1; i < selectedIndices.length; i++) {
      path.lineTo(letterPositions[selectedIndices[i]].dx, letterPositions[selectedIndices[i]].dy);
    }

    if (currentDragPos != null) {
      path.lineTo(currentDragPos!.dx, currentDragPos!.dy);
    }

    canvas.drawPath(path, borderPaint);
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.selectedIndices != selectedIndices || oldDelegate.currentDragPos != currentDragPos;
  }
}
