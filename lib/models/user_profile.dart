class UserProfile {
  String name;
  String painLocation; // 'left_leg', 'right_leg', 'lower_back', 'both_legs'
  String painSeverity; // 'mild', 'moderate', 'severe'
  String painDuration; // 'weeks', 'months', 'years'
  String mobilityLevel; // 'floor', 'chair', 'bed'
  List<String> otherConditions;
  bool onboardingCompleted;
  String reminderTime;
  bool notificationsEnabled;
  bool darkMode;
  bool isPremium;

  UserProfile({
    this.name = '',
    this.painLocation = '',
    this.painSeverity = '',
    this.painDuration = '',
    this.mobilityLevel = '',
    this.otherConditions = const [],
    this.onboardingCompleted = false,
    this.reminderTime = '08:00',
    this.notificationsEnabled = true,
    this.darkMode = true,
    this.isPremium = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'painLocation': painLocation,
      'painSeverity': painSeverity,
      'painDuration': painDuration,
      'mobilityLevel': mobilityLevel,
      'otherConditions': otherConditions.join(','),
      'onboardingCompleted': onboardingCompleted ? 1 : 0,
      'reminderTime': reminderTime,
      'notificationsEnabled': notificationsEnabled ? 1 : 0,
      'darkMode': darkMode ? 1 : 0,
      'isPremium': isPremium ? 1 : 0,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] as String? ?? '',
      painLocation: map['painLocation'] as String? ?? '',
      painSeverity: map['painSeverity'] as String? ?? '',
      painDuration: map['painDuration'] as String? ?? '',
      mobilityLevel: map['mobilityLevel'] as String? ?? '',
      otherConditions: (map['otherConditions'] as String?)?.isNotEmpty == true
          ? (map['otherConditions'] as String).split(',')
          : [],
      onboardingCompleted: (map['onboardingCompleted'] as int?) == 1,
      reminderTime: map['reminderTime'] as String? ?? '08:00',
      notificationsEnabled: (map['notificationsEnabled'] as int?) != 0,
      darkMode: (map['darkMode'] as int?) != 0,
      isPremium: (map['isPremium'] as int?) == 1,
    );
  }
}
