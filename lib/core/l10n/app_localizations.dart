import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('es'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get navRisk;

  /// No description provided for @navCollection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get navCollection;

  /// No description provided for @navMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get navMembers;

  /// No description provided for @placeholderComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get placeholderComingSoon;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get homeGreetingAnonymous;

  /// No description provided for @accountLanguageNotice.
  ///
  /// In en, this message translates to:
  /// **'Language: English'**
  String get accountLanguageNotice;

  /// No description provided for @accountGroupSecurity.
  ///
  /// In en, this message translates to:
  /// **'SECURITY'**
  String get accountGroupSecurity;

  /// No description provided for @accountChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get accountChangePassword;

  /// No description provided for @accountGroupPreferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get accountGroupPreferences;

  /// No description provided for @accountLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accountLanguage;

  /// No description provided for @accountLanguageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get accountLanguageSpanish;

  /// No description provided for @accountLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get accountLanguageEnglish;

  /// No description provided for @accountNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get accountNotifications;

  /// No description provided for @accountNotificationsOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get accountNotificationsOn;

  /// No description provided for @accountNotificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get accountNotificationsOff;

  /// No description provided for @accountVersion.
  ///
  /// In en, this message translates to:
  /// **'Viora {version} · Android · iOS'**
  String accountVersion(String version);

  /// No description provided for @accountDetailsSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get accountDetailsSaved;

  /// No description provided for @accountPasswordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get accountPasswordChanged;

  /// No description provided for @accountDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get accountDetailsTitle;

  /// No description provided for @accountDetailsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your\n*details.*'**
  String get accountDetailsHeadline;

  /// No description provided for @accountFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get accountFullName;

  /// No description provided for @accountFullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get accountFullNamePlaceholder;

  /// No description provided for @accountFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Your name is required.'**
  String get accountFullNameRequired;

  /// No description provided for @accountPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile · {country} {dialCode}'**
  String accountPhoneLabel(String country, String dialCode);

  /// No description provided for @accountPhoneHelper.
  ///
  /// In en, this message translates to:
  /// **'International format: {example}'**
  String accountPhoneHelper(String example);

  /// No description provided for @accountEmailHelper.
  ///
  /// In en, this message translates to:
  /// **'Verified · used to sign in to Viora'**
  String get accountEmailHelper;

  /// No description provided for @accountSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get accountSaveChanges;

  /// No description provided for @accountSaveOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection: your changes weren\'t saved. Try again.'**
  String get accountSaveOffline;

  /// No description provided for @accountSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t save your changes. Try again.'**
  String get accountSaveFailed;

  /// No description provided for @accountSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get accountSecurityTitle;

  /// No description provided for @accountPasswordHeadline.
  ///
  /// In en, this message translates to:
  /// **'New\n*password.*'**
  String get accountPasswordHeadline;

  /// No description provided for @accountCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get accountCurrentPassword;

  /// No description provided for @accountCurrentPasswordWrong.
  ///
  /// In en, this message translates to:
  /// **'The current password isn\'t correct.'**
  String get accountCurrentPasswordWrong;

  /// No description provided for @accountConfirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get accountConfirmNewPassword;

  /// No description provided for @accountPasswordRules.
  ///
  /// In en, this message translates to:
  /// **'It doesn\'t meet the requirements below.'**
  String get accountPasswordRules;

  /// No description provided for @accountPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'The passwords don\'t match.'**
  String get accountPasswordMismatch;

  /// No description provided for @accountRuleLength.
  ///
  /// In en, this message translates to:
  /// **'8 characters or more'**
  String get accountRuleLength;

  /// No description provided for @accountRuleDifferent.
  ///
  /// In en, this message translates to:
  /// **'Different from the current one'**
  String get accountRuleDifferent;

  /// No description provided for @languageSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'App\n*language*'**
  String get languageSheetTitle;

  /// No description provided for @languageSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Changes right away, without signing out'**
  String get languageSheetSubtitle;

  /// No description provided for @languageSheetNote.
  ///
  /// In en, this message translates to:
  /// **'Thousands separators and the date format change too. It stays saved on this phone.'**
  String get languageSheetNote;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'My account'**
  String get accountTitle;

  /// No description provided for @accountRole.
  ///
  /// In en, this message translates to:
  /// **'Technical manager'**
  String get accountRole;

  /// No description provided for @accountHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your\n*account.*'**
  String get accountHeadline;

  /// No description provided for @accountGroupPersonal.
  ///
  /// In en, this message translates to:
  /// **'PERSONAL DETAILS'**
  String get accountGroupPersonal;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get accountName;

  /// No description provided for @accountMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get accountMobile;

  /// No description provided for @accountEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get accountEmail;

  /// No description provided for @accountVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get accountVerified;

  /// No description provided for @accountGroupSession.
  ///
  /// In en, this message translates to:
  /// **'SESSION'**
  String get accountGroupSession;

  /// No description provided for @accountSignOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get accountSignOut;

  /// No description provided for @homeAlerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get homeAlerts;

  /// No description provided for @homeHeadlineLead.
  ///
  /// In en, this message translates to:
  /// **'Your valley,'**
  String get homeHeadlineLead;

  /// No description provided for @homeHeadlineEmphasis.
  ///
  /// In en, this message translates to:
  /// **'today.'**
  String get homeHeadlineEmphasis;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @welcomeIntroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO VIORA'**
  String get welcomeIntroEyebrow;

  /// No description provided for @welcomeIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your valley has\nits own *rhythm.*'**
  String get welcomeIntroTitle;

  /// No description provided for @welcomeIntroDescription.
  ///
  /// In en, this message translates to:
  /// **'Viora helps you read the alternate bearing of your valley and prioritize each visit in time.'**
  String get welcomeIntroDescription;

  /// No description provided for @welcomeStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get welcomeStart;

  /// No description provided for @welcomeHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get welcomeHaveAccount;

  /// No description provided for @welcomePlateEyebrow.
  ///
  /// In en, this message translates to:
  /// **'FOR TECHNICAL MANAGERS'**
  String get welcomePlateEyebrow;

  /// No description provided for @welcomePlateTitle.
  ///
  /// In en, this message translates to:
  /// **'The whole valley,\nin a *single read.*'**
  String get welcomePlateTitle;

  /// No description provided for @welcomePlateDescription.
  ///
  /// In en, this message translates to:
  /// **'Follow each producer\'s alternate bearing and prioritize visits where they matter most.'**
  String get welcomePlateDescription;

  /// No description provided for @welcomeSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get welcomeSkip;

  /// No description provided for @onboardingStepCounter.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total}'**
  String onboardingStepCounter(String current, String total);

  /// No description provided for @onboardingNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What is\nyour *name?*'**
  String get onboardingNameTitle;

  /// No description provided for @onboardingNameVoice.
  ///
  /// In en, this message translates to:
  /// **'I will greet you by it every season.'**
  String get onboardingNameVoice;

  /// No description provided for @onboardingNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First and last name'**
  String get onboardingNameLabel;

  /// No description provided for @onboardingPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Which number\nshould I *text?*'**
  String get onboardingPhoneTitle;

  /// No description provided for @onboardingPhoneVoice.
  ///
  /// In en, this message translates to:
  /// **'I will reach you here when your grove needs it.'**
  String get onboardingPhoneVoice;

  /// No description provided for @onboardingCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get onboardingCountryLabel;

  /// No description provided for @onboardingPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get onboardingPhoneLabel;

  /// No description provided for @onboardingPhoneSupporting.
  ///
  /// In en, this message translates to:
  /// **'Only for alerts and technical coordination.'**
  String get onboardingPhoneSupporting;

  /// No description provided for @onboardingPhoneInvalidNine.
  ///
  /// In en, this message translates to:
  /// **'Enter 9 digits starting with 9.'**
  String get onboardingPhoneInvalidNine;

  /// No description provided for @onboardingPhoneInvalidSixOrSeven.
  ///
  /// In en, this message translates to:
  /// **'Enter 9 digits starting with 6 or 7.'**
  String get onboardingPhoneInvalidSixOrSeven;

  /// No description provided for @countryPeru.
  ///
  /// In en, this message translates to:
  /// **'Peru'**
  String get countryPeru;

  /// No description provided for @countrySpain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countrySpain;

  /// No description provided for @countryChile.
  ///
  /// In en, this message translates to:
  /// **'Chile'**
  String get countryChile;

  /// No description provided for @onboardingAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'I only tell you\nwhat *matters.*'**
  String get onboardingAlertsTitle;

  /// No description provided for @onboardingAlertsVoice.
  ///
  /// In en, this message translates to:
  /// **'You can turn them off any time from your account.'**
  String get onboardingAlertsVoice;

  /// No description provided for @onboardingAlertBackMeta.
  ///
  /// In en, this message translates to:
  /// **'VALLEY TRAFFIC LIGHT · YESTERDAY'**
  String get onboardingAlertBackMeta;

  /// No description provided for @onboardingAlertBackBody.
  ///
  /// In en, this message translates to:
  /// **'9 plots in La Yarada Baja became critical.'**
  String get onboardingAlertBackBody;

  /// No description provided for @onboardingAlertFrontMeta.
  ///
  /// In en, this message translates to:
  /// **'OLIVAR DEL SUR · NOW'**
  String get onboardingAlertFrontMeta;

  /// No description provided for @onboardingAlertFrontBody.
  ///
  /// In en, this message translates to:
  /// **'4 members haven\'t recorded their sampling yet.'**
  String get onboardingAlertFrontBody;

  /// No description provided for @onboardingAlertsItemLoad.
  ///
  /// In en, this message translates to:
  /// **'Plots that reach a critical load'**
  String get onboardingAlertsItemLoad;

  /// No description provided for @onboardingAlertsItemClimate.
  ///
  /// In en, this message translates to:
  /// **'Climate risk by sector and El Niño'**
  String get onboardingAlertsItemClimate;

  /// No description provided for @onboardingAlertsItemMembers.
  ///
  /// In en, this message translates to:
  /// **'Members with pending sampling or thinning'**
  String get onboardingAlertsItemMembers;

  /// No description provided for @onboardingAlertsEnable.
  ///
  /// In en, this message translates to:
  /// **'Turn on alerts'**
  String get onboardingAlertsEnable;

  /// No description provided for @onboardingNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get onboardingNotNow;

  /// No description provided for @onboardingSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'All set,\n*{name}.*'**
  String onboardingSummaryTitle(String name);

  /// No description provided for @onboardingSummaryVoice.
  ///
  /// In en, this message translates to:
  /// **'Check what you chose before creating your account.'**
  String get onboardingSummaryVoice;

  /// No description provided for @onboardingSummaryName.
  ///
  /// In en, this message translates to:
  /// **'NAME'**
  String get onboardingSummaryName;

  /// No description provided for @onboardingSummaryPhone.
  ///
  /// In en, this message translates to:
  /// **'MOBILE'**
  String get onboardingSummaryPhone;

  /// No description provided for @onboardingSummaryAlerts.
  ///
  /// In en, this message translates to:
  /// **'ALERTS'**
  String get onboardingSummaryAlerts;

  /// No description provided for @onboardingEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get onboardingEdit;

  /// No description provided for @onboardingAlertsOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get onboardingAlertsOn;

  /// No description provided for @onboardingAlertsOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get onboardingAlertsOff;

  /// No description provided for @onboardingCreate.
  ///
  /// In en, this message translates to:
  /// **'Create my account'**
  String get onboardingCreate;

  /// No description provided for @onboardingLegalNotice.
  ///
  /// In en, this message translates to:
  /// **'By continuing you accept the Terms and conditions and the Privacy policy (Law No. 29733).'**
  String get onboardingLegalNotice;

  /// No description provided for @iamSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get iamSignIn;

  /// No description provided for @iamNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet?'**
  String get iamNoAccount;

  /// No description provided for @iamLetsStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start'**
  String get iamLetsStart;

  /// No description provided for @iamSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome\n*back.*'**
  String get iamSignInTitle;

  /// No description provided for @iamSignInVoice.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your email and password.'**
  String get iamSignInVoice;

  /// No description provided for @iamEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get iamEmail;

  /// No description provided for @iamPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get iamPassword;

  /// No description provided for @iamShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get iamShow;

  /// No description provided for @iamHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get iamHide;

  /// No description provided for @iamForgotLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get iamForgotLink;

  /// No description provided for @iamInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get iamInvalidCredentials;

  /// No description provided for @iamOtherRoleAccount.
  ///
  /// In en, this message translates to:
  /// **'This account isn\'t a technical manager\'s. Sign in from the Viora app for producers.'**
  String get iamOtherRoleAccount;

  /// No description provided for @iamCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get iamCreateAccount;

  /// No description provided for @iamCreateNote.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you a code to verify your email.'**
  String get iamCreateNote;

  /// No description provided for @iamCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your\n*account.*'**
  String get iamCreateTitle;

  /// No description provided for @iamCreateVoice.
  ///
  /// In en, this message translates to:
  /// **'I\'m keeping what you chose, {name}.'**
  String iamCreateVoice(String name);

  /// No description provided for @iamCreateVoiceAnonymous.
  ///
  /// In en, this message translates to:
  /// **'I\'m keeping what you chose.'**
  String get iamCreateVoiceAnonymous;

  /// No description provided for @iamEmailOtherRole.
  ///
  /// In en, this message translates to:
  /// **'This email is already signing up in the producer app. Use another email.'**
  String get iamEmailOtherRole;

  /// No description provided for @iamEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'This email already has an account. Sign in or use another email.'**
  String get iamEmailTaken;

  /// No description provided for @iamPasswordWeak.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters, with letters and numbers.'**
  String get iamPasswordWeak;

  /// No description provided for @iamRuleLength.
  ///
  /// In en, this message translates to:
  /// **'8 characters'**
  String get iamRuleLength;

  /// No description provided for @iamRuleLettersNumbers.
  ///
  /// In en, this message translates to:
  /// **'Letters and numbers'**
  String get iamRuleLettersNumbers;

  /// No description provided for @iamRuleMatch.
  ///
  /// In en, this message translates to:
  /// **'They match'**
  String get iamRuleMatch;

  /// No description provided for @iamVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your\n*email.*'**
  String get iamVerifyTitle;

  /// No description provided for @iamVerifyVoice.
  ///
  /// In en, this message translates to:
  /// **'I sent a 6-digit code to {email}'**
  String iamVerifyVoice(String email);

  /// No description provided for @iamCodeWrong.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code.'**
  String get iamCodeWrong;

  /// No description provided for @iamCodeWrongAttempts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Incorrect code. You have 1 attempt left.} other{Incorrect code. You have {count} attempts left.}}'**
  String iamCodeWrongAttempts(int count);

  /// No description provided for @iamCodeBlocked.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Request a new code.'**
  String get iamCodeBlocked;

  /// No description provided for @iamCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'This code expired. Request a new one.'**
  String get iamCodeExpired;

  /// No description provided for @iamCodeMissing.
  ///
  /// In en, this message translates to:
  /// **'There\'s no active code for this email. Request a new one.'**
  String get iamCodeMissing;

  /// No description provided for @iamResendIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String iamResendIn(String time);

  /// No description provided for @iamResendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get iamResendCode;

  /// No description provided for @iamChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get iamChangeEmail;

  /// No description provided for @iamCodeResent.
  ///
  /// In en, this message translates to:
  /// **'I sent you a new code.'**
  String get iamCodeResent;

  /// No description provided for @iamLinkResent.
  ///
  /// In en, this message translates to:
  /// **'I sent you a new link.'**
  String get iamLinkResent;

  /// No description provided for @iamSendLink.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get iamSendLink;

  /// No description provided for @iamForgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your\n*password?*'**
  String get iamForgotTitle;

  /// No description provided for @iamForgotVoice.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and I\'ll send you a link to create a new one.'**
  String get iamForgotVoice;

  /// No description provided for @iamLinkSentEyebrow.
  ///
  /// In en, this message translates to:
  /// **'LINK SENT'**
  String get iamLinkSentEyebrow;

  /// No description provided for @iamLinkSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your\n*email.*'**
  String get iamLinkSentTitle;

  /// No description provided for @iamLinkSentBody.
  ///
  /// In en, this message translates to:
  /// **'If {email} has an account, you\'ll get a single-use link to create a new password.'**
  String iamLinkSentBody(String email);

  /// No description provided for @iamOpenEmail.
  ///
  /// In en, this message translates to:
  /// **'Open my email'**
  String get iamOpenEmail;

  /// No description provided for @iamResendLink.
  ///
  /// In en, this message translates to:
  /// **'Resend link'**
  String get iamResendLink;

  /// No description provided for @iamSavePassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get iamSavePassword;

  /// No description provided for @iamNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new\n*password.*'**
  String get iamNewPasswordTitle;

  /// No description provided for @iamNewPasswordVoice.
  ///
  /// In en, this message translates to:
  /// **'Use one you haven\'t used before in Viora.'**
  String get iamNewPasswordVoice;

  /// No description provided for @iamNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get iamNewPassword;

  /// No description provided for @iamConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get iamConfirmPassword;

  /// No description provided for @iamPasswordReused.
  ///
  /// In en, this message translates to:
  /// **'Use one you haven\'t used before in Viora.'**
  String get iamPasswordReused;

  /// No description provided for @iamResetDoneEyebrow.
  ///
  /// In en, this message translates to:
  /// **'NEW PASSWORD'**
  String get iamResetDoneEyebrow;

  /// No description provided for @iamResetDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Done, you can\n*sign in.*'**
  String get iamResetDoneTitle;

  /// No description provided for @iamResetDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Your password was updated. For security, we closed your other sessions.'**
  String get iamResetDoneBody;

  /// No description provided for @iamLinkExpiredEyebrow.
  ///
  /// In en, this message translates to:
  /// **'INVALID LINK'**
  String get iamLinkExpiredEyebrow;

  /// No description provided for @iamLinkExpiredTitle.
  ///
  /// In en, this message translates to:
  /// **'This link\n*has expired.*'**
  String get iamLinkExpiredTitle;

  /// No description provided for @iamLinkExpiredBody.
  ///
  /// In en, this message translates to:
  /// **'For security, each link works only once and for a limited time. Request a new one.'**
  String get iamLinkExpiredBody;

  /// No description provided for @iamRequestNewLink.
  ///
  /// In en, this message translates to:
  /// **'Request a new link'**
  String get iamRequestNewLink;

  /// No description provided for @iamBackToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get iamBackToSignIn;

  /// No description provided for @iamErrorOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your signal and try again.'**
  String get iamErrorOffline;

  /// No description provided for @iamErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get iamErrorGeneric;

  /// No description provided for @iamErrorWait.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a moment and try again.'**
  String get iamErrorWait;

  /// No description provided for @iamErrorPhone.
  ///
  /// In en, this message translates to:
  /// **'The server didn\'t accept this mobile number. Go back and check it.'**
  String get iamErrorPhone;

  /// No description provided for @licenseNoneEyebrow.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT CREATED'**
  String get licenseNoneEyebrow;

  /// No description provided for @licenseNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have\n*a license yet.*'**
  String get licenseNoneTitle;

  /// No description provided for @licenseNoneBody.
  ///
  /// In en, this message translates to:
  /// **'If your organization already hired Viora, enter the code we gave you.'**
  String get licenseNoneBody;

  /// No description provided for @licenseCodeNotRedeemable.
  ///
  /// In en, this message translates to:
  /// **'Invalid or already used code. Ask the Viora team for a new one.'**
  String get licenseCodeNotRedeemable;

  /// No description provided for @licenseCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Manager code'**
  String get licenseCodeLabel;

  /// No description provided for @licenseCodeHint.
  ///
  /// In en, this message translates to:
  /// **'GEST-XXXX'**
  String get licenseCodeHint;

  /// No description provided for @licenseStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get licenseStatus;

  /// No description provided for @licenseStatusNone.
  ///
  /// In en, this message translates to:
  /// **'No license assigned'**
  String get licenseStatusNone;

  /// No description provided for @licenseStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'License expired'**
  String get licenseStatusExpired;

  /// No description provided for @licenseEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get licenseEmail;

  /// No description provided for @licenseActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate license'**
  String get licenseActivate;

  /// No description provided for @licenseContact.
  ///
  /// In en, this message translates to:
  /// **'Not hired yet? Write to us'**
  String get licenseContact;

  /// No description provided for @licenseActivatedEyebrow.
  ///
  /// In en, this message translates to:
  /// **'LICENSE ACTIVATED'**
  String get licenseActivatedEyebrow;

  /// No description provided for @licenseActivatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Your license\n*is now active.*'**
  String get licenseActivatedTitle;

  /// No description provided for @licenseActivatedBody.
  ///
  /// In en, this message translates to:
  /// **'You can now issue codes for your members and see their plots.'**
  String get licenseActivatedBody;

  /// No description provided for @licenseOrganization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get licenseOrganization;

  /// No description provided for @licenseQuota.
  ///
  /// In en, this message translates to:
  /// **'Quota'**
  String get licenseQuota;

  /// No description provided for @licenseQuotaValue.
  ///
  /// In en, this message translates to:
  /// **'{seats, plural, =1{1 seat} other{{seats} seats}} · {hectares} ha'**
  String licenseQuotaValue(int seats, String hectares);

  /// No description provided for @licenseValidity.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get licenseValidity;

  /// No description provided for @licenseValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String licenseValidUntil(String date);

  /// No description provided for @licenseGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get licenseGoHome;

  /// No description provided for @licenseActiveBadge.
  ///
  /// In en, this message translates to:
  /// **'Active license'**
  String get licenseActiveBadge;

  /// No description provided for @licenseRoleOfOrganization.
  ///
  /// In en, this message translates to:
  /// **' · {organization}'**
  String licenseRoleOfOrganization(String organization);

  /// No description provided for @licenseCheckFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t check\n*your license.*'**
  String get licenseCheckFailedTitle;

  /// No description provided for @licenseRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get licenseRetry;

  /// No description provided for @licenseErrorOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your signal and try again.'**
  String get licenseErrorOffline;

  /// No description provided for @licenseErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get licenseErrorGeneric;

  /// No description provided for @licenseErrorWait.
  ///
  /// In en, this message translates to:
  /// **'Too many codes tried. Wait a few minutes and try again.'**
  String get licenseErrorWait;

  /// No description provided for @producerPlanEyebrow.
  ///
  /// In en, this message translates to:
  /// **'ANNUAL SUBSCRIPTION'**
  String get producerPlanEyebrow;

  /// No description provided for @producerPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan\n*Producer*'**
  String get producerPlanTitle;

  /// No description provided for @producerPlanHectares.
  ///
  /// In en, this message translates to:
  /// **'YOUR HECTARES'**
  String get producerPlanHectares;

  /// No description provided for @producerPlanIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase by {step} ha'**
  String producerPlanIncrease(String step);

  /// No description provided for @producerPlanDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease by {step} ha'**
  String producerPlanDecrease(String step);

  /// No description provided for @producerPlanIncludes.
  ///
  /// In en, this message translates to:
  /// **'INCLUDES'**
  String get producerPlanIncludes;

  /// No description provided for @producerPlanBenefitBbi.
  ///
  /// In en, this message translates to:
  /// **'Alternate bearing diagnosis (BBI)'**
  String get producerPlanBenefitBbi;

  /// No description provided for @producerPlanBenefitClimate.
  ///
  /// In en, this message translates to:
  /// **'Accumulated chill and water stress alerts'**
  String get producerPlanBenefitClimate;

  /// No description provided for @producerPlanBenefitSampling.
  ///
  /// In en, this message translates to:
  /// **'Offline sampling and thinning prescription'**
  String get producerPlanBenefitSampling;

  /// No description provided for @producerPlanBenefitCapacity.
  ///
  /// In en, this message translates to:
  /// **'Up to {hectares} ha registered in your plots'**
  String producerPlanBenefitCapacity(String hectares);

  /// No description provided for @producerPlanTotal.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATED ANNUAL TOTAL'**
  String get producerPlanTotal;

  /// No description provided for @producerPlanMonthly.
  ///
  /// In en, this message translates to:
  /// **'Equivalent to {amount} per month · Paid annually'**
  String producerPlanMonthly(String amount);

  /// No description provided for @producerPlanTaxIncluded.
  ///
  /// In en, this message translates to:
  /// **'Includes IGV'**
  String get producerPlanTaxIncluded;

  /// No description provided for @producerPlanUpdated.
  ///
  /// In en, this message translates to:
  /// **'Catalog updated: {timestamp}'**
  String producerPlanUpdated(String timestamp);

  /// No description provided for @producerPlanSavedCopy.
  ///
  /// In en, this message translates to:
  /// **'Saved information. Refresh to check the latest conditions.'**
  String get producerPlanSavedCopy;

  /// No description provided for @producerPlanLoading.
  ///
  /// In en, this message translates to:
  /// **'Updating plan conditions…'**
  String get producerPlanLoading;

  /// No description provided for @producerPlanEmpty.
  ///
  /// In en, this message translates to:
  /// **'No plans are available. Refresh the catalog to check again.'**
  String get producerPlanEmpty;

  /// No description provided for @producerPlanCooperative.
  ///
  /// In en, this message translates to:
  /// **'I have a cooperative code'**
  String get producerPlanCooperative;

  /// No description provided for @cooperativeOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your signal and try again.'**
  String get cooperativeOffline;

  /// No description provided for @cooperativeUnexpected.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Try again.'**
  String get cooperativeUnexpected;

  /// No description provided for @cooperativeNoLicense.
  ///
  /// In en, this message translates to:
  /// **'Your license is not in force.'**
  String get cooperativeNoLicense;

  /// No description provided for @membersHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your\n*members.*'**
  String get membersHeadline;

  /// No description provided for @membersVoice.
  ///
  /// In en, this message translates to:
  /// **'You have {seats} seats and {hectares} ha left to invite more members.'**
  String membersVoice(Object seats, Object hectares);

  /// No description provided for @membersVoiceFull.
  ///
  /// In en, this message translates to:
  /// **'Your license has no free seats left. Ask to expand it to invite more members.'**
  String get membersVoiceFull;

  /// No description provided for @membersLicenseEyebrow.
  ///
  /// In en, this message translates to:
  /// **'License · Season {year}'**
  String membersLicenseEyebrow(Object year);

  /// No description provided for @membersSeatsOf.
  ///
  /// In en, this message translates to:
  /// **'of {seats} seats'**
  String membersSeatsOf(Object seats);

  /// No description provided for @membersLegendMembers.
  ///
  /// In en, this message translates to:
  /// **'{count} members'**
  String membersLegendMembers(Object count);

  /// No description provided for @membersLegendPending.
  ///
  /// In en, this message translates to:
  /// **'{count} to redeem'**
  String membersLegendPending(Object count);

  /// No description provided for @membersLegendFree.
  ///
  /// In en, this message translates to:
  /// **'{count} free'**
  String membersLegendFree(Object count);

  /// No description provided for @membersIssueCodes.
  ///
  /// In en, this message translates to:
  /// **'Issue codes'**
  String get membersIssueCodes;

  /// No description provided for @membersCodesToRedeem.
  ///
  /// In en, this message translates to:
  /// **'codes to redeem'**
  String get membersCodesToRedeem;

  /// No description provided for @membersCodesExpire.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 expires on {date}} other{{count} expire on {date}}}'**
  String membersCodesExpire(int count, String date);

  /// No description provided for @membersCodesNone.
  ///
  /// In en, this message translates to:
  /// **'None pending'**
  String get membersCodesNone;

  /// No description provided for @membersReservedOf.
  ///
  /// In en, this message translates to:
  /// **'reserved of {total} ha'**
  String membersReservedOf(Object total);

  /// No description provided for @membersRegistered.
  ///
  /// In en, this message translates to:
  /// **'{hectares} ha registered'**
  String membersRegistered(Object hectares);

  /// No description provided for @membersSection.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get membersSection;

  /// No description provided for @membersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or sector'**
  String get membersSearchHint;

  /// No description provided for @membersFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All · {count}'**
  String membersFilterAll(Object count);

  /// No description provided for @membersFilterSharing.
  ///
  /// In en, this message translates to:
  /// **'Sharing · {count}'**
  String membersFilterSharing(Object count);

  /// No description provided for @membersFilterWithdrawn.
  ///
  /// In en, this message translates to:
  /// **'Withdrew · {count}'**
  String membersFilterWithdrawn(Object count);

  /// No description provided for @membersPlots.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 plot} other{{count} plots}}'**
  String membersPlots(int count);

  /// No description provided for @membersNoSharedData.
  ///
  /// In en, this message translates to:
  /// **'No shared data'**
  String get membersNoSharedData;

  /// No description provided for @membersLinked.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get membersLinked;

  /// No description provided for @membersWithdrawnOn.
  ///
  /// In en, this message translates to:
  /// **'Withdrew access · {date}'**
  String membersWithdrawnOn(Object date);

  /// No description provided for @membersNotSharing.
  ///
  /// In en, this message translates to:
  /// **'Not sharing'**
  String get membersNotSharing;

  /// No description provided for @membersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No members yet. They show up here when they redeem a code.'**
  String get membersEmpty;

  /// No description provided for @membersNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No member matches your search.'**
  String get membersNoMatch;

  /// No description provided for @memberTitle.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get memberTitle;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member since {date}'**
  String memberSince(Object date);

  /// No description provided for @memberWithdrawnSince.
  ///
  /// In en, this message translates to:
  /// **'Stopped sharing on {date}'**
  String memberWithdrawnSince(Object date);

  /// No description provided for @memberWithdrawnTag.
  ///
  /// In en, this message translates to:
  /// **'Withdrew access'**
  String get memberWithdrawnTag;

  /// No description provided for @memberPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get memberPhone;

  /// No description provided for @memberEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get memberEmail;

  /// No description provided for @memberRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered hectares'**
  String get memberRegistered;

  /// No description provided for @memberRegisteredValue.
  ///
  /// In en, this message translates to:
  /// **'{registered} of {quota} ha'**
  String memberRegisteredValue(Object registered, Object quota);

  /// No description provided for @memberCode.
  ///
  /// In en, this message translates to:
  /// **'Link code'**
  String get memberCode;

  /// No description provided for @memberCodeValue.
  ///
  /// In en, this message translates to:
  /// **'{code} · redeemed'**
  String memberCodeValue(Object code);

  /// No description provided for @memberCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get memberCall;

  /// No description provided for @memberWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get memberWhatsapp;

  /// No description provided for @memberPlots.
  ///
  /// In en, this message translates to:
  /// **'Plots'**
  String get memberPlots;

  /// No description provided for @memberWithdrawnNote.
  ///
  /// In en, this message translates to:
  /// **'You no longer see their data. Their plan goes on and their seat stays taken. To free it, write to Viora support.'**
  String get memberWithdrawnNote;

  /// No description provided for @memberNotSharingNote.
  ///
  /// In en, this message translates to:
  /// **'They didn\'t accept to share their data. Their plan goes on and takes a seat.'**
  String get memberNotSharingNote;

  /// No description provided for @memberPlotSummary.
  ///
  /// In en, this message translates to:
  /// **'{variety} · {hectares} ha · {sector}'**
  String memberPlotSummary(Object variety, Object hectares, Object sector);

  /// No description provided for @memberPlotSectorPending.
  ///
  /// In en, this message translates to:
  /// **'To confirm'**
  String get memberPlotSectorPending;

  /// No description provided for @riskOverload.
  ///
  /// In en, this message translates to:
  /// **'Critical load'**
  String get riskOverload;

  /// No description provided for @riskCriticalIncident.
  ///
  /// In en, this message translates to:
  /// **'Critical incident'**
  String get riskCriticalIncident;

  /// No description provided for @riskFrost.
  ///
  /// In en, this message translates to:
  /// **'Frost expected'**
  String get riskFrost;

  /// No description provided for @riskCritical.
  ///
  /// In en, this message translates to:
  /// **'High risk'**
  String get riskCritical;

  /// No description provided for @riskModerate.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get riskModerate;

  /// No description provided for @riskOptimal.
  ///
  /// In en, this message translates to:
  /// **'Optimal'**
  String get riskOptimal;

  /// No description provided for @riskNoData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data'**
  String get riskNoData;

  /// No description provided for @codesTitle.
  ///
  /// In en, this message translates to:
  /// **'Activation codes'**
  String get codesTitle;

  /// No description provided for @codesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{organization} · {seats} seats · {hectares} ha'**
  String codesSubtitle(Object organization, Object seats, Object hectares);

  /// No description provided for @codesHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your\n*codes.*'**
  String get codesHeadline;

  /// No description provided for @codesTabAvailable.
  ///
  /// In en, this message translates to:
  /// **'To redeem · {count}'**
  String codesTabAvailable(Object count);

  /// No description provided for @codesTabRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Redeemed · {count}'**
  String codesTabRedeemed(Object count);

  /// No description provided for @codesTabClosed.
  ///
  /// In en, this message translates to:
  /// **'Expired · {count}'**
  String codesTabClosed(Object count);

  /// No description provided for @codesIssuedOn.
  ///
  /// In en, this message translates to:
  /// **'Issued on {date}'**
  String codesIssuedOn(Object date);

  /// No description provided for @codesExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Expires today} =1{Expires tomorrow} other{Expires in {days} days}}'**
  String codesExpiresIn(int days);

  /// No description provided for @codesExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires on {date}'**
  String codesExpiresOn(Object date);

  /// No description provided for @codesExpiredOn.
  ///
  /// In en, this message translates to:
  /// **'Expired on {date}'**
  String codesExpiredOn(Object date);

  /// No description provided for @codesRevokedTag.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get codesRevokedTag;

  /// No description provided for @codesPerCode.
  ///
  /// In en, this message translates to:
  /// **'{hectares} ha per code'**
  String codesPerCode(Object hectares);

  /// No description provided for @codesRedeemedBy.
  ///
  /// In en, this message translates to:
  /// **'{name} · {date}'**
  String codesRedeemedBy(Object name, Object date);

  /// No description provided for @codesShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get codesShare;

  /// No description provided for @codesRevoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get codesRevoke;

  /// No description provided for @codesFooterAvailable.
  ///
  /// In en, this message translates to:
  /// **'You have {seats} seats and {hectares} ha left. Each code to redeem holds them until it expires or you revoke it.'**
  String codesFooterAvailable(Object seats, Object hectares);

  /// No description provided for @codesFooterRedeemed.
  ///
  /// In en, this message translates to:
  /// **'A redeemed code can\'t be shared or revoked anymore. Only its reference is left.'**
  String get codesFooterRedeemed;

  /// No description provided for @codesFooterClosed.
  ///
  /// In en, this message translates to:
  /// **'An expired or revoked code gave its seat and hectares back to your license.'**
  String get codesFooterClosed;

  /// No description provided for @codesEmptyAvailable.
  ///
  /// In en, this message translates to:
  /// **'You have no codes to redeem.'**
  String get codesEmptyAvailable;

  /// No description provided for @codesEmptyRedeemed.
  ///
  /// In en, this message translates to:
  /// **'Nobody has redeemed a code yet.'**
  String get codesEmptyRedeemed;

  /// No description provided for @codesEmptyClosed.
  ///
  /// In en, this message translates to:
  /// **'There are no expired or revoked codes.'**
  String get codesEmptyClosed;

  /// No description provided for @codesRevokedNotice.
  ///
  /// In en, this message translates to:
  /// **'Code revoked'**
  String get codesRevokedNotice;

  /// No description provided for @codesNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This code had already expired or been revoked.'**
  String get codesNotAvailable;

  /// No description provided for @revokeTitle.
  ///
  /// In en, this message translates to:
  /// **'Revoke\n*{code}?*'**
  String revokeTitle(Object code);

  /// No description provided for @revokeBody.
  ///
  /// In en, this message translates to:
  /// **'Nobody will be able to use it. Its seat and its {hectares} ha go back to your license.'**
  String revokeBody(Object hectares);

  /// No description provided for @revokeSeats.
  ///
  /// In en, this message translates to:
  /// **'seats · {from} → {to} ha'**
  String revokeSeats(Object from, Object to);

  /// No description provided for @revokeAction.
  ///
  /// In en, this message translates to:
  /// **'Revoke code'**
  String get revokeAction;

  /// No description provided for @cooperativeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cooperativeCancel;

  /// No description provided for @redeemedTitle.
  ///
  /// In en, this message translates to:
  /// **'This code\n*was redeemed*'**
  String get redeemedTitle;

  /// No description provided for @redeemedBody.
  ///
  /// In en, this message translates to:
  /// **'{name} used it on {date}. Redeemed codes can\'t be revoked.'**
  String redeemedBody(Object name, Object date);

  /// No description provided for @redeemedBodyUnknown.
  ///
  /// In en, this message translates to:
  /// **'Someone used it recently. Redeemed codes can\'t be revoked.'**
  String get redeemedBodyUnknown;

  /// No description provided for @redeemedWhen.
  ///
  /// In en, this message translates to:
  /// **'redeemed on {date}'**
  String redeemedWhen(Object date);

  /// No description provided for @redeemedSeeMembers.
  ///
  /// In en, this message translates to:
  /// **'See members'**
  String get redeemedSeeMembers;

  /// No description provided for @redeemedUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get redeemedUnderstood;

  /// No description provided for @shareCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Hi, this is your code to join {organization} on Viora: {code}. Redeem it in the Viora app, under \"I have a cooperative code\". It expires on {date}.'**
  String shareCodeMessage(Object organization, Object code, Object date);

  /// No description provided for @shareCodesMessage.
  ///
  /// In en, this message translates to:
  /// **'Codes of {organization} on Viora, one per member:\n{codes}\nEach one is redeemed in the Viora app, under \"I have a cooperative code\". They expire on {date}.'**
  String shareCodesMessage(Object organization, Object codes, Object date);

  /// No description provided for @issueHeadline.
  ///
  /// In en, this message translates to:
  /// **'Issue\n*codes*'**
  String get issueHeadline;

  /// No description provided for @issueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{organization} · {seats} seats and {hectares} ha free'**
  String issueSubtitle(Object organization, Object seats, Object hectares);

  /// No description provided for @issueQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get issueQuantity;

  /// No description provided for @issueQuantityCaption.
  ///
  /// In en, this message translates to:
  /// **'codes · one per member'**
  String get issueQuantityCaption;

  /// No description provided for @issueHectares.
  ///
  /// In en, this message translates to:
  /// **'Hectares per code'**
  String get issueHectares;

  /// No description provided for @issueHectaresSuggested.
  ///
  /// In en, this message translates to:
  /// **'ha · suggested by your license'**
  String get issueHectaresSuggested;

  /// No description provided for @issueHectaresCaption.
  ///
  /// In en, this message translates to:
  /// **'ha per code'**
  String get issueHectaresCaption;

  /// No description provided for @issueValidity.
  ///
  /// In en, this message translates to:
  /// **'Validity'**
  String get issueValidity;

  /// No description provided for @issueDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String issueDays(Object days);

  /// No description provided for @issuePreview.
  ///
  /// In en, this message translates to:
  /// **'of {seats} seats · {fromHa} → {toHa} of {totalHa} ha. They expire on {date}.'**
  String issuePreview(
    Object seats,
    Object fromHa,
    Object toHa,
    Object totalHa,
    Object date,
  );

  /// No description provided for @issueSeatsExceeded.
  ///
  /// In en, this message translates to:
  /// **'over the {free} free seats'**
  String issueSeatsExceeded(Object free);

  /// No description provided for @issueSeatsExceededBanner.
  ///
  /// In en, this message translates to:
  /// **'of {seats} seats: over your quota. Issue up to {free} or ask to expand the license.'**
  String issueSeatsExceededBanner(Object seats, Object free);

  /// No description provided for @issueAreaExceeded.
  ///
  /// In en, this message translates to:
  /// **'{hectares} ha are over the {free} ha free'**
  String issueAreaExceeded(Object hectares, Object free);

  /// No description provided for @issueAreaExceededBanner.
  ///
  /// In en, this message translates to:
  /// **'ha of {free} free: over your quota. Lower the hectares or ask to expand the license.'**
  String issueAreaExceededBanner(Object free);

  /// No description provided for @issueAction.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Issue 1 code} other{Issue {count} codes}}'**
  String issueAction(int count);

  /// No description provided for @issueUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Codes can\'t be issued now. Let Viora support know.'**
  String get issueUnavailable;

  /// No description provided for @issueDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get issueDecrease;

  /// No description provided for @issueIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get issueIncrease;

  /// No description provided for @issuedHeadline.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 code\n*ready.*} other{{count} codes\n*ready.*}}'**
  String issuedHeadline(int count);

  /// No description provided for @issuedVoice.
  ///
  /// In en, this message translates to:
  /// **'Share them with your members: each one activates an account, takes a seat and holds {hectares} ha.'**
  String issuedVoice(Object hectares);

  /// No description provided for @issuedExpire.
  ///
  /// In en, this message translates to:
  /// **'They expire on {date}'**
  String issuedExpire(Object date);

  /// No description provided for @issuedCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get issuedCopy;

  /// No description provided for @issuedCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get issuedCopied;

  /// No description provided for @issuedShareWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Share on WhatsApp'**
  String get issuedShareWhatsapp;

  /// No description provided for @issuedSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all codes'**
  String get issuedSeeAll;
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
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
