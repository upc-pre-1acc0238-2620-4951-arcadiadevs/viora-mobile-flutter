// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navRisk => 'Risk';

  @override
  String get navCollection => 'Collection';

  @override
  String get navMembers => 'Members';

  @override
  String get placeholderComingSoon => 'Coming soon';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeGreetingAnonymous => 'Hello';

  @override
  String get accountLanguageNotice => 'Language: English';

  @override
  String get accountGroupSecurity => 'SECURITY';

  @override
  String get accountChangePassword => 'Change password';

  @override
  String get accountGroupPreferences => 'PREFERENCES';

  @override
  String get accountLanguage => 'Language';

  @override
  String get accountLanguageSpanish => 'Español';

  @override
  String get accountLanguageEnglish => 'English';

  @override
  String get accountNotifications => 'Notifications';

  @override
  String get accountNotificationsOn => 'On';

  @override
  String get accountNotificationsOff => 'Off';

  @override
  String accountVersion(String version) {
    return 'Viora $version · Android · iOS';
  }

  @override
  String get accountDetailsSaved => 'Changes saved';

  @override
  String get accountPasswordChanged => 'Password updated';

  @override
  String get accountDetailsTitle => 'Personal details';

  @override
  String get accountDetailsHeadline => 'Your\n*details.*';

  @override
  String get accountFullName => 'Full name';

  @override
  String get accountFullNamePlaceholder => 'Enter your name';

  @override
  String get accountFullNameRequired => 'Your name is required.';

  @override
  String accountPhoneLabel(String country, String dialCode) {
    return 'Mobile · $country $dialCode';
  }

  @override
  String accountPhoneHelper(String example) {
    return 'International format: $example';
  }

  @override
  String get accountEmailHelper => 'Verified · used to sign in to Viora';

  @override
  String get accountSaveChanges => 'Save changes';

  @override
  String get accountSaveOffline =>
      'No connection: your changes weren\'t saved. Try again.';

  @override
  String get accountSaveFailed => 'We couldn\'t save your changes. Try again.';

  @override
  String get accountSecurityTitle => 'Security';

  @override
  String get accountPasswordHeadline => 'New\n*password.*';

  @override
  String get accountCurrentPassword => 'Current password';

  @override
  String get accountCurrentPasswordWrong =>
      'The current password isn\'t correct.';

  @override
  String get accountConfirmNewPassword => 'Confirm new password';

  @override
  String get accountPasswordRules => 'It doesn\'t meet the requirements below.';

  @override
  String get accountPasswordMismatch => 'The passwords don\'t match.';

  @override
  String get accountRuleLength => '8 characters or more';

  @override
  String get accountRuleDifferent => 'Different from the current one';

  @override
  String get languageSheetTitle => 'App\n*language*';

  @override
  String get languageSheetSubtitle => 'Changes right away, without signing out';

  @override
  String get languageSheetNote =>
      'Thousands separators and the date format change too. It stays saved on this phone.';

  @override
  String get accountTitle => 'My account';

  @override
  String get accountRole => 'Technical manager';

  @override
  String get accountHeadline => 'Your\n*account.*';

  @override
  String get accountGroupPersonal => 'PERSONAL DETAILS';

  @override
  String get accountName => 'Name';

  @override
  String get accountMobile => 'Mobile';

  @override
  String get accountEmail => 'Email';

  @override
  String get accountVerified => 'Verified';

  @override
  String get accountGroupSession => 'SESSION';

  @override
  String get accountSignOut => 'Log out';

  @override
  String get homeAlerts => 'Alerts';

  @override
  String get homeHeadlineLead => 'Your valley,';

  @override
  String get homeHeadlineEmphasis => 'today.';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonRetry => 'Try again';

  @override
  String get welcomeIntroEyebrow => 'WELCOME TO VIORA';

  @override
  String get welcomeIntroTitle => 'Your valley has\nits own *rhythm.*';

  @override
  String get welcomeIntroDescription =>
      'Viora helps you read the alternate bearing of your valley and prioritize each visit in time.';

  @override
  String get welcomeStart => 'Get started';

  @override
  String get welcomeHaveAccount => 'I already have an account';

  @override
  String get welcomePlateEyebrow => 'FOR TECHNICAL MANAGERS';

  @override
  String get welcomePlateTitle => 'The whole valley,\nin a *single read.*';

  @override
  String get welcomePlateDescription =>
      'Follow each producer\'s alternate bearing and prioritize visits where they matter most.';

  @override
  String get welcomeSkip => 'Skip';

  @override
  String onboardingStepCounter(String current, String total) {
    return '$current / $total';
  }

  @override
  String get onboardingNameTitle => 'What is\nyour *name?*';

  @override
  String get onboardingNameVoice => 'I will greet you by it every season.';

  @override
  String get onboardingNameLabel => 'First and last name';

  @override
  String get onboardingPhoneTitle => 'Which number\nshould I *text?*';

  @override
  String get onboardingPhoneVoice =>
      'I will reach you here when your grove needs it.';

  @override
  String get onboardingCountryLabel => 'Country';

  @override
  String get onboardingPhoneLabel => 'Mobile';

  @override
  String get onboardingPhoneSupporting =>
      'Only for alerts and technical coordination.';

  @override
  String get onboardingPhoneInvalidNine => 'Enter 9 digits starting with 9.';

  @override
  String get onboardingPhoneInvalidSixOrSeven =>
      'Enter 9 digits starting with 6 or 7.';

  @override
  String get countryPeru => 'Peru';

  @override
  String get countrySpain => 'Spain';

  @override
  String get countryChile => 'Chile';

  @override
  String get onboardingAlertsTitle => 'I only tell you\nwhat *matters.*';

  @override
  String get onboardingAlertsVoice =>
      'You can turn them off any time from your account.';

  @override
  String get onboardingAlertBackMeta => 'VALLEY TRAFFIC LIGHT · YESTERDAY';

  @override
  String get onboardingAlertBackBody =>
      '9 plots in La Yarada Baja became critical.';

  @override
  String get onboardingAlertFrontMeta => 'OLIVAR DEL SUR · NOW';

  @override
  String get onboardingAlertFrontBody =>
      '4 members haven\'t recorded their sampling yet.';

  @override
  String get onboardingAlertsItemLoad => 'Plots that reach a critical load';

  @override
  String get onboardingAlertsItemClimate =>
      'Climate risk by sector and El Niño';

  @override
  String get onboardingAlertsItemMembers =>
      'Members with pending sampling or thinning';

  @override
  String get onboardingAlertsEnable => 'Turn on alerts';

  @override
  String get onboardingNotNow => 'Not now';

  @override
  String onboardingSummaryTitle(String name) {
    return 'All set,\n*$name.*';
  }

  @override
  String get onboardingSummaryVoice =>
      'Check what you chose before creating your account.';

  @override
  String get onboardingSummaryName => 'NAME';

  @override
  String get onboardingSummaryPhone => 'MOBILE';

  @override
  String get onboardingSummaryAlerts => 'ALERTS';

  @override
  String get onboardingEdit => 'Edit';

  @override
  String get onboardingAlertsOn => 'On';

  @override
  String get onboardingAlertsOff => 'Off';

  @override
  String get onboardingCreate => 'Create my account';

  @override
  String get onboardingLegalNotice =>
      'By continuing you accept the Terms and conditions and the Privacy policy (Law No. 29733).';

  @override
  String get iamSignIn => 'Sign in';

  @override
  String get iamNoAccount => 'Don\'t have an account yet?';

  @override
  String get iamLetsStart => 'Let\'s start';

  @override
  String get iamSignInTitle => 'Welcome\n*back.*';

  @override
  String get iamSignInVoice => 'Sign in with your email and password.';

  @override
  String get iamEmail => 'Email';

  @override
  String get iamPassword => 'Password';

  @override
  String get iamShow => 'Show';

  @override
  String get iamHide => 'Hide';

  @override
  String get iamForgotLink => 'Forgot your password?';

  @override
  String get iamInvalidCredentials => 'Incorrect email or password.';

  @override
  String get iamOtherRoleAccount =>
      'This account isn\'t a technical manager\'s. Sign in from the Viora app for producers.';

  @override
  String get iamCreateAccount => 'Create account';

  @override
  String get iamCreateNote => 'We\'ll send you a code to verify your email.';

  @override
  String get iamCreateTitle => 'Create your\n*account.*';

  @override
  String iamCreateVoice(String name) {
    return 'I\'m keeping what you chose, $name.';
  }

  @override
  String get iamCreateVoiceAnonymous => 'I\'m keeping what you chose.';

  @override
  String get iamEmailOtherRole =>
      'This email is already signing up in the producer app. Use another email.';

  @override
  String get iamEmailTaken =>
      'This email already has an account. Sign in or use another email.';

  @override
  String get iamPasswordWeak =>
      'Use at least 8 characters, with letters and numbers.';

  @override
  String get iamRuleLength => '8 characters';

  @override
  String get iamRuleLettersNumbers => 'Letters and numbers';

  @override
  String get iamRuleMatch => 'They match';

  @override
  String get iamVerifyTitle => 'Check your\n*email.*';

  @override
  String iamVerifyVoice(String email) {
    return 'I sent a 6-digit code to $email';
  }

  @override
  String get iamCodeWrong => 'Incorrect code.';

  @override
  String iamCodeWrongAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Incorrect code. You have $count attempts left.',
      one: 'Incorrect code. You have 1 attempt left.',
    );
    return '$_temp0';
  }

  @override
  String get iamCodeBlocked => 'Too many attempts. Request a new code.';

  @override
  String get iamCodeExpired => 'This code expired. Request a new one.';

  @override
  String get iamCodeMissing =>
      'There\'s no active code for this email. Request a new one.';

  @override
  String iamResendIn(String time) {
    return 'Resend code in $time';
  }

  @override
  String get iamResendCode => 'Resend code';

  @override
  String get iamChangeEmail => 'Change email';

  @override
  String get iamCodeResent => 'I sent you a new code.';

  @override
  String get iamLinkResent => 'I sent you a new link.';

  @override
  String get iamSendLink => 'Send link';

  @override
  String get iamForgotTitle => 'Forgot your\n*password?*';

  @override
  String get iamForgotVoice =>
      'Enter your email and I\'ll send you a link to create a new one.';

  @override
  String get iamLinkSentEyebrow => 'LINK SENT';

  @override
  String get iamLinkSentTitle => 'Check your\n*email.*';

  @override
  String iamLinkSentBody(String email) {
    return 'If $email has an account, you\'ll get a single-use link to create a new password.';
  }

  @override
  String get iamOpenEmail => 'Open my email';

  @override
  String get iamResendLink => 'Resend link';

  @override
  String get iamSavePassword => 'Save password';

  @override
  String get iamNewPasswordTitle => 'Create a new\n*password.*';

  @override
  String get iamNewPasswordVoice =>
      'Use one you haven\'t used before in Viora.';

  @override
  String get iamNewPassword => 'New password';

  @override
  String get iamConfirmPassword => 'Confirm password';

  @override
  String get iamPasswordReused => 'Use one you haven\'t used before in Viora.';

  @override
  String get iamResetDoneEyebrow => 'NEW PASSWORD';

  @override
  String get iamResetDoneTitle => 'Done, you can\n*sign in.*';

  @override
  String get iamResetDoneBody =>
      'Your password was updated. For security, we closed your other sessions.';

  @override
  String get iamLinkExpiredEyebrow => 'INVALID LINK';

  @override
  String get iamLinkExpiredTitle => 'This link\n*has expired.*';

  @override
  String get iamLinkExpiredBody =>
      'For security, each link works only once and for a limited time. Request a new one.';

  @override
  String get iamRequestNewLink => 'Request a new link';

  @override
  String get iamBackToSignIn => 'Back to sign in';

  @override
  String get iamErrorOffline =>
      'No connection. Check your signal and try again.';

  @override
  String get iamErrorGeneric => 'Something went wrong. Try again.';

  @override
  String get iamErrorWait => 'Too many attempts. Wait a moment and try again.';

  @override
  String get iamErrorPhone =>
      'The server didn\'t accept this mobile number. Go back and check it.';

  @override
  String get licenseNoneEyebrow => 'ACCOUNT CREATED';

  @override
  String get licenseNoneTitle => 'You don\'t have\n*a license yet.*';

  @override
  String get licenseNoneBody =>
      'If your organization already hired Viora, enter the code we gave you.';

  @override
  String get licenseCodeNotRedeemable =>
      'Invalid or already used code. Ask the Viora team for a new one.';

  @override
  String get licenseCodeLabel => 'Manager code';

  @override
  String get licenseCodeHint => 'GEST-XXXX';

  @override
  String get licenseStatus => 'Status';

  @override
  String get licenseStatusNone => 'No license assigned';

  @override
  String get licenseStatusExpired => 'License expired';

  @override
  String get licenseEmail => 'Email';

  @override
  String get licenseActivate => 'Activate license';

  @override
  String get licenseContact => 'Not hired yet? Write to us';

  @override
  String get licenseActivatedEyebrow => 'LICENSE ACTIVATED';

  @override
  String get licenseActivatedTitle => 'Your license\n*is now active.*';

  @override
  String get licenseActivatedBody =>
      'You can now issue codes for your members and see their plots.';

  @override
  String get licenseOrganization => 'Organization';

  @override
  String get licenseQuota => 'Quota';

  @override
  String licenseQuotaValue(int seats, String hectares) {
    String _temp0 = intl.Intl.pluralLogic(
      seats,
      locale: localeName,
      other: '$seats seats',
      one: '1 seat',
    );
    return '$_temp0 · $hectares ha';
  }

  @override
  String get licenseValidity => 'Valid';

  @override
  String licenseValidUntil(String date) {
    return 'Until $date';
  }

  @override
  String get licenseGoHome => 'Go to home';

  @override
  String get licenseActiveBadge => 'Active license';

  @override
  String licenseRoleOfOrganization(String organization) {
    return ' · $organization';
  }

  @override
  String get licenseCheckFailedTitle => 'We couldn\'t check\n*your license.*';

  @override
  String get licenseRetry => 'Try again';

  @override
  String get licenseErrorOffline =>
      'No connection. Check your signal and try again.';

  @override
  String get licenseErrorGeneric => 'Something went wrong. Try again.';

  @override
  String get licenseErrorWait =>
      'Too many codes tried. Wait a few minutes and try again.';

  @override
  String get producerPlanEyebrow => 'ANNUAL SUBSCRIPTION';

  @override
  String get producerPlanTitle => 'Plan\n*Producer*';

  @override
  String get producerPlanHectares => 'YOUR HECTARES';

  @override
  String producerPlanIncrease(String step) {
    return 'Increase by $step ha';
  }

  @override
  String producerPlanDecrease(String step) {
    return 'Decrease by $step ha';
  }

  @override
  String get producerPlanIncludes => 'INCLUDES';

  @override
  String get producerPlanBenefitBbi => 'Alternate bearing diagnosis (BBI)';

  @override
  String get producerPlanBenefitClimate =>
      'Accumulated chill and water stress alerts';

  @override
  String get producerPlanBenefitSampling =>
      'Offline sampling and thinning prescription';

  @override
  String producerPlanBenefitCapacity(String hectares) {
    return 'Up to $hectares ha registered in your plots';
  }

  @override
  String get producerPlanTotal => 'ESTIMATED ANNUAL TOTAL';

  @override
  String producerPlanMonthly(String amount) {
    return 'Equivalent to $amount per month · Paid annually';
  }

  @override
  String get producerPlanTaxIncluded => 'Includes IGV';

  @override
  String producerPlanUpdated(String timestamp) {
    return 'Catalog updated: $timestamp';
  }

  @override
  String get producerPlanSavedCopy =>
      'Saved information. Refresh to check the latest conditions.';

  @override
  String get producerPlanLoading => 'Updating plan conditions…';

  @override
  String get producerPlanEmpty =>
      'No plans are available. Refresh the catalog to check again.';

  @override
  String get producerPlanCooperative => 'I have a cooperative code';
}
