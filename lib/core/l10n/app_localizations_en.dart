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
}
