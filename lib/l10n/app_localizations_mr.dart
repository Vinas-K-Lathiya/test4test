// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get cancel => 'रद्द करा';

  @override
  String get save => 'सेव्ह करा';

  @override
  String get saved => 'सेव्ह झाले';

  @override
  String get delete => 'हटवा';

  @override
  String get edit => 'बदला';

  @override
  String get next => 'पुढे';

  @override
  String get retry => 'पुन्हा प्रयत्न करा';

  @override
  String get yes => 'हो';

  @override
  String get no => 'नाही';

  @override
  String get you => 'तुम्ही';

  @override
  String get required => 'आवश्यक';

  @override
  String get open => 'उघडा';

  @override
  String get install => 'इन्स्टॉल करा';

  @override
  String get leave => 'सोडा';

  @override
  String get accept => 'स्वीकारा';

  @override
  String get reject => 'नाकारा';

  @override
  String get confirmAction => 'पुष्टी करा';

  @override
  String get errDeviceInUse =>
      'हा फोन आधीच दुसऱ्या TestPact अकाउंटशी जोडलेला आहे. प्रत्येक डिव्हाइसवर एक अकाउंट ठेवल्याने ग्रुप न्याय्य राहतात.';

  @override
  String get errBanned =>
      'सध्या तुमचे अकाउंट नवीन ग्रुपमध्ये सामील होऊ शकत नाही. तुम्ही अपील पाठवू शकता.';

  @override
  String get errAlreadyInGroup =>
      'तुम्ही आधीच एका ग्रुपमध्ये आहात. आधी तो पूर्ण करा.';

  @override
  String get errAppNotFound => 'ही ॲप लिस्टिंग आता अस्तित्वात नाही.';

  @override
  String get errAppealOpen =>
      'तुमचे एक अपील आधीच पुनरावलोकनासाठी प्रलंबित आहे.';

  @override
  String get errAlreadyRated => 'तुम्ही हा फीडबॅक आधीच रेट केला आहे.';

  @override
  String get errIntegrity =>
      'हे डिव्हाइस Google Play च्या इंटिग्रिटी तपासणीत पास झाले नाही. Google Play वरून इन्स्टॉल केलेल्या ॲपसह खरा फोन वापरा.';

  @override
  String get errNetwork =>
      'कनेक्शन नाही. इंटरनेट तपासा आणि पुन्हा प्रयत्न करा.';

  @override
  String get errGeneric => 'काहीतरी चुकले. कृपया पुन्हा प्रयत्न करा.';

  @override
  String get levelProbation => 'प्रोबेशन';

  @override
  String get levelNewcomer => 'नवीन सदस्य';

  @override
  String get levelMember => 'सदस्य';

  @override
  String get levelTrusted => 'विश्वासू';

  @override
  String get levelTopTester => 'टॉप टेस्टर';

  @override
  String get reasonNotInstalled => 'माझे ॲप इन्स्टॉल केले नाही';

  @override
  String get reasonUninstalled => 'टेस्टदरम्यान अनइन्स्टॉल केले';

  @override
  String get reasonNotOpening => 'रोज ॲप्स उघडत नाहीत';

  @override
  String get reasonEmailNotAdded => 'माझा ईमेल त्यांच्या टेस्टमध्ये जोडला नाही';

  @override
  String get reasonSpam => 'स्पॅम किंवा गैरवर्तन';

  @override
  String get reasonFakeFeedback => 'बनावट किंवा कॉपी-पेस्ट फीडबॅक';

  @override
  String get reasonOther => 'इतर';

  @override
  String get catBug => 'बग';

  @override
  String get catUx => 'डिझाइन / UX';

  @override
  String get catIdea => 'कल्पना';

  @override
  String get catPraise => 'कौतुक';

  @override
  String get catOther => 'इतर';

  @override
  String get badgeFirstPact => 'पहिला पॅक्ट';

  @override
  String get badgeVeteran => 'अनुभवी (5 ग्रुप)';

  @override
  String get badgePerfect => 'परफेक्ट स्ट्रीक';

  @override
  String get badgeHelpful => 'उपयुक्त समीक्षक';

  @override
  String get badgeTopTester => 'टॉप टेस्टर';

  @override
  String get removedSetup => 'सेटअप वेळेत पूर्ण झाला नाही';

  @override
  String get removedInactive => '3 दिवस निष्क्रिय';

  @override
  String get removedReported => 'ॲडमिनने तक्रारींची पुष्टी केली';

  @override
  String get removedLeft => 'ग्रुप सोडला';

  @override
  String get removedCancelled => 'ग्रुप रद्द झाला';

  @override
  String get removedEnded => 'ग्रुप संपला';

  @override
  String get removedOther => 'काढले';

  @override
  String trustAdmin(String reason) {
    return 'ॲडमिनकडून बदल: $reason';
  }

  @override
  String get trustGroupCompleted => 'ग्रुप पूर्ण केला';

  @override
  String get trustActiveDay => 'दिवसाची सर्व ॲप्स उघडली';

  @override
  String get trustMissedDay => 'एक दिवस चुकला';

  @override
  String get trustHelpfulFeedback => 'फीडबॅक उपयुक्त ठरला';

  @override
  String get trustKickedInactive => 'निष्क्रियतेमुळे काढले';

  @override
  String get trustKickedReported => 'पुष्टी झालेल्या तक्रारींनंतर काढले';

  @override
  String get trustSetupFailed => 'सेटअप पूर्ण झाला नाही';

  @override
  String get trustLeftGroup => 'ग्रुप लवकर सोडला';

  @override
  String get trustFalseReport => 'ॲडमिनने तक्रार नाकारली';

  @override
  String get trustAppealAccepted => 'अपील स्वीकारले';

  @override
  String get statusSetup => 'सेटअप';

  @override
  String get statusActive => 'टेस्टिंग';

  @override
  String get statusCompleted => 'पूर्ण';

  @override
  String get statusCancelled => 'रद्द';

  @override
  String get stateSetup => 'सेटअप सुरू';

  @override
  String get stateActive => 'टेस्टिंग';

  @override
  String get stateSuspended => 'पुनरावलोकनात';

  @override
  String get stateRemoved => 'काढले';

  @override
  String get stateCompleted => 'पूर्ण';

  @override
  String get language => 'भाषा';

  @override
  String get tagline =>
      'खरे टेस्टर. खरा फीडबॅक.\nएकत्र मिळून Google Play क्लोज्ड टेस्टिंग पास करा.';

  @override
  String get signInBullet1 =>
      '20 पर्यंत Android डेव्हलपर्सच्या ग्रुपमध्ये सामील व्हा';

  @override
  String get signInBullet2 =>
      'इन्स्टॉल आणि रोजचा वापर डिव्हाइसवरच पडताळला जातो';

  @override
  String get signInBullet3 =>
      'प्रामाणिक फीडबॅक द्या आणि मिळवा, ज्यामुळे तुमचे ॲप सुधारते';

  @override
  String get continueWithGoogle => 'Google सह पुढे जा';

  @override
  String get privacyPolicy => 'प्रायव्हसी पॉलिसी';

  @override
  String get terms => 'अटी';

  @override
  String get ob1Title => 'डेव्हलपर्समधील करार';

  @override
  String get ob1P1 =>
      'नवीन पर्सनल अकाउंटला प्रोडक्शनपूर्वी 14 दिवस 12 ऑप्ट-इन टेस्टर लागतात.';

  @override
  String get ob1P2 =>
      'तुम्ही एका ग्रुपमध्ये सामील होता. सगळे एकमेकांना टेस्टर म्हणून जोडतात आणि सगळ्यांची ॲप्स इन्स्टॉल करतात.';

  @override
  String get ob1P3 =>
      '16 दिवस तुम्ही तुमच्या यादीतील प्रत्येक ॲप रोज उघडता, आणि बाकी सगळे तुमच्या ॲपसाठी तेच करतात.';

  @override
  String get ob2Title => 'सर्वांसाठी न्याय्य';

  @override
  String get ob2P1 =>
      'तुम्ही इतरांचे ईमेल जोडल्यानंतरच तुमचे ॲप त्यांना दिसते: आधी द्या, मग मिळवा.';

  @override
  String get ob2P2 =>
      'रोज टेस्ट केल्याने आणि उपयुक्त फीडबॅक दिल्याने ट्रस्ट स्कोर वाढतो, न केल्यास कमी होतो.';

  @override
  String get ob2P3 =>
      'निष्क्रिय सदस्यांना चेतावणी मिळते आणि 3 दिवस चुकल्यास काढले जाते. तक्रारी खऱ्या वापराच्या डेटाशी तपासल्या जातात.';

  @override
  String get ob3Title => 'तुमचे टेस्टिंग आपोआप सिद्ध करा';

  @override
  String get ob3P1 =>
      'TestPact फक्त तुम्हाला दिलेली ॲप्स तपासते: इन्स्टॉल आहेत का, आणि आज किती मिनिटे वापरली.';

  @override
  String get ob3P2 =>
      'तुमच्या इतर ॲप्सबद्दल काहीही कधीही वाचले किंवा पाठवले जात नाही.';

  @override
  String get usageAccessTitle => 'युसेज ॲक्सेस';

  @override
  String get usageAccessBody =>
      'यामुळे TestPact तुम्हाला दिलेल्या ॲप्समध्ये घालवलेली मिनिटे मोजू शकते, म्हणजे होम स्क्रीनवरून उघडले तरी तुम्हाला क्रेडिट मिळते.';

  @override
  String get granted => 'परवानगी दिली ✓';

  @override
  String get notGranted => 'परवानगी नाही, सुरू करण्यासाठी टॅप करा';

  @override
  String get grantUsageAccess => 'युसेज ॲक्सेस द्या';

  @override
  String get notificationsTitle => 'रिमाइंडर';

  @override
  String get notificationsBody =>
      'रोजचे रिमाइंडर आणि ग्रुप अपडेट, म्हणजे एकही दिवस चुकणार नाही.';

  @override
  String get allowNotifications => 'नोटिफिकेशनला परवानगी द्या';

  @override
  String get getStarted => 'सुरू करा';

  @override
  String get settingUp => 'तुमचे अकाउंट तयार होत आहे…';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get tabHome => 'होम';

  @override
  String get tabMyApps => 'माझी ॲप्स';

  @override
  String get tabFeedback => 'फीडबॅक';

  @override
  String get tabProfile => 'प्रोफाइल';

  @override
  String get admin => 'ॲडमिन';

  @override
  String get settings => 'सेटिंग्ज';

  @override
  String get addApp => 'ॲप जोडा';

  @override
  String get bannedTitle => 'अकाउंट प्रतिबंधित';

  @override
  String bannedBody(int count) {
    return 'तुमचे $count स्ट्राइक आहेत, त्यामुळे तुम्ही नवीन ग्रुपमध्ये सामील होऊ शकत नाही. ही चूक वाटत असल्यास अपील पाठवा.';
  }

  @override
  String get appeal => 'अपील';

  @override
  String strikesTitle(int count) {
    return 'तुमच्या अकाउंटवर $count स्ट्राइक';
  }

  @override
  String get strikesBody =>
      '3 स्ट्राइक झाल्यास तुम्ही नवीन ग्रुपमध्ये सामील होऊ शकत नाही. निष्क्रियता किंवा पुष्टी झालेल्या तक्रारींमुळे काढल्यास स्ट्राइक मिळतो.';

  @override
  String get howItWorks => 'हे कसे काम करते';

  @override
  String get googleRuleTitle => 'Google Play चा नियम';

  @override
  String get googleRuleBody =>
      '13 नोव्हेंबर 2023 नंतर तयार झालेल्या पर्सनल डेव्हलपर अकाउंटला सलग 14 दिवस किमान 12 ऑप्ट-इन टेस्टर लागतात. ग्रुप 20 जणांनी सुरू होतात आणि 16 दिवस चालतात, त्यामुळे तुमच्याकडे जास्तीची जागा राहते. टेस्टर्सनी ॲप खरोखर वापरले का हेही Google पाहते, म्हणून फक्त इन्स्टॉल करू नका, ॲप उघडून वापरा.';

  @override
  String hello(String name) {
    return 'नमस्कार, $name 👋';
  }

  @override
  String get joinCardTitle => 'तुमचे टेस्टर शोधायला तयार?';

  @override
  String get joinCardBody =>
      'रांगेत सामील व्हा. पुरेसे डेव्हलपर होताच तुमचा ग्रुप आपोआप तयार होईल.';

  @override
  String get joinCardNoApps =>
      'आधी टेस्ट करायचे ॲप जोडा, त्याच्या क्लोज्ड टेस्टिंग लिंकसह.';

  @override
  String get joinGroup => 'ग्रुपमध्ये सामील व्हा';

  @override
  String get addYourApp => 'तुमचे ॲप जोडा';

  @override
  String get inQueueTitle => 'तुम्ही रांगेत आहात';

  @override
  String inQueueBody(String app, String tier) {
    return '$app ला $tier ग्रुपमध्ये जोडण्याची वाट पाहत आहोत. तयार झाल्यावर आम्ही तुम्हाला कळवू.';
  }

  @override
  String get tierTrusted => 'विश्वासू';

  @override
  String get tierStarter => 'स्टार्टर';

  @override
  String queueWaiting(int count, int size) {
    return '$size पैकी $count डेव्हलपर वाट पाहत आहेत';
  }

  @override
  String queueJoinedAt(String time) {
    return '$time ला सामील झाले';
  }

  @override
  String get leaveQueue => 'रांग सोडा';

  @override
  String dayOf(int day, int total) {
    return 'दिवस $day / $total';
  }

  @override
  String groupTitle(String id) {
    return 'ग्रुप #$id';
  }

  @override
  String openedToday(int opened, int total) {
    return 'आज उघडली: $total पैकी $opened';
  }

  @override
  String get setupDoneWaiting => 'सेटअप पूर्ण ✓ इतरांची वाट पाहत आहोत.';

  @override
  String get setupTodo =>
      'सेटअप पूर्ण करा: ईमेल जोडा आणि सगळ्यांची ॲप्स इन्स्टॉल करा.';

  @override
  String get suspendedBody =>
      'अनेक तक्रारींनंतर तुम्ही पुनरावलोकनात आहात. ॲडमिन तुमचा ॲक्टिव्हिटी डेटा तपासत आहेत.';

  @override
  String get openGroup => 'ग्रुप उघडा';

  @override
  String get step1Title => 'तुमचे ॲप जोडा';

  @override
  String get step1Body => 'नाव, पॅकेज आणि तुमची क्लोज्ड टेस्टिंग ऑप्ट-इन लिंक.';

  @override
  String get step2Title => 'रांगेत सामील व्हा';

  @override
  String get step2Body =>
      '20 जणांचे ग्रुप आपोआप तयार होतात. विश्वासू टेस्टर्स एकत्र जोडले जातात.';

  @override
  String get step3Title => '48 तासांत सेटअप';

  @override
  String get step3Body =>
      'सगळ्यांचे ईमेल Play Console मध्ये पेस्ट करा, मग प्रत्येक ॲपमध्ये सामील होऊन इन्स्टॉल करा.';

  @override
  String get step4Title => '16 दिवस रोज टेस्ट करा';

  @override
  String get step4Body =>
      'प्रत्येक ॲप रोज उघडा आणि खरा फीडबॅक द्या. आम्ही डिव्हाइसवर पडताळतो.';

  @override
  String get step5Title => 'प्रोडक्शनसाठी अर्ज';

  @override
  String get step5Body =>
      'ट्रस्ट पॉइंट आणि बॅज मिळवा, मग Play Console मध्ये प्रोडक्शनसाठी अर्ज करा.';

  @override
  String get rule1 =>
      'मी 48 तासांत प्रत्येक सदस्याचा ईमेल माझ्या क्लोज्ड टेस्टमध्ये जोडेन.';

  @override
  String get rule2 =>
      'मी प्रत्येक सदस्याचे ॲप इन्स्टॉल करेन आणि शेवटपर्यंत ठेवेन.';

  @override
  String get rule3 =>
      'मी 16 दिवस रोज प्रत्येक ॲप उघडेन आणि प्रामाणिक फीडबॅक देईन.';

  @override
  String get rule4 =>
      'निष्क्रिय सदस्यांना काढले जाते आणि ते ट्रस्ट पॉइंट गमावतात हे मला समजते.';

  @override
  String get chooseApp => 'कोणते ॲप टेस्ट व्हावे?';

  @override
  String get yourCommitment => 'तुमचे वचन';

  @override
  String get joinedQueue => 'तुम्ही रांगेत आहात!';

  @override
  String get joinQueue => 'रांगेत सामील व्हा';

  @override
  String get noAppsTitle => 'अजून कोणतेही ॲप नाही';

  @override
  String get noAppsBody =>
      'टेस्ट करायचे ॲप जोडा. त्यासाठी Play Console मधील क्लोज्ड टेस्टिंग ऑप्ट-इन लिंक लागेल.';

  @override
  String get deleteAppTitle => 'हे ॲप हटवायचे?';

  @override
  String get deleteAppBody =>
      'ज्या ग्रुपमध्ये ते आधीच आहे तिथे त्याची प्रत राहील. तुम्ही नंतर पुन्हा जोडू शकता.';

  @override
  String get editApp => 'ॲप बदला';

  @override
  String get appIcon => 'आयकन सेट करण्यासाठी टॅप करा';

  @override
  String get appName => 'ॲपचे नाव';

  @override
  String get packageName => 'पॅकेज नाव';

  @override
  String get invalidPackage => 'योग्य पॅकेज नाव लिहा, उदा. com.example.app';

  @override
  String get optInLink => 'क्लोज्ड टेस्टिंग ऑप्ट-इन लिंक';

  @override
  String get optInHelp =>
      'Play Console → Testing → Closed testing → Testers → \"Join on the web\" लिंक.';

  @override
  String get invalidOptIn => 'ही play.google.com/apps/testing/… लिंक असावी';

  @override
  String get shortDescription => 'थोडक्यात वर्णन';

  @override
  String get testNotes => 'टेस्टर्सनी काय करून पाहावे?';

  @override
  String get testNotesHelp =>
      'उदा. \"अकाउंट तयार करा आणि कार्टमध्ये 2 वस्तू जोडा\". हे टेस्टर्सना रोज दिसेल.';

  @override
  String get closedTestTipTitle => 'सामील होण्यापूर्वी';

  @override
  String get closedTestTipBody =>
      'क्लोज्ड टेस्टिंग ट्रॅक तयार करा, बिल्ड अपलोड करून रोल आउट करा आणि टेस्टर्स ईमेल लिस्टवर सेट करा. तुमच्या ग्रुपचे ईमेल तिथे जातील.';

  @override
  String get tabToday => 'आज';

  @override
  String get tabSetup => 'सेटअप';

  @override
  String get tabMembers => 'सदस्य';

  @override
  String get tabActivity => 'घडामोडी';

  @override
  String get leaveGroup => 'ग्रुप सोडा';

  @override
  String get leaveGroupTitle => 'हा ग्रुप सोडायचा?';

  @override
  String get leaveGroupBody =>
      'इतर सदस्य तुमचे ॲप टेस्ट करणे थांबवतील आणि तुमचे ट्रस्ट पॉइंट कमी होतील. हे परत करता येणार नाही.';

  @override
  String youWereRemoved(String reason) {
    return 'तुम्हाला काढले: $reason.';
  }

  @override
  String get youCompleted =>
      'तुम्ही हा ग्रुप पूर्ण केला 🏆 आता तुम्ही Play Console मध्ये प्रोडक्शन ॲक्सेससाठी अर्ज करू शकता.';

  @override
  String get setupDeadlinePassed => 'सेटअपची मुदत संपली. प्रक्रिया सुरू आहे…';

  @override
  String setupTimeLeft(int hours, int minutes) {
    return 'सेटअप पूर्ण करण्यासाठी $hoursता $minutesमि बाकी';
  }

  @override
  String get setupExplain =>
      'जे सदस्य पूर्ण करत नाहीत त्यांच्या जागी रांगेतील लोक येतात. सगळे तयार झाल्यावर टेस्ट सुरू होते.';

  @override
  String get step1AddEmails =>
      'पायरी 1 · तुमच्या क्लोज्ड टेस्टमध्ये टेस्टर जोडा';

  @override
  String addEmailsBody(int count) {
    return 'सर्व $count ईमेल कॉपी करा आणि Play Console मध्ये तुमच्या क्लोज्ड टेस्टिंग ईमेल लिस्टमध्ये पेस्ट करा.';
  }

  @override
  String get copyAllEmails => 'सर्व ईमेल कॉपी करा';

  @override
  String copied(int count) {
    return '$count ईमेल कॉपी झाले';
  }

  @override
  String get emailsConfirmed => 'ईमेल जोडले';

  @override
  String get iAddedEveryone => 'मी सगळ्यांना जोडले';

  @override
  String get confirmEmailsTitle => 'तुम्ही सर्व ईमेल जोडले का?';

  @override
  String confirmEmailsBody(int count) {
    return 'सर्व $count ईमेल तुमच्या क्लोज्ड टेस्टच्या टेस्टर लिस्टमध्ये आहेत आणि बदल सेव्ह झाला आहे याची पुष्टी करा. सदस्य सामील होऊ शकले नाहीत तर ते तुमची तक्रार करू शकतात.';
  }

  @override
  String get yesAdded => 'हो, सगळे जोडले';

  @override
  String get emailsHowTo =>
      'Play Console → तुमचे ॲप → Testing → Closed testing → Testers → Email list → पेस्ट → Save.';

  @override
  String step2InstallApps(int done, int total) {
    return 'पायरी 2 · ॲप्समध्ये सामील व्हा आणि इन्स्टॉल करा ($done/$total)';
  }

  @override
  String get checkAgain => 'पुन्हा तपासा';

  @override
  String waitingForOwners(int count) {
    return '$count सदस्यांनी अजून ग्रुपचे ईमेल जोडलेले नाहीत. जोडल्यानंतर त्यांची ॲप्स इथे दिसतील.';
  }

  @override
  String get noAppsYet => 'अजून इन्स्टॉल करण्यासाठी ॲप्स नाहीत.';

  @override
  String byName(String name) {
    return '$name यांचे';
  }

  @override
  String get joinTest => 'टेस्टमध्ये सामील व्हा';

  @override
  String get newMembersTitle => 'नवीन सदस्य सामील';

  @override
  String get newMembersBody =>
      'नवीन ईमेल तुमच्या क्लोज्ड टेस्टमध्ये जोडा आणि त्यांचे ॲप इन्स्टॉल करा. सेटअप टॅब उघडा.';

  @override
  String get usageAccessOffTitle => 'युसेज ॲक्सेस बंद आहे';

  @override
  String get usageAccessOffBody =>
      'फक्त उघडा बटणाने उघडलेली ॲप्स मोजली जातात. होम स्क्रीनवरून उघडल्यावरही क्रेडिट मिळवण्यासाठी युसेज ॲक्सेस सुरू करा.';

  @override
  String get yourTestList => 'तुमची टेस्ट यादी';

  @override
  String get todayTitle => 'आजचे टेस्टिंग';

  @override
  String get todayDone => 'आजचे सगळे पूर्ण 🎉';

  @override
  String get todayDoneBody => 'छान! उद्या पुन्हा या.';

  @override
  String todayBody(int needed) {
    return 'किमान $needed ॲप्स उघडा आणि प्रत्येक थोडा वेळ वापरा.';
  }

  @override
  String dayResetsAt(String time) {
    return 'नवीन दिवस $time वाजता सुरू होतो';
  }

  @override
  String get notInstalled => 'इन्स्टॉल नाही';

  @override
  String openedMinutes(int minutes) {
    return 'आज उघडले · $minutes मिनिटे';
  }

  @override
  String get notOpenedYet => 'आज उघडले नाही';

  @override
  String feedbackGivenCount(int count) {
    return 'फीडबॅक ($count)';
  }

  @override
  String get giveFeedback => 'फीडबॅक';

  @override
  String get statMembers => 'सदस्य';

  @override
  String get statOnTrack => 'आज योग्य मार्गावर';

  @override
  String get statRemoved => 'काढलेले';

  @override
  String get membersLegend =>
      '🟢 योग्य मार्गावर  🟡 अजून बाकी  🔴 दिवस चुकले  ⚪ गेले';

  @override
  String memberSetupLine(String emails, int installed, int total) {
    return 'ईमेल $emails · इन्स्टॉल $installed/$total';
  }

  @override
  String memberActiveLine(int installed, int opened, int total, int feedback) {
    return 'इन्स्टॉल $installed/$total · उघडली $opened/$total · फीडबॅक $feedback';
  }

  @override
  String missedInARow(int count) {
    return 'सलग $count दिवस चुकले';
  }

  @override
  String get lastDays => 'मागील दिवस';

  @override
  String get viewProfile => 'प्रोफाइल पहा';

  @override
  String get openInPlay => 'Play Store मध्ये उघडा';

  @override
  String get reportMember => 'तक्रार करा';

  @override
  String get reportSent => 'तक्रार पाठवली. ग्रुप न्याय्य ठेवल्याबद्दल धन्यवाद.';

  @override
  String reportTitle(String name) {
    return '$name यांची तक्रार करा';
  }

  @override
  String get reportExplain =>
      'अनेक सदस्यांनी तक्रार केली आणि आमचा वापर डेटा सहमत असेल तेव्हाच कारवाई होते. खोट्या तक्रारींमुळे ट्रस्ट पॉइंट कमी होतात.';

  @override
  String get detailsOptional => 'तपशील (ऐच्छिक)';

  @override
  String get addScreenshot => 'स्क्रीनशॉट जोडा';

  @override
  String get screenshotAdded => 'स्क्रीनशॉट जोडला ✓';

  @override
  String get sendReport => 'तक्रार पाठवा';

  @override
  String get noActivity => 'अजून घडामोडी नाहीत';

  @override
  String evFormed(int count) {
    return '$count डेव्हलपर्ससह ग्रुप तयार झाला';
  }

  @override
  String evJoined(String name) {
    return '$name ग्रुपमध्ये सामील झाले';
  }

  @override
  String evEmailsAdded(String name) {
    return '$name यांनी सगळ्यांचे ईमेल जोडले';
  }

  @override
  String get evStarted => 'टेस्टिंग सुरू: दिवस 1';

  @override
  String evMemberActive(String name) {
    return '$name यांनी सेटअप पूर्ण करून टेस्टिंग सुरू केले';
  }

  @override
  String evWarning(String name) {
    return '$name सलग 2 दिवस चुकले (शेवटची चेतावणी)';
  }

  @override
  String evRemoved(String name, String reason) {
    return '$name यांना काढले ($reason)';
  }

  @override
  String evSuspended(String name) {
    return '$name ॲडमिन पुनरावलोकनात आहेत';
  }

  @override
  String evReinstated(String name) {
    return '$name निर्दोष ठरले आणि परत आले';
  }

  @override
  String get evCompleted => 'ग्रुप पूर्ण झाला 🏆';

  @override
  String get evCancelled => 'ग्रुप रद्द झाला';

  @override
  String get feedbackSent => 'फीडबॅक पाठवला. धन्यवाद!';

  @override
  String feedbackFor(String app) {
    return 'फीडबॅक: $app';
  }

  @override
  String get developerAsks => 'डेव्हलपर तुम्हाला हे करून पाहायला सांगतात';

  @override
  String get rating => 'रेटिंग';

  @override
  String get category => 'प्रकार';

  @override
  String get yourFeedback => 'तुमचा फीडबॅक';

  @override
  String get feedbackHint =>
      'काय चांगले चालले, काय बिघडले, काय गोंधळात टाकणारे होते? नेमके लिहा: स्क्रीन, पायऱ्या, डिव्हाइस.';

  @override
  String get feedbackMin => 'किमान 20 अक्षरे';

  @override
  String get sendFeedback => 'फीडबॅक पाठवा';

  @override
  String get received => 'मिळालेले';

  @override
  String get given => 'दिलेले';

  @override
  String get noFeedbackReceived => 'अजून फीडबॅक नाही';

  @override
  String get noFeedbackReceivedBody =>
      'तुमच्या ग्रुपमधील टेस्टर्सचा फीडबॅक इथे दिसेल.';

  @override
  String get noFeedbackGiven => 'तुम्ही अजून फीडबॅक दिलेला नाही';

  @override
  String get noFeedbackGivenBody =>
      'ग्रुपच्या आज टॅबमध्ये प्रत्येक ॲपवरील फीडबॅक बटण वापरा.';

  @override
  String fromOnApp(String name, String app) {
    return '$name, $app वर';
  }

  @override
  String get wasHelpful => 'हे उपयुक्त होते का?';

  @override
  String get markedHelpful => 'तुम्ही हे उपयुक्त ठरवले (त्यांना +2 ट्रस्ट)';

  @override
  String get markedNotHelpful => 'उपयुक्त नाही ठरवले';

  @override
  String get groupHistory => 'ग्रुप';

  @override
  String get noGroupsYet => 'अजून कोणताही ग्रुप नाही.';

  @override
  String get trustHistory => 'ट्रस्ट स्कोर इतिहास';

  @override
  String get noTrustHistory => 'अजून कोणताही बदल नाही.';

  @override
  String get trustScore => 'ट्रस्ट स्कोर';

  @override
  String pointsToNext(int points) {
    return 'पुढील लेव्हलसाठी $points पॉइंट';
  }

  @override
  String get statCompleted => 'पूर्ण केलेले ग्रुप';

  @override
  String get statCompletionRate => 'पूर्णता दर';

  @override
  String get statDailyActivity => 'रोजची सक्रियता';

  @override
  String get statActiveDays => 'सक्रिय दिवस';

  @override
  String get statFeedback => 'दिलेले फीडबॅक';

  @override
  String get statHelpful => 'उपयुक्त फीडबॅक';

  @override
  String get badges => 'बॅज';

  @override
  String get noBadges => 'बॅज मिळवण्यासाठी तुमचा पहिला ग्रुप पूर्ण करा.';

  @override
  String get systemLanguage => 'सिस्टम डीफॉल्ट';

  @override
  String get general => 'सामान्य';

  @override
  String get about => 'माहिती';

  @override
  String get contactSupport => 'सपोर्टशी संपर्क';

  @override
  String get rateApp => 'TestPact ला रेट करा';

  @override
  String get account => 'अकाउंट';

  @override
  String get deleteAccount => 'अकाउंट हटवा';

  @override
  String get deleteAccountTitle => 'तुमचे अकाउंट हटवायचे?';

  @override
  String get deleteAccountBody =>
      'तुमचे प्रोफाइल, ॲप्स आणि ट्रस्ट स्कोर कायमचे हटवले जातील. तुम्ही एखाद्या ग्रुपमध्ये असाल तर त्यातून काढले जाल.';

  @override
  String get appealTitle => 'निर्णयाविरुद्ध अपील करा';

  @override
  String get appealExplain =>
      'काय झाले ते सांगा. ॲडमिन प्रत्येक अपीलचे पुनरावलोकन करतात. स्वीकारल्यास एक स्ट्राइक हटतो आणि काही ट्रस्ट पॉइंट परत मिळतात.';

  @override
  String get appealHint =>
      'काय झाले? तारखा आणि तपासणीस मदत करणारी कोणतीही माहिती लिहा.';

  @override
  String get appealSent => 'अपील पाठवले';

  @override
  String get sendAppeal => 'अपील पाठवा';

  @override
  String get yourAppeals => 'तुमची अपील';

  @override
  String get appealOpen => 'पुनरावलोकनाची वाट';

  @override
  String get appealAccepted => 'स्वीकारले';

  @override
  String get appealRejected => 'नाकारले';

  @override
  String get adminReviews => 'पुनरावलोकने';

  @override
  String get adminAppeals => 'अपील';

  @override
  String get adminUsers => 'युजर्स';

  @override
  String get noteOptional => 'युजरसाठी टीप (ऐच्छिक)';

  @override
  String get nothingToReview => 'पुनरावलोकनासाठी काही नाही 🎉';

  @override
  String dataSummary(int active, int missed) {
    return 'वापर डेटा: $active सक्रिय दिवस, $missed चुकलेले दिवस';
  }

  @override
  String get rejectReports => 'तक्रारी नाकारा';

  @override
  String get confirmKick => 'पुष्टी करून काढा';

  @override
  String get searchByEmail => 'ईमेलने युजर शोधा';

  @override
  String get userNotFound => 'या ईमेलचा कोणताही युजर नाही.';

  @override
  String userSummary(int trust, int strikes, String banned) {
    return 'ट्रस्ट $trust · स्ट्राइक $strikes · बॅन: $banned';
  }

  @override
  String get ban => 'बॅन करा';

  @override
  String get unban => 'बॅन काढा';

  @override
  String get adjustTrust => 'ट्रस्ट स्कोर बदला';

  @override
  String get notificationsInbox => 'नोटिफिकेशन';

  @override
  String get markAllRead => 'सर्व वाचले म्हणून चिन्हांकित करा';

  @override
  String get noNotifications => 'अजून नोटिफिकेशन नाहीत';

  @override
  String get noNotificationsBody =>
      'ग्रुप अपडेट, रिमाइंडर, चेतावण्या आणि फीडबॅक अलर्ट इथे दिसतील.';

  @override
  String get notificationSettings => 'नोटिफिकेशन';

  @override
  String get notifPermissionOff => 'TestPact साठी नोटिफिकेशन बंद आहेत';

  @override
  String get openSettings => 'सेटिंग्ज उघडा';

  @override
  String get notifDaily => 'रोजचे रिमाइंडर';

  @override
  String get notifDailySub =>
      'आजची ॲप्स उघडली नसल्यास संध्याकाळी रिमाइंडर, आणि सेटअपची मुदत';

  @override
  String get notifGroup => 'ग्रुप अपडेट';

  @override
  String get notifGroupSub => 'ग्रुप तयार, टेस्ट सुरू, नवीन सदस्य, पूर्णता';

  @override
  String get notifFeedback => 'फीडबॅक';

  @override
  String get notifFeedbackSub => 'कोणी तुमच्या ॲपवर फीडबॅक दिल्यावर';

  @override
  String get notifImportantNote =>
      'चेतावण्या आणि काढल्याच्या सूचना नेहमी पाठवल्या जातात, म्हणजे तुमच्या जागेशी संबंधित काहीही चुकणार नाही.';

  @override
  String get noInternetTitle => 'इंटरनेट कनेक्शन नाही';

  @override
  String get noInternetBody =>
      'तुमचे Wi-Fi किंवा मोबाइल डेटा तपासा. ऑनलाइन होताच TestPact आपोआप जोडले जाईल.';

  @override
  String get checkingConnection => 'तपासत आहोत…';

  @override
  String get backOnline => 'पुन्हा ऑनलाइन';

  @override
  String get updateRequiredTitle => 'अपडेट आवश्यक';

  @override
  String get updateRequiredBody =>
      'TestPact ची ही आवृत्ती आता सपोर्टेड नाही. तुमच्या ग्रुपसोबत टेस्टिंग सुरू ठेवण्यासाठी अपडेट करा.';

  @override
  String get updateAvailableTitle => 'अपडेट उपलब्ध';

  @override
  String get updateAvailableBody =>
      'TestPact ची नवीन आवृत्ती सुधारणा आणि फिक्ससह तयार आहे.';

  @override
  String get updateNow => 'आता अपडेट करा';

  @override
  String get later => 'नंतर';

  @override
  String get updateDownloaded =>
      'अपडेट डाउनलोड झाले. इन्स्टॉल पूर्ण करण्यासाठी रीस्टार्ट करा.';

  @override
  String get restart => 'रीस्टार्ट';

  @override
  String appVersion(String version) {
    return 'आवृत्ती $version';
  }

  @override
  String get welcomeBack => 'तुम्हाला पुन्हा पाहून छान वाटले!';

  @override
  String get viewAll => 'सर्व पहा';

  @override
  String get more => 'आणखी';

  @override
  String get filterAll => 'सर्व';

  @override
  String get statusTesting => 'टेस्टिंग';

  @override
  String get inQueueShort => 'रांगेत';

  @override
  String get statusReady => 'तयार';

  @override
  String get memberDone => 'पूर्ण';

  @override
  String get memberTesting => 'टेस्टिंग';

  @override
  String get memberPending => 'आज बाकी';

  @override
  String get todaysTasks => 'आजची कामे';

  @override
  String tasksCompleted(int total, int done) {
    return '$total ॲप्स · $done/$total पूर्ण';
  }

  @override
  String groupMembersCount(int count) {
    return 'ग्रुप सदस्य ($count)';
  }

  @override
  String get recentActivity => 'अलीकडील घडामोडी';

  @override
  String badgesEarned(int earned, int total) {
    return '$total पैकी $earned मिळाले';
  }

  @override
  String get adLabel => 'जाहिरात';

  @override
  String get privateDnsTitle => 'Private DNS बंद करा';

  @override
  String get privateDnsBody =>
      'TestPact काही छोट्या जाहिरातींमुळे मोफत आहे. तुमचे Private DNS त्या ब्लॉक करते, म्हणून ॲप वापरत राहण्यासाठी कृपया ते बंद करा.';

  @override
  String get privateDnsStep1 =>
      'Settings → Network & internet (किंवा Connections → More connection settings) उघडा';

  @override
  String get privateDnsStep2 => 'Private DNS वर टॅप करा';

  @override
  String get privateDnsStep3 => 'Off किंवा Automatic निवडा, मग इथे परत या';

  @override
  String get privateDnsDone => 'मी बंद केले';

  @override
  String get adsSection => 'जाहिराती';

  @override
  String get removeAdsTitle => '24 तास जाहिराती नाहीत';

  @override
  String get removeAdsBody => 'एक छोटा व्हिडिओ पाहा आणि दिवसभर जाहिराती लपवा';

  @override
  String adFreeUntil(String time) {
    return '$time पर्यंत जाहिरात-मुक्त';
  }

  @override
  String get adFreeGranted => 'धन्यवाद! पुढील 24 तास जाहिराती नाहीत.';

  @override
  String get adNotAvailable =>
      'सध्या व्हिडिओ उपलब्ध नाही. कृपया नंतर प्रयत्न करा.';

  @override
  String get adPrivacyOptions => 'जाहिरात प्रायव्हसी पर्याय';
}
