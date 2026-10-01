// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get saved => 'Guardado';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get next => 'Siguiente';

  @override
  String get retry => 'Reintentar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get you => 'tú';

  @override
  String get required => 'Obligatorio';

  @override
  String get open => 'Abrir';

  @override
  String get install => 'Instalar';

  @override
  String get leave => 'Salir';

  @override
  String get accept => 'Aceptar';

  @override
  String get reject => 'Rechazar';

  @override
  String get confirmAction => 'Confirmar';

  @override
  String get errDeviceInUse =>
      'Este teléfono ya está vinculado a otra cuenta de TestPact. Una cuenta por dispositivo mantiene los grupos justos.';

  @override
  String get errBanned =>
      'Tu cuenta no puede unirse a nuevos grupos por ahora. Puedes enviar una apelación.';

  @override
  String get errAlreadyInGroup => 'Ya estás en un grupo. Termínalo primero.';

  @override
  String get errAppNotFound => 'Esa app ya no existe.';

  @override
  String get errAppealOpen => 'Ya tienes una apelación pendiente de revisión.';

  @override
  String get errAlreadyRated => 'Ya calificaste este comentario.';

  @override
  String get errIntegrity =>
      'Este dispositivo no pasó la verificación de integridad de Google Play. Usa un teléfono real con la app instalada desde Google Play.';

  @override
  String get errNetwork =>
      'Sin conexión. Revisa tu internet e inténtalo de nuevo.';

  @override
  String get errGeneric => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get levelProbation => 'En prueba';

  @override
  String get levelNewcomer => 'Recién llegado';

  @override
  String get levelMember => 'Miembro';

  @override
  String get levelTrusted => 'De confianza';

  @override
  String get levelTopTester => 'Top tester';

  @override
  String get reasonNotInstalled => 'No instaló mi app';

  @override
  String get reasonUninstalled => 'La desinstaló durante la prueba';

  @override
  String get reasonNotOpening => 'No abre las apps cada día';

  @override
  String get reasonEmailNotAdded => 'No añadió mi correo a su prueba';

  @override
  String get reasonSpam => 'Spam o abuso';

  @override
  String get reasonFakeFeedback => 'Comentarios falsos o copiados';

  @override
  String get reasonOther => 'Otro';

  @override
  String get catBug => 'Error';

  @override
  String get catUx => 'Diseño / UX';

  @override
  String get catIdea => 'Idea';

  @override
  String get catPraise => 'Elogio';

  @override
  String get catOther => 'Otro';

  @override
  String get badgeFirstPact => 'Primer pacto';

  @override
  String get badgeVeteran => 'Veterano (5 grupos)';

  @override
  String get badgePerfect => 'Racha perfecta';

  @override
  String get badgeHelpful => 'Revisor útil';

  @override
  String get badgeTopTester => 'Top tester';

  @override
  String get removedSetup => 'no completó la configuración a tiempo';

  @override
  String get removedInactive => 'inactivo durante 3 días';

  @override
  String get removedReported => 'reportes confirmados por el admin';

  @override
  String get removedLeft => 'salió del grupo';

  @override
  String get removedCancelled => 'grupo cancelado';

  @override
  String get removedEnded => 'grupo finalizado';

  @override
  String get removedOther => 'eliminado';

  @override
  String trustAdmin(String reason) {
    return 'Ajuste del admin: $reason';
  }

  @override
  String get trustGroupCompleted => 'Completó un grupo';

  @override
  String get trustActiveDay => 'Abrió todas las apps del día';

  @override
  String get trustMissedDay => 'Faltó un día';

  @override
  String get trustHelpfulFeedback => 'Comentario marcado como útil';

  @override
  String get trustKickedInactive => 'Eliminado por inactividad';

  @override
  String get trustKickedReported => 'Eliminado tras reportes confirmados';

  @override
  String get trustSetupFailed => 'Configuración sin terminar';

  @override
  String get trustLeftGroup => 'Salió antes de un grupo';

  @override
  String get trustFalseReport => 'Reporte rechazado por el admin';

  @override
  String get trustAppealAccepted => 'Apelación aceptada';

  @override
  String get statusSetup => 'Configuración';

  @override
  String get statusActive => 'En prueba';

  @override
  String get statusCompleted => 'Completado';

  @override
  String get statusCancelled => 'Cancelado';

  @override
  String get stateSetup => 'Configurando';

  @override
  String get stateActive => 'Probando';

  @override
  String get stateSuspended => 'En revisión';

  @override
  String get stateRemoved => 'Eliminado';

  @override
  String get stateCompleted => 'Completado';

  @override
  String get language => 'Idioma';

  @override
  String get tagline =>
      'Testers reales. Comentarios reales.\nSupera juntos las pruebas cerradas de Google Play.';

  @override
  String get signInBullet1 =>
      'Únete a un grupo de hasta 20 desarrolladores Android';

  @override
  String get signInBullet2 =>
      'Las instalaciones y el uso diario se verifican en el dispositivo';

  @override
  String get signInBullet3 =>
      'Da y recibe comentarios honestos que mejoran tu app';

  @override
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get terms => 'Términos';

  @override
  String get ob1Title => 'Un pacto entre desarrolladores';

  @override
  String get ob1P1 =>
      'Google exige 12 testers inscritos durante 14 días antes de que una cuenta personal nueva pase a producción.';

  @override
  String get ob1P2 =>
      'Te unes a un grupo. Todos se añaden como testers y todos instalan las apps de todos.';

  @override
  String get ob1P3 =>
      'Durante 16 días abres cada app de tu lista a diario. Los demás hacen lo mismo con la tuya.';

  @override
  String get ob2Title => 'Justo para todos';

  @override
  String get ob2P1 =>
      'Tu app solo se muestra a los demás después de que añades sus correos: primero das, luego recibes.';

  @override
  String get ob2P2 =>
      'Tu puntuación de confianza sube cuando pruebas a diario y das comentarios útiles, y baja cuando no.';

  @override
  String get ob2P3 =>
      'Los miembros inactivos reciben avisos y se eliminan tras 3 días sin actividad. Los reportes se contrastan con datos de uso reales.';

  @override
  String get ob3Title => 'Demuestra tus pruebas automáticamente';

  @override
  String get ob3P1 =>
      'TestPact solo revisa las apps que te asignaron: si están instaladas y cuántos minutos las usaste hoy.';

  @override
  String get ob3P2 => 'Nunca se lee ni se envía nada sobre tus otras apps.';

  @override
  String get usageAccessTitle => 'Acceso a uso';

  @override
  String get usageAccessBody =>
      'Permite a TestPact contar los minutos que pasas en tus apps asignadas, así recibes crédito aunque las abras desde la pantalla de inicio.';

  @override
  String get granted => 'Concedido ✓';

  @override
  String get notGranted => 'No concedido, toca para activarlo';

  @override
  String get grantUsageAccess => 'Conceder acceso a uso';

  @override
  String get notificationsTitle => 'Recordatorios';

  @override
  String get notificationsBody =>
      'Recordatorios diarios y novedades del grupo para que nunca te saltes un día.';

  @override
  String get allowNotifications => 'Permitir notificaciones';

  @override
  String get getStarted => 'Empezar';

  @override
  String get settingUp => 'Preparando tu cuenta…';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get tabHome => 'Inicio';

  @override
  String get tabMyApps => 'Mis apps';

  @override
  String get tabFeedback => 'Comentarios';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get admin => 'Admin';

  @override
  String get settings => 'Ajustes';

  @override
  String get addApp => 'Añadir app';

  @override
  String get bannedTitle => 'Cuenta restringida';

  @override
  String bannedBody(int count) {
    return 'Tienes $count faltas, así que no puedes unirte a nuevos grupos. Si crees que es un error, envía una apelación.';
  }

  @override
  String get appeal => 'Apelar';

  @override
  String strikesTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count faltas',
      one: '1 falta',
    );
    return '$_temp0 en tu cuenta';
  }

  @override
  String get strikesBody =>
      'Con 3 faltas no puedes unirte a nuevos grupos. Las faltas vienen de expulsiones por inactividad o reportes confirmados.';

  @override
  String get howItWorks => 'Cómo funciona';

  @override
  String get googleRuleTitle => 'La regla de Google Play';

  @override
  String get googleRuleBody =>
      'Las cuentas personales de desarrollador creadas después del 13 de noviembre de 2023 necesitan al menos 12 testers inscritos durante 14 días seguidos. Los grupos empiezan con 20 personas y duran 16 días, así tienes margen. Google también comprueba que los testers usaron de verdad la app: no basta con instalarla, ábrela y explórala.';

  @override
  String hello(String name) {
    return 'Hola, $name 👋';
  }

  @override
  String get joinCardTitle => '¿Listo para encontrar testers?';

  @override
  String get joinCardBody =>
      'Únete a la cola. En cuanto haya suficientes desarrolladores, tu grupo se crea automáticamente.';

  @override
  String get joinCardNoApps =>
      'Primero añade la app que quieres probar, con su enlace de prueba cerrada.';

  @override
  String get joinGroup => 'Unirse a un grupo';

  @override
  String get addYourApp => 'Añade tu app';

  @override
  String get inQueueTitle => 'Estás en la cola';

  @override
  String inQueueBody(String app, String tier) {
    return 'Esperando para incluir $app en un grupo $tier. Te avisaremos cuando esté listo.';
  }

  @override
  String get tierTrusted => 'de confianza';

  @override
  String get tierStarter => 'inicial';

  @override
  String queueWaiting(int count, int size) {
    return '$count de $size desarrolladores esperando';
  }

  @override
  String queueJoinedAt(String time) {
    return 'Te uniste el $time';
  }

  @override
  String get leaveQueue => 'Salir de la cola';

  @override
  String dayOf(int day, int total) {
    return 'Día $day de $total';
  }

  @override
  String groupTitle(String id) {
    return 'Grupo #$id';
  }

  @override
  String openedToday(int opened, int total) {
    return 'Abiertas hoy: $opened de $total';
  }

  @override
  String get setupDoneWaiting =>
      'Configuración lista ✓ Esperando a que terminen los demás.';

  @override
  String get setupTodo =>
      'Termina la configuración: añade los correos e instala las apps de todos.';

  @override
  String get suspendedBody =>
      'Estás en revisión tras varios reportes. Un admin está revisando tus datos de actividad.';

  @override
  String get openGroup => 'Abrir grupo';

  @override
  String get step1Title => 'Añade tu app';

  @override
  String get step1Body =>
      'Nombre, paquete y tu enlace de inscripción a la prueba cerrada.';

  @override
  String get step2Title => 'Únete a la cola';

  @override
  String get step2Body =>
      'Los grupos de 20 se forman solos. Los testers de confianza se agrupan entre sí.';

  @override
  String get step3Title => 'Configura en 48 h';

  @override
  String get step3Body =>
      'Pega los correos de todos en Play Console y luego únete e instala cada app.';

  @override
  String get step4Title => 'Prueba a diario durante 16 días';

  @override
  String get step4Body =>
      'Abre cada app todos los días y deja comentarios reales. Lo verificamos en el dispositivo.';

  @override
  String get step5Title => 'Solicita producción';

  @override
  String get step5Body =>
      'Gana puntos de confianza e insignias y solicita el acceso a producción en Play Console.';

  @override
  String get rule1 =>
      'Añadiré el correo de cada miembro a mi prueba cerrada en 48 horas.';

  @override
  String get rule2 =>
      'Instalaré la app de cada miembro y la mantendré hasta el final.';

  @override
  String get rule3 =>
      'Abriré cada app a diario durante 16 días y daré comentarios honestos.';

  @override
  String get rule4 =>
      'Entiendo que los miembros inactivos son eliminados y pierden puntos de confianza.';

  @override
  String get chooseApp => '¿Qué app quieres que prueben?';

  @override
  String get yourCommitment => 'Tu compromiso';

  @override
  String get joinedQueue => '¡Estás en la cola!';

  @override
  String get joinQueue => 'Unirse a la cola';

  @override
  String get noAppsTitle => 'Aún no hay apps';

  @override
  String get noAppsBody =>
      'Añade la app que quieres probar. Necesitarás su enlace de inscripción a la prueba cerrada de Play Console.';

  @override
  String get deleteAppTitle => '¿Eliminar esta app?';

  @override
  String get deleteAppBody =>
      'Los grupos que ya la incluyen conservan su copia. Puedes volver a añadirla luego.';

  @override
  String get editApp => 'Editar app';

  @override
  String get appIcon => 'Toca para elegir el ícono';

  @override
  String get appName => 'Nombre de la app';

  @override
  String get packageName => 'Nombre del paquete';

  @override
  String get invalidPackage =>
      'Introduce un paquete válido, p. ej. com.example.app';

  @override
  String get optInLink => 'Enlace de inscripción a la prueba cerrada';

  @override
  String get optInHelp =>
      'Play Console → Testing → Closed testing → Testers → enlace \"Join on the web\".';

  @override
  String get invalidOptIn =>
      'Debe ser un enlace play.google.com/apps/testing/…';

  @override
  String get shortDescription => 'Descripción corta';

  @override
  String get testNotes => '¿Qué deberían probar?';

  @override
  String get testNotesHelp =>
      'p. ej. \"Crea una cuenta y añade 2 productos al carrito\". Los testers lo verán cada día.';

  @override
  String get closedTestTipTitle => 'Antes de unirte';

  @override
  String get closedTestTipBody =>
      'Crea un canal de prueba cerrada, sube una versión, publícala y configura los testers como lista de correos. Los correos de tu grupo van ahí.';

  @override
  String get tabToday => 'Hoy';

  @override
  String get tabSetup => 'Configuración';

  @override
  String get tabMembers => 'Miembros';

  @override
  String get tabActivity => 'Actividad';

  @override
  String get leaveGroup => 'Salir del grupo';

  @override
  String get leaveGroupTitle => '¿Salir de este grupo?';

  @override
  String get leaveGroupBody =>
      'Los demás dejarán de probar tu app y perderás puntos de confianza. No se puede deshacer.';

  @override
  String youWereRemoved(String reason) {
    return 'Fuiste eliminado: $reason.';
  }

  @override
  String get youCompleted =>
      'Completaste este grupo 🏆 Ya puedes solicitar el acceso a producción en Play Console.';

  @override
  String get setupDeadlinePassed =>
      'Venció el plazo de configuración. Procesando…';

  @override
  String setupTimeLeft(int hours, int minutes) {
    return 'Quedan $hours h $minutes min para terminar la configuración';
  }

  @override
  String get setupExplain =>
      'Quien no termine será reemplazado desde la cola. La prueba empieza cuando todos están listos.';

  @override
  String get step1AddEmails => 'Paso 1 · Añade testers a tu prueba cerrada';

  @override
  String addEmailsBody(int count) {
    return 'Copia los $count correos y pégalos en la lista de correos de tu prueba cerrada en Play Console.';
  }

  @override
  String get copyAllEmails => 'Copiar todos los correos';

  @override
  String copied(int count) {
    return '$count correos copiados';
  }

  @override
  String get emailsConfirmed => 'Correos añadidos';

  @override
  String get iAddedEveryone => 'Añadí a todos';

  @override
  String get confirmEmailsTitle => '¿Añadiste todos los correos?';

  @override
  String confirmEmailsBody(int count) {
    return 'Confirma que los $count correos están en la lista de testers de tu prueba cerrada y que guardaste el cambio. Los miembros pueden reportarte si no pueden unirse.';
  }

  @override
  String get yesAdded => 'Sí, todos añadidos';

  @override
  String get emailsHowTo =>
      'Play Console → tu app → Testing → Closed testing → Testers → Email list → pegar → Save.';

  @override
  String step2InstallApps(int done, int total) {
    return 'Paso 2 · Únete e instala las apps ($done/$total)';
  }

  @override
  String get checkAgain => 'Comprobar de nuevo';

  @override
  String waitingForOwners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros aún no han',
      one: '1 miembro aún no ha',
    );
    return '$_temp0 añadido los correos del grupo. Sus apps aparecerán aquí cuando lo hagan.';
  }

  @override
  String get noAppsYet => 'Aún no hay apps para instalar.';

  @override
  String byName(String name) {
    return 'de $name';
  }

  @override
  String get joinTest => 'Unirse a la prueba';

  @override
  String get newMembersTitle => 'Se unió un nuevo miembro';

  @override
  String get newMembersBody =>
      'Añade los nuevos correos a tu prueba cerrada e instala su app. Abre la pestaña Configuración.';

  @override
  String get usageAccessOffTitle => 'El acceso a uso está desactivado';

  @override
  String get usageAccessOffBody =>
      'Solo cuentan las apps que abres con el botón Abrir. Activa el acceso a uso para recibir crédito también al abrirlas desde la pantalla de inicio.';

  @override
  String get yourTestList => 'Tu lista de pruebas';

  @override
  String get todayTitle => 'Pruebas de hoy';

  @override
  String get todayDone => '¡Todo listo por hoy! 🎉';

  @override
  String get todayDoneBody => 'Buen trabajo. Vuelve mañana.';

  @override
  String todayBody(int needed) {
    return 'Abre al menos $needed apps y usa cada una un rato.';
  }

  @override
  String dayResetsAt(String time) {
    return 'El nuevo día empieza a las $time';
  }

  @override
  String get notInstalled => 'No instalada';

  @override
  String openedMinutes(int minutes) {
    return 'Abierta hoy · $minutes min';
  }

  @override
  String get notOpenedYet => 'No abierta hoy';

  @override
  String feedbackGivenCount(int count) {
    return 'Comentarios ($count)';
  }

  @override
  String get giveFeedback => 'Comentar';

  @override
  String get statMembers => 'Miembros';

  @override
  String get statOnTrack => 'Al día hoy';

  @override
  String get statRemoved => 'Eliminados';

  @override
  String get membersLegend =>
      '🟢 al día  🟡 pendiente  🔴 días perdidos  ⚪ salió';

  @override
  String memberSetupLine(String emails, int installed, int total) {
    return 'correos $emails · instaladas $installed/$total';
  }

  @override
  String memberActiveLine(int installed, int opened, int total, int feedback) {
    return 'instaladas $installed/$total · abiertas $opened/$total · comentarios $feedback';
  }

  @override
  String missedInARow(int count) {
    return '$count día(s) seguidos sin actividad';
  }

  @override
  String get lastDays => 'Últimos días';

  @override
  String get viewProfile => 'Ver perfil';

  @override
  String get openInPlay => 'Abrir en Play Store';

  @override
  String get reportMember => 'Reportar';

  @override
  String get reportSent =>
      'Reporte enviado. Gracias por mantener los grupos justos.';

  @override
  String reportTitle(String name) {
    return 'Reportar a $name';
  }

  @override
  String get reportExplain =>
      'Solo se actúa cuando varios miembros reportan Y nuestros datos de uso coinciden. Los reportes falsos cuestan puntos de confianza.';

  @override
  String get detailsOptional => 'Detalles (opcional)';

  @override
  String get addScreenshot => 'Añadir captura';

  @override
  String get screenshotAdded => 'Captura añadida ✓';

  @override
  String get sendReport => 'Enviar reporte';

  @override
  String get noActivity => 'Aún no hay actividad';

  @override
  String evFormed(int count) {
    return 'Grupo formado con $count desarrolladores';
  }

  @override
  String evJoined(String name) {
    return '$name se unió al grupo';
  }

  @override
  String evEmailsAdded(String name) {
    return '$name añadió los correos de todos';
  }

  @override
  String get evStarted => 'Comenzó la prueba: día 1';

  @override
  String evMemberActive(String name) {
    return '$name terminó la configuración y empezó a probar';
  }

  @override
  String evWarning(String name) {
    return '$name faltó 2 días seguidos (último aviso)';
  }

  @override
  String evRemoved(String name, String reason) {
    return '$name fue eliminado ($reason)';
  }

  @override
  String evSuspended(String name) {
    return '$name está en revisión del admin';
  }

  @override
  String evReinstated(String name) {
    return '$name fue absuelto y volvió';
  }

  @override
  String get evCompleted => 'Grupo completado 🏆';

  @override
  String get evCancelled => 'Grupo cancelado';

  @override
  String get feedbackSent => 'Comentario enviado. ¡Gracias!';

  @override
  String feedbackFor(String app) {
    return 'Comentarios: $app';
  }

  @override
  String get developerAsks => 'El desarrollador te pide probar';

  @override
  String get rating => 'Valoración';

  @override
  String get category => 'Categoría';

  @override
  String get yourFeedback => 'Tu comentario';

  @override
  String get feedbackHint =>
      '¿Qué funcionó, qué falló, qué te confundió? Sé específico: pantallas, pasos, dispositivo.';

  @override
  String get feedbackMin => 'Al menos 20 caracteres';

  @override
  String get sendFeedback => 'Enviar comentario';

  @override
  String get received => 'Recibidos';

  @override
  String get given => 'Enviados';

  @override
  String get noFeedbackReceived => 'Aún no hay comentarios';

  @override
  String get noFeedbackReceivedBody =>
      'Aquí verás los comentarios de los testers de tu grupo.';

  @override
  String get noFeedbackGiven => 'Aún no has dado comentarios';

  @override
  String get noFeedbackGivenBody =>
      'Usa el botón Comentar en cada app de la pestaña Hoy de tu grupo.';

  @override
  String fromOnApp(String name, String app) {
    return '$name sobre $app';
  }

  @override
  String get wasHelpful => '¿Te fue útil?';

  @override
  String get markedHelpful =>
      'Lo marcaste como útil (+2 de confianza para esa persona)';

  @override
  String get markedNotHelpful => 'Marcado como no útil';

  @override
  String get groupHistory => 'Grupos';

  @override
  String get noGroupsYet => 'Aún no hay grupos.';

  @override
  String get trustHistory => 'Historial de confianza';

  @override
  String get noTrustHistory => 'Aún no hay cambios.';

  @override
  String get trustScore => 'Puntuación de confianza';

  @override
  String pointsToNext(int points) {
    return '$points puntos para el siguiente nivel';
  }

  @override
  String get statCompleted => 'Grupos completados';

  @override
  String get statCompletionRate => 'Tasa de finalización';

  @override
  String get statDailyActivity => 'Actividad diaria';

  @override
  String get statActiveDays => 'Días activos';

  @override
  String get statFeedback => 'Comentarios dados';

  @override
  String get statHelpful => 'Comentarios útiles';

  @override
  String get badges => 'Insignias';

  @override
  String get noBadges => 'Completa tu primer grupo para ganar una insignia.';

  @override
  String get systemLanguage => 'Predeterminado del sistema';

  @override
  String get general => 'General';

  @override
  String get about => 'Acerca de';

  @override
  String get contactSupport => 'Contactar soporte';

  @override
  String get rateApp => 'Valorar TestPact';

  @override
  String get account => 'Cuenta';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get deleteAccountTitle => '¿Eliminar tu cuenta?';

  @override
  String get deleteAccountBody =>
      'Tu perfil, apps y puntuación de confianza se eliminarán para siempre. Si estás en un grupo, saldrás de él.';

  @override
  String get appealTitle => 'Apelar una decisión';

  @override
  String get appealExplain =>
      'Explica qué pasó. Un admin revisa cada apelación. Si se acepta, se quita una falta y recuperas algunos puntos de confianza.';

  @override
  String get appealHint =>
      '¿Qué pasó? Incluye fechas y cualquier dato que nos ayude a comprobarlo.';

  @override
  String get appealSent => 'Apelación enviada';

  @override
  String get sendAppeal => 'Enviar apelación';

  @override
  String get yourAppeals => 'Tus apelaciones';

  @override
  String get appealOpen => 'Pendiente de revisión';

  @override
  String get appealAccepted => 'Aceptada';

  @override
  String get appealRejected => 'Rechazada';

  @override
  String get adminReviews => 'Revisiones';

  @override
  String get adminAppeals => 'Apelaciones';

  @override
  String get adminUsers => 'Usuarios';

  @override
  String get noteOptional => 'Nota para el usuario (opcional)';

  @override
  String get nothingToReview => 'Nada que revisar 🎉';

  @override
  String dataSummary(int active, int missed) {
    return 'Datos de uso: $active días activos, $missed días perdidos';
  }

  @override
  String get rejectReports => 'Rechazar reportes';

  @override
  String get confirmKick => 'Confirmar y eliminar';

  @override
  String get searchByEmail => 'Buscar usuario por correo';

  @override
  String get userNotFound => 'No hay usuarios con ese correo.';

  @override
  String userSummary(int trust, int strikes, String banned) {
    return 'Confianza $trust · faltas $strikes · bloqueado: $banned';
  }

  @override
  String get ban => 'Bloquear';

  @override
  String get unban => 'Desbloquear';

  @override
  String get adjustTrust => 'Ajustar confianza';
}
