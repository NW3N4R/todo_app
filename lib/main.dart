import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_app/custom_widgets/navigator_item.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/pages/new_todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await AwesomeNotifications().initialize(
    null, // app icon
    [
      NotificationChannel(
        channelKey: 'reminders',
        channelName: 'Reminders',
        channelDescription: 'Reminder notifications',
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      ),
    ],
    debug: true,
  );
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: const MainScreen()),
  );
}

Future<void> ensureNotifPermission() async {
  final allowed = await AwesomeNotifications().isNotificationAllowed();
  if (!allowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int currentIndex = 0;

class _MainScreenState extends State<MainScreen> {
  void onNavTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> pages = [
    Home(key: ValueKey('active')),
    Home(key: ValueKey('completed')),
    const NewTodo(),
  ];
  String? selectedValue = 'accending';

  @override
  void initState() {
    ensureNotifPermission();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[currentIndex],
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min, // Shrinks the Row to fit its children
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Centers the buttons
          children: [
            ButtonWidget(
              text: 'Home',
              icon: Icons.home,
              onPressed: () => onNavTap(0),
              index: 0,
              currentIndex: currentIndex,
            ),
            ButtonWidget(
              text: 'Completed',
              icon: Icons.done,
              onPressed: () => onNavTap(1),
              index: 1,
              currentIndex: currentIndex,
            ),
            ButtonWidget(
              text: 'Profile',
              icon: Icons.add,
              onPressed: () => onNavTap(2),
              index: 2,
              currentIndex: currentIndex,
            ),
          ],
        ),
      ),
    );
  }
}
