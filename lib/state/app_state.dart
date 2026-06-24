import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../models/gamification.dart';
import '../models/pain_entry.dart';
import '../models/exercise.dart';
import '../data/exercise_data.dart';
import '../services/notification_service.dart';
import '../services/subscription_service.dart';

class AppState extends ChangeNotifier {
  Database? _db;
  UserProfile _profile = UserProfile();
  GamificationData _gamification = GamificationData();
  List<PainEntry> _painEntries = [];
  List<CompletedExercise> _completedExercises = [];
  bool _isFlareUpMode = false;
  bool _isLoading = true;
  int _todaysPainScore = 0;
  List<String> _customSessionExerciseIds = [];
  String _languageCode = 'en';

  // ── Getters ──
  UserProfile get profile => _profile;
  GamificationData get gamification => _gamification;
  List<PainEntry> get painEntries => _painEntries;
  List<CompletedExercise> get completedExercises => _completedExercises;
  bool get isFlareUpMode => _isFlareUpMode;
  bool get isLoading => _isLoading;
  int get todaysPainScore => _todaysPainScore;
  bool get hasCompletedOnboarding => _profile.onboardingCompleted;
  List<String> get customSessionExerciseIds => _customSessionExerciseIds;
  String get languageCode => _languageCode;

  List<Exercise> get customSessionExercises {
    return _customSessionExerciseIds
        .map((id) => ExerciseData.allExercises.firstWhere((e) => e.id == id, orElse: () => ExerciseData.allExercises.first))
        .toList();
  }

  Future<void> loadCustomSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _customSessionExerciseIds = prefs.getStringList('custom_session_exercises') ?? [];
    } catch (e) {
      debugPrint('Error loading custom session: $e');
    }
  }

  Future<void> saveCustomSession(List<String> exerciseIds) async {
    _customSessionExerciseIds = exerciseIds;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('custom_session_exercises', exerciseIds);
    } catch (e) {
      debugPrint('Error saving custom session: $e');
    }
  }

  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _languageCode = prefs.getString('app_language') ?? 'en';
    } catch (e) {
      debugPrint('Error loading language: $e');
    }
  }

  Future<void> setLanguage(String code) async {
    _languageCode = code;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', code);
      
      // Reschedule reminders in the new language
      NotificationService().scheduleReminder(
        enabled: _profile.notificationsEnabled,
        timeStr: _profile.reminderTime,
        lang: _languageCode,
      );
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
  }

  /// Today's exercises based on pain level and flare-up mode
  List<Exercise> get todaysExercises {
    if (_isFlareUpMode) {
      return ExerciseData.getFlareUpExercises();
    }
    return ExerciseData.getSessionForPainLevel(_todaysPainScore);
  }

  /// Exercises completed today
  List<CompletedExercise> get todaysCompletedExercises {
    final today = DateTime.now();
    return _completedExercises.where((e) {
      return e.completedAt.year == today.year &&
          e.completedAt.month == today.month &&
          e.completedAt.day == today.day;
    }).toList();
  }

  /// Check if specific exercise is completed today
  bool isExerciseCompletedToday(String exerciseId) {
    return todaysCompletedExercises.any((e) => e.exerciseId == exerciseId);
  }

  /// Today's XP earned
  int get todaysXP {
    return todaysCompletedExercises.fold(0, (sum, e) => sum + e.xpEarned);
  }

  /// Weekly completed session count
  int get weeklySessionCount {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(weekStart.year, weekStart.month, weekStart.day);
    
    final daysWithSessions = <String>{};
    for (final e in _completedExercises) {
      if (e.completedAt.isAfter(startOfWeek)) {
        daysWithSessions.add(
          '${e.completedAt.year}-${e.completedAt.month}-${e.completedAt.day}',
        );
      }
    }
    return daysWithSessions.length;
  }

  /// Pain trend (average of last 7 days vs previous 7 days)
  double get painTrend {
    if (_painEntries.length < 2) return 0;
    final now = DateTime.now();
    final last7 = _painEntries
        .where((e) => now.difference(e.date).inDays <= 7)
        .toList();
    final prev7 = _painEntries
        .where((e) =>
            now.difference(e.date).inDays > 7 &&
            now.difference(e.date).inDays <= 14)
        .toList();
    if (last7.isEmpty || prev7.isEmpty) return 0;
    final avgLast = last7.fold(0, (sum, e) => sum + e.painScore) / last7.length;
    final avgPrev = prev7.fold(0, (sum, e) => sum + e.painScore) / prev7.length;
    return avgPrev - avgLast; // positive = improvement
  }

  // ── Database Initialization ──

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      String dbPath;
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        dbPath = inMemoryDatabasePath;
      } else {
        try {
          dbPath = await getDatabasesPath();
        } catch (_) {
          dbPath = inMemoryDatabasePath;
        }
      }
      final path = dbPath == inMemoryDatabasePath
          ? inMemoryDatabasePath
          : join(dbPath, 'sciatica_app.db');

      _db = await openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE user_profile (
              id INTEGER PRIMARY KEY,
              name TEXT,
              painLocation TEXT,
              painSeverity TEXT,
              painDuration TEXT,
              mobilityLevel TEXT,
              otherConditions TEXT,
              onboardingCompleted INTEGER DEFAULT 0,
              reminderTime TEXT DEFAULT '08:00',
              notificationsEnabled INTEGER DEFAULT 1,
              darkMode INTEGER DEFAULT 1,
              isPremium INTEGER DEFAULT 0
            )
          ''');
          await db.execute('''
            CREATE TABLE gamification (
              id INTEGER PRIMARY KEY,
              totalXP INTEGER DEFAULT 0,
              currentStreak INTEGER DEFAULT 0,
              longestStreak INTEGER DEFAULT 0,
              lastCompletedDate TEXT,
              completedSessionCount INTEGER DEFAULT 0,
              earnedBadges TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE pain_entries (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT,
              painScore INTEGER,
              painLocation TEXT,
              triggers TEXT,
              notes TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE completed_exercises (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              exerciseId TEXT,
              completedAt TEXT,
              xpEarned INTEGER
            )
          ''');

          // Insert default rows
          await db.insert('user_profile', UserProfile().toMap()..['id'] = 1);
          await db.insert('gamification', GamificationData().toMap()..['id'] = 1);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute(
              'ALTER TABLE user_profile ADD COLUMN isPremium INTEGER DEFAULT 0',
            );
          }
        },
      );

      await _loadAll();
      
      // Listen to RevenueCat premium status changes and sync to state
      SubscriptionService.isPremiumNotifier.addListener(() {
        final premium = SubscriptionService.isPremiumNotifier.value;
        if (_profile.isPremium != premium) {
          setPremiumStatus(premium);
        }
      });
      
      // Perform initial check
      try {
        final rcPremium = await SubscriptionService.checkPremiumStatus();
        if (_profile.isPremium != rcPremium) {
          setPremiumStatus(rcPremium);
        }
      } catch (e) {
        debugPrint('Error syncing initial RevenueCat premium status: $e');
      }

      await loadCustomSession();
      await loadLanguage();
      
      // Initialize local notifications service and schedule reminder
      final notificationService = NotificationService();
      await notificationService.init();
      await notificationService.scheduleReminder(
        enabled: _profile.notificationsEnabled,
        timeStr: _profile.reminderTime,
        lang: _languageCode,
      );
    } catch (e, stack) {
      debugPrint('DB Error during initialize: $e');
      debugPrint(stack.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadAll() async {
    if (_db == null) return;

    // Load profile
    final profileRows = await _db!.query('user_profile', where: 'id = 1');
    if (profileRows.isNotEmpty) {
      _profile = UserProfile.fromMap(profileRows.first);
    }

    // Load gamification
    final gamRows = await _db!.query('gamification', where: 'id = 1');
    if (gamRows.isNotEmpty) {
      _gamification = GamificationData.fromMap(gamRows.first);
    }

    // Load pain entries (last 90 days)
    final cutoff = DateTime.now().subtract(const Duration(days: 90));
    final painRows = await _db!.query(
      'pain_entries',
      where: 'date > ?',
      whereArgs: [cutoff.toIso8601String()],
      orderBy: 'date DESC',
    );
    _painEntries = painRows.map((r) => PainEntry.fromMap(r)).toList();

    // Set today's pain score
    final today = DateTime.now();
    final todayEntry = _painEntries.where((e) =>
        e.date.year == today.year &&
        e.date.month == today.month &&
        e.date.day == today.day);
    if (todayEntry.isNotEmpty) {
      _todaysPainScore = todayEntry.first.painScore;
    }

    // Load completed exercises (last 90 days)
    final exRows = await _db!.query(
      'completed_exercises',
      where: 'completedAt > ?',
      whereArgs: [cutoff.toIso8601String()],
      orderBy: 'completedAt DESC',
    );
    _completedExercises = exRows.map((r) => CompletedExercise.fromMap(r)).toList();
  }

  // ── Profile Actions ──

  Future<void> saveProfile(UserProfile updatedProfile) async {
    _profile = updatedProfile;
    await _db?.update('user_profile', _profile.toMap(), where: 'id = 1');
    notifyListeners();
    
    // Reschedule daily reminder matching updated setting parameters
    NotificationService().scheduleReminder(
      enabled: _profile.notificationsEnabled,
      timeStr: _profile.reminderTime,
      lang: _languageCode,
    );
  }

  Future<void> completeOnboarding(UserProfile profile) async {
    profile.onboardingCompleted = true;
    await saveProfile(profile);
  }

  // ── Pain Tracking ──

  Future<void> logPain(PainEntry entry) async {
    await _db?.insert('pain_entries', entry.toMap());
    _painEntries.insert(0, entry);
    if (entry.date.year == DateTime.now().year &&
        entry.date.month == DateTime.now().month &&
        entry.date.day == DateTime.now().day) {
      _todaysPainScore = entry.painScore;
    }
    notifyListeners();
  }

  // ── Exercise Completion ──

  Future<void> completeExercise(Exercise exercise) async {
    final completed = CompletedExercise(
      exerciseId: exercise.id,
      completedAt: DateTime.now(),
      xpEarned: exercise.xpReward,
    );

    await _db?.insert('completed_exercises', completed.toMap());
    _completedExercises.insert(0, completed);

    // Update gamification
    _gamification.totalXP += exercise.xpReward;
    _updateStreak();
    _gamification.completedSessionCount++;
    _checkBadges();

    await _db?.update('gamification', _gamification.toMap(), where: 'id = 1');
    notifyListeners();
  }

  void _updateStreak() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (_gamification.lastCompletedDate != null) {
      final lastDate = _gamification.lastCompletedDate!;
      final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final diff = todayDate.difference(lastDateOnly).inDays;

      if (diff == 1) {
        // Consecutive day — extend streak
        _gamification.currentStreak++;
      } else if (diff > 1) {
        // Streak broken
        _gamification.currentStreak = 1;
      }
      // diff == 0: same day, don't change streak
    } else {
      _gamification.currentStreak = 1;
    }

    if (_gamification.currentStreak > _gamification.longestStreak) {
      _gamification.longestStreak = _gamification.currentStreak;
    }

    _gamification.lastCompletedDate = today;
  }

  void _checkBadges() {
    for (final badge in allBadges) {
      if (!_gamification.earnedBadges.contains(badge.id) &&
          badge.isUnlocked(_gamification)) {
        _gamification.earnedBadges = [
          ..._gamification.earnedBadges,
          badge.id,
        ];
      }
    }
  }

  // ── Flare-up Mode ──

  void toggleFlareUpMode() {
    _isFlareUpMode = !_isFlareUpMode;
    notifyListeners();
  }

  void setFlareUpMode(bool value) {
    _isFlareUpMode = value;
    notifyListeners();
  }

  // ── Theme ──

  Future<void> setDarkMode(bool value) async {
    _profile.darkMode = value;
    await _db?.update('user_profile', _profile.toMap(), where: 'id = 1');
    notifyListeners();
  }

  Future<void> setPremiumStatus(bool value) async {
    _profile.isPremium = value;
    await _db?.update('user_profile', _profile.toMap(), where: 'id = 1');
    notifyListeners();
  }
}

/// InheritedWidget to provide AppState to the widget tree
class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    return provider!.notifier!;
  }

  static AppState? maybeOf(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    return provider?.notifier;
  }
}
