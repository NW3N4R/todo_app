import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/services/localeprovider.dart';
import 'package:todo_app/services/themeprovider.dart';
import 'package:todo_app/themes.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  String _appVersion = "";
  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = info.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    String? selectedValue =
        localeProvider.locale.languageCode; // Dropdown options
    final t = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final List<String> devs = t.localeName == 'en'
        ? [
            '\u2022 Mohammed Siamen Mehmud',
            '\u2022 Mohammad Mejid Rashid',
            '\u2022 Yousif Shehab Ahmed',
          ]
        : [
            '\u2022 محمد سیامەن محمود',
            '\u2022 محمد مجید ڕەشید',
            '\u2022 یوسف شەهاب احمد',
          ];
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(t.settings, style: Theme.of(context).textTheme.bodyLarge),
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        // Smooth curve for animation
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppThemes.isDarkMode(context)
                ? const [
                    Color.fromARGB(255, 30, 1, 56),
                    Color.fromARGB(255, 14, 0, 25),
                  ]
                : [
                    AppThemes.getPrimaryBg(context),
                    Color.fromARGB(255, 149, 209, 255),
                  ], // can also mix with secondaryColors
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppThemes.getSecondaryBg(context).withAlpha(120),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppThemes.getPrimaryBg(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SwitchListTile(
                      title: Text(t.darkMode),
                      subtitle: Text(
                        AppThemes.isDarkMode(context) ? t.dark : t.light,
                      ),
                      value: AppThemes.isDarkMode(context),
                      onChanged: (value) {
                        setState(() {
                          themeProvider.toggleTheme(
                            value,
                          ); // 🔥 triggers AnimatedContainer
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: AppThemes.getPrimaryBg(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.language,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              t.helloWorld,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Spacer(),
                        DropdownButton<String>(
                          style: Theme.of(context).textTheme.bodyLarge,
                          underline: Container(),
                          icon: const SizedBox.shrink(),
                          value: selectedValue, // currently selected
                          items: const [
                            DropdownMenuItem(value: 'ar', child: Text('کوردی')),
                            DropdownMenuItem(
                              value: 'en',
                              child: Text('English'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            if (newValue == 'en') {
                              localeProvider.setEnglish();
                            } else {
                              localeProvider.setKurdish();
                            }
                            setState(() {
                              selectedValue = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: AppThemes.getPrimaryBg(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '${t.about}\n${t.aboutParagraph}',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    width: double.infinity,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: AppThemes.getPrimaryBg(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.supervisor,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(t.supervisorName),
                        SizedBox(height: 12),
                        Text(
                          t.writtenBy,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(devs.join('\n')),
                      ],
                    ),
                  ),
SizedBox(height: 24,),
                  Center(child: Text('Todo App $_appVersion')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
