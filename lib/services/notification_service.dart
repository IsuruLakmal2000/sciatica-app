import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Initialize timezone database
    tz.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      final String timeZoneName = tzInfo.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('Error setting local timezone location: $e. Falling back to UTC.');
    }

    // Android Settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Settings
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle clicking on notification if needed
      },
    );

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    // Request Android 13+ permission
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

    // Request iOS permissions
    final iosImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      final bool? granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return true;
  }

  Future<void> scheduleReminder({
    required bool enabled,
    required String timeStr,
    required String lang,
  }) async {
    // Always cancel existing reminder first
    await cancelAllReminders();

    if (!enabled) {
      debugPrint('Reminders are disabled. Not scheduling.');
      return;
    }

    // Parse the time string
    final time = _parseReminderTime(timeStr);
    
    // Request permissions (non-blocking, but recommended)
    await requestPermissions();

    final localizedTitle = _getReminderTitle(lang);
    final localizedBody = _getReminderBody(lang);

    final androidDetails = const AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminders',
      channelDescription: 'Daily exercise and stretching reminders for sciatica relief',
      importance: Importance.high,
      priority: Priority.high,
    );

    final iosDetails = const DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final scheduledDate = _nextInstanceOfTime(time.hour, time.minute);

    try {
      await _notificationsPlugin.zonedSchedule(
        id: 888, // Constant ID for the daily reminder
        title: localizedTitle,
        body: localizedBody,
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // Repeating daily
      );
      debugPrint('Daily reminder scheduled successfully for $timeStr (parsed as ${time.hour}:${time.minute}) at $scheduledDate.');
    } catch (e) {
      debugPrint('Failed to schedule zoned daily reminder: $e');
      // If Android exact scheduling fails (due to SCHEDULE_EXACT_ALARM on some Android 12+), fallback to inexact
      try {
        await _notificationsPlugin.zonedSchedule(
          id: 888,
          title: localizedTitle,
          body: localizedBody,
          scheduledDate: scheduledDate,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        debugPrint('Fallback inexact daily reminder scheduled.');
      } catch (fallbackError) {
        debugPrint('Fallback scheduling also failed: $fallbackError');
      }
    }
  }

  Future<void> cancelAllReminders() async {
    await _notificationsPlugin.cancel(id: 888);
    debugPrint('Canceled daily reminder.');
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  TimeOfDay _parseReminderTime(String timeStr) {
    try {
      timeStr = timeStr.trim().toLowerCase();
      final isPm = timeStr.contains('pm');
      final isAm = timeStr.contains('am');
      final digitsOnly = timeStr.replaceAll(RegExp(r'[^0-9:]'), '');
      final parts = digitsOnly.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);
        if (isPm && hour < 12) {
          hour += 12;
        } else if (isAm && hour == 12) {
          hour = 0;
        }
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      debugPrint('Error parsing reminder time: $timeStr - $e');
    }
    return const TimeOfDay(hour: 8, minute: 0);
  }

  String _getReminderTitle(String lang) {
    switch (lang) {
      case 'es':
        return 'Recordatorio de Alivio de la Ciática';
      case 'fr':
        return 'Rappel de Soulagement de la Sciatique';
      case 'de':
        return 'Ischias-Entlastung Erinnerung';
      case 'it':
        return 'Promemoria Sollievo Sciatica';
      default:
        return 'Sciatica Relief Reminder';
    }
  }

  String _getReminderBody(String lang) {
    switch (lang) {
      case 'es':
        return '¡Es hora de tus estiramientos diarios para aliviar el dolor y mejorar la movilidad!';
      case 'fr':
        return 'C\'est l\'heure de vos étirements quotidiens pour soulager la douleur et améliorer la mobilité !';
      case 'de':
        return 'Zeit für Ihre täglichen Dehnübungen zur Schmerzlinderung und Mobilitätsverbesserung!';
      case 'it':
        return 'È il momento dei tuoi allungamenti giornalieri per alleviare il dolore e migliorare la mobilità!';
      default:
        return 'Time for your daily stretches to relieve pain and improve mobility!';
    }
  }
}
