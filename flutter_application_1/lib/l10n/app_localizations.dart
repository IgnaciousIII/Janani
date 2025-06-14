import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ka.dart';

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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ka')
  ];

  /// No description provided for @key1.
  ///
  /// In en, this message translates to:
  /// **'Janani'**
  String get key1;

  /// No description provided for @key2.
  ///
  /// In en, this message translates to:
  /// **'Hello Sumathi'**
  String get key2;

  /// No description provided for @key3.
  ///
  /// In en, this message translates to:
  /// **'Card Number- 2005678'**
  String get key3;

  /// No description provided for @key4.
  ///
  /// In en, this message translates to:
  /// **'Next PHC visit 16th October 2023'**
  String get key4;

  /// No description provided for @key5.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get key5;

  /// No description provided for @key6.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get key6;

  /// No description provided for @key7.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get key7;

  /// No description provided for @key8.
  ///
  /// In en, this message translates to:
  /// **'Complaints'**
  String get key8;

  /// No description provided for @key9.
  ///
  /// In en, this message translates to:
  /// **'Important Contact Number'**
  String get key9;

  /// No description provided for @key10.
  ///
  /// In en, this message translates to:
  /// **'Asha Worker'**
  String get key10;

  /// No description provided for @key11.
  ///
  /// In en, this message translates to:
  /// **'Duty Doctor'**
  String get key11;

  /// No description provided for @key12.
  ///
  /// In en, this message translates to:
  /// **'PHC'**
  String get key12;

  /// No description provided for @key13.
  ///
  /// In en, this message translates to:
  /// **'PHC Doctor Number'**
  String get key13;

  /// No description provided for @key14.
  ///
  /// In en, this message translates to:
  /// **'Personal Gynaec Number'**
  String get key14;

  /// No description provided for @key15.
  ///
  /// In en, this message translates to:
  /// **'In case of Emergency'**
  String get key15;

  /// No description provided for @key16.
  ///
  /// In en, this message translates to:
  /// **'Enter 1234'**
  String get key16;

  /// No description provided for @key17.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get key17;

  /// No description provided for @key18.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get key18;

  /// No description provided for @key19.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get key19;

  /// No description provided for @key20.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get key20;

  /// No description provided for @key21.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get key21;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ka'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ka':
      return AppLocalizationsKa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
