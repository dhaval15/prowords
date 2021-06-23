import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChasingArcIndiactor extends StatefulWidget {
  final Color? chasing;
  final Color? dot;
  final double size;
  final double thickness;

  const ChasingArcIndiactor({
    this.chasing,
    this.dot,
    this.size = 50,
    this.thickness = 6,
  });
  @override
  _ChasingArcIndiactorState createState() => _ChasingArcIndiactorState();
}

class _ChasingArcIndiactorState extends State<ChasingArcIndiactor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: widget.thickness,
            horizontal: widget.size / 2,
          ),
          child: CustomPaint(
            painter: ChasingArcPainter(
              fraction: _controller.value,
              thickness: widget.thickness,
              chasing:
                  widget.chasing ?? Theme.of(context).colorScheme.onBackground,
              dot: widget.dot ?? Theme.of(context).colorScheme.secondary,
            ),
            child: SizedBox(
              width: widget.size,
              height: widget.size * 0.5,
            ),
          ),
        );
      },
      animation: _controller,
    );
  }
}

class ChasingArcPainter extends CustomPainter {
  final double fraction;
  final double thickness;
  final Color chasing;
  final Color dot;
  ChasingArcPainter({
    required this.fraction,
    required this.thickness,
    required this.dot,
    required this.chasing,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final mid = size.width / 2;
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(mid - (size.width * fraction), size.height),
          radius: mid),
      -math.pi + (2 * math.pi * (fraction - 0.5).clamp(0, 0.5)),
      2 * math.pi * (0.5 - (fraction - 0.5).abs().clamp(-0.5, 0.5)),
      false,
      Paint()
        ..color = chasing
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = thickness,
    );
    final x =
        size.width * (1 + (fraction.clamp(0.4, 0.5) - 0.4) * 10 - fraction);
    canvas.drawOval(
      Rect.fromCircle(center: Offset(x, size.height), radius: thickness / 2),
      Paint()..color = dot,
    );
  }

  @override
  bool shouldRepaint(ChasingArcPainter oldDelegate) {
    return this.fraction != oldDelegate.fraction ||
        this.thickness != oldDelegate.thickness ||
        this.dot != oldDelegate.dot ||
        this.chasing != oldDelegate.chasing;
  }
}

class BouncingDotsIndiactor extends StatefulWidget {
  final Color? dot;
  final double amplitude;
  final double radius;
  final double width;

  const BouncingDotsIndiactor({
    this.dot,
    this.amplitude = 12,
    this.width = 32,
    this.radius = 2,
  });
  @override
  _BouncingDotsIndiactorState createState() => _BouncingDotsIndiactorState();
}

class _BouncingDotsIndiactorState extends State<BouncingDotsIndiactor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: widget.radius),
          child: CustomPaint(
            painter: BouncingDotsPainter(
              fraction: _controller.value,
              radius: widget.radius,
              dot: widget.dot ?? Theme.of(context).colorScheme.onBackground,
            ),
            child: SizedBox(
              width: widget.width,
              height: widget.amplitude,
            ),
          ),
        );
      },
      animation: _controller,
    );
  }
}

class BouncingDotsPainter extends CustomPainter {
  final double fraction;
  final double radius;
  final Color dot;
  BouncingDotsPainter({
    required this.fraction,
    required this.radius,
    required this.dot,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final nf1 = fraction.clamp(0, 0.5) * 2;
    final nf2 = (fraction.clamp(0.075, 0.575) - 0.075) * 2;
    final nf3 = (fraction.clamp(0.15, 0.65) - 0.15) * 2;
    final x1 = radius;
    final x2 = size.width / 2;
    final x3 = size.width - radius;
    final y1 = height * (0.5 - math.sin(math.pi * 2 * nf1) / 2);
    final y2 = height * (0.5 - math.sin(math.pi * 2 * nf2) / 2);
    final y3 = height * (0.5 - math.sin(math.pi * 2 * nf3) / 2);
    final paint = Paint()..color = dot;
    canvas.drawOval(
        Rect.fromCircle(center: Offset(x1, y1), radius: radius), paint);
    canvas.drawOval(
        Rect.fromCircle(center: Offset(x2, y2), radius: radius), paint);
    canvas.drawOval(
        Rect.fromCircle(center: Offset(x3, y3), radius: radius), paint);
  }

  @override
  bool shouldRepaint(BouncingDotsPainter oldDelegate) {
    return this.fraction != oldDelegate.fraction ||
        this.radius != oldDelegate.radius ||
        this.dot != oldDelegate.dot;
  }
}
