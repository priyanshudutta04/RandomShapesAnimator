import 'dart:math';
import 'package:flutter/material.dart';

enum Shape { star, circle, snowflake }

class RandomShapesAnimator extends StatefulWidget {
  final Widget child;
  final int? starCount;
  final double? maxSpeed;
  final int? trailLength;
  final Size? areaSize;
  final Color? sparkleColor;
  final double? minOpacity;
  final double? maxOpacity;
  final Shape? shape;

  const RandomShapesAnimator({
    super.key,
    required this.child,
    this.starCount,
    this.maxSpeed,
    this.trailLength,
    this.areaSize,
    this.sparkleColor,
    this.minOpacity,
    this.maxOpacity,
    this.shape,
  });

  @override
  State<RandomShapesAnimator> createState() => _RandomShapesAnimatorState();
}

class _RandomShapesAnimatorState extends State<RandomShapesAnimator>
    with SingleTickerProviderStateMixin {
  final Random random = Random();
  final List<List<Offset>> _sparkleTrails = [];
  final List<double> _sparkleOpacities = [];
  final List<Offset> _velocity = [];
  late AnimationController _controller;

  int get _starCount => widget.starCount ?? 15;
  double get _maxSpeed => widget.maxSpeed ?? 0.3;
  int get _trailLength => widget.trailLength ?? 10;
  Size get _areaSize => widget.areaSize ?? const Size(200, 200);
  Color get _sparkleColor => widget.sparkleColor ?? Colors.white;
  double get _minOpacity => widget.minOpacity ?? 0.5;
  double get _maxOpacity => widget.maxOpacity ?? 1.0;
  Shape get _shape => widget.shape ?? Shape.star;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < _starCount; i++) {
      List<Offset> initialTrail = List.generate(
        _trailLength,
        (_) => Offset(
          random.nextDouble() * _areaSize.width,
          random.nextDouble() * _areaSize.height,
        ),
      );

      _sparkleTrails.add(initialTrail);
      _sparkleOpacities.add(
        random.nextDouble() * (_maxOpacity - _minOpacity) + _minOpacity,
      );

      _velocity.add(
        Offset(
          random.nextDouble() * _maxSpeed * 2 - _maxSpeed,
          random.nextDouble() * _maxSpeed * 2 - _maxSpeed,
        ),
      );
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 16),
      vsync: this,
    )..repeat();

    _controller.addListener(_updateSparkles);
  }

  void _updateSparkles() {
    for (int i = 0; i < _sparkleTrails.length; i++) {
      List<Offset> trail = _sparkleTrails[i];
      Offset newPosition = trail.last + _velocity[i];

      if (newPosition.dx < 0 || newPosition.dx > _areaSize.width) {
        _velocity[i] = Offset(-_velocity[i].dx, _velocity[i].dy);
      }
      if (newPosition.dy < 0 || newPosition.dy > _areaSize.height) {
        _velocity[i] = Offset(_velocity[i].dx, -_velocity[i].dy);
      }

      trail.add(newPosition);
      if (trail.length > _trailLength) {
        trail.removeAt(0);
      }

      _sparkleTrails[i] = trail;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_updateSparkles);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: CustomPaint(
              painter: SparklingPainter(
                sparkleTrails: _sparkleTrails,
                sparkleOpacities: _sparkleOpacities,
                sparkleColor: _sparkleColor,
                shape: _shape,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SparklingPainter extends CustomPainter {
  final List<List<Offset>> sparkleTrails;
  final List<double> sparkleOpacities;
  final Color sparkleColor;
  final Shape shape;

  SparklingPainter({
    required this.sparkleTrails,
    required this.sparkleOpacities,
    required this.sparkleColor,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < sparkleTrails.length; i++) {
      final trail = sparkleTrails[i];
      final double opacity = sparkleOpacities[i];

      for (int j = 0; j < trail.length - 1; j++) {
        final start = trail[j];
        final end = trail[j + 1];

        paint.color = sparkleColor.withValues(
          alpha: opacity * (j + 1) / trail.length,
        );
        canvas.drawLine(start, end, paint);
      }

      paint.color = sparkleColor.withValues(alpha: opacity);
      drawShape(canvas, trail.last.dx, trail.last.dy, paint);
    }
  }

  void drawShape(Canvas canvas, double x, double y, Paint paint) {
    switch (shape) {
      case Shape.star:
        drawStar(canvas, x, y, paint);
        break;
      case Shape.circle:
        canvas.drawCircle(Offset(x, y), 4, paint);
        break;
      case Shape.snowflake:
        drawSnowflake(canvas, x, y, paint);
        break;
    }
  }

  void drawStar(Canvas canvas, double x, double y, Paint paint) {
    final path = Path();
    const double radius = 5.0;
    path.moveTo(x, y - radius);
    for (int i = 1; i <= 5; i++) {
      path.lineTo(
        x + radius * cos((i * 2 * pi) / 5),
        y - radius * sin((i * 2 * pi) / 5),
      );
      path.lineTo(
        x + (radius / 2) * cos(((i * 2 + 1) * pi) / 5),
        y - (radius / 2) * sin(((i * 2 + 1) * pi) / 5),
      );
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void drawSnowflake(Canvas canvas, double x, double y, Paint paint) {
    for (int i = 0; i < 6; i++) {
      double angle = (pi / 3) * i;
      double dx = 5 * cos(angle);
      double dy = 5 * sin(angle);
      canvas.drawLine(Offset(x, y), Offset(x + dx, y + dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
