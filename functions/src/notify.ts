import { getMessaging } from "firebase-admin/messaging";
import { logger } from "firebase-functions/v2";
import { db, FieldValue } from "./util";

type Key =
  | "groupFormed"
  | "setupReminder"
  | "setupFailed"
  | "testStarted"
  | "newMember"
  | "warning1"
  | "warning2"
  | "kicked"
  | "completed"
  | "dailyReminder"
  | "newFeedback"
  | "suspended"
  | "reinstated"
  | "groupCancelled"
  | "appealResolved";

type Templates = Record<Key, [title: string, body: string]>;

// {n}, {name}, {app} are replaced at send time.
const T: Record<string, Templates> = {
  en: {
    groupFormed: ["Your group is ready! 🎉", "Finish setup within 48 hours: add {n} tester emails and install their apps."],
    setupReminder: ["Setup not finished", "Finish your group setup soon or you'll lose your spot."],
    setupFailed: ["Removed from group", "Setup wasn't finished in time. You can join the queue again."],
    testStarted: ["Day 1 starts now 🚀", "Open every app in your list each day for the next {n} days."],
    newMember: ["New member joined", "{name} joined your group. Add their email to your testers and install {app}."],
    warning1: ["You missed a day", "Yesterday's apps weren't opened. Open them today to keep your spot."],
    warning2: ["Final warning ⚠️", "2 days missed in a row. One more and you'll be removed from the group."],
    kicked: ["Removed from group", "You were removed: {name}. Tap to see details or appeal."],
    completed: ["Test complete! 🏆", "You finished your 14+ days. Apply for production access in Play Console."],
    dailyReminder: ["Daily testing reminder", "You've opened {n} apps today. Open the rest before the day ends."],
    newFeedback: ["New feedback 💬", "{name} left feedback on {app}."],
    suspended: ["Account under review", "Several members reported you. An admin will review your activity data."],
    reinstated: ["You're back in the group ✅", "Reports were reviewed and dismissed. Keep testing!"],
    groupCancelled: ["Group cancelled", "Not enough members finished setup. You're back at the front of the queue."],
    appealResolved: ["Appeal reviewed", "{name}"],
  },
  hi: {
    groupFormed: ["आपका ग्रुप तैयार है! 🎉", "48 घंटे में सेटअप पूरा करें: {n} टेस्टर ईमेल जोड़ें और उनके ऐप इंस्टॉल करें।"],
    setupReminder: ["सेटअप अधूरा है", "जल्द सेटअप पूरा करें, नहीं तो आपकी जगह चली जाएगी।"],
    setupFailed: ["ग्रुप से हटाया गया", "सेटअप समय पर पूरा नहीं हुआ। आप फिर से कतार में जुड़ सकते हैं।"],
    testStarted: ["पहला दिन शुरू 🚀", "अगले {n} दिनों तक रोज़ अपनी सूची का हर ऐप खोलें।"],
    newMember: ["नया सदस्य जुड़ा", "{name} आपके ग्रुप में जुड़े। उनका ईमेल टेस्टर्स में जोड़ें और {app} इंस्टॉल करें।"],
    warning1: ["आपने एक दिन मिस किया", "कल के ऐप नहीं खोले गए। अपनी जगह बचाने के लिए आज खोलें।"],
    warning2: ["आखिरी चेतावनी ⚠️", "लगातार 2 दिन मिस हुए। एक और दिन मिस हुआ तो आप ग्रुप से हटा दिए जाएंगे।"],
    kicked: ["ग्रुप से हटाया गया", "आपको हटाया गया: {name}। विवरण देखने या अपील करने के लिए टैप करें।"],
    completed: ["टेस्ट पूरा! 🏆", "आपके 14+ दिन पूरे हुए। Play Console में प्रोडक्शन एक्सेस के लिए आवेदन करें।"],
    dailyReminder: ["रोज़ का टेस्टिंग रिमाइंडर", "आज आपने {n} ऐप खोले हैं। दिन खत्म होने से पहले बाकी खोलें।"],
    newFeedback: ["नया फीडबैक 💬", "{name} ने {app} पर फीडबैक दिया।"],
    suspended: ["अकाउंट की समीक्षा हो रही है", "कई सदस्यों ने आपकी रिपोर्ट की है। एडमिन आपका एक्टिविटी डेटा देखेंगे।"],
    reinstated: ["आप ग्रुप में वापस हैं ✅", "रिपोर्ट्स की समीक्षा करके खारिज कर दी गईं। टेस्टिंग जारी रखें!"],
    groupCancelled: ["ग्रुप रद्द हुआ", "पर्याप्त सदस्यों ने सेटअप पूरा नहीं किया। आप कतार में सबसे आगे हैं।"],
    appealResolved: ["अपील की समीक्षा हुई", "{name}"],
  },
  gu: {
    groupFormed: ["તમારું ગ્રુપ તૈયાર છે! 🎉", "48 કલાકમાં સેટઅપ પૂરું કરો: {n} ટેસ્ટર ઈમેલ ઉમેરો અને તેમની એપ્સ ઇન્સ્ટોલ કરો."],
    setupReminder: ["સેટઅપ અધૂરું છે", "જલ્દી સેટઅપ પૂરું કરો, નહીંતર તમારી જગ્યા જતી રહેશે."],
    setupFailed: ["ગ્રુપમાંથી દૂર કરાયા", "સેટઅપ સમયસર પૂરું ન થયું. તમે ફરીથી કતારમાં જોડાઈ શકો છો."],
    testStarted: ["પહેલો દિવસ શરૂ 🚀", "આગામી {n} દિવસ સુધી રોજ તમારી યાદીની દરેક એપ ખોલો."],
    newMember: ["નવા સભ્ય જોડાયા", "{name} તમારા ગ્રુપમાં જોડાયા. તેમનો ઈમેલ ટેસ્ટર્સમાં ઉમેરો અને {app} ઇન્સ્ટોલ કરો."],
    warning1: ["તમે એક દિવસ ચૂકી ગયા", "ગઈકાલની એપ્સ ખોલાઈ નથી. તમારી જગ્યા જાળવવા આજે ખોલો."],
    warning2: ["છેલ્લી ચેતવણી ⚠️", "સતત 2 દિવસ ચૂક્યા. વધુ એક દિવસ ચૂકશો તો ગ્રુપમાંથી દૂર થશો."],
    kicked: ["ગ્રુપમાંથી દૂર કરાયા", "તમને દૂર કરાયા: {name}. વિગતો જોવા અથવા અપીલ કરવા ટેપ કરો."],
    completed: ["ટેસ્ટ પૂરો! 🏆", "તમારા 14+ દિવસ પૂરા થયા. Play Console માં પ્રોડક્શન એક્સેસ માટે અરજી કરો."],
    dailyReminder: ["રોજનું ટેસ્ટિંગ રિમાઇન્ડર", "આજે તમે {n} એપ્સ ખોલી છે. દિવસ પૂરો થાય તે પહેલાં બાકીની ખોલો."],
    newFeedback: ["નવો ફીડબેક 💬", "{name} એ {app} પર ફીડબેક આપ્યો."],
    suspended: ["એકાઉન્ટની સમીક્ષા ચાલુ છે", "ઘણા સભ્યોએ તમારી ફરિયાદ કરી છે. એડમિન તમારો એક્ટિવિટી ડેટા તપાસશે."],
    reinstated: ["તમે ગ્રુપમાં પાછા છો ✅", "ફરિયાદોની સમીક્ષા કરીને રદ કરાઈ. ટેસ્ટિંગ ચાલુ રાખો!"],
    groupCancelled: ["ગ્રુપ રદ થયું", "પૂરતા સભ્યોએ સેટઅપ પૂરું ન કર્યું. તમે કતારમાં સૌથી આગળ છો."],
    appealResolved: ["અપીલની સમીક્ષા થઈ", "{name}"],
  },
  mr: {
    groupFormed: ["तुमचा ग्रुप तयार आहे! 🎉", "48 तासांत सेटअप पूर्ण करा: {n} टेस्टर ईमेल जोडा आणि त्यांची ॲप्स इन्स्टॉल करा."],
    setupReminder: ["सेटअप अपूर्ण आहे", "लवकर सेटअप पूर्ण करा, नाहीतर तुमची जागा जाईल."],
    setupFailed: ["ग्रुपमधून काढले", "सेटअप वेळेत पूर्ण झाला नाही. तुम्ही पुन्हा रांगेत सामील होऊ शकता."],
    testStarted: ["पहिला दिवस सुरू 🚀", "पुढील {n} दिवस रोज तुमच्या यादीतील प्रत्येक ॲप उघडा."],
    newMember: ["नवीन सदस्य सामील", "{name} तुमच्या ग्रुपमध्ये आले. त्यांचा ईमेल टेस्टर्समध्ये जोडा आणि {app} इन्स्टॉल करा."],
    warning1: ["तुमचा एक दिवस चुकला", "कालची ॲप्स उघडली नाहीत. तुमची जागा टिकवण्यासाठी आज उघडा."],
    warning2: ["शेवटची चेतावणी ⚠️", "सलग 2 दिवस चुकले. आणखी एक दिवस चुकल्यास ग्रुपमधून काढले जाईल."],
    kicked: ["ग्रुपमधून काढले", "तुम्हाला काढले: {name}. तपशील पाहण्यासाठी किंवा अपील करण्यासाठी टॅप करा."],
    completed: ["टेस्ट पूर्ण! 🏆", "तुमचे 14+ दिवस पूर्ण झाले. Play Console मध्ये प्रोडक्शन ॲक्सेससाठी अर्ज करा."],
    dailyReminder: ["रोजचे टेस्टिंग रिमाइंडर", "आज तुम्ही {n} ॲप्स उघडली. दिवस संपण्यापूर्वी उरलेली उघडा."],
    newFeedback: ["नवीन फीडबॅक 💬", "{name} यांनी {app} वर फीडबॅक दिला."],
    suspended: ["अकाउंटचे पुनरावलोकन सुरू", "अनेक सदस्यांनी तुमची तक्रार केली आहे. ॲडमिन तुमचा ॲक्टिव्हिटी डेटा तपासतील."],
    reinstated: ["तुम्ही ग्रुपमध्ये परत आहात ✅", "तक्रारींचे पुनरावलोकन करून त्या फेटाळल्या. टेस्टिंग सुरू ठेवा!"],
    groupCancelled: ["ग्रुप रद्द झाला", "पुरेशा सदस्यांनी सेटअप पूर्ण केला नाही. तुम्ही रांगेत सर्वात पुढे आहात."],
    appealResolved: ["अपीलचे पुनरावलोकन झाले", "{name}"],
  },
  es: {
    groupFormed: ["¡Tu grupo está listo! 🎉", "Completa la configuración en 48 horas: añade {n} correos de testers e instala sus apps."],
    setupReminder: ["Configuración pendiente", "Termina la configuración pronto o perderás tu lugar."],
    setupFailed: ["Eliminado del grupo", "No terminaste la configuración a tiempo. Puedes volver a la cola."],
    testStarted: ["¡Empieza el día 1! 🚀", "Abre cada app de tu lista todos los días durante los próximos {n} días."],
    newMember: ["Nuevo miembro", "{name} se unió a tu grupo. Añade su correo a tus testers e instala {app}."],
    warning1: ["Te saltaste un día", "Ayer no abriste las apps. Ábrelas hoy para conservar tu lugar."],
    warning2: ["Última advertencia ⚠️", "2 días seguidos sin actividad. Uno más y serás eliminado del grupo."],
    kicked: ["Eliminado del grupo", "Fuiste eliminado: {name}. Toca para ver detalles o apelar."],
    completed: ["¡Prueba completada! 🏆", "Cumpliste tus 14+ días. Solicita acceso a producción en Play Console."],
    dailyReminder: ["Recordatorio diario", "Hoy abriste {n} apps. Abre las demás antes de que termine el día."],
    newFeedback: ["Nuevo comentario 💬", "{name} dejó comentarios sobre {app}."],
    suspended: ["Cuenta en revisión", "Varios miembros te reportaron. Un administrador revisará tus datos de actividad."],
    reinstated: ["Has vuelto al grupo ✅", "Los reportes fueron revisados y descartados. ¡Sigue probando!"],
    groupCancelled: ["Grupo cancelado", "No suficientes miembros terminaron la configuración. Estás al frente de la cola."],
    appealResolved: ["Apelación revisada", "{name}"],
  },
  pt: {
    groupFormed: ["Seu grupo está pronto! 🎉", "Conclua a configuração em 48 horas: adicione {n} e-mails de testers e instale os apps."],
    setupReminder: ["Configuração pendente", "Conclua a configuração logo ou você perderá sua vaga."],
    setupFailed: ["Removido do grupo", "A configuração não foi concluída a tempo. Você pode entrar na fila de novo."],
    testStarted: ["O dia 1 começou 🚀", "Abra todos os apps da sua lista todos os dias pelos próximos {n} dias."],
    newMember: ["Novo membro", "{name} entrou no seu grupo. Adicione o e-mail aos testers e instale {app}."],
    warning1: ["Você perdeu um dia", "Os apps de ontem não foram abertos. Abra-os hoje para manter sua vaga."],
    warning2: ["Último aviso ⚠️", "2 dias seguidos sem atividade. Mais um e você será removido do grupo."],
    kicked: ["Removido do grupo", "Você foi removido: {name}. Toque para ver detalhes ou recorrer."],
    completed: ["Teste concluído! 🏆", "Você completou 14+ dias. Solicite acesso à produção no Play Console."],
    dailyReminder: ["Lembrete diário", "Você abriu {n} apps hoje. Abra o restante antes do fim do dia."],
    newFeedback: ["Novo feedback 💬", "{name} deixou feedback em {app}."],
    suspended: ["Conta em análise", "Vários membros denunciaram você. Um administrador vai analisar seus dados de atividade."],
    reinstated: ["Você voltou ao grupo ✅", "As denúncias foram analisadas e descartadas. Continue testando!"],
    groupCancelled: ["Grupo cancelado", "Poucos membros concluíram a configuração. Você está no início da fila."],
    appealResolved: ["Recurso analisado", "{name}"],
  },
};

function fill(s: string, params: Record<string, string | number>): string {
  return s.replace(/\{(\w+)\}/g, (_, k) => String(params[k] ?? ""));
}

/** Push a localized notification to a user. Never throws. */
export async function notify(
  uid: string,
  key: Key,
  params: Record<string, string | number> = {},
  data: Record<string, string> = {},
): Promise<void> {
  try {
    const snap = await db.collection("users").doc(uid).get();
    const token = snap.get("fcmToken") as string | undefined;
    if (!token) return;
    const locale = (snap.get("locale") as string | undefined) ?? "en";
    const [title, body] = (T[locale] ?? T.en)[key];
    await getMessaging().send({
      token,
      notification: { title: fill(title, params), body: fill(body, params) },
      data: { key, ...data },
      android: { priority: "high", notification: { channelId: "testpact_default", color: "#4F46E5" } },
    });
  } catch (e: unknown) {
    const code = (e as { code?: string }).code ?? "";
    if (code.includes("registration-token-not-registered") || code.includes("invalid-argument")) {
      await db.collection("users").doc(uid).update({ fcmToken: FieldValue.delete() }).catch(() => undefined);
    } else {
      logger.warn("notify failed", { uid, key, e });
    }
  }
}

export async function notifyMany(
  uids: string[],
  key: Key,
  params: Record<string, string | number> = {},
  data: Record<string, string> = {},
): Promise<void> {
  await Promise.all(uids.map((u) => notify(u, key, params, data)));
}
