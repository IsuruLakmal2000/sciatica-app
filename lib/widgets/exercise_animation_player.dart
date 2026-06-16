import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ExerciseAnimationPlayer extends StatefulWidget {
  final List<String> imageAssets;
  final bool isPaused;
  final double height;
  final double width;
  final Duration frameDuration;

  const ExerciseAnimationPlayer({
    super.key,
    required this.imageAssets,
    this.isPaused = false,
    this.height = 220,
    this.width = double.infinity,
    this.frameDuration = const Duration(milliseconds: 1000),
  });

  @override
  State<ExerciseAnimationPlayer> createState() => _ExerciseAnimationPlayerState();
}

class _ExerciseAnimationPlayerState extends State<ExerciseAnimationPlayer> {
  int _currentFrameIndex = 0;
  Timer? _timer;
  bool _precached = false;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precached) {
      _precacheImages();
      _precached = true;
    }
  }

  @override
  void didUpdateWidget(covariant ExerciseAnimationPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPaused != widget.isPaused ||
        oldWidget.frameDuration != widget.frameDuration ||
        oldWidget.imageAssets != widget.imageAssets) {
      _stopAnimation();
      _startAnimation();
    }
  }

  @override
  void dispose() {
    _stopAnimation();
    super.dispose();
  }

  void _precacheImages() {
    for (final asset in widget.imageAssets) {
      precacheImage(AssetImage(asset), context);
    }
  }

  void _startAnimation() {
    if (widget.imageAssets.isEmpty || widget.isPaused) return;

    _timer = Timer.periodic(widget.frameDuration, (timer) {
      if (mounted) {
        setState(() {
          _currentFrameIndex = (_currentFrameIndex + 1) % widget.imageAssets.length;
        });
      }
    });
  }

  void _stopAnimation() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageAssets.isEmpty) {
      return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.warmBorder, width: 1.5),
        ),
        child: Center(
          child: Icon(Icons.image_not_supported_outlined, color: AppColors.textMuted, size: 40),
        ),
      );
    }

    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.warmBorder, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.burntOrange.withAlpha(8),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Image.asset(
          widget.imageAssets[_currentFrameIndex],
          key: ValueKey<String>(widget.imageAssets[_currentFrameIndex]),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: AppColors.dangerRed, size: 32),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load frame',
                      style: TextStyle(color: AppColors.dangerRedLight, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
