import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:todo_app/models/todo_model.dart';

Future<void> scheduleNotification(ToDoModel todo) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 1,
      channelKey: 'reminders',
      title: todo.title,
      body: 'You have a task scheduled: ${todo.description}',
      notificationLayout: NotificationLayout.Default,
      wakeUpScreen: true,
    ),
    schedule: NotificationCalendar(
      year: todo.repeatDate.year,
      month: todo.repeatDate.month,
      day: todo.repeatDate.day,
      hour: todo.repeatDate.hour,
      minute: todo.repeatDate.minute,
      second: todo.repeatDate.second,
      millisecond: 0,
      repeats: false,
      preciseAlarm: true, // important for exact delivery
      allowWhileIdle: true,
    ),
  );

  await AwesomeNotifications().listScheduledNotifications();
}
