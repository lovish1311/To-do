import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for MethodChannel
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // Singleton pattern
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static const MethodChannel _platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

  /// Call this early in main()
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Timezone initialization
    tzdata.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));

    // 2. Notification init settings
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // 3. Request Android 13+ notification permission
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // 4. Request exact alarm (Android 12+)
    await _checkAndRequestExactAlarmPermission();
  }

  void _onNotificationResponse(NotificationResponse response) {
    debugPrint('Notification tapped: id=${response.id}');
  }

  /// Show an immediate notification
  Future<void> showInstant({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'instant_channel',
      'Instant Notifications',
      channelDescription: 'Channel for immediate alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(id, title, body, details);
  }

  /// Schedule a one‑off notification after [delay]
  Future<void> scheduleOnce({
    required int id,
    required String title,
    required String body,
    required Duration delay,
  }) async {
    final scheduled = tz.TZDateTime.now(tz.local).add(delay);

    const androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Channel for one-off scheduled alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Request exact alarm permission if not already granted (Android 12+)
  Future<void> _checkAndRequestExactAlarmPermission() async {
    if (Platform.isAndroid && (await _androidSdkInt()) >= 31) {
      try {
        final bool granted = await _platform.invokeMethod('areExactAlarmsAllowed');

        if (!granted) {
          await _platform.invokeMethod('requestExactAlarmPermission');
        }
      } on PlatformException catch (e) {
        debugPrint("Exact alarm permission error: ${e.message}");
      }
    }
  }

  /// Get Android SDK version
  Future<int> _androidSdkInt() async {
    final String sdkString = await _platform.invokeMethod('getAndroidSdkInt');
    return int.tryParse(sdkString) ?? 0;
  }

  /// Schedule a daily notification
  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Daily Notifications',
      channelDescription: 'Channel for daily scheduled alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedule a weekly notification
  Future<void> scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required int weekday,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    int daysToAdd = (weekday - now.weekday) % 7;
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + daysToAdd,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    const androidDetails = AndroidNotificationDetails(
      'weekly_channel',
      'Weekly Notifications',
      channelDescription: 'Channel for weekly scheduled alerts',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id);
  Future<void> cancelAll() => _plugin.cancelAll();
}
