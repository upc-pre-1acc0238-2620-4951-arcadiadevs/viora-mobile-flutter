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
}
