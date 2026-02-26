import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/pages/home.dart';
import 'package:todo_app/pages/new_todo.dart';
import 'package:todo_app/pages/todos.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_app/services/localeprovider.dart';
import 'package:todo_app/services/themeprovider.dart';
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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MyApp(),
    ),
  );
}

Future<void> ensureNotifPermission() async {
  final allowed = await AwesomeNotifications().isNotificationAllowed();
  if (!allowed) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: localeProvider.locale,
      supportedLocales: const [Locale('en', 'US'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 1;
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
    // if (mounted) {
    //   final locale = Localizations.localeOf(context);
    //   debugPrint('LOCALE: $locale');
    // }
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
        child: Container(
          margin: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppThemes.getSecondaryBg(context).withAlpha(100),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // Shrinks the Row to fit its children
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // Centers the buttons
            children: [
              navButtons(() => onNavTap(0), 0, Icons.add),
              navButtons(() => onNavTap(1), 1, Icons.home),
              navButtons(() => onNavTap(2), 2, Icons.list),
            ],
          ),
        ),
      ),
    );
  }

  Widget navButtons(VoidCallback onPressed, int index, IconData icon) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: FittedBox(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: currentIndex == index
                ? AppThemes.getPrimaryColor(context).withAlpha(50)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: currentIndex != index
                    ? const Color.fromARGB(255, 105, 104, 104)
                    : AppThemes.getPrimaryColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
