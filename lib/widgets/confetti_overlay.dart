import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiOverlay extends StatefulWidget {
  final bool show;
  final VoidCallback? onComplete;

  const ConfettiOverlay({Key? key, required this.show, this.onComplete}) : super(key: key);

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> with TickerProviderStateMixin {
  final List<_ConfettiParticle> _particles = [];
  late AnimationController _controller;
  final Random _random = Random();
  final List<Color> _colors = const [
    Color(0xFFfcd53f),
    Color(0xFFff4757),
    Color(0xFF2ed573),
    Color(0xFF8c7ae6),
    Color(0xFFffffff),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(covariant ConfettiOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _generateParticles();
      _controller.forward(from: 0);
    }
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < 90; i++) {
      _particles.add(_ConfettiParticle(
        x: _random.nextDouble(),
        delay: i * 0.012,
        speed: 0.4 + _random.nextDouble() * 0.6,
        size: 8 + _random.nextDouble() * 8,
        color: _colors[_random.nextInt(_colors.length)],
        rotation: _random.nextDouble() * 720,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return IgnorePointer(
          child: CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _ConfettiPainter(
              particles: _particles,
              progress: _controller.value,
            ),
          ),
        );
      },
    );
  }
}

class _ConfettiParticle {
  final double x;
  final double delay;
  final double speed;
  final double size;
  final Color color;
  final double rotation;

  _ConfettiParticle({
    required this.x,
    required this.delay,
    required this.speed,
    required this.size,
    required this.color,
    required this.rotation,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      double t = (progress - p.delay).clamp(0.0, 1.0) / p.speed;
      if (t <= 0) continue;

      double y = -10 + t * (size.height + 20);
      double x = p.x * size.width + sin(t * 10) * 20;
      double opacity = (1 - t).clamp(0.0, 1.0);
      double angle = t * p.rotation * pi / 180;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);

      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          const Radius.circular(2),
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
