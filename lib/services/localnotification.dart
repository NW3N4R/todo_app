import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> scheduleNotification(
  int id,
  String title,
  String msg,
  DateTime dt,
) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'reminders',
      title: title,
      body: 'You have a task scheduled: $msg',
      notificationLayout: NotificationLayout.Default,
      wakeUpScreen: true,
    ),
    schedule: NotificationCalendar(
      year: dt.year,
      month: dt.month,
      day: dt.day,
      hour: dt.hour,
      minute: dt.minute,
      second: dt.second,
      millisecond: 0,
      repeats: false,
      preciseAlarm: true,
      allowWhileIdle: true,
    ),
  );

  await AwesomeNotifications().listScheduledNotifications();
}
