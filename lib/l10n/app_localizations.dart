import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @dashBoard.
  ///
  /// In en, this message translates to:
  /// **'DashBoard'**
  String get dashBoard;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello world'**
  String get helloWorld;

  /// No description provided for @remainingTasks.
  ///
  /// In en, this message translates to:
  /// **'Remaining Todos'**
  String get remainingTasks;

  /// No description provided for @remainingTasksCount.
  ///
  /// In en, this message translates to:
  /// **'Tasks Remain out of'**
  String get remainingTasksCount;

  /// No description provided for @completedTasks.
  ///
  /// In en, this message translates to:
  /// **'Completed Tasks'**
  String get completedTasks;

  /// No description provided for @activeTasks.
  ///
  /// In en, this message translates to:
  /// **'Active Tasks'**
  String get activeTasks;

  /// No description provided for @overDueTasks.
  ///
  /// In en, this message translates to:
  /// **'Over Dues'**
  String get overDueTasks;

  /// No description provided for @thisWeeksTodos.
  ///
  /// In en, this message translates to:
  /// **'Tasks of The Week'**
  String get thisWeeksTodos;

  /// No description provided for @myTodos.
  ///
  /// In en, this message translates to:
  /// **'My Todos'**
  String get myTodos;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @overDue.
  ///
  /// In en, this message translates to:
  /// **'Over Due'**
  String get overDue;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @nameOfTodo.
  ///
  /// In en, this message translates to:
  /// **'Todo Name'**
  String get nameOfTodo;

  /// No description provided for @descOfTodo.
  ///
  /// In en, this message translates to:
  /// **'Todo Description'**
  String get descOfTodo;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @dateOfNotification.
  ///
  /// In en, this message translates to:
  /// **'Date of Notifying'**
  String get dateOfNotification;

  /// No description provided for @timeofNotification.
  ///
  /// In en, this message translates to:
  /// **'Time of Notifying'**
  String get timeofNotification;

  /// No description provided for @daysOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Days of The Week'**
  String get daysOfWeek;

  /// No description provided for @todoNameReq.
  ///
  /// In en, this message translates to:
  /// **'Todo Name is Required'**
  String get todoNameReq;

  /// No description provided for @todoDescReq.
  ///
  /// In en, this message translates to:
  /// **'Description is Required'**
  String get todoDescReq;

  /// No description provided for @dateOrWeekDay.
  ///
  /// In en, this message translates to:
  /// **'Either a date or day of the todo is required'**
  String get dateOrWeekDay;

  /// No description provided for @timeOfTodoRequired.
  ///
  /// In en, this message translates to:
  /// **'Time of the Todo is Required'**
  String get timeOfTodoRequired;

  /// No description provided for @newTodo.
  ///
  /// In en, this message translates to:
  /// **'New Todo'**
  String get newTodo;

  /// No description provided for @updateTodo.
  ///
  /// In en, this message translates to:
  /// **'Update Todo'**
  String get updateTodo;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @actionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Action Success'**
  String get actionSuccess;

  /// No description provided for @errorHappened.
  ///
  /// In en, this message translates to:
  /// **'an Error Occured'**
  String get errorHappened;

  /// No description provided for @todoSaved.
  ///
  /// In en, this message translates to:
  /// **'Todo Saved!'**
  String get todoSaved;

  /// No description provided for @todoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Todo Updated'**
  String get todoUpdated;

  /// No description provided for @todoDeleted.
  ///
  /// In en, this message translates to:
  /// **'Todo Deleted'**
  String get todoDeleted;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No Data Found'**
  String get noDataFound;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
