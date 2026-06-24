import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CountdownTimer extends StatefulWidget {
  final int totalSeconds;
  final VoidCallback? onComplete;
  final bool isPaused;
  final Color? color;

  const CountdownTimer({
    super.key,
    required this.totalSeconds,
    this.onComplete,
    this.isPaused = false,
    this.color,
  });

  @override
  State<CountdownTimer> createState() => CountdownTimerState();
}

class CountdownTimerState extends State<CountdownTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.totalSeconds),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    if (!widget.isPaused) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant CountdownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPaused != oldWidget.isPaused) {
      if (widget.isPaused) {
        _controller.stop();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.burntOrange;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final remaining =
            (widget.totalSeconds * (1 - _controller.value)).ceil();
        final minutes = remaining ~/ 60;
        final seconds = remaining % 60;

        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background ring
              SizedBox(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: _TimerPainter(
                    progress: _controller.value,
                    color: color,
                    backgroundColor: AppColors.warmBorder,
                    strokeWidth: 8,
                  ),
                ),
              ),
              // Time display
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.isPaused ? 'PAUSED' : 'REMAINING',
                    style: TextStyle(
                      color: widget.isPaused ? color : AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimerPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _TimerPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Glow effect
    final glowPaint = Paint()
      ..color = color.withAlpha(40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final sweepAngle = 2 * pi * (1 - progress);
    const startAngle = -pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      glowPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
