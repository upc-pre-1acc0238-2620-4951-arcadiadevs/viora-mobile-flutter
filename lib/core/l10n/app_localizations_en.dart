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
  String get cooperativeOffline =>
      'No connection. Check your signal and try again.';

  @override
  String get cooperativeUnexpected => 'Something went wrong. Try again.';

  @override
  String get cooperativeNoLicense => 'Your license is not in force.';

  @override
  String get membersHeadline => 'Your\n*members.*';

  @override
  String membersVoice(Object seats, Object hectares) {
    return 'You have $seats seats and $hectares ha left to invite more members.';
  }

  @override
  String get membersVoiceFull =>
      'Your license has no free seats left. Ask to expand it to invite more members.';

  @override
  String membersLicenseEyebrow(Object year) {
    return 'License · Season $year';
  }

  @override
  String membersSeatsOf(Object seats) {
    return 'of $seats seats';
  }

  @override
  String membersLegendMembers(Object count) {
    return '$count members';
  }

  @override
  String membersLegendPending(Object count) {
    return '$count to redeem';
  }

  @override
  String membersLegendFree(Object count) {
    return '$count free';
  }

  @override
  String get membersIssueCodes => 'Issue codes';

  @override
  String get membersCodesToRedeem => 'codes to redeem';

  @override
  String membersCodesExpire(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expire on $date',
      one: '1 expires on $date',
    );
    return '$_temp0';
  }

  @override
  String get membersCodesNone => 'None pending';

  @override
  String membersReservedOf(Object total) {
    return 'reserved of $total ha';
  }

  @override
  String membersRegistered(Object hectares) {
    return '$hectares ha registered';
  }

  @override
  String get membersSection => 'Members';

  @override
  String get membersSearchHint => 'Search by name or sector';

  @override
  String membersFilterAll(Object count) {
    return 'All · $count';
  }

  @override
  String membersFilterSharing(Object count) {
    return 'Sharing · $count';
  }

  @override
  String membersFilterWithdrawn(Object count) {
    return 'Withdrew · $count';
  }

  @override
  String membersFilterUnsampled(Object count) {
    return 'Not sampled · $count';
  }

  @override
  String membersPlots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plots',
      one: '1 plot',
    );
    return '$_temp0';
  }

  @override
  String get membersNoSharedData => 'No shared data';

  @override
  String get membersLinked => 'Linked';

  @override
  String membersWithdrawnOn(Object date) {
    return 'Withdrew access · $date';
  }

  @override
  String get membersNotSharing => 'Not sharing';

  @override
  String get membersEmpty =>
      'No members yet. They show up here when they redeem a code.';

  @override
  String get membersNoMatch => 'No member matches your search.';

  @override
  String get memberTitle => 'Member';

  @override
  String memberSince(Object date) {
    return 'Member since $date';
  }

  @override
  String memberWithdrawnSince(Object date) {
    return 'Stopped sharing on $date';
  }

  @override
  String get memberWithdrawnTag => 'Withdrew access';

  @override
  String get memberPhone => 'Phone';

  @override
  String get memberEmail => 'Email';

  @override
  String get memberRegistered => 'Registered hectares';

  @override
  String memberRegisteredValue(Object registered, Object quota) {
    return '$registered of $quota ha';
  }

  @override
  String get memberCode => 'Link code';

  @override
  String memberCodeValue(Object code) {
    return '$code · redeemed';
  }

  @override
  String get memberCall => 'Call';

  @override
  String get memberWhatsapp => 'WhatsApp';

  @override
  String get memberPlots => 'Plots';

  @override
  String get memberWithdrawnNote =>
      'You no longer see their data. Their plan goes on and their seat stays taken. To free it, write to Viora support.';

  @override
  String get memberNotSharingNote =>
      'They didn\'t accept to share their data. Their plan goes on and takes a seat.';

  @override
  String memberPlotSummary(Object variety, Object hectares, Object sector) {
    return '$variety · $hectares ha · $sector';
  }

  @override
  String get memberPlotSectorPending => 'To confirm';

  @override
  String get riskOverload => 'Critical load';

  @override
  String get riskCriticalIncident => 'Critical incident';

  @override
  String get riskFrost => 'Frost expected';

  @override
  String get riskCritical => 'High risk';

  @override
  String get riskModerate => 'Watch';

  @override
  String get riskOptimal => 'Optimal';

  @override
  String get riskNoData => 'Not enough data';

  @override
  String get codesTitle => 'Activation codes';

  @override
  String codesSubtitle(Object organization, Object seats, Object hectares) {
    return '$organization · $seats seats · $hectares ha';
  }

  @override
  String get codesHeadline => 'Your\n*codes.*';

  @override
  String codesTabAvailable(Object count) {
    return 'To redeem · $count';
  }

  @override
  String codesTabRedeemed(Object count) {
    return 'Redeemed · $count';
  }

  @override
  String codesTabClosed(Object count) {
    return 'Expired · $count';
  }

  @override
  String codesIssuedOn(Object date) {
    return 'Issued on $date';
  }

  @override
  String codesExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Expires in $days days',
      one: 'Expires tomorrow',
      zero: 'Expires today',
    );
    return '$_temp0';
  }

  @override
  String codesExpiresOn(Object date) {
    return 'Expires on $date';
  }

  @override
  String codesExpiredOn(Object date) {
    return 'Expired on $date';
  }

  @override
  String get codesRevokedTag => 'Revoked';

  @override
  String codesPerCode(Object hectares) {
    return '$hectares ha per code';
  }

  @override
  String codesRedeemedBy(Object name, Object date) {
    return '$name · $date';
  }

  @override
  String get codesShare => 'Share';

  @override
  String get codesRevoke => 'Revoke';

  @override
  String codesFooterAvailable(Object seats, Object hectares) {
    return 'You have $seats seats and $hectares ha left. Each code to redeem holds them until it expires or you revoke it.';
  }

  @override
  String get codesFooterRedeemed =>
      'A redeemed code can\'t be shared or revoked anymore. Only its reference is left.';

  @override
  String get codesFooterClosed =>
      'An expired or revoked code gave its seat and hectares back to your license.';

  @override
  String get codesEmptyAvailable => 'You have no codes to redeem.';

  @override
  String get codesEmptyRedeemed => 'Nobody has redeemed a code yet.';

  @override
  String get codesEmptyClosed => 'There are no expired or revoked codes.';

  @override
  String get codesRevokedNotice => 'Code revoked';

  @override
  String get codesNotAvailable =>
      'This code had already expired or been revoked.';

  @override
  String revokeTitle(Object code) {
    return 'Revoke\n*$code?*';
  }

  @override
  String revokeBody(Object hectares) {
    return 'Nobody will be able to use it. Its seat and its $hectares ha go back to your license.';
  }

  @override
  String revokeSeats(Object from, Object to) {
    return 'seats · $from → $to ha';
  }

  @override
  String get revokeAction => 'Revoke code';

  @override
  String get cooperativeCancel => 'Cancel';

  @override
  String get redeemedTitle => 'This code\n*was redeemed*';

  @override
  String redeemedBody(Object name, Object date) {
    return '$name used it on $date. Redeemed codes can\'t be revoked.';
  }

  @override
  String get redeemedBodyUnknown =>
      'Someone used it recently. Redeemed codes can\'t be revoked.';

  @override
  String redeemedWhen(Object date) {
    return 'redeemed on $date';
  }

  @override
  String get redeemedSeeMembers => 'See members';

  @override
  String get redeemedUnderstood => 'Got it';

  @override
  String shareCodeMessage(Object organization, Object code, Object date) {
    return 'Hi, this is your code to join $organization on Viora: $code. Redeem it in the Viora app, under \"I have a cooperative code\". It expires on $date.';
  }

  @override
  String shareCodesMessage(Object organization, Object codes, Object date) {
    return 'Codes of $organization on Viora, one per member:\n$codes\nEach one is redeemed in the Viora app, under \"I have a cooperative code\". They expire on $date.';
  }

  @override
  String get issueHeadline => 'Issue\n*codes*';

  @override
  String issueSubtitle(Object organization, Object seats, Object hectares) {
    return '$organization · $seats seats and $hectares ha free';
  }

  @override
  String get issueQuantity => 'Quantity';

  @override
  String get issueQuantityCaption => 'codes · one per member';

  @override
  String get issueHectares => 'Hectares per code';

  @override
  String get issueHectaresSuggested => 'ha · suggested by your license';

  @override
  String get issueHectaresCaption => 'ha per code';

  @override
  String get issueValidity => 'Validity';

  @override
  String issueDays(Object days) {
    return '$days days';
  }

  @override
  String issuePreview(
    Object seats,
    Object fromHa,
    Object toHa,
    Object totalHa,
    Object date,
  ) {
    return 'of $seats seats · $fromHa → $toHa of $totalHa ha. They expire on $date.';
  }

  @override
  String issueSeatsExceeded(Object free) {
    return 'over the $free free seats';
  }

  @override
  String issueSeatsExceededBanner(Object seats, Object free) {
    return 'of $seats seats: over your quota. Issue up to $free or ask to expand the license.';
  }

  @override
  String issueAreaExceeded(Object hectares, Object free) {
    return '$hectares ha are over the $free ha free';
  }

  @override
  String issueAreaExceededBanner(Object free) {
    return 'ha of $free free: over your quota. Lower the hectares or ask to expand the license.';
  }

  @override
  String issueAction(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Issue $count codes',
      one: 'Issue 1 code',
    );
    return '$_temp0';
  }

  @override
  String get issueUnavailable =>
      'Codes can\'t be issued now. Let Viora support know.';

  @override
  String get issueDecrease => 'Decrease';

  @override
  String get issueIncrease => 'Increase';

  @override
  String issuedHeadline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count codes\n*ready.*',
      one: '1 code\n*ready.*',
    );
    return '$_temp0';
  }

  @override
  String issuedVoice(Object hectares) {
    return 'Share them with your members: each one activates an account, takes a seat and holds $hectares ha.';
  }

  @override
  String issuedExpire(Object date) {
    return 'They expire on $date';
  }

  @override
  String get issuedCopy => 'Copy';

  @override
  String get issuedCopied => 'Copied';

  @override
  String get issuedShareWhatsapp => 'Share on WhatsApp';

  @override
  String get issuedSeeAll => 'See all codes';

  @override
  String get riskMap => 'Map';

  @override
  String get riskList => 'List';

  @override
  String get riskYou => 'You';

  @override
  String get riskGpsOff => 'No location · showing the whole valley';

  @override
  String get riskLevelCritical => 'Critical';

  @override
  String get riskLevelModerate => 'Moderate';

  @override
  String get riskLevelNoData => 'No data';

  @override
  String get riskCountCritical => 'critical';

  @override
  String get riskCountModerate => 'moderate';

  @override
  String get riskCountOptimal => 'optimal';

  @override
  String get riskCountNoData => 'no data';

  @override
  String riskChipCritical(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count critical',
    );
    return '$_temp0';
  }

  @override
  String riskNearEyebrow(Object meters) {
    return 'Near you · GPS ± $meters m';
  }

  @override
  String get riskNearTitle => 'Within 5 km';

  @override
  String get riskNearAction => 'See visits by distance';

  @override
  String riskNearSubtitle(Object plots) {
    return 'Near you · $plots';
  }

  @override
  String get riskSectorEyebrow => 'Sector filter';

  @override
  String get riskSectorAction => 'See the sector\'s plots';

  @override
  String riskSectorSubtitle(Object plots) {
    return 'Sector · $plots';
  }

  @override
  String get riskPlotEyebrow => 'Plot chosen on the map';

  @override
  String get riskPlotAction => 'See plot';

  @override
  String riskPlotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count member plots',
      one: '1 member plot',
    );
    return '$_temp0';
  }

  @override
  String riskPlotCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plots',
      one: '1 plot',
    );
    return '$_temp0';
  }

  @override
  String riskGroupFreshness(Object plots, Object updated) {
    return '$plots · $updated';
  }

  @override
  String get riskUpdatedNow => 'updated just now';

  @override
  String riskUpdatedMinutes(Object minutes) {
    return 'updated $minutes min ago';
  }

  @override
  String riskUpdatedAt(Object date) {
    return 'updated on $date';
  }

  @override
  String get riskUpdatedUnknown => 'no reading date';

  @override
  String get riskTileCritical => 'critical plots';

  @override
  String get riskTileOverload => 'overload > 30%';

  @override
  String get riskTileFrost => 'frost ≤ 1.5 °C in 48 h';

  @override
  String get riskTileOverloadPlot => 'overload';

  @override
  String get riskTilePrescribed => 'prescribed thinning';

  @override
  String get riskTileDaysLeft => 'days left to thin';

  @override
  String riskPercent(Object value) {
    return '$value%';
  }

  @override
  String riskHectares(Object value) {
    return '$value ha';
  }

  @override
  String get riskPickerTitle => 'Choose a\n*sector.*';

  @override
  String get riskPendingTitle => 'To confirm';

  @override
  String riskPendingSummary(Object plots) {
    return '$plots · review the sector';
  }

  @override
  String get riskUnassignedTitle => 'No sector';

  @override
  String get riskReview => 'Review';

  @override
  String riskSummaryCritical(Object plots, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count critical',
    );
    return '$plots · $_temp0';
  }

  @override
  String riskSummaryModerate(Object plots, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count moderate',
    );
    return '$plots · $_temp0';
  }

  @override
  String riskSummaryNoData(Object plots) {
    return '$plots · no valid sampling';
  }

  @override
  String riskSummaryOptimal(Object plots) {
    return '$plots · no risk';
  }

  @override
  String get riskEmptyTitle => 'No plots\n*yet.*';

  @override
  String get riskEmptyBody =>
      'They will appear here once your members agree to share their data and register their plots.';

  @override
  String get riskListTitle => 'Valley risk,\n*today.*';

  @override
  String get riskMostCritical => 'Most critical';

  @override
  String get riskPermissionTitle => 'Shall we place you\n*on the map?*';

  @override
  String get riskPermissionBody =>
      'With your GPS we show you on the map and sort the plots by distance. We only use it while you look at the map.';

  @override
  String get riskPermissionAllow => 'Allow location';

  @override
  String get riskPermissionLater => 'Not now';

  @override
  String get riskScopeEmpty => 'There are no plots to show here.';

  @override
  String get riskPriorityTitle => 'By priority';

  @override
  String get riskOrderNearest => 'Closest first';

  @override
  String get riskOrderPriority => 'Priority first';

  @override
  String get riskRestTitle => 'Rest of the sector';

  @override
  String get riskRestModerate => 'Active attention alert';

  @override
  String get riskRestOptimal => 'Load within target, no frost';

  @override
  String get riskRestNoData => 'No valid sampling this season';

  @override
  String riskTogether(Object first, Object second) {
    return '$first and $second are within 1.5 km: you can see them on one trip.';
  }

  @override
  String riskHeroEyebrow(Object level) {
    return 'Sector traffic light · $level';
  }

  @override
  String riskHeroCritical(Object total) {
    return 'of $total plots in red';
  }

  @override
  String riskHeroModerate(Object total) {
    return 'of $total plots in amber';
  }

  @override
  String riskHeroOptimal(Object total) {
    return 'of $total optimal plots';
  }

  @override
  String riskHeroNoData(Object total) {
    return 'of $total plots without data';
  }

  @override
  String riskLegend(Object level, Object count) {
    return '$level $count';
  }

  @override
  String riskFrostDetail(Object value, Object day) {
    return 'Low of $value °C on $day';
  }

  @override
  String riskDistance(Object value) {
    return '$value km away';
  }

  @override
  String riskProposedSector(Object name) {
    return 'wrote “$name”';
  }

  @override
  String riskReasonOverload(Object value) {
    return 'Overload $value%';
  }

  @override
  String riskReasonFrost(Object value, Object day) {
    return 'Frost $value °C · $day';
  }

  @override
  String get riskDossierAction => 'See provisional dossier';

  @override
  String get riskReadOnly => 'Read only';

  @override
  String riskReadAt(Object when) {
    return 'Updated $when';
  }

  @override
  String riskToday(Object time) {
    return 'today, $time';
  }

  @override
  String get riskLoadTitle => 'Fruit load';

  @override
  String get riskLoadUnit => 'Fruits per shoot';

  @override
  String get riskLoadEstimated => 'Estimated';

  @override
  String get riskLoadTarget => 'Sustainable target';

  @override
  String get riskTonsAfterThinning => 'estimated t/ha after thinning';

  @override
  String riskOverloadNotice(Object percent, Object year) {
    return '$percent% more fruit than the tree can carry. Left unregulated, alternate bearing goes on and $year would be a strong OFF year.';
  }

  @override
  String riskSampleBasis(Object trees, Object day) {
    return 'Based on $trees trees · round of $day';
  }

  @override
  String get riskPrescriptionEyebrow => 'Prescription · thinning';

  @override
  String get riskPrescriptionUnit => 'of the fruits';

  @override
  String riskPrescriptionBody(Object name, Object count) {
    return 'Prescribed to $name: remove $count of every 10 fruitlets, starting with the most loaded branches.';
  }

  @override
  String riskWindowFrom(Object day) {
    return 'From $day';
  }

  @override
  String riskWindowUntil(Object day) {
    return 'Until $day';
  }

  @override
  String get riskWindowClosed => 'The window has closed';

  @override
  String riskWindowOpens(Object day) {
    return 'Opens on $day';
  }

  @override
  String riskWindowDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
      zero: 'Last day',
    );
    return '$_temp0';
  }

  @override
  String get riskThinningMissing => 'Thinning not registered yet';

  @override
  String riskThinningDone(Object day) {
    return 'Thinning registered on $day';
  }

  @override
  String get riskBearingEyebrow => 'Alternate bearing · for information';

  @override
  String riskBearingBand(Object band) {
    return 'BBI · $band alternation';
  }

  @override
  String get riskBearingHigh => 'high';

  @override
  String get riskBearingModerate => 'moderate';

  @override
  String get riskBearingLow => 'mild';

  @override
  String get riskBearingNote => 'It doesn\'t change the traffic light.';

  @override
  String get riskNoDataTitle => 'Not enough\n*data*';

  @override
  String get riskNoDataBody =>
      'This plot has no valid fruit-set sampling this season yet. Without it we can\'t work out its load: it stays grey, never green.';

  @override
  String get riskNoDataSampling => 'Fruit-set sampling';

  @override
  String riskNoDataSamplingValue(Object sampled, Object required) {
    return '$sampled of $required trees';
  }

  @override
  String get riskNoDataLoadValue => 'estimated after sampling';

  @override
  String get riskNoDataPrescription => 'Thinning prescription';

  @override
  String get riskNoDataPrescriptionValue => 'pending';

  @override
  String riskNoDataVoice(Object name, Object trees) {
    return 'Write to $name: with $trees trees sampled we can assess their plot.';
  }

  @override
  String get alertsPreferences => 'Alert preferences';

  @override
  String alertsActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'active alerts',
      one: 'active alert',
    );
    return '$_temp0';
  }

  @override
  String alertsWhere(Object sectors, Object time) {
    return 'In $sectors · updated $time';
  }

  @override
  String alertsCalm(Object time) {
    return 'Your sectors are calm · updated $time';
  }

  @override
  String alertsSectorsJoin(Object first, Object last) {
    return '$first and $last';
  }

  @override
  String get alertsFilterCritical => 'Critical';

  @override
  String get alertsFilterAttention => 'Attention';

  @override
  String get alertsFilterNormalized => 'Normalized';

  @override
  String get alertsToday => 'Today';

  @override
  String get alertsYesterday => 'Yesterday';

  @override
  String get alertsNormalizedTitle => 'Normalized · last 7 days';

  @override
  String get alertsFilteredEmpty => 'No alerts in this group.';

  @override
  String get alertsChipCritical => 'Critical';

  @override
  String get alertsChipAttention => 'Attention';

  @override
  String get alertsAgoNow => 'Just now';

  @override
  String alertsAgoMinutes(int minutes) {
    return '$minutes min ago';
  }

  @override
  String alertsAgoHours(int hours) {
    return '$hours h ago';
  }

  @override
  String alertsSectorCriticalTitle(Object sector) {
    return '$sector turned Critical';
  }

  @override
  String alertsFrostTitle(Object sector) {
    return 'Radiative frost in $sector';
  }

  @override
  String alertsOverloadBody(Object producer, Object value, Object plots) {
    return '$producer recorded an overload of $value %. $plots';
  }

  @override
  String alertsIncidentBody(Object producer, Object plots) {
    return '$producer reported a critical incident. $plots';
  }

  @override
  String alertsRedPlots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'There are now $count plots in red in the sector.',
      one: 'There is now 1 plot in red in the sector.',
    );
    return '$_temp0';
  }

  @override
  String alertsFrostForecastBody(Object value, Object day) {
    return 'Forecast low of $value °C on $day. Let the sector\'s members know.';
  }

  @override
  String alertsFrostIncidentBody(Object producer, Object plot) {
    return '$producer reported frost on $plot. Let the sector\'s members know.';
  }

  @override
  String alertsFrostPlots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plots exposed. Let the sector\'s members know.',
      one: '1 plot exposed. Let the sector\'s members know.',
    );
    return '$_temp0';
  }

  @override
  String get alertsOpenSector => 'Open sector';

  @override
  String alertsBackTo(Object sector, Object level) {
    return '$sector went back to $level';
  }

  @override
  String alertsFrostPassed(Object sector) {
    return 'The frost passed in $sector';
  }

  @override
  String alertsNormalizedPlain(Object sector) {
    return '$sector normalized';
  }

  @override
  String get dossierTitle => 'Technical dossier';

  @override
  String dossierSubtitle(Object plot, Object year) {
    return '$plot · $year season';
  }

  @override
  String get dossierEyebrow => 'Agronomic dossier · Provisional';

  @override
  String get dossierCampaign => 'Season';

  @override
  String dossierCampaignValue(Object year) {
    return '$year · in progress';
  }

  @override
  String get dossierVarietyArea => 'Variety and area';

  @override
  String get dossierLoad => 'Fruit load';

  @override
  String dossierLoadValue(Object fruits) {
    return '$fruits fruits/shoot';
  }

  @override
  String get dossierPrescription => 'Prescription';

  @override
  String dossierPrescriptionValue(Object percent) {
    return 'Thin $percent';
  }

  @override
  String get dossierThinning => 'Thinning registered';

  @override
  String get dossierThinningMissing => 'Not yet';

  @override
  String get dossierClimate => 'Climate and telemetry';

  @override
  String dossierNodes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nodes',
      one: '1 node',
    );
    return '$_temp0';
  }

  @override
  String dossierDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days of data',
      one: '1 day of data',
    );
    return '$_temp0';
  }

  @override
  String get dossierNotAvailable => 'Not available';

  @override
  String get dossierProvisionalEyebrow => 'Provisional · Not certified';

  @override
  String dossierCutOff(Object when) {
    return 'Cut-off $when';
  }

  @override
  String get dossierProvisionalBody =>
      'It shows the data of that moment and may change. It has no verification code: the producer seals the final dossier when the season closes.';

  @override
  String get dossierDownload => 'Download PDF';

  @override
  String get dossierShare => 'Share';

  @override
  String dossierShareSubject(Object plot) {
    return 'Provisional dossier · $plot';
  }

  @override
  String get dossierSaved => 'PDF saved';

  @override
  String get dossierNotShared => 'This member no longer shares the plot.';

  @override
  String homeManagerSubtitle(String organization) {
    return '$organization · technician';
  }

  @override
  String get homeVoiceNoPlots =>
      'No member shares a plot yet: issue codes to invite them.';

  @override
  String homeVoiceOverload(String sector, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plots overloaded',
      one: '1 plot overloaded',
    );
    return '$sector needs your visit: $_temp0.';
  }

  @override
  String homeVoiceCritical(String sector, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plots in red',
      one: '1 plot in red',
    );
    return '$sector needs your visit: $_temp0.';
  }

  @override
  String homeVoiceCriticalValley(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plots in red are waiting for your visit.',
      one: 'A plot in red is waiting for your visit.',
    );
    return '$_temp0';
  }

  @override
  String homeVoiceFrost(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plots',
      one: '1 plot',
    );
    return 'Frost is coming: $_temp0 under 1.5 °C within 48 h.';
  }

  @override
  String get homeVoiceCalm => 'Your valley is calm: no plot in red.';

  @override
  String homeValleyEyebrow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plots',
      one: '1 plot',
    );
    return 'Valley traffic light · $_temp0';
  }

  @override
  String homeValleyCritical(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'critical\nplots',
      one: 'critical\nplot',
    );
    return '$_temp0';
  }

  @override
  String get homeOpenRisk => 'See territorial risk';

  @override
  String get homeLicenseTitle => 'Your license';

  @override
  String homeCampaign(String year) {
    return 'Season $year';
  }

  @override
  String get homeIntakeLabel => 'Intake';

  @override
  String homeTons(String tons) {
    return '$tons t';
  }

  @override
  String get homeIntakeProjected => 'projected';

  @override
  String get homeIntakeSettled => 'delivered';

  @override
  String get homeIntakeNoData => 'no samplings yet';

  @override
  String homeIntakeGreen(String tons) {
    return '$tons t green';
  }

  @override
  String homeIntakeBlack(String tons) {
    return '$tons t black';
  }

  @override
  String homeIntakeUnclassified(String tons) {
    return '$tons t unclassified';
  }

  @override
  String homeIntakeCoverage(int percent) {
    return 'Coverage $percent %';
  }

  @override
  String homeFrostAlerts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'frost alerts',
      one: 'frost alert',
    );
    return '$_temp0\n≤ 1.5 °C within 48 h';
  }

  @override
  String get homeSeatsLabel => 'seats of the license';

  @override
  String get homeVisitsTitle => 'Suggested visits';

  @override
  String get homeVisitsSeeAll => 'See all';

  @override
  String get homeVisitsNone => 'No plot needs a visit today.';

  @override
  String get sectorsTitle => 'Sectors';

  @override
  String get sectorsSubtitle => 'Your license\'s list';

  @override
  String get sectorsHeadline => 'Your\n*sectors.*';

  @override
  String get sectorsPendingTitle => 'To confirm';

  @override
  String sectorsPendingCount(int count) {
    return '$count to review';
  }

  @override
  String sectorsPendingLine(String producer, String plot) {
    return '$producer · $plot';
  }

  @override
  String get sectorsListTitle => 'Your list';

  @override
  String sectorsListCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sectors',
      one: '1 sector',
    );
    return '$_temp0';
  }

  @override
  String sectorsPlotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plots',
      one: '1 plot',
      zero: 'No plots yet',
    );
    return '$_temp0';
  }

  @override
  String get sectorsReview => 'Review';

  @override
  String get sectorsRename => 'Rename';

  @override
  String get sectorsAdd => 'Add sector';

  @override
  String get sectorsNote =>
      'Sectors belong to your license. Renaming updates all its plots; they are not deleted.';

  @override
  String get sectorsEmpty => 'Your list has no sectors yet.';

  @override
  String get sectorAddHeadline => 'Add\n*sector*';

  @override
  String get sectorRenameHeadline => 'Rename\n*sector*';

  @override
  String get sectorNameLabel => 'Sector name';

  @override
  String get sectorNamePlaceholder => 'Cerro Blanco';

  @override
  String get sectorNameHint =>
      'Accents and case don\'t count: «cerro blanco» and «Cerro Blanco» are the same sector.';

  @override
  String get sectorSave => 'Save sector';

  @override
  String get sectorRenameSave => 'Save name';

  @override
  String get sectorNameTaken =>
      'Your list already has a sector with that name.';

  @override
  String get sectorNameInvalid => 'Write between 2 and 60 letters.';

  @override
  String get sectorSaveOffline =>
      'No connection. Try again when you have signal.';

  @override
  String get sectorSaveFailed => 'It could not be saved. Try again.';

  @override
  String get sectorReviewSameAs => 'It is the same as';

  @override
  String get sectorReviewHint =>
      'It only sorts your panel: the member\'s plot doesn\'t change.';

  @override
  String get sectorReviewAdd => 'Add as a sector';

  @override
  String sectorReviewJoin(String sector) {
    return 'Join $sector';
  }

  @override
  String membersSectorsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sectors in your list',
      one: '1 sector in your list',
    );
    return '$_temp0';
  }

  @override
  String membersSectorsPending(int count) {
    return '$count to confirm';
  }

  @override
  String intakeCampaign(String year) {
    return 'Season $year';
  }

  @override
  String get intakeChooseCampaign => 'Choose season';

  @override
  String get intakeHeadlineProjected => 'Your intake,\n*projected.*';

  @override
  String get intakeHeadlineSettled => 'Your intake,\n*recorded.*';

  @override
  String get intakeHeadlineNoData => 'Your intake,\n*no figure yet.*';

  @override
  String intakeVoiceSufficient(int count) {
    return 'It adds up only the estimable plots, without extrapolating. $count still to sample.';
  }

  @override
  String get intakeVoiceAllSampled =>
      'It adds up only the estimable plots, without extrapolating.';

  @override
  String intakeVoicePreliminary(int percent) {
    return 'Only $percent % of the plots are sampled: use this figure with care for contracts.';
  }

  @override
  String get intakeVoiceSettled =>
      'It is the real intake the members settled since they joined.';

  @override
  String intakeEyebrowProjection(String year) {
    return 'PROJECTION · SEASON $year';
  }

  @override
  String intakeEyebrowSettled(String year) {
    return 'REAL INTAKE · SEASON $year';
  }

  @override
  String get intakeTagSufficient => 'Enough coverage';

  @override
  String get intakeTagPreliminary => 'Preliminary';

  @override
  String get intakeTagClosed => 'Closed';

  @override
  String get intakeTagPartial => 'Partial';

  @override
  String get intakeTonsUnit => 'tons';

  @override
  String intakeUncertainty(int sampled, int plots) {
    return 'High margin of uncertainty · $sampled of $plots plots';
  }

  @override
  String get intakeGreenHistory => 'Green · by history';

  @override
  String get intakeBlackHistory => 'Black · by history';

  @override
  String get intakeGreenSettled => 'Green · settled';

  @override
  String get intakeBlackSettled => 'Black · settled';

  @override
  String intakePercent(int percent) {
    return '$percent %';
  }

  @override
  String intakeUnclassified(String tons, int percent) {
    return '$tons t unclassified · $percent %';
  }

  @override
  String get intakeCoverageLabel => 'SAMPLING COVERAGE';

  @override
  String get intakeSettledCoverageLabel => 'SETTLED HARVESTS';

  @override
  String intakeCoveragePlots(int sampled, int plots) {
    return '$sampled of $plots plots';
  }

  @override
  String intakeOf(int sampled, int plots) {
    return '$sampled of $plots';
  }

  @override
  String intakeThreshold(int percent) {
    return '$percent % · preliminary threshold';
  }

  @override
  String intakeCoverageSufficient(int estimable, int plots, int threshold) {
    return '$estimable of $plots plots are estimable. From $threshold % sampling the projection stops being preliminary.';
  }

  @override
  String intakeCoveragePreliminary(int estimable, int plots, int threshold) {
    return '$estimable of $plots plots are estimable. The projection is preliminary until sampling reaches $threshold %.';
  }

  @override
  String intakeMissingPlots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more to get there.',
      one: '1 more to get there.',
    );
    return '$_temp0';
  }

  @override
  String intakeCoverageSettled(int settled, int plots, String year) {
    return '$settled of $plots plots settled their harvest of the $year season.';
  }

  @override
  String get intakeBySector => 'By sector';

  @override
  String intakeSectorSampled(int sampled, int plots) {
    return '$sampled of $plots sampled';
  }

  @override
  String intakeSectorSettled(int sampled, int plots) {
    return '$sampled of $plots with harvest';
  }

  @override
  String intakeSectorNoData(int sampled, int plots) {
    return '$sampled of $plots · no data';
  }

  @override
  String intakeSectorPending(int sampled, int plots) {
    return '$sampled of $plots · check the sector';
  }

  @override
  String get intakeNoDataTitle => 'Not enough data\nto project';

  @override
  String intakeNoDataBody(String year) {
    return 'No member recorded a fruit set sampling in the $year season. The projection shows up with the first samplings, marked as preliminary.';
  }

  @override
  String intakeNoEstimableBody(String year) {
    return 'There are samplings in the $year season, but no plot is estimable yet: it lacks its yield estimate or its area.';
  }

  @override
  String get intakeSettledNoDataTitle => 'No settled\nharvests';

  @override
  String intakeSettledNoDataBody(String year) {
    return 'No member settled their harvest of the $year season since joining.';
  }

  @override
  String get intakeMembersWithoutSampling => 'See members without sampling';

  @override
  String get intakeSheetTitle => 'Choose the\n*season*';

  @override
  String intakeSheetInProgress(String tons) {
    return 'In progress · projection $tons t';
  }

  @override
  String get intakeSheetInProgressNoData => 'In progress · no figure yet';

  @override
  String intakeSheetClosed(String tons) {
    return 'Closed · real intake $tons t';
  }

  @override
  String intakeSheetPartial(String tons) {
    return 'Partial · real intake $tons t';
  }

  @override
  String get intakeSheetSettledNoData => 'No settled harvests';

  @override
  String get intakeSheetNote =>
      'In closed seasons you see the real intake the members recorded.';

  @override
  String offlineToday(String what, String when) {
    return 'Offline · $what from $when';
  }

  @override
  String offlineOn(String what, String when) {
    return 'Offline · $what from $when';
  }

  @override
  String get offlineWhatState => 'last state';

  @override
  String get offlineWhatProjection => 'projection';

  @override
  String get offlineWhatIntake => 'intake';

  @override
  String get offlineWhatAlerts => 'alerts';

  @override
  String riskSavedAt(String when) {
    return 'saved $when';
  }
}
