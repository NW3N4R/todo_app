import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_app/custom_widgets/navigator_item.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/pages/new_todo.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  tz.initializeTimeZones();
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
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
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'DroidArabicKufi', // 👈 default font
      ),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    ),
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
    Home(key: ValueKey('overDue')),
    Home(key: ValueKey('active')),
    Home(key: ValueKey('completed')),
  ];
  String? selectedValue = 'accending';

  @override
  void initState() {
    request();

    super.initState();
  }

  void request() async {
    await ensureNotifPermission();
    final locale = Localizations.localeOf(context);
    debugPrint('LOCALE: $locale');
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
              icon: Icons.close,
              onPressed: () => onNavTap(0),
              index: 0,
              currentIndex: currentIndex,
            ),
            ButtonWidget(
              text: 'Home',
              icon: Icons.timer_sharp,
              onPressed: () => onNavTap(1),
              index: 1,
              currentIndex: currentIndex,
            ),
            ButtonWidget(
              text: 'Completed',
              icon: Icons.done,
              onPressed: () => onNavTap(2),
              index: 2,
              currentIndex: currentIndex,
            ),
            // ButtonWidget(
            //   text: 'Profile',
            //   icon: Icons.add_circle_outline_outlined,
            //   onPressed: () => onNavTap(3),
            //   index: 3,
            //   currentIndex: currentIndex,
            // ),
          ],
        ),
      ),
    );
  }
}
