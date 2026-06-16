import 'package:flutter/material.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final String category; // 'stretch', 'strengthen', 'decompress'
  final int durationSeconds;
  final int sets;
  final int holdSeconds;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final List<String> instructions;
  final List<String> commonMistakes;
  final List<String> modifications;
  final bool flareUpFriendly;
  final bool bedFriendly;
  final bool bedtimeRoutine;
  final int xpReward;
  final IconData icon;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.durationSeconds = 60,
    this.sets = 3,
    this.holdSeconds = 15,
    this.difficulty = 'beginner',
    this.instructions = const [],
    this.commonMistakes = const [],
    this.modifications = const [],
    this.flareUpFriendly = false,
    this.bedFriendly = false,
    this.bedtimeRoutine = false,
    this.xpReward = 10,
    this.icon = Icons.fitness_center,
  });

  String get durationDisplay {
    final mins = durationSeconds ~/ 60;
    if (mins < 1) return '${durationSeconds}s';
    return '$mins min';
  }

  String get difficultyDisplay {
    return '${difficulty[0].toUpperCase()}${difficulty.substring(1)}';
  }

  String get categoryDisplay {
    switch (category) {
      case 'stretch':
        return 'Stretch';
      case 'strengthen':
        return 'Strengthen';
      case 'decompress':
        return 'Decompress';
      default:
        return category;
    }
  }

  List<String> get imageAssets {
    switch (id) {
      case 'piriformis_stretch':
        return const [
          'Assets/excercises/piriformis stretch/1.jpg',
          'Assets/excercises/piriformis stretch/2.jpg',
        ];
      case 'knee_to_chest':
        return const [
          'Assets/excercises/knee to chest/1.jpg',
          'Assets/excercises/knee to chest/2.jpg',
          'Assets/excercises/knee to chest/3.jpg',
        ];
      case 'sciatic_nerve_floss':
        return const [
          'Assets/excercises/sciatic nerve/1.jpg',
          'Assets/excercises/sciatic nerve/2.jpg',
          'Assets/excercises/sciatic nerve/3.jpg',
        ];
      case 'cat_cow':
        return const [
          'Assets/excercises/cat cow/1.jpg',
          'Assets/excercises/cat cow/2.jpg',
          'Assets/excercises/cat cow/3.jpg',
          'Assets/excercises/cat cow/4.jpg',
        ];
      case 'hamstring_stretch':
        return const [
          'Assets/excercises/hamstring stretch/1.jpg',
          'Assets/excercises/hamstring stretch/2.jpg',
          'Assets/excercises/hamstring stretch/3.jpg',
          'Assets/excercises/hamstring stretch/4.jpg',
        ];
      case 'hip_flexor_release':
        return const [
          'Assets/excercises/hip flexor/1.jpg',
          'Assets/excercises/hip flexor/2.jpg',
          'Assets/excercises/hip flexor/3.jpg',
        ];
      case 'glute_bridge':
        return const [
          'Assets/excercises/glute/1.jpg',
          'Assets/excercises/glute/2.jpg',
          'Assets/excercises/glute/3.jpg',
        ];
      case 'bird_dog':
        return const [
          'Assets/excercises/bird dog/1.jpg',
          'Assets/excercises/bird dog/2.jpg',
        ];
      case 'mckenzie_extension':
        return const [
          'Assets/excercises/Mckenzie extension/1.jpg',
          'Assets/excercises/Mckenzie extension/2.jpg',
          'Assets/excercises/Mckenzie extension/3.jpg',
        ];
      case 'lumbar_decompression':
        return const [
          'Assets/excercises/lumber decmprs/1.jpg',
          'Assets/excercises/lumber decmprs/2.jpg',
          'Assets/excercises/lumber decmprs/3.jpg',
        ];
      default:
        return const [];
    }
  }
}

class CompletedExercise {
  final String exerciseId;
  final DateTime completedAt;
  final int xpEarned;

  CompletedExercise({
    required this.exerciseId,
    required this.completedAt,
    required this.xpEarned,
  });

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'completedAt': completedAt.toIso8601String(),
      'xpEarned': xpEarned,
    };
  }

  factory CompletedExercise.fromMap(Map<String, dynamic> map) {
    return CompletedExercise(
      exerciseId: map['exerciseId'] as String,
      completedAt: DateTime.parse(map['completedAt'] as String),
      xpEarned: map['xpEarned'] as int,
    );
  }
}
