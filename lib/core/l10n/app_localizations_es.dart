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

  @override
  String get licenseNoneEyebrow => 'CUENTA CREADA';

  @override
  String get licenseNoneTitle => 'Aún no tienes\n*una licencia.*';

  @override
  String get licenseNoneBody =>
      'Si tu organización ya contrató Viora, ingresa el código que te entregamos.';

  @override
  String get licenseCodeNotRedeemable =>
      'Código no válido o ya usado. Pide uno nuevo al equipo de Viora.';

  @override
  String get licenseCodeLabel => 'Código de gestor';

  @override
  String get licenseCodeHint => 'GEST-XXXX';

  @override
  String get licenseStatus => 'Estado';

  @override
  String get licenseStatusNone => 'Sin licencia asignada';

  @override
  String get licenseStatusExpired => 'Licencia vencida';

  @override
  String get licenseEmail => 'Correo';

  @override
  String get licenseActivate => 'Activar licencia';

  @override
  String get licenseContact => '¿Aún no contrató? Escríbenos';

  @override
  String get licenseActivatedEyebrow => 'LICENCIA ACTIVADA';

  @override
  String get licenseActivatedTitle => 'Tu licencia\n*ya está activa.*';

  @override
  String get licenseActivatedBody =>
      'Ya puedes generar códigos para tus socios y ver sus lotes.';

  @override
  String get licenseOrganization => 'Organización';

  @override
  String get licenseQuota => 'Cupo';

  @override
  String licenseQuotaValue(int seats, String hectares) {
    String _temp0 = intl.Intl.pluralLogic(
      seats,
      locale: localeName,
      other: '$seats plazas',
      one: '1 plaza',
    );
    return '$_temp0 · $hectares ha';
  }

  @override
  String get licenseValidity => 'Vigencia';

  @override
  String licenseValidUntil(String date) {
    return 'Hasta el $date';
  }

  @override
  String get licenseGoHome => 'Ir al inicio';

  @override
  String get licenseActiveBadge => 'Licencia activa';

  @override
  String licenseRoleOfOrganization(String organization) {
    return ' · $organization';
  }

  @override
  String get licenseCheckFailedTitle => 'No pudimos revisar\n*tu licencia.*';

  @override
  String get licenseRetry => 'Reintentar';

  @override
  String get licenseErrorOffline =>
      'Sin conexión. Revisa tu señal e inténtalo de nuevo.';

  @override
  String get licenseErrorGeneric => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get licenseErrorWait =>
      'Probaste demasiados códigos. Espera unos minutos e inténtalo de nuevo.';

  @override
  String get producerPlanEyebrow => 'SUSCRIPCIÓN ANUAL';

  @override
  String get producerPlanTitle => 'Plan\n*Productor*';

  @override
  String get producerPlanHectares => 'TUS HECTÁREAS';

  @override
  String producerPlanIncrease(String step) {
    return 'Aumentar $step ha';
  }

  @override
  String producerPlanDecrease(String step) {
    return 'Disminuir $step ha';
  }

  @override
  String get producerPlanIncludes => 'INCLUYE';

  @override
  String get producerPlanBenefitBbi => 'Diagnóstico de vecería (BBI)';

  @override
  String get producerPlanBenefitClimate =>
      'Frío acumulado y alertas de estrés hídrico';

  @override
  String get producerPlanBenefitSampling =>
      'Muestreo sin señal y prescripción de aclareo';

  @override
  String producerPlanBenefitCapacity(String hectares) {
    return 'Hasta $hectares ha registradas en tus lotes';
  }

  @override
  String get producerPlanTotal => 'TOTAL ANUAL ESTIMADO';

  @override
  String producerPlanMonthly(String amount) {
    return 'Equivale a $amount al mes · Pago anual';
  }

  @override
  String get producerPlanTaxIncluded => 'Incluye IGV';

  @override
  String producerPlanUpdated(String timestamp) {
    return 'Catálogo actualizado: $timestamp';
  }

  @override
  String get producerPlanSavedCopy =>
      'Información guardada. Actualiza para verificar las condiciones vigentes.';

  @override
  String get producerPlanLoading => 'Actualizando las condiciones del plan…';

  @override
  String get producerPlanEmpty =>
      'No hay planes disponibles. Actualiza el catálogo para volver a consultar.';

  @override
  String get producerPlanCooperative => 'Tengo un código de cooperativa';

  @override
  String get cooperativeOffline =>
      'Sin conexión. Revisa tu señal e inténtalo de nuevo.';

  @override
  String get cooperativeUnexpected => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get cooperativeNoLicense => 'Tu licencia no está vigente.';

  @override
  String get membersHeadline => 'Tus\n*socios.*';

  @override
  String membersVoice(Object seats, Object hectares) {
    return 'Te quedan $seats plazas y $hectares ha libres para invitar a más socios.';
  }

  @override
  String get membersVoiceFull =>
      'Tu licencia ya no tiene plazas libres. Para invitar a más socios, pide ampliarla.';

  @override
  String membersLicenseEyebrow(Object year) {
    return 'Licencia · Campaña $year';
  }

  @override
  String membersSeatsOf(Object seats) {
    return 'de $seats plazas';
  }

  @override
  String membersLegendMembers(Object count) {
    return '$count socios';
  }

  @override
  String membersLegendPending(Object count) {
    return '$count por canjear';
  }

  @override
  String membersLegendFree(Object count) {
    return '$count libres';
  }

  @override
  String get membersIssueCodes => 'Generar códigos';

  @override
  String get membersCodesToRedeem => 'códigos por canjear';

  @override
  String membersCodesExpire(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vencen el $date',
      one: '1 vence el $date',
    );
    return '$_temp0';
  }

  @override
  String get membersCodesNone => 'Ninguno pendiente';

  @override
  String membersReservedOf(Object total) {
    return 'reservadas de $total ha';
  }

  @override
  String membersRegistered(Object hectares) {
    return '$hectares ha registradas';
  }

  @override
  String get membersSection => 'Socios';

  @override
  String get membersSearchHint => 'Buscar por nombre o sector';

  @override
  String membersFilterAll(Object count) {
    return 'Todos · $count';
  }

  @override
  String membersFilterSharing(Object count) {
    return 'Comparten · $count';
  }

  @override
  String membersFilterWithdrawn(Object count) {
    return 'Retiraron · $count';
  }

  @override
  String membersPlots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lotes',
      one: '1 lote',
    );
    return '$_temp0';
  }

  @override
  String get membersNoSharedData => 'Sin datos compartidos';

  @override
  String get membersLinked => 'Vinculado';

  @override
  String membersWithdrawnOn(Object date) {
    return 'Retiró el acceso · $date';
  }

  @override
  String get membersNotSharing => 'No comparte';

  @override
  String get membersEmpty =>
      'Aún no hay socios. Aparecen aquí cuando canjean un código.';

  @override
  String get membersNoMatch => 'Ningún socio coincide con tu búsqueda.';

  @override
  String get memberTitle => 'Socio';

  @override
  String memberSince(Object date) {
    return 'Socio desde el $date';
  }

  @override
  String memberWithdrawnSince(Object date) {
    return 'Dejó de compartir el $date';
  }

  @override
  String get memberWithdrawnTag => 'Retiró el acceso';

  @override
  String get memberPhone => 'Teléfono';

  @override
  String get memberEmail => 'Correo';

  @override
  String get memberRegistered => 'Hectáreas registradas';

  @override
  String memberRegisteredValue(Object registered, Object quota) {
    return '$registered de $quota ha';
  }

  @override
  String get memberCode => 'Código de vinculación';

  @override
  String memberCodeValue(Object code) {
    return '$code · canjeado';
  }

  @override
  String get memberCall => 'Llamar';

  @override
  String get memberWhatsapp => 'WhatsApp';

  @override
  String get memberPlots => 'Lotes';

  @override
  String get memberWithdrawnNote =>
      'Ya no ves sus datos. Su plan sigue vigente y su plaza continúa ocupada. Para liberarla, escribe a soporte de Viora.';

  @override
  String get memberNotSharingNote =>
      'No aceptó compartir sus datos. Su plan sigue vigente y ocupa una plaza.';

  @override
  String memberPlotSummary(Object variety, Object hectares, Object sector) {
    return '$variety · $hectares ha · $sector';
  }

  @override
  String get memberPlotSectorPending => 'Por confirmar';

  @override
  String get riskOverload => 'Carga crítica';

  @override
  String get riskCriticalIncident => 'Incidente crítico';

  @override
  String get riskFrost => 'Helada prevista';

  @override
  String get riskCritical => 'Riesgo alto';

  @override
  String get riskModerate => 'Atención';

  @override
  String get riskOptimal => 'Óptimo';

  @override
  String get riskNoData => 'Sin datos suficientes';

  @override
  String get codesTitle => 'Códigos de activación';

  @override
  String codesSubtitle(Object organization, Object seats, Object hectares) {
    return '$organization · $seats plazas · $hectares ha';
  }

  @override
  String get codesHeadline => 'Tus\n*códigos.*';

  @override
  String codesTabAvailable(Object count) {
    return 'Por canjear · $count';
  }

  @override
  String codesTabRedeemed(Object count) {
    return 'Canjeados · $count';
  }

  @override
  String codesTabClosed(Object count) {
    return 'Vencidos · $count';
  }

  @override
  String codesIssuedOn(Object date) {
    return 'Emitidos el $date';
  }

  @override
  String codesExpiresIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Vence en $days días',
      one: 'Vence mañana',
      zero: 'Vence hoy',
    );
    return '$_temp0';
  }

  @override
  String codesExpiresOn(Object date) {
    return 'Vence el $date';
  }

  @override
  String codesExpiredOn(Object date) {
    return 'Venció el $date';
  }

  @override
  String get codesRevokedTag => 'Revocado';

  @override
  String codesPerCode(Object hectares) {
    return '$hectares ha por código';
  }

  @override
  String codesRedeemedBy(Object name, Object date) {
    return '$name · $date';
  }

  @override
  String get codesShare => 'Compartir';

  @override
  String get codesRevoke => 'Revocar';

  @override
  String codesFooterAvailable(Object seats, Object hectares) {
    return 'Te quedan $seats plazas y $hectares ha libres. Cada código por canjear las reserva hasta que venza o lo revoques.';
  }

  @override
  String get codesFooterRedeemed =>
      'Un código canjeado ya no se puede compartir ni revocar. Solo queda su referencia.';

  @override
  String get codesFooterClosed =>
      'Un código vencido o revocado devolvió su plaza y sus hectáreas a tu licencia.';

  @override
  String get codesEmptyAvailable => 'No tienes códigos por canjear.';

  @override
  String get codesEmptyRedeemed => 'Aún nadie canjeó un código.';

  @override
  String get codesEmptyClosed => 'No hay códigos vencidos ni revocados.';

  @override
  String get codesRevokedNotice => 'Código revocado';

  @override
  String get codesNotAvailable => 'Este código ya había vencido o se revocó.';

  @override
  String revokeTitle(Object code) {
    return '¿Revocar\n*$code?*';
  }

  @override
  String revokeBody(Object hectares) {
    return 'Nadie podrá usarlo. Su plaza y sus $hectares ha vuelven a tu licencia.';
  }

  @override
  String revokeSeats(Object from, Object to) {
    return 'plazas · $from → $to ha';
  }

  @override
  String get revokeAction => 'Revocar código';

  @override
  String get cooperativeCancel => 'Cancelar';

  @override
  String get redeemedTitle => 'Este código\n*ya se canjeó*';

  @override
  String redeemedBody(Object name, Object date) {
    return '$name lo usó el $date. Los códigos canjeados no se pueden revocar.';
  }

  @override
  String get redeemedBodyUnknown =>
      'Alguien lo usó hace poco. Los códigos canjeados no se pueden revocar.';

  @override
  String redeemedWhen(Object date) {
    return 'canjeado el $date';
  }

  @override
  String get redeemedSeeMembers => 'Ver socios';

  @override
  String get redeemedUnderstood => 'Entendido';

  @override
  String shareCodeMessage(Object organization, Object code, Object date) {
    return 'Hola, este es tu código para unirte a $organization en Viora: $code. Canjéalo en la app Viora, en «Tengo un código de cooperativa». Vence el $date.';
  }

  @override
  String shareCodesMessage(Object organization, Object codes, Object date) {
    return 'Códigos de $organization en Viora, uno por socio:\n$codes\nCada uno se canjea en la app Viora, en «Tengo un código de cooperativa». Vencen el $date.';
  }

  @override
  String get issueHeadline => 'Generar\n*códigos*';

  @override
  String issueSubtitle(Object organization, Object seats, Object hectares) {
    return '$organization · $seats plazas y $hectares ha libres';
  }

  @override
  String get issueQuantity => 'Cantidad';

  @override
  String get issueQuantityCaption => 'códigos · uno por socio';

  @override
  String get issueHectares => 'Hectáreas por código';

  @override
  String get issueHectaresSuggested => 'ha · sugeridas por tu licencia';

  @override
  String get issueHectaresCaption => 'ha por código';

  @override
  String get issueValidity => 'Vigencia';

  @override
  String issueDays(Object days) {
    return '$days días';
  }

  @override
  String issuePreview(
    Object seats,
    Object fromHa,
    Object toHa,
    Object totalHa,
    Object date,
  ) {
    return 'de $seats plazas · $fromHa → $toHa de $totalHa ha. Vencen el $date.';
  }

  @override
  String issueSeatsExceeded(Object free) {
    return 'supera las $free plazas libres';
  }

  @override
  String issueSeatsExceededBanner(Object seats, Object free) {
    return 'de $seats plazas: pasarías tu cupo. Genera hasta $free o pide ampliar la licencia.';
  }

  @override
  String issueAreaExceeded(Object hectares, Object free) {
    return '$hectares ha superan las $free ha libres';
  }

  @override
  String issueAreaExceededBanner(Object free) {
    return 'ha de $free libres: pasarías tu cupo. Reduce las hectáreas o pide ampliar la licencia.';
  }

  @override
  String issueAction(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Generar $count códigos',
      one: 'Generar 1 código',
    );
    return '$_temp0';
  }

  @override
  String get issueUnavailable =>
      'No se pueden generar códigos ahora. Avísale a soporte de Viora.';

  @override
  String get issueDecrease => 'Restar';

  @override
  String get issueIncrease => 'Sumar';

  @override
  String issuedHeadline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count códigos\n*listos.*',
      one: '1 código\n*listo.*',
    );
    return '$_temp0';
  }

  @override
  String issuedVoice(Object hectares) {
    return 'Compártelos con tus socios: cada uno activa una cuenta, ocupa una plaza y reserva $hectares ha.';
  }

  @override
  String issuedExpire(Object date) {
    return 'Vencen el $date';
  }

  @override
  String get issuedCopy => 'Copiar';

  @override
  String get issuedCopied => 'Copiado';

  @override
  String get issuedShareWhatsapp => 'Compartir por WhatsApp';

  @override
  String get issuedSeeAll => 'Ver todos los códigos';

  @override
  String get riskMap => 'Mapa';

  @override
  String get riskList => 'Lista';

  @override
  String get riskYou => 'Tú';

  @override
  String get riskGpsOff => 'Sin ubicación · mostramos todo el valle';

  @override
  String get riskLevelCritical => 'Crítico';

  @override
  String get riskLevelModerate => 'Moderado';

  @override
  String get riskLevelNoData => 'Sin datos';

  @override
  String get riskCountCritical => 'críticas';

  @override
  String get riskCountModerate => 'moderadas';

  @override
  String get riskCountOptimal => 'óptimas';

  @override
  String get riskCountNoData => 'sin datos';

  @override
  String riskChipCritical(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count críticas',
      one: '1 crítica',
    );
    return '$_temp0';
  }

  @override
  String riskNearEyebrow(Object meters) {
    return 'Cerca de ti · GPS ± $meters m';
  }

  @override
  String get riskNearTitle => 'A menos de 5 km';

  @override
  String get riskNearAction => 'Ver visitas por cercanía';

  @override
  String riskNearSubtitle(Object plots) {
    return 'Cerca de ti · $plots';
  }

  @override
  String get riskSectorEyebrow => 'Filtro por sector';

  @override
  String get riskSectorAction => 'Ver parcelas del sector';

  @override
  String riskSectorSubtitle(Object plots) {
    return 'Sector · $plots';
  }

  @override
  String get riskPlotEyebrow => 'Lote elegido en el mapa';

  @override
  String get riskPlotAction => 'Ver lote';

  @override
  String riskPlotCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parcelas socias',
      one: '1 parcela socia',
    );
    return '$_temp0';
  }

  @override
  String riskPlotCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parcelas',
      one: '1 parcela',
    );
    return '$_temp0';
  }

  @override
  String riskGroupFreshness(Object plots, Object updated) {
    return '$plots · $updated';
  }

  @override
  String get riskUpdatedNow => 'actualizado ahora';

  @override
  String riskUpdatedMinutes(Object minutes) {
    return 'actualizado hace $minutes min';
  }

  @override
  String riskUpdatedAt(Object date) {
    return 'actualizado el $date';
  }

  @override
  String get riskUpdatedUnknown => 'sin fecha de lectura';

  @override
  String get riskTileCritical => 'parcelas críticas';

  @override
  String get riskTileOverload => 'sobrecarga > 30 %';

  @override
  String get riskTileFrost => 'helada ≤ 1,5 °C en 48 h';

  @override
  String get riskTileOverloadPlot => 'sobrecarga';

  @override
  String get riskTilePrescribed => 'aclareo prescrito';

  @override
  String get riskTileDaysLeft => 'días para aclarar';

  @override
  String riskPercent(Object value) {
    return '$value %';
  }

  @override
  String riskHectares(Object value) {
    return '$value ha';
  }

  @override
  String get riskPickerTitle => 'Elige un\n*sector.*';

  @override
  String get riskPendingTitle => 'Por confirmar';

  @override
  String riskPendingSummary(Object plots) {
    return '$plots · revisar el sector';
  }

  @override
  String get riskUnassignedTitle => 'Sin sector';

  @override
  String get riskReview => 'Revisar';

  @override
  String riskSummaryCritical(Object plots, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count críticas',
      one: '1 crítica',
    );
    return '$plots · $_temp0';
  }

  @override
  String riskSummaryModerate(Object plots, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count moderadas',
      one: '1 moderada',
    );
    return '$plots · $_temp0';
  }

  @override
  String riskSummaryNoData(Object plots) {
    return '$plots · sin muestreo válido';
  }

  @override
  String riskSummaryOptimal(Object plots) {
    return '$plots · sin riesgo';
  }

  @override
  String get riskEmptyTitle => 'Aún no hay\n*lotes.*';

  @override
  String get riskEmptyBody =>
      'Aparecerán aquí cuando tus socios acepten compartir sus datos y registren sus lotes.';

  @override
  String get riskListTitle => 'Riesgo del\n*valle, hoy.*';

  @override
  String get riskMostCritical => 'Más crítico';

  @override
  String get riskPermissionTitle => '¿Te ubicamos\n*en el mapa?*';

  @override
  String get riskPermissionBody =>
      'Con tu GPS te mostramos en el mapa y ordenamos las parcelas por cercanía. Solo lo usamos mientras miras el mapa.';

  @override
  String get riskPermissionAllow => 'Permitir ubicación';

  @override
  String get riskPermissionLater => 'Ahora no';

  @override
  String get riskScopeEmpty => 'No hay parcelas que mostrar aquí.';

  @override
  String get riskPriorityTitle => 'Por prioridad';

  @override
  String get riskOrderNearest => 'Más cerca primero';

  @override
  String get riskOrderPriority => 'Prioridad primero';

  @override
  String get riskRestTitle => 'Resto del sector';

  @override
  String get riskRestModerate => 'Alerta de atención activa';

  @override
  String get riskRestOptimal => 'Carga dentro del objetivo, sin heladas';

  @override
  String get riskRestNoData => 'Sin muestreo válido esta campaña';

  @override
  String riskTogether(Object first, Object second) {
    return '$first y $second están a menos de 1,5 km: puedes verlos en una sola salida.';
  }

  @override
  String riskHeroEyebrow(Object level) {
    return 'Semáforo del sector · $level';
  }

  @override
  String riskHeroCritical(Object total) {
    return 'de $total parcelas en rojo';
  }

  @override
  String riskHeroModerate(Object total) {
    return 'de $total parcelas en ámbar';
  }

  @override
  String riskHeroOptimal(Object total) {
    return 'de $total parcelas óptimas';
  }

  @override
  String riskHeroNoData(Object total) {
    return 'de $total parcelas sin datos';
  }

  @override
  String riskLegend(Object level, Object count) {
    return '$level $count';
  }

  @override
  String riskFrostDetail(Object value, Object day) {
    return 'Mínima de $value °C el $day';
  }

  @override
  String riskDistance(Object value) {
    return 'a $value km';
  }

  @override
  String riskProposedSector(Object name) {
    return 'escribió «$name»';
  }

  @override
  String riskReasonOverload(Object value) {
    return 'Sobrecarga $value %';
  }

  @override
  String riskReasonFrost(Object value, Object day) {
    return 'Helada $value °C · $day';
  }

  @override
  String get riskDossierAction => 'Ver expediente provisional';

  @override
  String get riskReadOnly => 'Solo lectura';

  @override
  String riskReadAt(Object when) {
    return 'Actualizado $when';
  }

  @override
  String riskToday(Object time) {
    return 'hoy, $time';
  }

  @override
  String get riskLoadTitle => 'Carga frutal';

  @override
  String get riskLoadUnit => 'Frutos por brote';

  @override
  String get riskLoadEstimated => 'Estimada';

  @override
  String get riskLoadTarget => 'Objetivo sostenible';

  @override
  String get riskTonsAfterThinning => 't/ha estimadas tras aclarar';

  @override
  String riskOverloadNotice(Object percent, Object year) {
    return '$percent % más fruta de la que el árbol sostiene. Si no se regula, la vecería se prolonga y $year sería un año OFF fuerte.';
  }

  @override
  String riskSampleBasis(Object trees, Object day) {
    return 'Basado en $trees árboles · ronda del $day';
  }

  @override
  String get riskPrescriptionEyebrow => 'Prescripción · aclareo';

  @override
  String get riskPrescriptionUnit => 'de los frutos';

  @override
  String riskPrescriptionBody(Object name, Object count) {
    return 'Prescrito a $name: quitar $count de cada 10 frutitos, empezando por las ramas más cargadas.';
  }

  @override
  String riskWindowFrom(Object day) {
    return 'Desde $day';
  }

  @override
  String riskWindowUntil(Object day) {
    return 'Hasta $day';
  }

  @override
  String get riskWindowClosed => 'La ventana ya cerró';

  @override
  String riskWindowOpens(Object day) {
    return 'Abre el $day';
  }

  @override
  String riskWindowDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Quedan $count días',
      one: 'Queda 1 día',
      zero: 'Último día',
    );
    return '$_temp0';
  }

  @override
  String get riskThinningMissing => 'Aclareo aún sin registrar';

  @override
  String riskThinningDone(Object day) {
    return 'Aclareo registrado el $day';
  }

  @override
  String get riskBearingEyebrow => 'Alternancia · dato informativo';

  @override
  String riskBearingBand(Object band) {
    return 'BBI · alternancia $band';
  }

  @override
  String get riskBearingHigh => 'alta';

  @override
  String get riskBearingModerate => 'moderada';

  @override
  String get riskBearingLow => 'leve';

  @override
  String get riskBearingNote => 'No cambia el color del semáforo.';

  @override
  String get riskNoDataTitle => 'Sin datos\n*suficientes*';

  @override
  String get riskNoDataBody =>
      'Esta parcela aún no tiene un muestreo de cuajado válido esta campaña. Sin él no calculamos su carga: queda en gris, nunca en verde.';

  @override
  String get riskNoDataSampling => 'Muestreo de cuajado';

  @override
  String riskNoDataSamplingValue(Object sampled, Object required) {
    return '$sampled de $required árboles';
  }

  @override
  String get riskNoDataLoadValue => 'se estima tras el muestreo';

  @override
  String get riskNoDataPrescription => 'Prescripción de aclareo';

  @override
  String get riskNoDataPrescriptionValue => 'pendiente';

  @override
  String riskNoDataVoice(Object name, Object trees) {
    return 'Escríbele a $name: con $trees árboles muestreados ya podremos evaluar su parcela.';
  }
}
