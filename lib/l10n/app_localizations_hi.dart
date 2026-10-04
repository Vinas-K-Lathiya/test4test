// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get cancel => 'रद्द करें';

  @override
  String get save => 'सेव करें';

  @override
  String get saved => 'सेव हो गया';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'बदलें';

  @override
  String get next => 'आगे';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get you => 'आप';

  @override
  String get required => 'ज़रूरी है';

  @override
  String get open => 'खोलें';

  @override
  String get install => 'इंस्टॉल करें';

  @override
  String get leave => 'छोड़ें';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get reject => 'अस्वीकार करें';

  @override
  String get confirmAction => 'पुष्टि करें';

  @override
  String get errDeviceInUse =>
      'यह फ़ोन पहले से किसी दूसरे TestPact अकाउंट से जुड़ा है। हर डिवाइस पर एक अकाउंट से ग्रुप निष्पक्ष रहते हैं।';

  @override
  String get errBanned =>
      'अभी आपका अकाउंट नए ग्रुप में शामिल नहीं हो सकता। आप अपील भेज सकते हैं।';

  @override
  String get errAlreadyInGroup =>
      'आप पहले से एक ग्रुप में हैं। पहले उसे पूरा करें।';

  @override
  String get errAppNotFound => 'यह ऐप लिस्टिंग अब मौजूद नहीं है।';

  @override
  String get errAppealOpen => 'आपकी एक अपील पहले से समीक्षा के लिए लंबित है।';

  @override
  String get errAlreadyRated => 'आप इस फीडबैक को पहले ही रेट कर चुके हैं।';

  @override
  String get errIntegrity =>
      'यह डिवाइस Google Play की इंटीग्रिटी जांच में पास नहीं हुआ। Google Play से इंस्टॉल किए ऐप के साथ असली फ़ोन इस्तेमाल करें।';

  @override
  String get errNetwork => 'कनेक्शन नहीं है। इंटरनेट जांचें और फिर कोशिश करें।';

  @override
  String get errGeneric => 'कुछ गड़बड़ हो गई। कृपया फिर कोशिश करें।';

  @override
  String get levelProbation => 'प्रोबेशन';

  @override
  String get levelNewcomer => 'नया सदस्य';

  @override
  String get levelMember => 'सदस्य';

  @override
  String get levelTrusted => 'भरोसेमंद';

  @override
  String get levelTopTester => 'टॉप टेस्टर';

  @override
  String get reasonNotInstalled => 'मेरा ऐप इंस्टॉल नहीं किया';

  @override
  String get reasonUninstalled => 'टेस्ट के दौरान अनइंस्टॉल किया';

  @override
  String get reasonNotOpening => 'रोज़ ऐप नहीं खोल रहे';

  @override
  String get reasonEmailNotAdded => 'मेरा ईमेल अपने टेस्ट में नहीं जोड़ा';

  @override
  String get reasonSpam => 'स्पैम या दुर्व्यवहार';

  @override
  String get reasonFakeFeedback => 'नकली या कॉपी-पेस्ट फीडबैक';

  @override
  String get reasonOther => 'अन्य';

  @override
  String get catBug => 'बग';

  @override
  String get catUx => 'डिज़ाइन / UX';

  @override
  String get catIdea => 'सुझाव';

  @override
  String get catPraise => 'तारीफ़';

  @override
  String get catOther => 'अन्य';

  @override
  String get badgeFirstPact => 'पहला पैक्ट';

  @override
  String get badgeVeteran => 'अनुभवी (5 ग्रुप)';

  @override
  String get badgePerfect => 'परफेक्ट स्ट्रीक';

  @override
  String get badgeHelpful => 'मददगार समीक्षक';

  @override
  String get badgeTopTester => 'टॉप टेस्टर';

  @override
  String get removedSetup => 'सेटअप समय पर पूरा नहीं हुआ';

  @override
  String get removedInactive => '3 दिन से निष्क्रिय';

  @override
  String get removedReported => 'एडमिन ने रिपोर्ट की पुष्टि की';

  @override
  String get removedLeft => 'ग्रुप छोड़ दिया';

  @override
  String get removedCancelled => 'ग्रुप रद्द हुआ';

  @override
  String get removedEnded => 'ग्रुप समाप्त हुआ';

  @override
  String get removedOther => 'हटाया गया';

  @override
  String trustAdmin(String reason) {
    return 'एडमिन द्वारा बदलाव: $reason';
  }

  @override
  String get trustGroupCompleted => 'ग्रुप पूरा किया';

  @override
  String get trustActiveDay => 'दिन के सभी ऐप खोले';

  @override
  String get trustMissedDay => 'एक दिन छूटा';

  @override
  String get trustHelpfulFeedback => 'फीडबैक मददगार माना गया';

  @override
  String get trustKickedInactive => 'निष्क्रियता के कारण हटाया गया';

  @override
  String get trustKickedReported => 'पुष्ट रिपोर्ट के बाद हटाया गया';

  @override
  String get trustSetupFailed => 'सेटअप पूरा नहीं हुआ';

  @override
  String get trustLeftGroup => 'ग्रुप जल्दी छोड़ा';

  @override
  String get trustFalseReport => 'एडमिन ने रिपोर्ट खारिज की';

  @override
  String get trustAppealAccepted => 'अपील स्वीकार हुई';

  @override
  String get statusSetup => 'सेटअप';

  @override
  String get statusActive => 'टेस्टिंग';

  @override
  String get statusCompleted => 'पूरा';

  @override
  String get statusCancelled => 'रद्द';

  @override
  String get stateSetup => 'सेटअप जारी';

  @override
  String get stateActive => 'टेस्टिंग';

  @override
  String get stateSuspended => 'समीक्षा में';

  @override
  String get stateRemoved => 'हटाया गया';

  @override
  String get stateCompleted => 'पूरा';

  @override
  String get language => 'भाषा';

  @override
  String get tagline =>
      'असली टेस्टर। असली फीडबैक।\nसाथ मिलकर Google Play क्लोज़्ड टेस्टिंग पास करें।';

  @override
  String get signInBullet1 => '20 तक Android डेवलपर्स के ग्रुप में जुड़ें';

  @override
  String get signInBullet2 =>
      'इंस्टॉल और रोज़ का इस्तेमाल डिवाइस पर ही वेरिफ़ाई होता है';

  @override
  String get signInBullet3 =>
      'ईमानदार फीडबैक दें और पाएं, जिससे आपका ऐप बेहतर बने';

  @override
  String get continueWithGoogle => 'Google से जारी रखें';

  @override
  String get privacyPolicy => 'प्राइवेसी पॉलिसी';

  @override
  String get terms => 'शर्तें';

  @override
  String get ob1Title => 'डेवलपर्स के बीच एक समझौता';

  @override
  String get ob1P1 =>
      'नए पर्सनल अकाउंट को प्रोडक्शन से पहले 14 दिनों तक 12 ऑप्ट-इन टेस्टर चाहिए।';

  @override
  String get ob1P2 =>
      'आप एक ग्रुप में जुड़ते हैं। सब एक-दूसरे को टेस्टर के रूप में जोड़ते हैं और सबके ऐप इंस्टॉल करते हैं।';

  @override
  String get ob1P3 =>
      '16 दिनों तक आप अपनी सूची का हर ऐप रोज़ खोलते हैं, और बाकी सब आपके ऐप के लिए यही करते हैं।';

  @override
  String get ob2Title => 'सबके लिए निष्पक्ष';

  @override
  String get ob2P1 =>
      'आपका ऐप दूसरों को तभी दिखता है जब आप उनके ईमेल जोड़ देते हैं: पहले दें, फिर पाएं।';

  @override
  String get ob2P2 =>
      'रोज़ टेस्ट करने और मददगार फीडबैक देने पर ट्रस्ट स्कोर बढ़ता है, न करने पर घटता है।';

  @override
  String get ob2P3 =>
      'निष्क्रिय सदस्यों को चेतावनी मिलती है और 3 दिन चूकने पर हटा दिए जाते हैं। रिपोर्ट को असली इस्तेमाल डेटा से जांचा जाता है।';

  @override
  String get ob3Title => 'अपनी टेस्टिंग अपने-आप साबित करें';

  @override
  String get ob3P1 =>
      'TestPact केवल आपको दिए गए ऐप्स जांचता है: इंस्टॉल हैं या नहीं, और आज कितने मिनट इस्तेमाल हुए।';

  @override
  String get ob3P2 =>
      'आपके बाकी ऐप्स के बारे में कुछ भी कभी पढ़ा या भेजा नहीं जाता।';

  @override
  String get usageAccessTitle => 'यूसेज एक्सेस';

  @override
  String get usageAccessBody =>
      'इससे TestPact आपके दिए गए ऐप्स में बिताए मिनट गिन पाता है, ताकि होम स्क्रीन से खोलने पर भी आपको क्रेडिट मिले।';

  @override
  String get granted => 'अनुमति दी गई ✓';

  @override
  String get notGranted => 'अनुमति नहीं, चालू करने के लिए टैप करें';

  @override
  String get grantUsageAccess => 'यूसेज एक्सेस दें';

  @override
  String get notificationsTitle => 'रिमाइंडर';

  @override
  String get notificationsBody =>
      'रोज़ के रिमाइंडर और ग्रुप अपडेट, ताकि कोई दिन न छूटे।';

  @override
  String get allowNotifications => 'नोटिफिकेशन की अनुमति दें';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get settingUp => 'आपका अकाउंट तैयार हो रहा है…';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get tabHome => 'होम';

  @override
  String get tabMyApps => 'मेरे ऐप';

  @override
  String get tabFeedback => 'फीडबैक';

  @override
  String get tabProfile => 'प्रोफ़ाइल';

  @override
  String get admin => 'एडमिन';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get addApp => 'ऐप जोड़ें';

  @override
  String get bannedTitle => 'अकाउंट प्रतिबंधित';

  @override
  String bannedBody(int count) {
    return 'आपके $count स्ट्राइक हैं, इसलिए आप नए ग्रुप में नहीं जुड़ सकते। अगर यह गलती लगती है तो अपील भेजें।';
  }

  @override
  String get appeal => 'अपील';

  @override
  String strikesTitle(int count) {
    return 'आपके अकाउंट पर $count स्ट्राइक';
  }

  @override
  String get strikesBody =>
      '3 स्ट्राइक होने पर आप नए ग्रुप में नहीं जुड़ सकते। स्ट्राइक निष्क्रियता या पुष्ट रिपोर्ट से हटाए जाने पर मिलते हैं।';

  @override
  String get howItWorks => 'यह कैसे काम करता है';

  @override
  String get googleRuleTitle => 'Google Play का नियम';

  @override
  String get googleRuleBody =>
      '13 नवंबर 2023 के बाद बने पर्सनल डेवलपर अकाउंट को लगातार 14 दिनों तक कम से कम 12 ऑप्ट-इन टेस्टर चाहिए। ग्रुप 20 लोगों से शुरू होते हैं और 16 दिन चलते हैं, ताकि आपके पास गुंजाइश रहे। Google यह भी देखता है कि टेस्टर्स ने ऐप सच में इस्तेमाल किया या नहीं, इसलिए सिर्फ़ इंस्टॉल न करें, ऐप खोलकर इस्तेमाल करें।';

  @override
  String hello(String name) {
    return 'नमस्ते, $name 👋';
  }

  @override
  String get joinCardTitle => 'अपने टेस्टर ढूंढने के लिए तैयार?';

  @override
  String get joinCardBody =>
      'कतार में जुड़ें। जैसे ही पर्याप्त डेवलपर होंगे, आपका ग्रुप अपने-आप बन जाएगा।';

  @override
  String get joinCardNoApps =>
      'पहले वह ऐप जोड़ें जिसे टेस्ट कराना है, उसके क्लोज़्ड टेस्टिंग लिंक के साथ।';

  @override
  String get joinGroup => 'ग्रुप में जुड़ें';

  @override
  String get addYourApp => 'अपना ऐप जोड़ें';

  @override
  String get inQueueTitle => 'आप कतार में हैं';

  @override
  String inQueueBody(String app, String tier) {
    return '$app को $tier ग्रुप में मिलाने का इंतज़ार है। तैयार होने पर हम आपको सूचित करेंगे।';
  }

  @override
  String get tierTrusted => 'भरोसेमंद';

  @override
  String get tierStarter => 'स्टार्टर';

  @override
  String queueWaiting(int count, int size) {
    return '$size में से $count डेवलपर इंतज़ार में';
  }

  @override
  String queueJoinedAt(String time) {
    return '$time को जुड़े';
  }

  @override
  String get leaveQueue => 'कतार छोड़ें';

  @override
  String dayOf(int day, int total) {
    return 'दिन $day / $total';
  }

  @override
  String groupTitle(String id) {
    return 'ग्रुप #$id';
  }

  @override
  String openedToday(int opened, int total) {
    return 'आज खोले: $total में से $opened';
  }

  @override
  String get setupDoneWaiting => 'सेटअप पूरा ✓ बाकी सदस्यों का इंतज़ार है।';

  @override
  String get setupTodo =>
      'सेटअप पूरा करें: ईमेल जोड़ें और सबके ऐप इंस्टॉल करें।';

  @override
  String get suspendedBody =>
      'कई रिपोर्ट के बाद आप समीक्षा में हैं। एडमिन आपका एक्टिविटी डेटा जांच रहे हैं।';

  @override
  String get openGroup => 'ग्रुप खोलें';

  @override
  String get step1Title => 'अपना ऐप जोड़ें';

  @override
  String get step1Body => 'नाम, पैकेज और आपका क्लोज़्ड टेस्टिंग ऑप्ट-इन लिंक।';

  @override
  String get step2Title => 'कतार में जुड़ें';

  @override
  String get step2Body =>
      '20 लोगों के ग्रुप अपने-आप बनते हैं। भरोसेमंद टेस्टर्स साथ मिलाए जाते हैं।';

  @override
  String get step3Title => '48 घंटे में सेटअप';

  @override
  String get step3Body =>
      'सबके ईमेल Play Console में पेस्ट करें, फिर हर ऐप में जुड़ें और इंस्टॉल करें।';

  @override
  String get step4Title => '16 दिन रोज़ टेस्ट करें';

  @override
  String get step4Body =>
      'हर ऐप रोज़ खोलें और असली फीडबैक दें। हम डिवाइस पर इसे वेरिफ़ाई करते हैं।';

  @override
  String get step5Title => 'प्रोडक्शन के लिए आवेदन';

  @override
  String get step5Body =>
      'ट्रस्ट पॉइंट और बैज कमाएं, फिर Play Console में प्रोडक्शन के लिए आवेदन करें।';

  @override
  String get rule1 =>
      'मैं 48 घंटे में हर सदस्य का ईमेल अपने क्लोज़्ड टेस्ट में जोड़ूंगा/जोड़ूंगी।';

  @override
  String get rule2 =>
      'मैं हर सदस्य का ऐप इंस्टॉल करूंगा/करूंगी और अंत तक इंस्टॉल रखूंगा/रखूंगी।';

  @override
  String get rule3 =>
      'मैं 16 दिनों तक रोज़ हर ऐप खोलूंगा/खोलूंगी और ईमानदार फीडबैक दूंगा/दूंगी।';

  @override
  String get rule4 =>
      'मैं समझता/समझती हूँ कि निष्क्रिय सदस्य हटाए जाते हैं और ट्रस्ट पॉइंट खोते हैं।';

  @override
  String get chooseApp => 'कौन सा ऐप टेस्ट होना चाहिए?';

  @override
  String get yourCommitment => 'आपका वादा';

  @override
  String get joinedQueue => 'आप कतार में हैं!';

  @override
  String get joinQueue => 'कतार में जुड़ें';

  @override
  String get noAppsTitle => 'अभी कोई ऐप नहीं';

  @override
  String get noAppsBody =>
      'जिस ऐप को टेस्ट कराना है उसे जोड़ें। इसके लिए Play Console से क्लोज़्ड टेस्टिंग ऑप्ट-इन लिंक चाहिए।';

  @override
  String get deleteAppTitle => 'यह ऐप हटाएं?';

  @override
  String get deleteAppBody =>
      'जिन ग्रुप्स में यह पहले से है, उनमें इसकी कॉपी रहेगी। आप इसे बाद में फिर जोड़ सकते हैं।';

  @override
  String get editApp => 'ऐप बदलें';

  @override
  String get appIcon => 'आइकन सेट करने के लिए टैप करें';

  @override
  String get appName => 'ऐप का नाम';

  @override
  String get packageName => 'पैकेज नाम';

  @override
  String get invalidPackage => 'सही पैकेज नाम लिखें, जैसे com.example.app';

  @override
  String get optInLink => 'क्लोज़्ड टेस्टिंग ऑप्ट-इन लिंक';

  @override
  String get optInHelp =>
      'Play Console → Testing → Closed testing → Testers → \"Join on the web\" लिंक।';

  @override
  String get invalidOptIn =>
      'यह play.google.com/apps/testing/… लिंक होना चाहिए';

  @override
  String get shortDescription => 'छोटा विवरण';

  @override
  String get testNotes => 'टेस्टर्स क्या आज़माएं?';

  @override
  String get testNotesHelp =>
      'जैसे \"अकाउंट बनाएं और कार्ट में 2 आइटम जोड़ें\"। यह टेस्टर्स को रोज़ दिखेगा।';

  @override
  String get closedTestTipTitle => 'जुड़ने से पहले';

  @override
  String get closedTestTipBody =>
      'क्लोज़्ड टेस्टिंग ट्रैक बनाएं, बिल्ड अपलोड करके रोल आउट करें, और टेस्टर्स को ईमेल लिस्ट पर सेट करें। आपके ग्रुप के ईमेल वहीं जाएंगे।';

  @override
  String get tabToday => 'आज';

  @override
  String get tabSetup => 'सेटअप';

  @override
  String get tabMembers => 'सदस्य';

  @override
  String get tabActivity => 'गतिविधि';

  @override
  String get leaveGroup => 'ग्रुप छोड़ें';

  @override
  String get leaveGroupTitle => 'यह ग्रुप छोड़ें?';

  @override
  String get leaveGroupBody =>
      'बाकी सदस्य आपका ऐप टेस्ट करना बंद कर देंगे और आपके ट्रस्ट पॉइंट कटेंगे। इसे वापस नहीं किया जा सकता।';

  @override
  String youWereRemoved(String reason) {
    return 'आपको हटाया गया: $reason।';
  }

  @override
  String get youCompleted =>
      'आपने यह ग्रुप पूरा किया 🏆 अब आप Play Console में प्रोडक्शन एक्सेस के लिए आवेदन कर सकते हैं।';

  @override
  String get setupDeadlinePassed =>
      'सेटअप की समय-सीमा खत्म। प्रोसेस हो रहा है…';

  @override
  String setupTimeLeft(int hours, int minutes) {
    return 'सेटअप पूरा करने के लिए $hoursघं $minutesमि बाकी';
  }

  @override
  String get setupExplain =>
      'जो सदस्य पूरा नहीं करते, उनकी जगह कतार से लोग आते हैं। सब तैयार होने पर टेस्ट शुरू होता है।';

  @override
  String get step1AddEmails => 'चरण 1 · अपने क्लोज़्ड टेस्ट में टेस्टर जोड़ें';

  @override
  String addEmailsBody(int count) {
    return 'सभी $count ईमेल कॉपी करें और Play Console में अपनी क्लोज़्ड टेस्टिंग ईमेल लिस्ट में पेस्ट करें।';
  }

  @override
  String get copyAllEmails => 'सभी ईमेल कॉपी करें';

  @override
  String copied(int count) {
    return '$count ईमेल कॉपी हुए';
  }

  @override
  String get emailsConfirmed => 'ईमेल जोड़े गए';

  @override
  String get iAddedEveryone => 'मैंने सबको जोड़ दिया';

  @override
  String get confirmEmailsTitle => 'क्या आपने सभी ईमेल जोड़ दिए?';

  @override
  String confirmEmailsBody(int count) {
    return 'पुष्टि करें कि सभी $count ईमेल आपकी क्लोज़्ड टेस्ट की टेस्टर लिस्ट में हैं और बदलाव सेव हो गया है। अगर सदस्य जुड़ नहीं पाए तो वे आपकी रिपोर्ट कर सकते हैं।';
  }

  @override
  String get yesAdded => 'हाँ, सब जोड़ दिए';

  @override
  String get emailsHowTo =>
      'Play Console → आपका ऐप → Testing → Closed testing → Testers → Email list → पेस्ट → Save।';

  @override
  String step2InstallApps(int done, int total) {
    return 'चरण 2 · ऐप्स में जुड़ें और इंस्टॉल करें ($done/$total)';
  }

  @override
  String get checkAgain => 'फिर जांचें';

  @override
  String waitingForOwners(int count) {
    return '$count सदस्यों ने अभी ग्रुप के ईमेल नहीं जोड़े हैं। जोड़ने के बाद उनके ऐप यहां दिखेंगे।';
  }

  @override
  String get noAppsYet => 'अभी इंस्टॉल करने के लिए कोई ऐप नहीं।';

  @override
  String byName(String name) {
    return '$name द्वारा';
  }

  @override
  String get joinTest => 'टेस्ट में जुड़ें';

  @override
  String get newMembersTitle => 'नया सदस्य जुड़ा';

  @override
  String get newMembersBody =>
      'नए ईमेल अपने क्लोज़्ड टेस्ट में जोड़ें और उनका ऐप इंस्टॉल करें। सेटअप टैब खोलें।';

  @override
  String get usageAccessOffTitle => 'यूसेज एक्सेस बंद है';

  @override
  String get usageAccessOffBody =>
      'सिर्फ़ खोलें बटन से खोले गए ऐप गिने जाते हैं। होम स्क्रीन से खोलने पर भी क्रेडिट पाने के लिए यूसेज एक्सेस चालू करें।';

  @override
  String get yourTestList => 'आपकी टेस्ट सूची';

  @override
  String get todayTitle => 'आज की टेस्टिंग';

  @override
  String get todayDone => 'आज का सब पूरा 🎉';

  @override
  String get todayDoneBody => 'बढ़िया! कल फिर आइए।';

  @override
  String todayBody(int needed) {
    return 'कम से कम $needed ऐप खोलें और हर एक को थोड़ा इस्तेमाल करें।';
  }

  @override
  String dayResetsAt(String time) {
    return 'नया दिन $time बजे शुरू होता है';
  }

  @override
  String get notInstalled => 'इंस्टॉल नहीं है';

  @override
  String openedMinutes(int minutes) {
    return 'आज खोला · $minutes मिनट';
  }

  @override
  String get notOpenedYet => 'आज नहीं खोला';

  @override
  String feedbackGivenCount(int count) {
    return 'फीडबैक ($count)';
  }

  @override
  String get giveFeedback => 'फीडबैक';

  @override
  String get statMembers => 'सदस्य';

  @override
  String get statOnTrack => 'आज सही राह पर';

  @override
  String get statRemoved => 'हटाए गए';

  @override
  String get membersLegend =>
      '🟢 सही राह पर  🟡 अभी बाकी  🔴 दिन छूटे  ⚪ चले गए';

  @override
  String memberSetupLine(String emails, int installed, int total) {
    return 'ईमेल $emails · इंस्टॉल $installed/$total';
  }

  @override
  String memberActiveLine(int installed, int opened, int total, int feedback) {
    return 'इंस्टॉल $installed/$total · खोले $opened/$total · फीडबैक $feedback';
  }

  @override
  String missedInARow(int count) {
    return 'लगातार $count दिन छूटे';
  }

  @override
  String get lastDays => 'पिछले दिन';

  @override
  String get viewProfile => 'प्रोफ़ाइल देखें';

  @override
  String get openInPlay => 'Play Store में खोलें';

  @override
  String get reportMember => 'रिपोर्ट करें';

  @override
  String get reportSent =>
      'रिपोर्ट भेजी गई। ग्रुप को निष्पक्ष रखने के लिए धन्यवाद।';

  @override
  String reportTitle(String name) {
    return '$name की रिपोर्ट करें';
  }

  @override
  String get reportExplain =>
      'कार्रवाई तभी होती है जब कई सदस्य रिपोर्ट करें और हमारा यूसेज डेटा भी सहमत हो। झूठी रिपोर्ट पर ट्रस्ट पॉइंट कटते हैं।';

  @override
  String get detailsOptional => 'विवरण (वैकल्पिक)';

  @override
  String get addScreenshot => 'स्क्रीनशॉट जोड़ें';

  @override
  String get screenshotAdded => 'स्क्रीनशॉट जुड़ गया ✓';

  @override
  String get sendReport => 'रिपोर्ट भेजें';

  @override
  String get noActivity => 'अभी कोई गतिविधि नहीं';

  @override
  String evFormed(int count) {
    return '$count डेवलपर्स के साथ ग्रुप बना';
  }

  @override
  String evJoined(String name) {
    return '$name ग्रुप में जुड़े';
  }

  @override
  String evEmailsAdded(String name) {
    return '$name ने सबके ईमेल जोड़े';
  }

  @override
  String get evStarted => 'टेस्टिंग शुरू: दिन 1';

  @override
  String evMemberActive(String name) {
    return '$name ने सेटअप पूरा करके टेस्टिंग शुरू की';
  }

  @override
  String evWarning(String name) {
    return '$name लगातार 2 दिन चूके (आखिरी चेतावनी)';
  }

  @override
  String evRemoved(String name, String reason) {
    return '$name को हटाया गया ($reason)';
  }

  @override
  String evSuspended(String name) {
    return '$name एडमिन समीक्षा में हैं';
  }

  @override
  String evReinstated(String name) {
    return '$name निर्दोष पाए गए और वापस आ गए';
  }

  @override
  String get evCompleted => 'ग्रुप पूरा हुआ 🏆';

  @override
  String get evCancelled => 'ग्रुप रद्द हुआ';

  @override
  String get feedbackSent => 'फीडबैक भेजा गया। धन्यवाद!';

  @override
  String feedbackFor(String app) {
    return 'फीडबैक: $app';
  }

  @override
  String get developerAsks => 'डेवलपर आपसे यह आज़माने को कहते हैं';

  @override
  String get rating => 'रेटिंग';

  @override
  String get category => 'श्रेणी';

  @override
  String get yourFeedback => 'आपका फीडबैक';

  @override
  String get feedbackHint =>
      'क्या अच्छा चला, क्या टूटा, क्या उलझा? स्पष्ट लिखें: स्क्रीन, स्टेप, डिवाइस।';

  @override
  String get feedbackMin => 'कम से कम 20 अक्षर';

  @override
  String get sendFeedback => 'फीडबैक भेजें';

  @override
  String get received => 'मिले';

  @override
  String get given => 'दिए';

  @override
  String get noFeedbackReceived => 'अभी कोई फीडबैक नहीं';

  @override
  String get noFeedbackReceivedBody =>
      'आपके ग्रुप के टेस्टर्स का फीडबैक यहां दिखेगा।';

  @override
  String get noFeedbackGiven => 'आपने अभी फीडबैक नहीं दिया';

  @override
  String get noFeedbackGivenBody =>
      'ग्रुप के आज टैब में हर ऐप पर फीडबैक बटन इस्तेमाल करें।';

  @override
  String fromOnApp(String name, String app) {
    return '$name, $app पर';
  }

  @override
  String get wasHelpful => 'क्या यह मददगार था?';

  @override
  String get markedHelpful => 'आपने इसे मददगार बताया (उन्हें +2 ट्रस्ट)';

  @override
  String get markedNotHelpful => 'मददगार नहीं बताया';

  @override
  String get groupHistory => 'ग्रुप';

  @override
  String get noGroupsYet => 'अभी कोई ग्रुप नहीं।';

  @override
  String get trustHistory => 'ट्रस्ट स्कोर इतिहास';

  @override
  String get noTrustHistory => 'अभी कोई बदलाव नहीं।';

  @override
  String get trustScore => 'ट्रस्ट स्कोर';

  @override
  String pointsToNext(int points) {
    return 'अगले लेवल के लिए $points पॉइंट';
  }

  @override
  String get statCompleted => 'पूरे ग्रुप';

  @override
  String get statCompletionRate => 'पूरा करने की दर';

  @override
  String get statDailyActivity => 'रोज़ की गतिविधि';

  @override
  String get statActiveDays => 'सक्रिय दिन';

  @override
  String get statFeedback => 'दिए फीडबैक';

  @override
  String get statHelpful => 'मददगार फीडबैक';

  @override
  String get badges => 'बैज';

  @override
  String get noBadges => 'बैज पाने के लिए अपना पहला ग्रुप पूरा करें।';

  @override
  String get systemLanguage => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get general => 'सामान्य';

  @override
  String get about => 'जानकारी';

  @override
  String get contactSupport => 'सपोर्ट से संपर्क';

  @override
  String get rateApp => 'TestPact को रेट करें';

  @override
  String get account => 'अकाउंट';

  @override
  String get deleteAccount => 'अकाउंट हटाएं';

  @override
  String get deleteAccountTitle => 'अपना अकाउंट हटाएं?';

  @override
  String get deleteAccountBody =>
      'आपकी प्रोफ़ाइल, ऐप्स और ट्रस्ट स्कोर हमेशा के लिए हट जाएंगे। अगर आप किसी ग्रुप में हैं तो उससे हटा दिए जाएंगे।';

  @override
  String get appealTitle => 'किसी फैसले पर अपील करें';

  @override
  String get appealExplain =>
      'बताएं क्या हुआ। एडमिन हर अपील की समीक्षा करते हैं। स्वीकार होने पर एक स्ट्राइक हटता है और कुछ ट्रस्ट पॉइंट वापस मिलते हैं।';

  @override
  String get appealHint =>
      'क्या हुआ? तारीखें और जांच में मदद करने वाली कोई भी जानकारी लिखें।';

  @override
  String get appealSent => 'अपील भेजी गई';

  @override
  String get sendAppeal => 'अपील भेजें';

  @override
  String get yourAppeals => 'आपकी अपीलें';

  @override
  String get appealOpen => 'समीक्षा का इंतज़ार';

  @override
  String get appealAccepted => 'स्वीकार';

  @override
  String get appealRejected => 'अस्वीकार';

  @override
  String get adminReviews => 'समीक्षाएं';

  @override
  String get adminAppeals => 'अपीलें';

  @override
  String get adminUsers => 'यूज़र';

  @override
  String get noteOptional => 'यूज़र के लिए नोट (वैकल्पिक)';

  @override
  String get nothingToReview => 'समीक्षा के लिए कुछ नहीं 🎉';

  @override
  String dataSummary(int active, int missed) {
    return 'यूसेज डेटा: $active सक्रिय दिन, $missed छूटे दिन';
  }

  @override
  String get rejectReports => 'रिपोर्ट खारिज करें';

  @override
  String get confirmKick => 'पुष्टि करें और हटाएं';

  @override
  String get searchByEmail => 'ईमेल से यूज़र खोजें';

  @override
  String get userNotFound => 'इस ईमेल का कोई यूज़र नहीं।';

  @override
  String userSummary(int trust, int strikes, String banned) {
    return 'ट्रस्ट $trust · स्ट्राइक $strikes · बैन: $banned';
  }

  @override
  String get ban => 'बैन करें';

  @override
  String get unban => 'बैन हटाएं';

  @override
  String get adjustTrust => 'ट्रस्ट स्कोर बदलें';

  @override
  String get notificationsInbox => 'नोटिफिकेशन';

  @override
  String get markAllRead => 'सभी पढ़े हुए करें';

  @override
  String get noNotifications => 'अभी कोई नोटिफिकेशन नहीं';

  @override
  String get noNotificationsBody =>
      'ग्रुप अपडेट, रिमाइंडर, चेतावनियां और फीडबैक अलर्ट यहां दिखेंगे।';

  @override
  String get notificationSettings => 'नोटिफिकेशन';

  @override
  String get notifPermissionOff => 'TestPact के लिए नोटिफिकेशन बंद हैं';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get notifDaily => 'रोज़ के रिमाइंडर';

  @override
  String get notifDailySub =>
      'अगर आज के ऐप नहीं खोले तो शाम को रिमाइंडर, और सेटअप की समय-सीमा';

  @override
  String get notifGroup => 'ग्रुप अपडेट';

  @override
  String get notifGroupSub => 'ग्रुप बना, टेस्ट शुरू, नए सदस्य, पूरा होना';

  @override
  String get notifFeedback => 'फीडबैक';

  @override
  String get notifFeedbackSub => 'जब कोई आपके ऐप पर फीडबैक दे';

  @override
  String get notifImportantNote =>
      'चेतावनियां और हटाए जाने की सूचना हमेशा भेजी जाती है, ताकि आपकी जगह से जुड़ी कोई बात न छूटे।';

  @override
  String get noInternetTitle => 'इंटरनेट कनेक्शन नहीं है';

  @override
  String get noInternetBody =>
      'अपना Wi-Fi या मोबाइल डेटा जांचें। ऑनलाइन होते ही TestPact अपने-आप जुड़ जाएगा।';

  @override
  String get checkingConnection => 'जांच रहे हैं…';

  @override
  String get backOnline => 'फिर से ऑनलाइन';

  @override
  String get updateRequiredTitle => 'अपडेट ज़रूरी है';

  @override
  String get updateRequiredBody =>
      'TestPact का यह वर्शन अब सपोर्टेड नहीं है। अपने ग्रुप के साथ टेस्टिंग जारी रखने के लिए अपडेट करें।';

  @override
  String get updateAvailableTitle => 'अपडेट उपलब्ध है';

  @override
  String get updateAvailableBody =>
      'TestPact का नया वर्शन सुधारों और फिक्स के साथ तैयार है।';

  @override
  String get updateNow => 'अभी अपडेट करें';

  @override
  String get later => 'बाद में';

  @override
  String get updateDownloaded =>
      'अपडेट डाउनलोड हो गया। इंस्टॉल पूरा करने के लिए रीस्टार्ट करें।';

  @override
  String get restart => 'रीस्टार्ट';

  @override
  String appVersion(String version) {
    return 'वर्शन $version';
  }

  @override
  String get welcomeBack => 'आपको फिर देखकर अच्छा लगा!';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get more => 'और';

  @override
  String get filterAll => 'सभी';

  @override
  String get statusTesting => 'टेस्टिंग';

  @override
  String get inQueueShort => 'कतार में';

  @override
  String get statusReady => 'तैयार';

  @override
  String get memberDone => 'पूरा';

  @override
  String get memberTesting => 'टेस्टिंग';

  @override
  String get memberPending => 'आज बाकी';

  @override
  String get todaysTasks => 'आज के काम';

  @override
  String tasksCompleted(int total, int done) {
    return '$total ऐप · $done/$total पूरे';
  }

  @override
  String groupMembersCount(int count) {
    return 'ग्रुप सदस्य ($count)';
  }

  @override
  String get recentActivity => 'हाल की गतिविधि';

  @override
  String badgesEarned(int earned, int total) {
    return '$total में से $earned मिले';
  }

  @override
  String get adLabel => 'विज्ञापन';

  @override
  String get privateDnsTitle => 'Private DNS बंद करें';

  @override
  String get privateDnsBody =>
      'TestPact कुछ छोटे विज्ञापनों की वजह से मुफ़्त है। आपका Private DNS उन्हें ब्लॉक करता है, इसलिए ऐप इस्तेमाल करते रहने के लिए कृपया इसे बंद करें।';

  @override
  String get privateDnsStep1 =>
      'Settings → Network & internet (या Connections → More connection settings) खोलें';

  @override
  String get privateDnsStep2 => 'Private DNS पर टैप करें';

  @override
  String get privateDnsStep3 => 'Off या Automatic चुनें, फिर यहां वापस आएं';

  @override
  String get privateDnsDone => 'मैंने बंद कर दिया';

  @override
  String get adsSection => 'विज्ञापन';

  @override
  String get removeAdsTitle => '24 घंटे के लिए कोई विज्ञापन नहीं';

  @override
  String get removeAdsBody =>
      'एक छोटा वीडियो देखें और पूरे दिन विज्ञापन छिपाएं';

  @override
  String adFreeUntil(String time) {
    return '$time तक विज्ञापन-मुक्त';
  }

  @override
  String get adFreeGranted => 'धन्यवाद! अगले 24 घंटे कोई विज्ञापन नहीं।';

  @override
  String get adNotAvailable =>
      'अभी कोई वीडियो उपलब्ध नहीं है। कृपया बाद में कोशिश करें।';

  @override
  String get adPrivacyOptions => 'विज्ञापन प्राइवेसी विकल्प';
}
