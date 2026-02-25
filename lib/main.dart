import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_app/custom_widgets/navigator_item.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/pages/new_todo.dart';
import 'package:todo_app/pages/todos.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_app/themes.dart';

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
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
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

int currentIndex = 1;

class _MainScreenState extends State<MainScreen> {
  void onNavTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> pages = [
    NewTodo(key: const ValueKey(0)),
    Home(key: const ValueKey(0)),
    TodoView(key: const ValueKey(0)),
  ];
  String? selectedValue = 'accending';

  @override
  void initState() {
    request();

    super.initState();
  }

  void request() async {
    await ensureNotifPermission();
    if (mounted) {
      final locale = Localizations.localeOf(context);
      debugPrint('LOCALE: $locale');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: pages[currentIndex],
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min, // Shrinks the Row to fit its children
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Centers the buttons
          children: [
            ButtonWidget(
              text: 'Home',
              icon: Icons.add,
              onPressed: () => onNavTap(0),
              index: 0,
              currentIndex: currentIndex,
            ),

            ButtonWidget(
              text: 'Home',
              icon: Icons.home,
              onPressed: () => onNavTap(1),
              index: 1,
              currentIndex: currentIndex,
            ),

            ButtonWidget(
              text: 'Home',
              icon: Icons.list,
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
