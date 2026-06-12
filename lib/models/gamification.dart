class GamificationData {
  int totalXP;
  int currentStreak;
  int longestStreak;
  DateTime? lastCompletedDate;
  int completedSessionCount;
  List<String> earnedBadges;

  GamificationData({
    this.totalXP = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
    this.completedSessionCount = 0,
    this.earnedBadges = const [],
  });

  int get currentLevel {
    if (totalXP < 100) return 1;
    if (totalXP < 300) return 2;
    if (totalXP < 600) return 3;
    if (totalXP < 1000) return 4;
    if (totalXP < 1500) return 5;
    if (totalXP < 2200) return 6;
    if (totalXP < 3000) return 7;
    if (totalXP < 4000) return 8;
    if (totalXP < 5500) return 9;
    return 10;
  }

  String get levelTitle {
    switch (currentLevel) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Pain Fighter';
      case 3:
        return 'Stretch Starter';
      case 4:
        return 'Spine Warrior';
      case 5:
        return 'Pain Crusher';
      case 6:
        return 'Recovery Warrior';
      case 7:
        return 'Flexibility Hero';
      case 8:
        return 'Recovery Champion';
      case 9:
        return 'Sciatica Conqueror';
      case 10:
        return 'Legend';
      default:
        return 'Beginner';
    }
  }

  int get xpForCurrentLevel {
    const thresholds = [0, 100, 300, 600, 1000, 1500, 2200, 3000, 4000, 5500];
    final idx = (currentLevel - 1).clamp(0, thresholds.length - 1);
    return thresholds[idx];
  }

  int get xpForNextLevel {
    const thresholds = [100, 300, 600, 1000, 1500, 2200, 3000, 4000, 5500, 7500];
    final idx = (currentLevel - 1).clamp(0, thresholds.length - 1);
    return thresholds[idx];
  }

  double get levelProgress {
    final rangeTotal = xpForNextLevel - xpForCurrentLevel;
    if (rangeTotal <= 0) return 1.0;
    final progress = (totalXP - xpForCurrentLevel) / rangeTotal;
    return progress.clamp(0.0, 1.0);
  }

  Map<String, dynamic> toMap() {
    return {
      'totalXP': totalXP,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String() ?? '',
      'completedSessionCount': completedSessionCount,
      'earnedBadges': earnedBadges.join(','),
    };
  }

  factory GamificationData.fromMap(Map<String, dynamic> map) {
    final lastDate = map['lastCompletedDate'] as String? ?? '';
    return GamificationData(
      totalXP: map['totalXP'] as int? ?? 0,
      currentStreak: map['currentStreak'] as int? ?? 0,
      longestStreak: map['longestStreak'] as int? ?? 0,
      lastCompletedDate: lastDate.isNotEmpty ? DateTime.tryParse(lastDate) : null,
      completedSessionCount: map['completedSessionCount'] as int? ?? 0,
      earnedBadges: (map['earnedBadges'] as String?)?.isNotEmpty == true
          ? (map['earnedBadges'] as String).split(',')
          : [],
    );
  }
}

class Badge {
  final String id;
  final String name;
  final String description;
  final String icon; // emoji
  final bool Function(GamificationData data) isUnlocked;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isUnlocked,
  });
}

final List<Badge> allBadges = [
  Badge(
    id: 'first_session',
    name: 'First Step',
    description: 'Complete your first session',
    icon: '🌱',
    isUnlocked: (d) => d.completedSessionCount >= 1,
  ),
  Badge(
    id: 'streak_7',
    name: '7-Day Streak',
    description: 'Exercise for 7 consecutive days',
    icon: '🔥',
    isUnlocked: (d) => d.longestStreak >= 7,
  ),
  Badge(
    id: 'streak_30',
    name: '30-Day Streak',
    description: 'Exercise for 30 consecutive days',
    icon: '💪',
    isUnlocked: (d) => d.longestStreak >= 30,
  ),
  Badge(
    id: 'sessions_10',
    name: 'Committed',
    description: 'Complete 10 sessions',
    icon: '⭐',
    isUnlocked: (d) => d.completedSessionCount >= 10,
  ),
  Badge(
    id: 'sessions_50',
    name: 'Dedicated',
    description: 'Complete 50 sessions',
    icon: '🏆',
    isUnlocked: (d) => d.completedSessionCount >= 50,
  ),
  Badge(
    id: 'sessions_100',
    name: 'Century Club',
    description: 'Complete 100 sessions',
    icon: '👑',
    isUnlocked: (d) => d.completedSessionCount >= 100,
  ),
  Badge(
    id: 'xp_1000',
    name: 'XP Master',
    description: 'Earn 1000 XP',
    icon: '💎',
    isUnlocked: (d) => d.totalXP >= 1000,
  ),
  Badge(
    id: 'level_5',
    name: 'Pain Crusher',
    description: 'Reach Level 5',
    icon: '🎯',
    isUnlocked: (d) => d.currentLevel >= 5,
  ),
  Badge(
    id: 'level_10',
    name: 'Legend',
    description: 'Reach Level 10',
    icon: '🌟',
    isUnlocked: (d) => d.currentLevel >= 10,
  ),
];
