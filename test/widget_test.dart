import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sciatica_app/main.dart';
import 'package:sciatica_app/screens/onboarding_screen.dart';

void main() {
  testWidgets('App renders onboarding welcome screen', (WidgetTester tester) async {
    const MethodChannel channel = MethodChannel('plugins.flutter.io/sqflite');
    
    // Set up mock method call handler for sqflite plugin
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getDatabasesPath') {
        return '/dummy/path';
      }
      if (methodCall.method == 'openDatabase') {
        return {'id': 1};
      }
      if (methodCall.method == 'query') {
        final arguments = methodCall.arguments as Map;
        final sql = arguments['sql'] as String;
        if (sql.contains('user_profile')) {
          return [
            {
              'id': 1,
              'name': 'Test User',
              'painLocation': 'left_leg',
              'painSeverity': 'mild',
              'painDuration': 'weeks',
              'mobilityLevel': 'floor',
              'otherConditions': '[]',
              'onboardingCompleted': 0,
              'reminderTime': '08:00',
              'notificationsEnabled': 1,
              'darkMode': 1,
            }
          ];
        }
        if (sql.contains('gamification')) {
          return [
            {
              'id': 1,
              'totalXP': 0,
              'currentStreak': 0,
              'longestStreak': 0,
              'lastCompletedDate': null,
              'completedSessionCount': 0,
              'earnedBadges': '[]',
            }
          ];
        }
        return [];
      }
      if (methodCall.method == 'insert' || methodCall.method == 'update' || methodCall.method == 'execute') {
        return 1;
      }
      return null;
    });

    await tester.pumpWidget(const SciaticaApp());
    
    // Pump frames to allow db future to complete
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.textContaining('Sciatica Relief'), findsWidgets);
  });
}