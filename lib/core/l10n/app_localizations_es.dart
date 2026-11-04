// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navHome => 'Inicio';

  @override
  String get navRisk => 'Riesgo';

  @override
  String get navCollection => 'Acopio';

  @override
  String get navMembers => 'Socios';

  @override
  String get placeholderComingSoon => 'Próximamente';

  @override
  String homeGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get homeGreetingAnonymous => 'Hola';

  @override
  String get accountLanguageNotice => 'Idioma: Español';

  @override
  String get accountGroupSecurity => 'SEGURIDAD';

  @override
  String get accountChangePassword => 'Cambiar contraseña';

  @override
  String get accountGroupPreferences => 'PREFERENCIAS';

  @override
  String get accountLanguage => 'Idioma';

  @override
  String get accountLanguageSpanish => 'Español';

  @override
  String get accountLanguageEnglish => 'English';

  @override
  String get accountNotifications => 'Notificaciones';

  @override
  String get accountNotificationsOn => 'Activadas';

  @override
  String get accountNotificationsOff => 'Desactivadas';

  @override
  String accountVersion(String version) {
    return 'Viora $version · Android · iOS';
  }

  @override
  String get accountDetailsSaved => 'Cambios guardados';

  @override
  String get accountPasswordChanged => 'Contraseña actualizada';

  @override
  String get accountDetailsTitle => 'Datos personales';

  @override
  String get accountDetailsHeadline => 'Tus\n*datos.*';

  @override
  String get accountFullName => 'Nombre completo';

  @override
  String get accountFullNamePlaceholder => 'Escribe tu nombre';

  @override
  String get accountFullNameRequired => 'Tu nombre es obligatorio.';

  @override
  String accountPhoneLabel(String country, String dialCode) {
    return 'Celular · $country $dialCode';
  }

  @override
  String accountPhoneHelper(String example) {
    return 'Formato internacional: $example';
  }

  @override
  String get accountEmailHelper => 'Verificado · se usa para entrar a Viora';

  @override
  String get accountSaveChanges => 'Guardar cambios';

  @override
  String get accountSaveOffline =>
      'Sin conexión: tus cambios no se guardaron. Inténtalo de nuevo.';

  @override
  String get accountSaveFailed =>
      'No pudimos guardar tus cambios. Inténtalo de nuevo.';

  @override
  String get accountSecurityTitle => 'Seguridad';

  @override
  String get accountPasswordHeadline => 'Nueva\n*contraseña.*';

  @override
  String get accountCurrentPassword => 'Contraseña actual';

  @override
  String get accountCurrentPasswordWrong =>
      'La contraseña actual no es correcta.';

  @override
  String get accountConfirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get accountPasswordRules => 'No cumple los requisitos de abajo.';

  @override
  String get accountPasswordMismatch => 'Las contraseñas no coinciden.';

  @override
  String get accountRuleLength => '8 caracteres o más';

  @override
  String get accountRuleDifferent => 'Distinta a la actual';

  @override
  String get languageSheetTitle => 'Idioma\n*de la app*';

  @override
  String get languageSheetSubtitle => 'Cambia al instante, sin cerrar sesión';

  @override
  String get languageSheetNote =>
      'También cambian los separadores de miles y el formato de fechas. Queda guardado en este teléfono.';

  @override
  String get accountTitle => 'Mi cuenta';

  @override
  String get accountRole => 'Gestor técnico';

  @override
  String get accountHeadline => 'Tu\n*cuenta.*';

  @override
  String get accountGroupPersonal => 'DATOS PERSONALES';

  @override
  String get accountName => 'Nombre';

  @override
  String get accountMobile => 'Celular';

  @override
  String get accountEmail => 'Correo';

  @override
  String get accountVerified => 'Verificado';

  @override
  String get accountGroupSession => 'SESIÓN';

  @override
  String get accountSignOut => 'Cerrar sesión';

  @override
  String get homeAlerts => 'Alertas';

  @override
  String get homeHeadlineLead => 'Tu valle,';

  @override
  String get homeHeadlineEmphasis => 'hoy.';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get welcomeIntroEyebrow => 'BIENVENIDO A VIORA';

  @override
  String get welcomeIntroTitle => 'Tu valle tiene\nsu propio *ritmo.*';

  @override
  String get welcomeIntroDescription =>
      'Viora te ayuda a leer la vecería de tu valle y a priorizar cada visita con tiempo.';

  @override
  String get welcomeStart => 'Comenzar';

  @override
  String get welcomeHaveAccount => 'Ya tengo una cuenta';

  @override
  String get welcomePlateEyebrow => 'PARA GESTORES TÉCNICOS';

  @override
  String get welcomePlateTitle => 'Todo el valle, en\nuna *sola lectura.*';

  @override
  String get welcomePlateDescription =>
      'Sigue la alternancia de cada productor y prioriza tus visitas técnicas donde más importan.';

  @override
  String get welcomeSkip => 'Omitir';

  @override
  String onboardingStepCounter(String current, String total) {
    return '$current / $total';
  }

  @override
  String get onboardingNameTitle => '¿Cómo te\n*llamas?*';

  @override
  String get onboardingNameVoice => 'Así te saludaré en cada campaña.';

  @override
  String get onboardingNameLabel => 'Nombre y apellido';

  @override
  String get onboardingPhoneTitle => '¿A qué número\nte *avisamos?*';

  @override
  String get onboardingPhoneVoice =>
      'Te aviso por aquí cuando tu olivar lo necesite.';

  @override
  String get onboardingCountryLabel => 'País';

  @override
  String get onboardingPhoneLabel => 'Celular';

  @override
  String get onboardingPhoneSupporting =>
      'Solo para avisos y coordinación técnica.';

  @override
  String get onboardingPhoneInvalidNine =>
      'Ingresa 9 dígitos que empiecen con 9.';

  @override
  String get onboardingPhoneInvalidSixOrSeven =>
      'Ingresa 9 dígitos que empiecen con 6 o 7.';

  @override
  String get countryPeru => 'Perú';

  @override
  String get countrySpain => 'España';

  @override
  String get countryChile => 'Chile';

  @override
  String get onboardingAlertsTitle => 'Te aviso solo\nlo *importante.*';

  @override
  String get onboardingAlertsVoice =>
      'Puedes apagarlas cuando quieras desde tu cuenta.';

  @override
  String get onboardingAlertBackMeta => 'SEMÁFORO DEL VALLE · AYER';

  @override
  String get onboardingAlertBackBody =>
      '9 parcelas de La Yarada Baja pasaron a crítico.';

  @override
  String get onboardingAlertFrontMeta => 'OLIVAR DEL SUR · AHORA';

  @override
  String get onboardingAlertFrontBody =>
      '4 socios aún no registran su muestreo.';

  @override
  String get onboardingAlertsItemLoad => 'Parcelas que pasan a carga crítica';

  @override
  String get onboardingAlertsItemClimate =>
      'Riesgo climático por sector y El Niño';

  @override
  String get onboardingAlertsItemMembers =>
      'Socios con muestreo o aclareo pendiente';

  @override
  String get onboardingAlertsEnable => 'Activar alertas';

  @override
  String get onboardingNotNow => 'Ahora no';

  @override
  String onboardingSummaryTitle(String name) {
    return 'Todo listo,\n*$name.*';
  }

  @override
  String get onboardingSummaryVoice =>
      'Revisa lo que elegiste antes de crear tu cuenta.';

  @override
  String get onboardingSummaryName => 'NOMBRE';

  @override
  String get onboardingSummaryPhone => 'CELULAR';

  @override
  String get onboardingSummaryAlerts => 'ALERTAS';

  @override
  String get onboardingEdit => 'Editar';

  @override
  String get onboardingAlertsOn => 'Activadas';

  @override
  String get onboardingAlertsOff => 'Desactivadas';

  @override
  String get onboardingCreate => 'Crear mi cuenta';

  @override
  String get onboardingLegalNotice =>
      'Al continuar aceptas los Términos y condiciones y la Política de privacidad (Ley N.° 29733).';

  @override
  String get iamSignIn => 'Iniciar sesión';

  @override
  String get iamNoAccount => '¿Aún no tienes cuenta?';

  @override
  String get iamLetsStart => 'Empecemos';

  @override
  String get iamSignInTitle => 'Hola de\n*nuevo.*';

  @override
  String get iamSignInVoice => 'Entra con tu correo y contraseña.';

  @override
  String get iamEmail => 'Correo electrónico';

  @override
  String get iamPassword => 'Contraseña';

  @override
  String get iamShow => 'Mostrar';

  @override
  String get iamHide => 'Ocultar';

  @override
  String get iamForgotLink => '¿Olvidaste tu contraseña?';

  @override
  String get iamInvalidCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get iamOtherRoleAccount =>
      'Esta cuenta no es de gestor técnico. Entra desde la app de Viora para productores.';

  @override
  String get iamCreateAccount => 'Crear cuenta';

  @override
  String get iamCreateNote =>
      'Te enviaremos un código para verificar tu correo.';

  @override
  String get iamCreateTitle => 'Crea tu\n*cuenta.*';

  @override
  String iamCreateVoice(String name) {
    return 'Guardo lo que elegiste, $name.';
  }

  @override
  String get iamCreateVoiceAnonymous => 'Guardo lo que elegiste.';

  @override
  String get iamEmailOtherRole =>
      'Este correo ya se está registrando en la app de productores. Usa otro correo.';

  @override
  String get iamEmailTaken =>
      'Este correo ya tiene una cuenta. Inicia sesión o usa otro correo.';

  @override
  String get iamPasswordWeak =>
      'Usa al menos 8 caracteres, con letras y números.';

  @override
  String get iamRuleLength => '8 caracteres';

  @override
  String get iamRuleLettersNumbers => 'Letras y números';

  @override
  String get iamRuleMatch => 'Coinciden';

  @override
  String get iamVerifyTitle => 'Revisa tu\n*correo.*';

  @override
  String iamVerifyVoice(String email) {
    return 'Te envié un código de 6 dígitos a $email';
  }

  @override
  String get iamCodeWrong => 'Código incorrecto.';

  @override
  String iamCodeWrongAttempts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Código incorrecto. Te quedan $count intentos.',
      one: 'Código incorrecto. Te queda 1 intento.',
    );
    return '$_temp0';
  }

  @override
  String get iamCodeBlocked => 'Demasiados intentos. Pide un código nuevo.';

  @override
  String get iamCodeExpired => 'Este código venció. Pide uno nuevo.';

  @override
  String get iamCodeMissing =>
      'No hay un código activo para este correo. Pide uno nuevo.';

  @override
  String iamResendIn(String time) {
    return 'Reenviar código en $time';
  }

  @override
  String get iamResendCode => 'Reenviar código';

  @override
  String get iamChangeEmail => 'Cambiar correo';

  @override
  String get iamCodeResent => 'Te envié un código nuevo.';

  @override
  String get iamLinkResent => 'Te envié un enlace nuevo.';

  @override
  String get iamSendLink => 'Enviar enlace';

  @override
  String get iamForgotTitle => '¿Olvidaste tu\n*contraseña?*';

  @override
  String get iamForgotVoice =>
      'Escribe tu correo y te envío un enlace para crear una nueva.';

  @override
  String get iamLinkSentEyebrow => 'ENLACE ENVIADO';

  @override
  String get iamLinkSentTitle => 'Revisa tu\n*correo.*';

  @override
  String iamLinkSentBody(String email) {
    return 'Si $email tiene una cuenta, te llegará un enlace de un solo uso para crear una nueva contraseña.';
  }

  @override
  String get iamOpenEmail => 'Abrir mi correo';

  @override
  String get iamResendLink => 'Reenviar enlace';

  @override
  String get iamSavePassword => 'Guardar contraseña';

  @override
  String get iamNewPasswordTitle => 'Crea una nueva\n*contraseña.*';

  @override
  String get iamNewPasswordVoice =>
      'Usa una que no hayas usado antes en Viora.';

  @override
  String get iamNewPassword => 'Nueva contraseña';

  @override
  String get iamConfirmPassword => 'Confirmar contraseña';

  @override
  String get iamPasswordReused => 'Usa una que no hayas usado antes en Viora.';

  @override
  String get iamResetDoneEyebrow => 'CONTRASEÑA NUEVA';

  @override
  String get iamResetDoneTitle => 'Listo, ya puedes\n*entrar.*';

  @override
  String get iamResetDoneBody =>
      'Tu contraseña se actualizó. Por seguridad, cerramos tus otras sesiones.';

  @override
  String get iamLinkExpiredEyebrow => 'ENLACE NO VÁLIDO';

  @override
  String get iamLinkExpiredTitle => 'Este enlace\n*ya venció.*';

  @override
  String get iamLinkExpiredBody =>
      'Por seguridad, cada enlace sirve una sola vez y por tiempo limitado. Pide uno nuevo.';

  @override
  String get iamRequestNewLink => 'Solicitar nuevo enlace';

  @override
  String get iamBackToSignIn => 'Volver a iniciar sesión';

  @override
  String get iamErrorOffline =>
      'Sin conexión. Revisa tu señal e inténtalo de nuevo.';

  @override
  String get iamErrorGeneric => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get iamErrorWait =>
      'Demasiados intentos. Espera un momento e inténtalo de nuevo.';

  @override
  String get iamErrorPhone =>
      'El servidor no aceptó este celular. Vuelve atrás y revísalo.';
}
