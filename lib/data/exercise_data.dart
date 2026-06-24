import 'package:flutter/material.dart';
import '../models/exercise.dart';

class ExerciseData {
  static const List<Exercise> allExercises = [
    // ── STRETCHES ──
    Exercise(
      id: 'piriformis_stretch',
      name: 'Piriformis Stretch',
      description:
          'Targets the piriformis muscle deep in the buttock that can compress the sciatic nerve. One of the most effective stretches for sciatica relief.',
      category: 'stretch',
      durationSeconds: 180,
      sets: 3,
      holdSeconds: 30,
      difficulty: 'beginner',
      flareUpFriendly: true,
      bedFriendly: true,
      xpReward: 15,
      icon: Icons.accessibility_new,
      instructions: [
        'Lie on your back with both knees bent and feet flat on the floor.',
        'Cross your affected leg over the opposite knee, resting the ankle on the knee.',
        'Gently pull the bottom knee toward your chest using both hands.',
        'Hold the stretch for 30 seconds — you should feel it deep in the buttock.',
        'Slowly release and repeat on the same side.',
        'Complete 3 sets, then switch sides if needed.',
      ],
      commonMistakes: [
        'Pulling too aggressively — this should be a gentle stretch.',
        'Lifting the head and shoulders off the floor.',
        'Holding your breath — breathe slowly and deeply throughout.',
        'Bouncing instead of holding a steady stretch.',
      ],
      modifications: [
        'If you can\'t reach your knee, loop a towel around your thigh.',
        'On flare-up days, keep both feet on the floor and just cross the ankle.',
        'If lying down is painful, do this seated in a chair instead.',
      ],
    ),
    Exercise(
      id: 'knee_to_chest',
      name: 'Knee to Chest Stretch',
      description:
          'Gently stretches the lower back and glutes, relieving pressure on the sciatic nerve and reducing muscle tension.',
      category: 'stretch',
      durationSeconds: 120,
      sets: 3,
      holdSeconds: 20,
      difficulty: 'beginner',
      flareUpFriendly: true,
      bedFriendly: true,
      bedtimeRoutine: true,
      xpReward: 10,
      icon: Icons.self_improvement,
      instructions: [
        'Lie on your back with both legs extended.',
        'Slowly bend one knee and bring it toward your chest.',
        'Clasp your hands around your shin or behind your thigh.',
        'Gently pull your knee closer to your chest until you feel a comfortable stretch.',
        'Hold for 20 seconds while breathing deeply.',
        'Slowly lower your leg and repeat with the other side.',
      ],
      commonMistakes: [
        'Jerking the knee up too quickly.',
        'Straining the neck by lifting the head.',
        'Forcing the knee past the point of comfort.',
      ],
      modifications: [
        'Place a pillow under your head for neck comfort.',
        'Hold behind the thigh instead of the shin if painful.',
        'On flare days, just bring the knee partway — don\'t force it.',
      ],
    ),
    Exercise(
      id: 'sciatic_nerve_floss',
      name: 'Sciatic Nerve Flossing',
      description:
          'A gentle neural mobilisation technique that helps the sciatic nerve glide freely, reducing nerve compression symptoms.',
      category: 'stretch',
      durationSeconds: 120,
      sets: 3,
      holdSeconds: 5,
      difficulty: 'intermediate',
      flareUpFriendly: false,
      bedFriendly: false,
      xpReward: 20,
      icon: Icons.waves,
      instructions: [
        'Sit on a chair with your feet flat on the floor.',
        'Straighten the affected leg out in front of you.',
        'Point your toes up toward the ceiling while looking up at the same time.',
        'Then point your toes down while tucking your chin to your chest.',
        'Repeat this rocking motion smoothly for 5 repetitions.',
        'Do 3 sets with 30 seconds rest between sets.',
      ],
      commonMistakes: [
        'Moving too quickly — this should be slow and controlled.',
        'Forcing the leg to full extension if it causes sharp pain.',
        'Doing this exercise during a severe flare-up.',
      ],
      modifications: [
        'Reduce the range of motion if you feel tingling.',
        'Support your thigh with your hands while straightening.',
        'Start with just ankle pumps if nerve flossing is too intense.',
      ],
    ),
    Exercise(
      id: 'cat_cow',
      name: 'Cat-Cow Stretch',
      description:
          'A flowing spinal movement that gently mobilises the entire spine, improving flexibility and relieving lower back tension.',
      category: 'stretch',
      durationSeconds: 120,
      sets: 3,
      holdSeconds: 5,
      difficulty: 'beginner',
      flareUpFriendly: true,
      bedFriendly: false,
      xpReward: 15,
      icon: Icons.pets,
      instructions: [
        'Start on all fours with hands under shoulders and knees under hips.',
        'COW: Inhale, drop your belly toward the floor, lift your head and tailbone up.',
        'CAT: Exhale, round your back toward the ceiling, tuck your chin and tailbone.',
        'Flow smoothly between the two positions.',
        'Hold each position for about 5 seconds.',
        'Repeat for 10 cycles, 3 sets.',
      ],
      commonMistakes: [
        'Moving too quickly without coordinating with breath.',
        'Overarching the lower back in the cow position.',
        'Not engaging the core during the movement.',
      ],
      modifications: [
        'Place a folded towel under your knees for cushioning.',
        'Reduce the range of motion if your back is sore.',
        'Do seated cat-cow in a chair if getting on the floor is difficult.',
      ],
    ),
    Exercise(
      id: 'hamstring_stretch',
      name: 'Hamstring Stretch',
      description:
          'Tight hamstrings pull on the pelvis and increase pressure on the lower back. This stretch helps relieve that tension.',
      category: 'stretch',
      durationSeconds: 180,
      sets: 3,
      holdSeconds: 30,
      difficulty: 'beginner',
      flareUpFriendly: true,
      bedFriendly: true,
      bedtimeRoutine: true,
      xpReward: 15,
      icon: Icons.airline_seat_legroom_extra,
      instructions: [
        'Lie on your back with both legs flat.',
        'Raise one leg up, keeping it as straight as comfortable.',
        'Loop a towel or belt around the ball of your foot.',
        'Gently pull the leg toward you until you feel a stretch behind the thigh.',
        'Hold for 30 seconds, breathing deeply.',
        'Lower slowly and repeat on the other side.',
      ],
      commonMistakes: [
        'Bending the knee of the raised leg too much.',
        'Lifting the opposite hip off the floor.',
        'Pulling too hard — the stretch should never be painful.',
      ],
      modifications: [
        'Keep the knee slightly bent if full extension is too intense.',
        'Use a doorway stretch: lie with one leg up against the door frame.',
        'On flare days, just do gentle ankle pumps with the leg slightly raised.',
      ],
    ),
    Exercise(
      id: 'hip_flexor_release',
      name: 'Hip Flexor Release',
      description:
          'Releases tight hip flexors that contribute to pelvic imbalance and increased lower back strain. Essential for desk workers.',
      category: 'stretch',
      durationSeconds: 180,
      sets: 3,
      holdSeconds: 30,
      difficulty: 'intermediate',
      flareUpFriendly: false,
      bedFriendly: false,
      xpReward: 20,
      icon: Icons.directions_walk,
      instructions: [
        'Kneel on one knee with the other foot flat in front (lunge position).',
        'Keep your torso upright and core engaged.',
        'Gently push your hips forward until you feel a stretch in the front of the kneeling hip.',
        'Hold for 30 seconds.',
        'You can raise the arm on the kneeling side overhead for a deeper stretch.',
        'Repeat on the other side.',
      ],
      commonMistakes: [
        'Leaning the torso forward instead of staying upright.',
        'Letting the front knee go past the toes.',
        'Arching the lower back excessively.',
      ],
      modifications: [
        'Place a pillow under the kneeling knee.',
        'Hold onto a chair for balance.',
        'Reduce the forward push if too intense.',
      ],
    ),

    // ── STRENGTHENING ──
    Exercise(
      id: 'pelvic_tilts',
      name: 'Pelvic Tilts',
      description:
          'Gently activates the core muscles and mobilises the lower spine. Safe even during mild flare-ups.',
      category: 'strengthen',
      durationSeconds: 120,
      sets: 3,
      holdSeconds: 5,
      difficulty: 'beginner',
      flareUpFriendly: true,
      bedFriendly: true,
      xpReward: 10,
      icon: Icons.swap_vert,
      instructions: [
        'Lie on your back with knees bent and feet flat on the floor.',
        'Place your hands on your hips or beside you.',
        'Gently flatten your lower back into the floor by tilting your pelvis upward.',
        'Hold for 5 seconds, then release.',
        'You should feel your lower abdominals engage.',
        'Repeat 10 times for 3 sets.',
      ],
      commonMistakes: [
        'Using the legs to push rather than the core muscles.',
        'Holding your breath during the hold.',
        'Over-tilting and lifting the buttocks off the floor.',
      ],
      modifications: [
        'Place a small towel roll under your lower back for feedback.',
        'Do smaller movements if experiencing pain.',
        'This can be done in bed on a flare-up day.',
      ],
    ),
    Exercise(
      id: 'glute_bridge',
      name: 'Glute Bridge',
      description:
          'Strengthens the glutes and core, providing stability to the pelvis and reducing load on the lower back.',
      category: 'strengthen',
      durationSeconds: 180,
      sets: 3,
      holdSeconds: 10,
      difficulty: 'intermediate',
      flareUpFriendly: false,
      bedFriendly: false,
      xpReward: 20,
      icon: Icons.landscape,
      instructions: [
        'Lie on your back with knees bent and feet hip-width apart.',
        'Press your feet into the floor and lift your hips up.',
        'Squeeze your glutes at the top — your body should form a straight line from shoulders to knees.',
        'Hold for 10 seconds.',
        'Slowly lower back down.',
        'Repeat 10 times for 3 sets.',
      ],
      commonMistakes: [
        'Arching the lower back instead of maintaining a neutral spine.',
        'Pushing up too high.',
        'Not engaging the glutes — relying on the hamstrings instead.',
      ],
      modifications: [
        'Start with smaller lifts if full bridges are too intense.',
        'Place a ball or pillow between the knees to engage inner thighs.',
        'Hold at the top for a shorter time and build up gradually.',
      ],
    ),
    Exercise(
      id: 'bird_dog',
      name: 'Bird Dog',
      description:
          'A core stability exercise that strengthens the back extensors and improves coordination. Excellent for spinal health.',
      category: 'strengthen',
      durationSeconds: 180,
      sets: 3,
      holdSeconds: 10,
      difficulty: 'intermediate',
      flareUpFriendly: false,
      bedFriendly: false,
      xpReward: 25,
      icon: Icons.sports_gymnastics,
      instructions: [
        'Start on all fours with hands under shoulders, knees under hips.',
        'Simultaneously extend your right arm forward and left leg backward.',
        'Keep your back flat — don\'t let the hips rotate.',
        'Hold for 10 seconds.',
        'Return to start and repeat with opposite arm and leg.',
        'Do 8 repetitions on each side for 3 sets.',
      ],
      commonMistakes: [
        'Letting the hips drop or twist to one side.',
        'Raising the arm or leg too high.',
        'Moving too quickly without control.',
      ],
      modifications: [
        'Start with just arm extension, then just leg extension separately.',
        'Place a towel under your knees for cushioning.',
        'Hold for shorter duration and build up.',
      ],
    ),

    // ── DECOMPRESSION ──
    Exercise(
      id: 'mckenzie_extension',
      name: 'McKenzie Extension',
      description:
          'A proven physiotherapy technique that uses backward bending to centralise pain and relieve disc pressure on the sciatic nerve.',
      category: 'decompress',
      durationSeconds: 180,
      sets: 3,
      holdSeconds: 10,
      difficulty: 'beginner',
      flareUpFriendly: false,
      bedFriendly: true,
      xpReward: 20,
      icon: Icons.arrow_upward,
      instructions: [
        'Lie face down on a firm surface with hands by your shoulders.',
        'Slowly push your upper body up, straightening your arms.',
        'Keep your hips and pelvis on the floor.',
        'Hold the top position for 10 seconds.',
        'Slowly lower back down.',
        'Repeat 10 times for 3 sets.',
      ],
      commonMistakes: [
        'Lifting the hips off the floor.',
        'Pushing up too far too quickly on the first repetition.',
        'Doing this exercise if it increases leg pain (stop immediately).',
      ],
      modifications: [
        'Start propped on elbows (sphinx position) before full extension.',
        'Reduce hold time if back feels stiff.',
        'Stop immediately if pain moves further down the leg.',
      ],
    ),
    Exercise(
      id: 'lumbar_decompression',
      name: 'Lumbar Decompression',
      description:
          'A gentle traction stretch that creates space between vertebrae, reducing nerve compression in the lower spine.',
      category: 'decompress',
      durationSeconds: 180,
      sets: 3,
      holdSeconds: 30,
      difficulty: 'beginner',
      flareUpFriendly: true,
      bedFriendly: true,
      bedtimeRoutine: true,
      xpReward: 15,
      icon: Icons.expand,
      instructions: [
        'Lie on your back and hug both knees to your chest.',
        'Gently rock side to side for 10 seconds.',
        'Then extend into child\'s pose: kneel on the floor, sit back on your heels.',
        'Reach your arms forward on the floor and relax your forehead down.',
        'Hold child\'s pose for 30 seconds, breathing deeply.',
        'Repeat the sequence 3 times.',
      ],
      commonMistakes: [
        'Rocking too vigorously.',
        'Not relaxing the shoulders in child\'s pose.',
        'Holding your breath.',
      ],
      modifications: [
        'If child\'s pose is difficult, stay with the knee hug only.',
        'Place a pillow between your calves and thighs in child\'s pose.',
        'On bed: just do the knee hug gently.',
      ],
    ),
    Exercise(
      id: 'supine_twist',
      name: 'Supine Spinal Twist',
      description:
          'A gentle rotational stretch that releases tension throughout the entire spine and decompresses the lower back.',
      category: 'decompress',
      durationSeconds: 180,
      sets: 2,
      holdSeconds: 30,
      difficulty: 'beginner',
      flareUpFriendly: true,
      bedFriendly: true,
      bedtimeRoutine: true,
      xpReward: 15,
      icon: Icons.rotate_right,
      instructions: [
        'Lie on your back with arms out to the sides in a T position.',
        'Bend both knees with feet flat on the floor.',
        'Slowly drop both knees to one side, keeping shoulders on the floor.',
        'Turn your head to the opposite direction.',
        'Hold for 30 seconds, breathing deeply into the stretch.',
        'Slowly return to centre and repeat on the other side.',
      ],
      commonMistakes: [
        'Letting the opposite shoulder lift off the floor.',
        'Dropping the knees too quickly.',
        'Not breathing deeply through the stretch.',
      ],
      modifications: [
        'Place a pillow between the knees.',
        'Don\'t drop knees all the way to the floor — go partway.',
        'This is perfect for bed — do it right before sleep.',
      ],
    ),
  ];

  /// Generates a customized list of exercises based on pain location, severity, and mobility level
  static List<Exercise> generateCustomPlan({
    required String painLocation,
    required String painSeverity,
    required String mobilityLevel,
  }) {
    final List<Exercise> selected = [];

    for (final ex in allExercises) {
      // 1. Mobility filters
      if (mobilityLevel == 'bed' && !ex.bedFriendly) {
        continue;
      }
      
      // 2. Severity filters
      if (painSeverity == 'severe' && !ex.flareUpFriendly) {
        continue;
      }
      if (painSeverity == 'moderate' && ex.difficulty == 'advanced') {
        continue;
      }

      // 3. Location/Relevance filters
      bool isRelevant = false;
      if (painLocation == 'lower_back') {
        // Core stability, cat-cow, pelvic tilts, and decompression
        if (ex.category == 'decompress' || 
            ex.id == 'pelvic_tilts' || 
            ex.id == 'cat_cow') {
          isRelevant = true;
        }
      } else {
        // Leg pain: stretches, nerve flossing, bridges
        if (ex.category == 'stretch' || 
            ex.id == 'supine_twist' || 
            ex.id == 'glute_bridge') {
          isRelevant = true;
        }
      }

      if (isRelevant) {
        selected.add(ex);
      }
    }

    // Default safe fallbacks if the filter is too restrictive
    if (selected.isEmpty) {
      selected.addAll(allExercises.where((e) => e.flareUpFriendly && e.bedFriendly));
    }

    return selected;
  }

  /// Returns exercises suitable for a given pain score
  static List<Exercise> getSessionForPainLevel(int painScore) {
    if (painScore >= 8) {
      // Severe pain: gentle, bed-friendly only
      return allExercises
          .where((e) => e.flareUpFriendly && e.bedFriendly)
          .toList();
    } else if (painScore >= 6) {
      // Moderate-high: flare-up friendly only
      return allExercises.where((e) => e.flareUpFriendly).toList();
    } else if (painScore >= 4) {
      // Moderate: beginner + intermediate, no advanced
      return allExercises
          .where((e) => e.difficulty != 'advanced')
          .toList();
    } else {
      // Low pain: all exercises available
      return allExercises.toList();
    }
  }

  /// Returns flare-up mode exercises (bed-friendly only)
  static List<Exercise> getFlareUpExercises() {
    return allExercises
        .where((e) => e.flareUpFriendly && e.bedFriendly)
        .toList();
  }

  /// Returns bedtime routine exercises
  static List<Exercise> getBedtimeExercises() {
    return allExercises.where((e) => e.bedtimeRoutine).toList();
  }

  /// Returns exercises by category
  static List<Exercise> getByCategory(String category) {
    return allExercises.where((e) => e.category == category).toList();
  }

  /// Returns exercises by difficulty
  static List<Exercise> getByDifficulty(String difficulty) {
    return allExercises.where((e) => e.difficulty == difficulty).toList();
  }
}
