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
