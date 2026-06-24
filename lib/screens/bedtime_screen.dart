import 'package:flutter/material.dart';
import '../data/exercise_data.dart';
import 'session_player_screen.dart';
import '../state/app_state.dart';
import '../l10n/app_localizations.dart';

class BedtimeScreen extends StatelessWidget {
  const BedtimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppStateProvider.of(context);
    final exercises = ExerciseData.getBedtimeExercises();
    return Scaffold(
      backgroundColor: const Color(0xFF141018),
      appBar: AppBar(
        backgroundColor: const Color(0xFF141018),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.l10n('bedtime_wind_down'),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Moon header
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF3D2D7C).withAlpha(60),
                    const Color(0xFF5A3D99).withAlpha(40),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bedtime,
                color: Color(0xFFB4A0E8),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n('wind_down_relax'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n('gentle_stretches_minutes', [exercises.length.toString(), '5']),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                context.l10n('bedtime_screen_desc'),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            // Exercise list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1520),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF2A2030),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D2D7C).withAlpha(30),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            exercise.icon,
                            color: const Color(0xFFB4A0E8),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercise.getName(context),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${context.l10n('hold_seconds_count', [exercise.holdSeconds.toString()])} • ${context.l10n('sets_count', [exercise.sets.toString()])}',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${exercise.xpReward}XP',
                          style: const TextStyle(
                            color: Color(0xFFB4A0E8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Start button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => SessionPlayerScreen(
                          exercises: exercises,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5A3D99),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded,
                          size: 26, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n('begin_wind_down'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
