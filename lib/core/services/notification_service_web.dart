class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {}
  Future<void> requestPermissions() async {}
  Future<void> scheduleInvoiceReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {}
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
  }) async {}
  Future<void> cancelNotification(int id) async {}
  Future<void> cancelAllNotifications() async {}
}
