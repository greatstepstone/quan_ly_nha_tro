// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {
    // Web initialization if needed
  }

  Future<void> requestPermissions() async {
    if (html.Notification.permission != 'granted') {
      await html.Notification.requestPermission();
    }
  }

  Future<void> scheduleInvoiceReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // Note: True background scheduling on Web requires Service Workers.
    // This is a simplified version that just shows it if it's due now.
    if (scheduledDate.isBefore(DateTime.now())) {
      await showLocalNotification(id: id, title: title, body: body);
    }
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await requestPermissions();
    if (html.Notification.permission == 'granted') {
      html.Notification(title, body: body);
    }
  }

  Future<void> cancelNotification(int id) async {
    // Web notifications usually dismiss themselves or can't be easily cancelled by ID without keeping track of the Notification object.
  }

  Future<void> cancelAllNotifications() async {
    // Not easily supported on Web without Service Workers
  }
}
