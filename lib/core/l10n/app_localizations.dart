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

  /// No description provided for @membersFilterUnsampled.
  ///
  /// In en, this message translates to:
  /// **'Not sampled · {count}'**
  String membersFilterUnsampled(Object count);

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

  /// No description provided for @riskMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get riskMap;

  /// No description provided for @riskList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get riskList;

  /// No description provided for @riskYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get riskYou;

  /// No description provided for @riskGpsOff.
  ///
  /// In en, this message translates to:
  /// **'No location · showing the whole valley'**
  String get riskGpsOff;

  /// No description provided for @riskLevelCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get riskLevelCritical;

  /// No description provided for @riskLevelModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get riskLevelModerate;

  /// No description provided for @riskLevelNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get riskLevelNoData;

  /// No description provided for @riskCountCritical.
  ///
  /// In en, this message translates to:
  /// **'critical'**
  String get riskCountCritical;

  /// No description provided for @riskCountModerate.
  ///
  /// In en, this message translates to:
  /// **'moderate'**
  String get riskCountModerate;

  /// No description provided for @riskCountOptimal.
  ///
  /// In en, this message translates to:
  /// **'optimal'**
  String get riskCountOptimal;

  /// No description provided for @riskCountNoData.
  ///
  /// In en, this message translates to:
  /// **'no data'**
  String get riskCountNoData;

  /// No description provided for @riskChipCritical.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} critical}}'**
  String riskChipCritical(int count);

  /// No description provided for @riskNearEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Near you · GPS ± {meters} m'**
  String riskNearEyebrow(Object meters);

  /// No description provided for @riskNearTitle.
  ///
  /// In en, this message translates to:
  /// **'Within 5 km'**
  String get riskNearTitle;

  /// No description provided for @riskNearAction.
  ///
  /// In en, this message translates to:
  /// **'See visits by distance'**
  String get riskNearAction;

  /// No description provided for @riskNearSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Near you · {plots}'**
  String riskNearSubtitle(Object plots);

  /// No description provided for @riskSectorEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Sector filter'**
  String get riskSectorEyebrow;

  /// No description provided for @riskSectorAction.
  ///
  /// In en, this message translates to:
  /// **'See the sector\'s plots'**
  String get riskSectorAction;

  /// No description provided for @riskSectorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sector · {plots}'**
  String riskSectorSubtitle(Object plots);

  /// No description provided for @riskPlotEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Plot chosen on the map'**
  String get riskPlotEyebrow;

  /// No description provided for @riskPlotAction.
  ///
  /// In en, this message translates to:
  /// **'See plot'**
  String get riskPlotAction;

  /// No description provided for @riskPlotCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member plot} other{{count} member plots}}'**
  String riskPlotCount(int count);

  /// No description provided for @riskPlotCountShort.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 plot} other{{count} plots}}'**
  String riskPlotCountShort(int count);

  /// No description provided for @riskGroupFreshness.
  ///
  /// In en, this message translates to:
  /// **'{plots} · {updated}'**
  String riskGroupFreshness(Object plots, Object updated);

  /// No description provided for @riskUpdatedNow.
  ///
  /// In en, this message translates to:
  /// **'updated just now'**
  String get riskUpdatedNow;

  /// No description provided for @riskUpdatedMinutes.
  ///
  /// In en, this message translates to:
  /// **'updated {minutes} min ago'**
  String riskUpdatedMinutes(Object minutes);

  /// No description provided for @riskUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'updated on {date}'**
  String riskUpdatedAt(Object date);

  /// No description provided for @riskUpdatedUnknown.
  ///
  /// In en, this message translates to:
  /// **'no reading date'**
  String get riskUpdatedUnknown;

  /// No description provided for @riskTileCritical.
  ///
  /// In en, this message translates to:
  /// **'critical plots'**
  String get riskTileCritical;

  /// No description provided for @riskTileOverload.
  ///
  /// In en, this message translates to:
  /// **'overload > 30%'**
  String get riskTileOverload;

  /// No description provided for @riskTileFrost.
  ///
  /// In en, this message translates to:
  /// **'frost ≤ 1.5 °C in 48 h'**
  String get riskTileFrost;

  /// No description provided for @riskTileOverloadPlot.
  ///
  /// In en, this message translates to:
  /// **'overload'**
  String get riskTileOverloadPlot;

  /// No description provided for @riskTilePrescribed.
  ///
  /// In en, this message translates to:
  /// **'prescribed thinning'**
  String get riskTilePrescribed;

  /// No description provided for @riskTileDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'days left to thin'**
  String get riskTileDaysLeft;

  /// No description provided for @riskPercent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String riskPercent(Object value);

  /// No description provided for @riskHectares.
  ///
  /// In en, this message translates to:
  /// **'{value} ha'**
  String riskHectares(Object value);

  /// No description provided for @riskPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a\n*sector.*'**
  String get riskPickerTitle;

  /// No description provided for @riskPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'To confirm'**
  String get riskPendingTitle;

  /// No description provided for @riskPendingSummary.
  ///
  /// In en, this message translates to:
  /// **'{plots} · review the sector'**
  String riskPendingSummary(Object plots);

  /// No description provided for @riskUnassignedTitle.
  ///
  /// In en, this message translates to:
  /// **'No sector'**
  String get riskUnassignedTitle;

  /// No description provided for @riskReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get riskReview;

  /// No description provided for @riskSummaryCritical.
  ///
  /// In en, this message translates to:
  /// **'{plots} · {count, plural, other{{count} critical}}'**
  String riskSummaryCritical(Object plots, int count);

  /// No description provided for @riskSummaryModerate.
  ///
  /// In en, this message translates to:
  /// **'{plots} · {count, plural, other{{count} moderate}}'**
  String riskSummaryModerate(Object plots, int count);

  /// No description provided for @riskSummaryNoData.
  ///
  /// In en, this message translates to:
  /// **'{plots} · no valid sampling'**
  String riskSummaryNoData(Object plots);

  /// No description provided for @riskSummaryOptimal.
  ///
  /// In en, this message translates to:
  /// **'{plots} · no risk'**
  String riskSummaryOptimal(Object plots);

  /// No description provided for @riskEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No plots\n*yet.*'**
  String get riskEmptyTitle;

  /// No description provided for @riskEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'They will appear here once your members agree to share their data and register their plots.'**
  String get riskEmptyBody;

  /// No description provided for @riskListTitle.
  ///
  /// In en, this message translates to:
  /// **'Valley risk,\n*today.*'**
  String get riskListTitle;

  /// No description provided for @riskMostCritical.
  ///
  /// In en, this message translates to:
  /// **'Most critical'**
  String get riskMostCritical;

  /// No description provided for @riskPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Shall we place you\n*on the map?*'**
  String get riskPermissionTitle;

  /// No description provided for @riskPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'With your GPS we show you on the map and sort the plots by distance. We only use it while you look at the map.'**
  String get riskPermissionBody;

  /// No description provided for @riskPermissionAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow location'**
  String get riskPermissionAllow;

  /// No description provided for @riskPermissionLater.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get riskPermissionLater;

  /// No description provided for @riskScopeEmpty.
  ///
  /// In en, this message translates to:
  /// **'There are no plots to show here.'**
  String get riskScopeEmpty;

  /// No description provided for @riskPriorityTitle.
  ///
  /// In en, this message translates to:
  /// **'By priority'**
  String get riskPriorityTitle;

  /// No description provided for @riskOrderNearest.
  ///
  /// In en, this message translates to:
  /// **'Closest first'**
  String get riskOrderNearest;

  /// No description provided for @riskOrderPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority first'**
  String get riskOrderPriority;

  /// No description provided for @riskRestTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest of the sector'**
  String get riskRestTitle;

  /// No description provided for @riskRestModerate.
  ///
  /// In en, this message translates to:
  /// **'Active attention alert'**
  String get riskRestModerate;

  /// No description provided for @riskRestOptimal.
  ///
  /// In en, this message translates to:
  /// **'Load within target, no frost'**
  String get riskRestOptimal;

  /// No description provided for @riskRestNoData.
  ///
  /// In en, this message translates to:
  /// **'No valid sampling this season'**
  String get riskRestNoData;

  /// No description provided for @riskTogether.
  ///
  /// In en, this message translates to:
  /// **'{first} and {second} are within 1.5 km: you can see them on one trip.'**
  String riskTogether(Object first, Object second);

  /// No description provided for @riskHeroEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Sector traffic light · {level}'**
  String riskHeroEyebrow(Object level);

  /// No description provided for @riskHeroCritical.
  ///
  /// In en, this message translates to:
  /// **'of {total} plots in red'**
  String riskHeroCritical(Object total);

  /// No description provided for @riskHeroModerate.
  ///
  /// In en, this message translates to:
  /// **'of {total} plots in amber'**
  String riskHeroModerate(Object total);

  /// No description provided for @riskHeroOptimal.
  ///
  /// In en, this message translates to:
  /// **'of {total} optimal plots'**
  String riskHeroOptimal(Object total);

  /// No description provided for @riskHeroNoData.
  ///
  /// In en, this message translates to:
  /// **'of {total} plots without data'**
  String riskHeroNoData(Object total);

  /// No description provided for @riskLegend.
  ///
  /// In en, this message translates to:
  /// **'{level} {count}'**
  String riskLegend(Object level, Object count);

  /// No description provided for @riskFrostDetail.
  ///
  /// In en, this message translates to:
  /// **'Low of {value} °C on {day}'**
  String riskFrostDetail(Object value, Object day);

  /// No description provided for @riskDistance.
  ///
  /// In en, this message translates to:
  /// **'{value} km away'**
  String riskDistance(Object value);

  /// No description provided for @riskProposedSector.
  ///
  /// In en, this message translates to:
  /// **'wrote “{name}”'**
  String riskProposedSector(Object name);

  /// No description provided for @riskReasonOverload.
  ///
  /// In en, this message translates to:
  /// **'Overload {value}%'**
  String riskReasonOverload(Object value);

  /// No description provided for @riskReasonFrost.
  ///
  /// In en, this message translates to:
  /// **'Frost {value} °C · {day}'**
  String riskReasonFrost(Object value, Object day);

  /// No description provided for @riskDossierAction.
  ///
  /// In en, this message translates to:
  /// **'See provisional dossier'**
  String get riskDossierAction;

  /// No description provided for @riskReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get riskReadOnly;

  /// No description provided for @riskReadAt.
  ///
  /// In en, this message translates to:
  /// **'Updated {when}'**
  String riskReadAt(Object when);

  /// No description provided for @riskToday.
  ///
  /// In en, this message translates to:
  /// **'today, {time}'**
  String riskToday(Object time);

  /// No description provided for @riskLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Fruit load'**
  String get riskLoadTitle;

  /// No description provided for @riskLoadUnit.
  ///
  /// In en, this message translates to:
  /// **'Fruits per shoot'**
  String get riskLoadUnit;

  /// No description provided for @riskLoadEstimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated'**
  String get riskLoadEstimated;

  /// No description provided for @riskLoadTarget.
  ///
  /// In en, this message translates to:
  /// **'Sustainable target'**
  String get riskLoadTarget;

  /// No description provided for @riskTonsAfterThinning.
  ///
  /// In en, this message translates to:
  /// **'estimated t/ha after thinning'**
  String get riskTonsAfterThinning;

  /// No description provided for @riskOverloadNotice.
  ///
  /// In en, this message translates to:
  /// **'{percent}% more fruit than the tree can carry. Left unregulated, alternate bearing goes on and {year} would be a strong OFF year.'**
  String riskOverloadNotice(Object percent, Object year);

  /// No description provided for @riskSampleBasis.
  ///
  /// In en, this message translates to:
  /// **'Based on {trees} trees · round of {day}'**
  String riskSampleBasis(Object trees, Object day);

  /// No description provided for @riskPrescriptionEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Prescription · thinning'**
  String get riskPrescriptionEyebrow;

  /// No description provided for @riskPrescriptionUnit.
  ///
  /// In en, this message translates to:
  /// **'of the fruits'**
  String get riskPrescriptionUnit;

  /// No description provided for @riskPrescriptionBody.
  ///
  /// In en, this message translates to:
  /// **'Prescribed to {name}: remove {count} of every 10 fruitlets, starting with the most loaded branches.'**
  String riskPrescriptionBody(Object name, Object count);

  /// No description provided for @riskWindowFrom.
  ///
  /// In en, this message translates to:
  /// **'From {day}'**
  String riskWindowFrom(Object day);

  /// No description provided for @riskWindowUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {day}'**
  String riskWindowUntil(Object day);

  /// No description provided for @riskWindowClosed.
  ///
  /// In en, this message translates to:
  /// **'The window has closed'**
  String get riskWindowClosed;

  /// No description provided for @riskWindowOpens.
  ///
  /// In en, this message translates to:
  /// **'Opens on {day}'**
  String riskWindowOpens(Object day);

  /// No description provided for @riskWindowDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Last day} =1{1 day left} other{{count} days left}}'**
  String riskWindowDaysLeft(int count);

  /// No description provided for @riskThinningMissing.
  ///
  /// In en, this message translates to:
  /// **'Thinning not registered yet'**
  String get riskThinningMissing;

  /// No description provided for @riskThinningDone.
  ///
  /// In en, this message translates to:
  /// **'Thinning registered on {day}'**
  String riskThinningDone(Object day);

  /// No description provided for @riskBearingEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Alternate bearing · for information'**
  String get riskBearingEyebrow;

  /// No description provided for @riskBearingBand.
  ///
  /// In en, this message translates to:
  /// **'BBI · {band} alternation'**
  String riskBearingBand(Object band);

  /// No description provided for @riskBearingHigh.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get riskBearingHigh;

  /// No description provided for @riskBearingModerate.
  ///
  /// In en, this message translates to:
  /// **'moderate'**
  String get riskBearingModerate;

  /// No description provided for @riskBearingLow.
  ///
  /// In en, this message translates to:
  /// **'mild'**
  String get riskBearingLow;

  /// No description provided for @riskBearingNote.
  ///
  /// In en, this message translates to:
  /// **'It doesn\'t change the traffic light.'**
  String get riskBearingNote;

  /// No description provided for @riskNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough\n*data*'**
  String get riskNoDataTitle;

  /// No description provided for @riskNoDataBody.
  ///
  /// In en, this message translates to:
  /// **'This plot has no valid fruit-set sampling this season yet. Without it we can\'t work out its load: it stays grey, never green.'**
  String get riskNoDataBody;

  /// No description provided for @riskNoDataSampling.
  ///
  /// In en, this message translates to:
  /// **'Fruit-set sampling'**
  String get riskNoDataSampling;

  /// No description provided for @riskNoDataSamplingValue.
  ///
  /// In en, this message translates to:
  /// **'{sampled} of {required} trees'**
  String riskNoDataSamplingValue(Object sampled, Object required);

  /// No description provided for @riskNoDataLoadValue.
  ///
  /// In en, this message translates to:
  /// **'estimated after sampling'**
  String get riskNoDataLoadValue;

  /// No description provided for @riskNoDataPrescription.
  ///
  /// In en, this message translates to:
  /// **'Thinning prescription'**
  String get riskNoDataPrescription;

  /// No description provided for @riskNoDataPrescriptionValue.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get riskNoDataPrescriptionValue;

  /// No description provided for @riskNoDataVoice.
  ///
  /// In en, this message translates to:
  /// **'Write to {name}: with {trees} trees sampled we can assess their plot.'**
  String riskNoDataVoice(Object name, Object trees);

  /// No description provided for @alertsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Alert preferences'**
  String get alertsPreferences;

  /// No description provided for @alertsActive.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{active alert} other{active alerts}}'**
  String alertsActive(int count);

  /// No description provided for @alertsWhere.
  ///
  /// In en, this message translates to:
  /// **'In {sectors} · updated {time}'**
  String alertsWhere(Object sectors, Object time);

  /// No description provided for @alertsCalm.
  ///
  /// In en, this message translates to:
  /// **'Your sectors are calm · updated {time}'**
  String alertsCalm(Object time);

  /// No description provided for @alertsSectorsJoin.
  ///
  /// In en, this message translates to:
  /// **'{first} and {last}'**
  String alertsSectorsJoin(Object first, Object last);

  /// No description provided for @alertsFilterCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get alertsFilterCritical;

  /// No description provided for @alertsFilterAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get alertsFilterAttention;

  /// No description provided for @alertsFilterNormalized.
  ///
  /// In en, this message translates to:
  /// **'Normalized'**
  String get alertsFilterNormalized;

  /// No description provided for @alertsToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get alertsToday;

  /// No description provided for @alertsYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get alertsYesterday;

  /// No description provided for @alertsNormalizedTitle.
  ///
  /// In en, this message translates to:
  /// **'Normalized · last 7 days'**
  String get alertsNormalizedTitle;

  /// No description provided for @alertsFilteredEmpty.
  ///
  /// In en, this message translates to:
  /// **'No alerts in this group.'**
  String get alertsFilteredEmpty;

  /// No description provided for @alertsChipCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get alertsChipCritical;

  /// No description provided for @alertsChipAttention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get alertsChipAttention;

  /// No description provided for @alertsAgoNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get alertsAgoNow;

  /// No description provided for @alertsAgoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String alertsAgoMinutes(int minutes);

  /// No description provided for @alertsAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ago'**
  String alertsAgoHours(int hours);

  /// No description provided for @alertsSectorCriticalTitle.
  ///
  /// In en, this message translates to:
  /// **'{sector} turned Critical'**
  String alertsSectorCriticalTitle(Object sector);

  /// No description provided for @alertsFrostTitle.
  ///
  /// In en, this message translates to:
  /// **'Radiative frost in {sector}'**
  String alertsFrostTitle(Object sector);

  /// No description provided for @alertsOverloadBody.
  ///
  /// In en, this message translates to:
  /// **'{producer} recorded an overload of {value} %. {plots}'**
  String alertsOverloadBody(Object producer, Object value, Object plots);

  /// No description provided for @alertsIncidentBody.
  ///
  /// In en, this message translates to:
  /// **'{producer} reported a critical incident. {plots}'**
  String alertsIncidentBody(Object producer, Object plots);

  /// No description provided for @alertsRedPlots.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{There is now 1 plot in red in the sector.} other{There are now {count} plots in red in the sector.}}'**
  String alertsRedPlots(int count);

  /// No description provided for @alertsFrostForecastBody.
  ///
  /// In en, this message translates to:
  /// **'Forecast low of {value} °C on {day}. Let the sector\'s members know.'**
  String alertsFrostForecastBody(Object value, Object day);

  /// No description provided for @alertsFrostIncidentBody.
  ///
  /// In en, this message translates to:
  /// **'{producer} reported frost on {plot}. Let the sector\'s members know.'**
  String alertsFrostIncidentBody(Object producer, Object plot);

  /// No description provided for @alertsFrostPlots.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 plot exposed. Let the sector\'s members know.} other{{count} plots exposed. Let the sector\'s members know.}}'**
  String alertsFrostPlots(int count);

  /// No description provided for @alertsOpenSector.
  ///
  /// In en, this message translates to:
  /// **'Open sector'**
  String get alertsOpenSector;

  /// No description provided for @alertsBackTo.
  ///
  /// In en, this message translates to:
  /// **'{sector} went back to {level}'**
  String alertsBackTo(Object sector, Object level);

  /// No description provided for @alertsFrostPassed.
  ///
  /// In en, this message translates to:
  /// **'The frost passed in {sector}'**
  String alertsFrostPassed(Object sector);

  /// No description provided for @alertsNormalizedPlain.
  ///
  /// In en, this message translates to:
  /// **'{sector} normalized'**
  String alertsNormalizedPlain(Object sector);

  /// No description provided for @dossierTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical dossier'**
  String get dossierTitle;

  /// No description provided for @dossierSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{plot} · {year} season'**
  String dossierSubtitle(Object plot, Object year);

  /// No description provided for @dossierEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Agronomic dossier · Provisional'**
  String get dossierEyebrow;

  /// No description provided for @dossierCampaign.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get dossierCampaign;

  /// No description provided for @dossierCampaignValue.
  ///
  /// In en, this message translates to:
  /// **'{year} · in progress'**
  String dossierCampaignValue(Object year);

  /// No description provided for @dossierVarietyArea.
  ///
  /// In en, this message translates to:
  /// **'Variety and area'**
  String get dossierVarietyArea;

  /// No description provided for @dossierLoad.
  ///
  /// In en, this message translates to:
  /// **'Fruit load'**
  String get dossierLoad;

  /// No description provided for @dossierLoadValue.
  ///
  /// In en, this message translates to:
  /// **'{fruits} fruits/shoot'**
  String dossierLoadValue(Object fruits);

  /// No description provided for @dossierPrescription.
  ///
  /// In en, this message translates to:
  /// **'Prescription'**
  String get dossierPrescription;

  /// No description provided for @dossierPrescriptionValue.
  ///
  /// In en, this message translates to:
  /// **'Thin {percent}'**
  String dossierPrescriptionValue(Object percent);

  /// No description provided for @dossierThinning.
  ///
  /// In en, this message translates to:
  /// **'Thinning registered'**
  String get dossierThinning;

  /// No description provided for @dossierThinningMissing.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get dossierThinningMissing;

  /// No description provided for @dossierClimate.
  ///
  /// In en, this message translates to:
  /// **'Climate and telemetry'**
  String get dossierClimate;

  /// No description provided for @dossierNodes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 node} other{{count} nodes}}'**
  String dossierNodes(int count);

  /// No description provided for @dossierDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day of data} other{{count} days of data}}'**
  String dossierDays(int count);

  /// No description provided for @dossierNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get dossierNotAvailable;

  /// No description provided for @dossierProvisionalEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Provisional · Not certified'**
  String get dossierProvisionalEyebrow;

  /// No description provided for @dossierCutOff.
  ///
  /// In en, this message translates to:
  /// **'Cut-off {when}'**
  String dossierCutOff(Object when);

  /// No description provided for @dossierProvisionalBody.
  ///
  /// In en, this message translates to:
  /// **'It shows the data of that moment and may change. It has no verification code: the producer seals the final dossier when the season closes.'**
  String get dossierProvisionalBody;

  /// No description provided for @dossierDownload.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get dossierDownload;

  /// No description provided for @dossierShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get dossierShare;

  /// No description provided for @dossierShareSubject.
  ///
  /// In en, this message translates to:
  /// **'Provisional dossier · {plot}'**
  String dossierShareSubject(Object plot);

  /// No description provided for @dossierSaved.
  ///
  /// In en, this message translates to:
  /// **'PDF saved'**
  String get dossierSaved;

  /// No description provided for @dossierNotShared.
  ///
  /// In en, this message translates to:
  /// **'This member no longer shares the plot.'**
  String get dossierNotShared;

  /// No description provided for @homeManagerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{organization} · technician'**
  String homeManagerSubtitle(String organization);

  /// No description provided for @homeVoiceNoPlots.
  ///
  /// In en, this message translates to:
  /// **'No member shares a plot yet: issue codes to invite them.'**
  String get homeVoiceNoPlots;

  /// No description provided for @homeVoiceOverload.
  ///
  /// In en, this message translates to:
  /// **'{sector} needs your visit: {count, plural, =1{1 plot overloaded} other{{count} plots overloaded}}.'**
  String homeVoiceOverload(String sector, int count);

  /// No description provided for @homeVoiceCritical.
  ///
  /// In en, this message translates to:
  /// **'{sector} needs your visit: {count, plural, =1{1 plot in red} other{{count} plots in red}}.'**
  String homeVoiceCritical(String sector, int count);

  /// No description provided for @homeVoiceCriticalValley.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{A plot in red is waiting for your visit.} other{{count} plots in red are waiting for your visit.}}'**
  String homeVoiceCriticalValley(int count);

  /// No description provided for @homeVoiceFrost.
  ///
  /// In en, this message translates to:
  /// **'Frost is coming: {count, plural, =1{1 plot} other{{count} plots}} under 1.5 °C within 48 h.'**
  String homeVoiceFrost(int count);

  /// No description provided for @homeVoiceCalm.
  ///
  /// In en, this message translates to:
  /// **'Your valley is calm: no plot in red.'**
  String get homeVoiceCalm;

  /// No description provided for @homeValleyEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Valley traffic light · {count, plural, =1{1 plot} other{{count} plots}}'**
  String homeValleyEyebrow(int count);

  /// No description provided for @homeValleyCritical.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{critical\nplot} other{critical\nplots}}'**
  String homeValleyCritical(int count);

  /// No description provided for @homeOpenRisk.
  ///
  /// In en, this message translates to:
  /// **'See territorial risk'**
  String get homeOpenRisk;

  /// No description provided for @homeLicenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Your license'**
  String get homeLicenseTitle;

  /// No description provided for @homeCampaign.
  ///
  /// In en, this message translates to:
  /// **'Season {year}'**
  String homeCampaign(String year);

  /// No description provided for @homeIntakeLabel.
  ///
  /// In en, this message translates to:
  /// **'Intake'**
  String get homeIntakeLabel;

  /// No description provided for @homeTons.
  ///
  /// In en, this message translates to:
  /// **'{tons} t'**
  String homeTons(String tons);

  /// No description provided for @homeIntakeProjected.
  ///
  /// In en, this message translates to:
  /// **'projected'**
  String get homeIntakeProjected;

  /// No description provided for @homeIntakeSettled.
  ///
  /// In en, this message translates to:
  /// **'delivered'**
  String get homeIntakeSettled;

  /// No description provided for @homeIntakeNoData.
  ///
  /// In en, this message translates to:
  /// **'no samplings yet'**
  String get homeIntakeNoData;

  /// No description provided for @homeIntakeGreen.
  ///
  /// In en, this message translates to:
  /// **'{tons} t green'**
  String homeIntakeGreen(String tons);

  /// No description provided for @homeIntakeBlack.
  ///
  /// In en, this message translates to:
  /// **'{tons} t black'**
  String homeIntakeBlack(String tons);

  /// No description provided for @homeIntakeUnclassified.
  ///
  /// In en, this message translates to:
  /// **'{tons} t unclassified'**
  String homeIntakeUnclassified(String tons);

  /// No description provided for @homeIntakeCoverage.
  ///
  /// In en, this message translates to:
  /// **'Coverage {percent} %'**
  String homeIntakeCoverage(int percent);

  /// No description provided for @homeFrostAlerts.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{frost alert} other{frost alerts}}\n≤ 1.5 °C within 48 h'**
  String homeFrostAlerts(int count);

  /// No description provided for @homeSeatsLabel.
  ///
  /// In en, this message translates to:
  /// **'seats of the license'**
  String get homeSeatsLabel;

  /// No description provided for @homeVisitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested visits'**
  String get homeVisitsTitle;

  /// No description provided for @homeVisitsSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeVisitsSeeAll;

  /// No description provided for @homeVisitsNone.
  ///
  /// In en, this message translates to:
  /// **'No plot needs a visit today.'**
  String get homeVisitsNone;

  /// No description provided for @sectorsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sectors'**
  String get sectorsTitle;

  /// No description provided for @sectorsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your license\'s list'**
  String get sectorsSubtitle;

  /// No description provided for @sectorsHeadline.
  ///
  /// In en, this message translates to:
  /// **'Your\n*sectors.*'**
  String get sectorsHeadline;

  /// No description provided for @sectorsPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'To confirm'**
  String get sectorsPendingTitle;

  /// No description provided for @sectorsPendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} to review'**
  String sectorsPendingCount(int count);

  /// No description provided for @sectorsPendingLine.
  ///
  /// In en, this message translates to:
  /// **'{producer} · {plot}'**
  String sectorsPendingLine(String producer, String plot);

  /// No description provided for @sectorsListTitle.
  ///
  /// In en, this message translates to:
  /// **'Your list'**
  String get sectorsListTitle;

  /// No description provided for @sectorsListCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 sector} other{{count} sectors}}'**
  String sectorsListCount(int count);

  /// No description provided for @sectorsPlotCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No plots yet} =1{1 plot} other{{count} plots}}'**
  String sectorsPlotCount(int count);

  /// No description provided for @sectorsReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get sectorsReview;

  /// No description provided for @sectorsRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get sectorsRename;

  /// No description provided for @sectorsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add sector'**
  String get sectorsAdd;

  /// No description provided for @sectorsNote.
  ///
  /// In en, this message translates to:
  /// **'Sectors belong to your license. Renaming updates all its plots; they are not deleted.'**
  String get sectorsNote;

  /// No description provided for @sectorsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your list has no sectors yet.'**
  String get sectorsEmpty;

  /// No description provided for @sectorAddHeadline.
  ///
  /// In en, this message translates to:
  /// **'Add\n*sector*'**
  String get sectorAddHeadline;

  /// No description provided for @sectorRenameHeadline.
  ///
  /// In en, this message translates to:
  /// **'Rename\n*sector*'**
  String get sectorRenameHeadline;

  /// No description provided for @sectorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Sector name'**
  String get sectorNameLabel;

  /// No description provided for @sectorNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Cerro Blanco'**
  String get sectorNamePlaceholder;

  /// No description provided for @sectorNameHint.
  ///
  /// In en, this message translates to:
  /// **'Accents and case don\'t count: «cerro blanco» and «Cerro Blanco» are the same sector.'**
  String get sectorNameHint;

  /// No description provided for @sectorSave.
  ///
  /// In en, this message translates to:
  /// **'Save sector'**
  String get sectorSave;

  /// No description provided for @sectorRenameSave.
  ///
  /// In en, this message translates to:
  /// **'Save name'**
  String get sectorRenameSave;

  /// No description provided for @sectorNameTaken.
  ///
  /// In en, this message translates to:
  /// **'Your list already has a sector with that name.'**
  String get sectorNameTaken;

  /// No description provided for @sectorNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Write between 2 and 60 letters.'**
  String get sectorNameInvalid;

  /// No description provided for @sectorSaveOffline.
  ///
  /// In en, this message translates to:
  /// **'No connection. Try again when you have signal.'**
  String get sectorSaveOffline;

  /// No description provided for @sectorSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'It could not be saved. Try again.'**
  String get sectorSaveFailed;

  /// No description provided for @sectorReviewSameAs.
  ///
  /// In en, this message translates to:
  /// **'It is the same as'**
  String get sectorReviewSameAs;

  /// No description provided for @sectorReviewHint.
  ///
  /// In en, this message translates to:
  /// **'It only sorts your panel: the member\'s plot doesn\'t change.'**
  String get sectorReviewHint;

  /// No description provided for @sectorReviewAdd.
  ///
  /// In en, this message translates to:
  /// **'Add as a sector'**
  String get sectorReviewAdd;

  /// No description provided for @sectorReviewJoin.
  ///
  /// In en, this message translates to:
  /// **'Join {sector}'**
  String sectorReviewJoin(String sector);

  /// No description provided for @membersSectorsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 sector in your list} other{{count} sectors in your list}}'**
  String membersSectorsCount(int count);

  /// No description provided for @membersSectorsPending.
  ///
  /// In en, this message translates to:
  /// **'{count} to confirm'**
  String membersSectorsPending(int count);

  /// No description provided for @intakeCampaign.
  ///
  /// In en, this message translates to:
  /// **'Season {year}'**
  String intakeCampaign(String year);

  /// No description provided for @intakeChooseCampaign.
  ///
  /// In en, this message translates to:
  /// **'Choose season'**
  String get intakeChooseCampaign;

  /// No description provided for @intakeHeadlineProjected.
  ///
  /// In en, this message translates to:
  /// **'Your intake,\n*projected.*'**
  String get intakeHeadlineProjected;

  /// No description provided for @intakeHeadlineSettled.
  ///
  /// In en, this message translates to:
  /// **'Your intake,\n*recorded.*'**
  String get intakeHeadlineSettled;

  /// No description provided for @intakeHeadlineNoData.
  ///
  /// In en, this message translates to:
  /// **'Your intake,\n*no figure yet.*'**
  String get intakeHeadlineNoData;

  /// No description provided for @intakeVoiceSufficient.
  ///
  /// In en, this message translates to:
  /// **'It adds up only the estimable plots, without extrapolating. {count} still to sample.'**
  String intakeVoiceSufficient(int count);

  /// No description provided for @intakeVoiceAllSampled.
  ///
  /// In en, this message translates to:
  /// **'It adds up only the estimable plots, without extrapolating.'**
  String get intakeVoiceAllSampled;

  /// No description provided for @intakeVoicePreliminary.
  ///
  /// In en, this message translates to:
  /// **'Only {percent} % of the plots are sampled: use this figure with care for contracts.'**
  String intakeVoicePreliminary(int percent);

  /// No description provided for @intakeVoiceSettled.
  ///
  /// In en, this message translates to:
  /// **'It is the real intake the members settled since they joined.'**
  String get intakeVoiceSettled;

  /// No description provided for @intakeEyebrowProjection.
  ///
  /// In en, this message translates to:
  /// **'PROJECTION · SEASON {year}'**
  String intakeEyebrowProjection(String year);

  /// No description provided for @intakeEyebrowSettled.
  ///
  /// In en, this message translates to:
  /// **'REAL INTAKE · SEASON {year}'**
  String intakeEyebrowSettled(String year);

  /// No description provided for @intakeTagSufficient.
  ///
  /// In en, this message translates to:
  /// **'Enough coverage'**
  String get intakeTagSufficient;

  /// No description provided for @intakeTagPreliminary.
  ///
  /// In en, this message translates to:
  /// **'Preliminary'**
  String get intakeTagPreliminary;

  /// No description provided for @intakeTagClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get intakeTagClosed;

  /// No description provided for @intakeTagPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get intakeTagPartial;

  /// No description provided for @intakeTonsUnit.
  ///
  /// In en, this message translates to:
  /// **'tons'**
  String get intakeTonsUnit;

  /// No description provided for @intakeUncertainty.
  ///
  /// In en, this message translates to:
  /// **'High margin of uncertainty · {sampled} of {plots} plots'**
  String intakeUncertainty(int sampled, int plots);

  /// No description provided for @intakeGreenHistory.
  ///
  /// In en, this message translates to:
  /// **'Green · by history'**
  String get intakeGreenHistory;

  /// No description provided for @intakeBlackHistory.
  ///
  /// In en, this message translates to:
  /// **'Black · by history'**
  String get intakeBlackHistory;

  /// No description provided for @intakeGreenSettled.
  ///
  /// In en, this message translates to:
  /// **'Green · settled'**
  String get intakeGreenSettled;

  /// No description provided for @intakeBlackSettled.
  ///
  /// In en, this message translates to:
  /// **'Black · settled'**
  String get intakeBlackSettled;

  /// No description provided for @intakePercent.
  ///
  /// In en, this message translates to:
  /// **'{percent} %'**
  String intakePercent(int percent);

  /// No description provided for @intakeUnclassified.
  ///
  /// In en, this message translates to:
  /// **'{tons} t unclassified · {percent} %'**
  String intakeUnclassified(String tons, int percent);

  /// No description provided for @intakeCoverageLabel.
  ///
  /// In en, this message translates to:
  /// **'SAMPLING COVERAGE'**
  String get intakeCoverageLabel;

  /// No description provided for @intakeSettledCoverageLabel.
  ///
  /// In en, this message translates to:
  /// **'SETTLED HARVESTS'**
  String get intakeSettledCoverageLabel;

  /// No description provided for @intakeCoveragePlots.
  ///
  /// In en, this message translates to:
  /// **'{sampled} of {plots} plots'**
  String intakeCoveragePlots(int sampled, int plots);

  /// No description provided for @intakeOf.
  ///
  /// In en, this message translates to:
  /// **'{sampled} of {plots}'**
  String intakeOf(int sampled, int plots);

  /// No description provided for @intakeThreshold.
  ///
  /// In en, this message translates to:
  /// **'{percent} % · preliminary threshold'**
  String intakeThreshold(int percent);

  /// No description provided for @intakeCoverageSufficient.
  ///
  /// In en, this message translates to:
  /// **'{estimable} of {plots} plots are estimable. From {threshold} % sampling the projection stops being preliminary.'**
  String intakeCoverageSufficient(int estimable, int plots, int threshold);

  /// No description provided for @intakeCoveragePreliminary.
  ///
  /// In en, this message translates to:
  /// **'{estimable} of {plots} plots are estimable. The projection is preliminary until sampling reaches {threshold} %.'**
  String intakeCoveragePreliminary(int estimable, int plots, int threshold);

  /// No description provided for @intakeMissingPlots.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more to get there.} other{{count} more to get there.}}'**
  String intakeMissingPlots(int count);

  /// No description provided for @intakeCoverageSettled.
  ///
  /// In en, this message translates to:
  /// **'{settled} of {plots} plots settled their harvest of the {year} season.'**
  String intakeCoverageSettled(int settled, int plots, String year);

  /// No description provided for @intakeBySector.
  ///
  /// In en, this message translates to:
  /// **'By sector'**
  String get intakeBySector;

  /// No description provided for @intakeSectorSampled.
  ///
  /// In en, this message translates to:
  /// **'{sampled} of {plots} sampled'**
  String intakeSectorSampled(int sampled, int plots);

  /// No description provided for @intakeSectorSettled.
  ///
  /// In en, this message translates to:
  /// **'{sampled} of {plots} with harvest'**
  String intakeSectorSettled(int sampled, int plots);

  /// No description provided for @intakeSectorNoData.
  ///
  /// In en, this message translates to:
  /// **'{sampled} of {plots} · no data'**
  String intakeSectorNoData(int sampled, int plots);

  /// No description provided for @intakeSectorPending.
  ///
  /// In en, this message translates to:
  /// **'{sampled} of {plots} · check the sector'**
  String intakeSectorPending(int sampled, int plots);

  /// No description provided for @intakeNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Not enough data\nto project'**
  String get intakeNoDataTitle;

  /// No description provided for @intakeNoDataBody.
  ///
  /// In en, this message translates to:
  /// **'No member recorded a fruit set sampling in the {year} season. The projection shows up with the first samplings, marked as preliminary.'**
  String intakeNoDataBody(String year);

  /// No description provided for @intakeNoEstimableBody.
  ///
  /// In en, this message translates to:
  /// **'There are samplings in the {year} season, but no plot is estimable yet: it lacks its yield estimate or its area.'**
  String intakeNoEstimableBody(String year);

  /// No description provided for @intakeSettledNoDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No settled\nharvests'**
  String get intakeSettledNoDataTitle;

  /// No description provided for @intakeSettledNoDataBody.
  ///
  /// In en, this message translates to:
  /// **'No member settled their harvest of the {year} season since joining.'**
  String intakeSettledNoDataBody(String year);

  /// No description provided for @intakeMembersWithoutSampling.
  ///
  /// In en, this message translates to:
  /// **'See members without sampling'**
  String get intakeMembersWithoutSampling;

  /// No description provided for @intakeSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the\n*season*'**
  String get intakeSheetTitle;

  /// No description provided for @intakeSheetInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress · projection {tons} t'**
  String intakeSheetInProgress(String tons);

  /// No description provided for @intakeSheetInProgressNoData.
  ///
  /// In en, this message translates to:
  /// **'In progress · no figure yet'**
  String get intakeSheetInProgressNoData;

  /// No description provided for @intakeSheetClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed · real intake {tons} t'**
  String intakeSheetClosed(String tons);

  /// No description provided for @intakeSheetPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial · real intake {tons} t'**
  String intakeSheetPartial(String tons);

  /// No description provided for @intakeSheetSettledNoData.
  ///
  /// In en, this message translates to:
  /// **'No settled harvests'**
  String get intakeSheetSettledNoData;

  /// No description provided for @intakeSheetNote.
  ///
  /// In en, this message translates to:
  /// **'In closed seasons you see the real intake the members recorded.'**
  String get intakeSheetNote;

  /// No description provided for @offlineToday.
  ///
  /// In en, this message translates to:
  /// **'Offline · {what} from {when}'**
  String offlineToday(String what, String when);

  /// No description provided for @offlineOn.
  ///
  /// In en, this message translates to:
  /// **'Offline · {what} from {when}'**
  String offlineOn(String what, String when);

  /// No description provided for @offlineWhatState.
  ///
  /// In en, this message translates to:
  /// **'last state'**
  String get offlineWhatState;

  /// No description provided for @offlineWhatProjection.
  ///
  /// In en, this message translates to:
  /// **'projection'**
  String get offlineWhatProjection;

  /// No description provided for @offlineWhatIntake.
  ///
  /// In en, this message translates to:
  /// **'intake'**
  String get offlineWhatIntake;

  /// No description provided for @offlineWhatAlerts.
  ///
  /// In en, this message translates to:
  /// **'alerts'**
  String get offlineWhatAlerts;

  /// No description provided for @offlineWhatMembers.
  ///
  /// In en, this message translates to:
  /// **'members'**
  String get offlineWhatMembers;

  /// No description provided for @riskSavedAt.
  ///
  /// In en, this message translates to:
  /// **'saved {when}'**
  String riskSavedAt(String when);
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
