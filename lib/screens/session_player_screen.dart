import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/exercise.dart';
import '../state/app_state.dart';
import '../widgets/countdown_timer.dart';
import '../widgets/exercise_animation_player.dart';

class SessionPlayerScreen extends StatefulWidget {
  final List<Exercise> exercises;
  final int startIndex;

  const SessionPlayerScreen({
    super.key,
    required this.exercises,
    this.startIndex = 0,
  });

  @override
  State<SessionPlayerScreen> createState() => _SessionPlayerScreenState();
}

class _SessionPlayerScreenState extends State<SessionPlayerScreen>
    with TickerProviderStateMixin {
  late int _currentIndex;
  int _currentSet = 1;
  int _currentStep = 0;
  bool _isResting = false;
  bool _isPaused = false;
  bool _isCompleted = false;
  int _earnedXP = 0;
  final GlobalKey<CountdownTimerState> _timerKey = GlobalKey();
  late AnimationController _pulseController;

  Exercise get _currentExercise => widget.exercises[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.startIndex;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTimerComplete() {
    if (_isResting) {
      // Rest period over — start next set
      setState(() {
        _isResting = false;
        _currentSet++;
      });
    } else {
      // Exercise set complete
      if (_currentSet < _currentExercise.sets) {
        // More sets remaining — start rest
        setState(() => _isResting = true);
      } else {
        // All sets done — complete this exercise
        _completeCurrentExercise();
      }
    }
  }

  void _completeCurrentExercise() {
    final state = AppStateProvider.of(context);
    state.completeExercise(_currentExercise);
    _earnedXP += _currentExercise.xpReward;

    if (_currentIndex < widget.exercises.length - 1) {
      // Move to next exercise
      setState(() {
        _currentIndex++;
        _currentSet = 1;
        _currentStep = 0;
        _isResting = false;
      });
    } else {
      // Session complete
      setState(() => _isCompleted = true);
    }
  }

  void _togglePause() {
    if (_isPaused) {
      _timerKey.currentState?.resume();
    } else {
      _timerKey.currentState?.pause();
    }
    setState(() => _isPaused = !_isPaused);
  }

  @override
  Widget build(BuildContext context) {
    AppStateProvider.of(context);
    if (_isCompleted) return _buildCompletionScreen();

    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(child: _buildPlayerContent()),
            _buildBottomSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showExitDialog(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warmBorder),
              ),
              child: Icon(Icons.close, color: AppColors.textSecondary, size: 20),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${_currentIndex + 1} of ${widget.exercises.length}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // Progress bar
                Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: AppColors.warmBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor:
                        (_currentIndex + 1) / widget.exercises.length,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.burntOrange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.warmGold.withAlpha(15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, size: 14, color: AppColors.warmGold),
                const SizedBox(width: 4),
                Text(
                  '+${_earnedXP}XP',
                  style: const TextStyle(
                    color: AppColors.warmGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerContent() {
    final showAnimation = !_isResting && _currentExercise.imageAssets.isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showAnimation)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ExerciseAnimationPlayer(
              imageAssets: _currentExercise.imageAssets,
              isPaused: _isPaused,
              height: 220,
            ),
          )
        else
          // Exercise icon with pulse animation
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
            final scale = 1.0 + (_pulseController.value * 0.1);
            return Transform.scale(
              scale: _isPaused ? 1.0 : scale,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _isResting
                      ? AppColors.forestGreen.withAlpha(20)
                      : AppColors.burntOrange.withAlpha(20),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isResting
                        ? AppColors.forestGreen.withAlpha(40)
                        : AppColors.burntOrange.withAlpha(40),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _isResting ? Icons.pause_circle : _currentExercise.icon,
                  size: 48,
                  color: _isResting
                      ? AppColors.forestGreen
                      : AppColors.burntOrange,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        // Exercise name
        Text(
          _isResting ? 'Rest' : _currentExercise.name,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _isResting
              ? 'Relax before the next set'
              : 'Set $_currentSet of ${_currentExercise.sets}',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 32),
        // Countdown timer
        CountdownTimer(
          key: ValueKey('${_currentIndex}_${_currentSet}_$_isResting'),
          totalSeconds: _isResting ? 15 : _currentExercise.holdSeconds,
          onComplete: _onTimerComplete,
          color: _isResting ? AppColors.forestGreen : AppColors.burntOrange,
        ),
        const SizedBox(height: 24),
        // Current instruction
        if (!_isResting &&
            _currentStep < _currentExercise.instructions.length)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _currentExercise.instructions[_currentStep],
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: AppColors.warmBorder),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Previous step
          _buildControlButton(
            icon: Icons.skip_previous_rounded,
            label: 'Prev',
            onTap: () {
              if (_currentStep > 0) {
                setState(() => _currentStep--);
              }
            },
          ),
          // Pause/Resume
          GestureDetector(
            onTap: _togglePause,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.burntOrange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.burntOrange.withAlpha(60),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          // Next step / Skip
          _buildControlButton(
            icon: Icons.skip_next_rounded,
            label: 'Next',
            onTap: () {
              if (_currentStep < _currentExercise.instructions.length - 1) {
                setState(() => _currentStep++);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.warmBorder.withAlpha(60),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionScreen() {
    return Scaffold(
      backgroundColor: AppColors.espressoBrown,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.forestGreen.withAlpha(20),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.forestGreen.withAlpha(60),
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.forestGreen,
                    size: 52,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Session Complete! 🎉',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Great job! You\'re one step closer to recovery.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // XP earned card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.warmGold.withAlpha(40)),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.warmGold,
                        size: 36,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '+$_earnedXP XP',
                        style: const TextStyle(
                          color: AppColors.warmGold,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Experience earned',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.warmBorder),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${widget.exercises.length}',
                              style: const TextStyle(
                                color: AppColors.burntOrange,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Exercises',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.warmBorder),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${_totalDuration()}',
                              style: const TextStyle(
                                color: AppColors.burntOrange,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Minutes',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int _totalDuration() {
    return widget.exercises.fold(0, (sum, e) => sum + e.durationSeconds) ~/ 60;
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'End session?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Your progress will be saved, but you won\'t earn XP for remaining exercises.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Continue', style: TextStyle(color: AppColors.burntOrange)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('End', style: TextStyle(color: AppColors.dangerRed)),
          ),
        ],
      ),
    );
  }
}
