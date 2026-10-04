// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get cancel => 'રદ કરો';

  @override
  String get save => 'સેવ કરો';

  @override
  String get saved => 'સેવ થયું';

  @override
  String get delete => 'કાઢી નાખો';

  @override
  String get edit => 'બદલો';

  @override
  String get next => 'આગળ';

  @override
  String get retry => 'ફરી પ્રયાસ કરો';

  @override
  String get yes => 'હા';

  @override
  String get no => 'ના';

  @override
  String get you => 'તમે';

  @override
  String get required => 'જરૂરી છે';

  @override
  String get open => 'ખોલો';

  @override
  String get install => 'ઇન્સ્ટોલ કરો';

  @override
  String get leave => 'છોડો';

  @override
  String get accept => 'સ્વીકારો';

  @override
  String get reject => 'નકારો';

  @override
  String get confirmAction => 'પુષ્ટિ કરો';

  @override
  String get errDeviceInUse =>
      'આ ફોન પહેલેથી બીજા TestPact એકાઉન્ટ સાથે જોડાયેલો છે. દરેક ડિવાઇસ પર એક એકાઉન્ટથી ગ્રુપ ન્યાયી રહે છે.';

  @override
  String get errBanned =>
      'હાલમાં તમારું એકાઉન્ટ નવા ગ્રુપમાં જોડાઈ શકતું નથી. તમે અપીલ મોકલી શકો છો.';

  @override
  String get errAlreadyInGroup =>
      'તમે પહેલેથી એક ગ્રુપમાં છો. પહેલા તે પૂરું કરો.';

  @override
  String get errAppNotFound => 'આ એપ લિસ્ટિંગ હવે અસ્તિત્વમાં નથી.';

  @override
  String get errAppealOpen => 'તમારી એક અપીલ પહેલેથી સમીક્ષા માટે બાકી છે.';

  @override
  String get errAlreadyRated => 'તમે આ ફીડબેકને પહેલેથી રેટ કર્યો છે.';

  @override
  String get errIntegrity =>
      'આ ડિવાઇસ Google Play ની ઇન્ટિગ્રિટી તપાસમાં પાસ ન થયું. Google Play પરથી ઇન્સ્ટોલ કરેલી એપ સાથે અસલી ફોન વાપરો.';

  @override
  String get errNetwork => 'કનેક્શન નથી. ઇન્ટરનેટ તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String get errGeneric => 'કંઈક ખોટું થયું. કૃપા કરી ફરી પ્રયાસ કરો.';

  @override
  String get levelProbation => 'પ્રોબેશન';

  @override
  String get levelNewcomer => 'નવા સભ્ય';

  @override
  String get levelMember => 'સભ્ય';

  @override
  String get levelTrusted => 'વિશ્વસનીય';

  @override
  String get levelTopTester => 'ટોપ ટેસ્ટર';

  @override
  String get reasonNotInstalled => 'મારી એપ ઇન્સ્ટોલ ન કરી';

  @override
  String get reasonUninstalled => 'ટેસ્ટ દરમિયાન અનઇન્સ્ટોલ કરી';

  @override
  String get reasonNotOpening => 'રોજ એપ્સ ખોલતા નથી';

  @override
  String get reasonEmailNotAdded => 'મારો ઈમેલ તેમના ટેસ્ટમાં ન ઉમેર્યો';

  @override
  String get reasonSpam => 'સ્પામ અથવા દુર્વ્યવહાર';

  @override
  String get reasonFakeFeedback => 'નકલી અથવા કોપી-પેસ્ટ ફીડબેક';

  @override
  String get reasonOther => 'અન્ય';

  @override
  String get catBug => 'બગ';

  @override
  String get catUx => 'ડિઝાઇન / UX';

  @override
  String get catIdea => 'સૂચન';

  @override
  String get catPraise => 'વખાણ';

  @override
  String get catOther => 'અન્ય';

  @override
  String get badgeFirstPact => 'પહેલો પેક્ટ';

  @override
  String get badgeVeteran => 'અનુભવી (5 ગ્રુપ)';

  @override
  String get badgePerfect => 'પરફેક્ટ સ્ટ્રીક';

  @override
  String get badgeHelpful => 'મદદરૂપ સમીક્ષક';

  @override
  String get badgeTopTester => 'ટોપ ટેસ્ટર';

  @override
  String get removedSetup => 'સેટઅપ સમયસર પૂરું ન થયું';

  @override
  String get removedInactive => '3 દિવસથી નિષ્ક્રિય';

  @override
  String get removedReported => 'એડમિને ફરિયાદની પુષ્ટિ કરી';

  @override
  String get removedLeft => 'ગ્રુપ છોડી દીધું';

  @override
  String get removedCancelled => 'ગ્રુપ રદ થયું';

  @override
  String get removedEnded => 'ગ્રુપ પૂરું થયું';

  @override
  String get removedOther => 'દૂર કરાયા';

  @override
  String trustAdmin(String reason) {
    return 'એડમિન દ્વારા ફેરફાર: $reason';
  }

  @override
  String get trustGroupCompleted => 'ગ્રુપ પૂરું કર્યું';

  @override
  String get trustActiveDay => 'દિવસની બધી એપ્સ ખોલી';

  @override
  String get trustMissedDay => 'એક દિવસ ચૂક્યા';

  @override
  String get trustHelpfulFeedback => 'ફીડબેક મદદરૂપ ગણાયો';

  @override
  String get trustKickedInactive => 'નિષ્ક્રિયતાને કારણે દૂર કરાયા';

  @override
  String get trustKickedReported => 'પુષ્ટ ફરિયાદ બાદ દૂર કરાયા';

  @override
  String get trustSetupFailed => 'સેટઅપ પૂરું ન થયું';

  @override
  String get trustLeftGroup => 'ગ્રુપ વહેલું છોડ્યું';

  @override
  String get trustFalseReport => 'એડમિને ફરિયાદ નકારી';

  @override
  String get trustAppealAccepted => 'અપીલ સ્વીકારાઈ';

  @override
  String get statusSetup => 'સેટઅપ';

  @override
  String get statusActive => 'ટેસ્ટિંગ';

  @override
  String get statusCompleted => 'પૂર્ણ';

  @override
  String get statusCancelled => 'રદ';

  @override
  String get stateSetup => 'સેટઅપ ચાલુ';

  @override
  String get stateActive => 'ટેસ્ટિંગ';

  @override
  String get stateSuspended => 'સમીક્ષા હેઠળ';

  @override
  String get stateRemoved => 'દૂર કરાયા';

  @override
  String get stateCompleted => 'પૂર્ણ';

  @override
  String get language => 'ભાષા';

  @override
  String get tagline =>
      'અસલી ટેસ્ટર. અસલી ફીડબેક.\nસાથે મળીને Google Play ક્લોઝ્ડ ટેસ્ટિંગ પાસ કરો.';

  @override
  String get signInBullet1 => '20 સુધી Android ડેવલપર્સના ગ્રુપમાં જોડાઓ';

  @override
  String get signInBullet2 => 'ઇન્સ્ટોલ અને રોજનો ઉપયોગ ડિવાઇસ પર જ ચકાસાય છે';

  @override
  String get signInBullet3 =>
      'પ્રામાણિક ફીડબેક આપો અને મેળવો, જેથી તમારી એપ વધુ સારી બને';

  @override
  String get continueWithGoogle => 'Google સાથે ચાલુ રાખો';

  @override
  String get privacyPolicy => 'પ્રાઇવસી પોલિસી';

  @override
  String get terms => 'શરતો';

  @override
  String get ob1Title => 'ડેવલપર્સ વચ્ચેનો કરાર';

  @override
  String get ob1P1 =>
      'નવા પર્સનલ એકાઉન્ટને પ્રોડક્શન પહેલાં 14 દિવસ સુધી 12 ઓપ્ટ-ઇન ટેસ્ટર જોઈએ.';

  @override
  String get ob1P2 =>
      'તમે એક ગ્રુપમાં જોડાઓ છો. બધા એકબીજાને ટેસ્ટર તરીકે ઉમેરે છે અને બધાની એપ્સ ઇન્સ્ટોલ કરે છે.';

  @override
  String get ob1P3 =>
      '16 દિવસ સુધી તમે તમારી યાદીની દરેક એપ રોજ ખોલો છો, અને બાકીના બધા તમારી એપ માટે એ જ કરે છે.';

  @override
  String get ob2Title => 'બધા માટે ન્યાયી';

  @override
  String get ob2P1 =>
      'તમે બીજાના ઈમેલ ઉમેરો પછી જ તમારી એપ તેમને દેખાય છે: પહેલા આપો, પછી મેળવો.';

  @override
  String get ob2P2 =>
      'રોજ ટેસ્ટ કરવાથી અને મદદરૂપ ફીડબેક આપવાથી ટ્રસ્ટ સ્કોર વધે છે, ન કરવાથી ઘટે છે.';

  @override
  String get ob2P3 =>
      'નિષ્ક્રિય સભ્યોને ચેતવણી મળે છે અને 3 દિવસ ચૂકે તો દૂર કરાય છે. ફરિયાદો અસલી વપરાશ ડેટા સામે ચકાસાય છે.';

  @override
  String get ob3Title => 'તમારું ટેસ્ટિંગ આપમેળે સાબિત કરો';

  @override
  String get ob3P1 =>
      'TestPact ફક્ત તમને સોંપેલી એપ્સ તપાસે છે: ઇન્સ્ટોલ છે કે નહીં, અને આજે કેટલી મિનિટ વપરાઈ.';

  @override
  String get ob3P2 =>
      'તમારી બીજી એપ્સ વિશે કંઈ પણ ક્યારેય વાંચવામાં કે મોકલવામાં આવતું નથી.';

  @override
  String get usageAccessTitle => 'યુસેજ એક્સેસ';

  @override
  String get usageAccessBody =>
      'આનાથી TestPact તમને સોંપેલી એપ્સમાં વિતાવેલી મિનિટો ગણી શકે છે, જેથી હોમ સ્ક્રીન પરથી ખોલો તો પણ તમને ક્રેડિટ મળે.';

  @override
  String get granted => 'મંજૂરી આપી ✓';

  @override
  String get notGranted => 'મંજૂરી નથી, ચાલુ કરવા ટેપ કરો';

  @override
  String get grantUsageAccess => 'યુસેજ એક્સેસ આપો';

  @override
  String get notificationsTitle => 'રિમાઇન્ડર';

  @override
  String get notificationsBody =>
      'રોજના રિમાઇન્ડર અને ગ્રુપ અપડેટ, જેથી એક પણ દિવસ ન ચૂકો.';

  @override
  String get allowNotifications => 'નોટિફિકેશનની મંજૂરી આપો';

  @override
  String get getStarted => 'શરૂ કરો';

  @override
  String get settingUp => 'તમારું એકાઉન્ટ તૈયાર થઈ રહ્યું છે…';

  @override
  String get signOut => 'સાઇન આઉટ';

  @override
  String get tabHome => 'હોમ';

  @override
  String get tabMyApps => 'મારી એપ્સ';

  @override
  String get tabFeedback => 'ફીડબેક';

  @override
  String get tabProfile => 'પ્રોફાઇલ';

  @override
  String get admin => 'એડમિન';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get addApp => 'એપ ઉમેરો';

  @override
  String get bannedTitle => 'એકાઉન્ટ પ્રતિબંધિત';

  @override
  String bannedBody(int count) {
    return 'તમારા $count સ્ટ્રાઇક છે, એટલે તમે નવા ગ્રુપમાં જોડાઈ શકતા નથી. જો આ ભૂલ લાગે તો અપીલ મોકલો.';
  }

  @override
  String get appeal => 'અપીલ';

  @override
  String strikesTitle(int count) {
    return 'તમારા એકાઉન્ટ પર $count સ્ટ્રાઇક';
  }

  @override
  String get strikesBody =>
      '3 સ્ટ્રાઇક થાય તો તમે નવા ગ્રુપમાં જોડાઈ શકતા નથી. નિષ્ક્રિયતા અથવા પુષ્ટ ફરિયાદથી દૂર થવા પર સ્ટ્રાઇક મળે છે.';

  @override
  String get howItWorks => 'આ કેવી રીતે કામ કરે છે';

  @override
  String get googleRuleTitle => 'Google Play નો નિયમ';

  @override
  String get googleRuleBody =>
      '13 નવેમ્બર 2023 પછી બનેલા પર્સનલ ડેવલપર એકાઉન્ટને સતત 14 દિવસ સુધી ઓછામાં ઓછા 12 ઓપ્ટ-ઇન ટેસ્ટર જોઈએ. ગ્રુપ 20 લોકોથી શરૂ થાય છે અને 16 દિવસ ચાલે છે, જેથી તમારી પાસે ગાળો રહે. Google એ પણ જુએ છે કે ટેસ્ટર્સે એપ ખરેખર વાપરી કે નહીં, એટલે ફક્ત ઇન્સ્ટોલ ન કરો, એપ ખોલીને વાપરો.';

  @override
  String hello(String name) {
    return 'નમસ્તે, $name 👋';
  }

  @override
  String get joinCardTitle => 'તમારા ટેસ્ટર શોધવા તૈયાર છો?';

  @override
  String get joinCardBody =>
      'કતારમાં જોડાઓ. પૂરતા ડેવલપર થતાં જ તમારું ગ્રુપ આપમેળે બની જશે.';

  @override
  String get joinCardNoApps =>
      'પહેલા જે એપ ટેસ્ટ કરાવવી છે તે ઉમેરો, તેની ક્લોઝ્ડ ટેસ્ટિંગ લિંક સાથે.';

  @override
  String get joinGroup => 'ગ્રુપમાં જોડાઓ';

  @override
  String get addYourApp => 'તમારી એપ ઉમેરો';

  @override
  String get inQueueTitle => 'તમે કતારમાં છો';

  @override
  String inQueueBody(String app, String tier) {
    return '$app ને $tier ગ્રુપમાં જોડવાની રાહ જોવાય છે. તૈયાર થતાં અમે તમને જાણ કરીશું.';
  }

  @override
  String get tierTrusted => 'વિશ્વસનીય';

  @override
  String get tierStarter => 'સ્ટાર્ટર';

  @override
  String queueWaiting(int count, int size) {
    return '$size માંથી $count ડેવલપર રાહ જુએ છે';
  }

  @override
  String queueJoinedAt(String time) {
    return '$time એ જોડાયા';
  }

  @override
  String get leaveQueue => 'કતાર છોડો';

  @override
  String dayOf(int day, int total) {
    return 'દિવસ $day / $total';
  }

  @override
  String groupTitle(String id) {
    return 'ગ્રુપ #$id';
  }

  @override
  String openedToday(int opened, int total) {
    return 'આજે ખોલી: $total માંથી $opened';
  }

  @override
  String get setupDoneWaiting => 'સેટઅપ પૂર્ણ ✓ બાકીના સભ્યોની રાહ છે.';

  @override
  String get setupTodo =>
      'સેટઅપ પૂરું કરો: ઈમેલ ઉમેરો અને બધાની એપ્સ ઇન્સ્ટોલ કરો.';

  @override
  String get suspendedBody =>
      'ઘણી ફરિયાદો બાદ તમે સમીક્ષા હેઠળ છો. એડમિન તમારો એક્ટિવિટી ડેટા તપાસી રહ્યા છે.';

  @override
  String get openGroup => 'ગ્રુપ ખોલો';

  @override
  String get step1Title => 'તમારી એપ ઉમેરો';

  @override
  String get step1Body => 'નામ, પેકેજ અને તમારી ક્લોઝ્ડ ટેસ્ટિંગ ઓપ્ટ-ઇન લિંક.';

  @override
  String get step2Title => 'કતારમાં જોડાઓ';

  @override
  String get step2Body =>
      '20 લોકોના ગ્રુપ આપમેળે બને છે. વિશ્વસનીય ટેસ્ટર્સ સાથે જોડાય છે.';

  @override
  String get step3Title => '48 કલાકમાં સેટઅપ';

  @override
  String get step3Body =>
      'બધાના ઈમેલ Play Console માં પેસ્ટ કરો, પછી દરેક એપમાં જોડાઓ અને ઇન્સ્ટોલ કરો.';

  @override
  String get step4Title => '16 દિવસ રોજ ટેસ્ટ કરો';

  @override
  String get step4Body =>
      'દરેક એપ રોજ ખોલો અને અસલી ફીડબેક આપો. અમે ડિવાઇસ પર ચકાસીએ છીએ.';

  @override
  String get step5Title => 'પ્રોડક્શન માટે અરજી';

  @override
  String get step5Body =>
      'ટ્રસ્ટ પોઇન્ટ અને બેજ મેળવો, પછી Play Console માં પ્રોડક્શન માટે અરજી કરો.';

  @override
  String get rule1 =>
      'હું 48 કલાકમાં દરેક સભ્યનો ઈમેલ મારા ક્લોઝ્ડ ટેસ્ટમાં ઉમેરીશ.';

  @override
  String get rule2 =>
      'હું દરેક સભ્યની એપ ઇન્સ્ટોલ કરીશ અને અંત સુધી ઇન્સ્ટોલ રાખીશ.';

  @override
  String get rule3 =>
      'હું 16 દિવસ સુધી રોજ દરેક એપ ખોલીશ અને પ્રામાણિક ફીડબેક આપીશ.';

  @override
  String get rule4 =>
      'હું સમજું છું કે નિષ્ક્રિય સભ્યો દૂર કરાય છે અને ટ્રસ્ટ પોઇન્ટ ગુમાવે છે.';

  @override
  String get chooseApp => 'કઈ એપ ટેસ્ટ થવી જોઈએ?';

  @override
  String get yourCommitment => 'તમારું વચન';

  @override
  String get joinedQueue => 'તમે કતારમાં છો!';

  @override
  String get joinQueue => 'કતારમાં જોડાઓ';

  @override
  String get noAppsTitle => 'હજુ કોઈ એપ નથી';

  @override
  String get noAppsBody =>
      'જે એપ ટેસ્ટ કરાવવી છે તે ઉમેરો. આ માટે Play Console માંથી ક્લોઝ્ડ ટેસ્ટિંગ ઓપ્ટ-ઇન લિંક જોઈશે.';

  @override
  String get deleteAppTitle => 'આ એપ કાઢી નાખવી?';

  @override
  String get deleteAppBody =>
      'જે ગ્રુપમાં તે પહેલેથી છે ત્યાં તેની કોપી રહેશે. તમે પછી ફરી ઉમેરી શકો છો.';

  @override
  String get editApp => 'એપ બદલો';

  @override
  String get appIcon => 'આઇકન સેટ કરવા ટેપ કરો';

  @override
  String get appName => 'એપનું નામ';

  @override
  String get packageName => 'પેકેજ નામ';

  @override
  String get invalidPackage => 'સાચું પેકેજ નામ લખો, જેમ કે com.example.app';

  @override
  String get optInLink => 'ક્લોઝ્ડ ટેસ્ટિંગ ઓપ્ટ-ઇન લિંક';

  @override
  String get optInHelp =>
      'Play Console → Testing → Closed testing → Testers → \"Join on the web\" લિંક.';

  @override
  String get invalidOptIn => 'આ play.google.com/apps/testing/… લિંક હોવી જોઈએ';

  @override
  String get shortDescription => 'ટૂંકું વર્ણન';

  @override
  String get testNotes => 'ટેસ્ટર્સ શું અજમાવે?';

  @override
  String get testNotesHelp =>
      'જેમ કે \"એકાઉન્ટ બનાવો અને કાર્ટમાં 2 વસ્તુ ઉમેરો\". આ ટેસ્ટર્સને રોજ દેખાશે.';

  @override
  String get closedTestTipTitle => 'જોડાતા પહેલાં';

  @override
  String get closedTestTipBody =>
      'ક્લોઝ્ડ ટેસ્ટિંગ ટ્રેક બનાવો, બિલ્ડ અપલોડ કરીને રોલ આઉટ કરો અને ટેસ્ટર્સને ઈમેલ લિસ્ટ પર સેટ કરો. તમારા ગ્રુપના ઈમેલ ત્યાં જશે.';

  @override
  String get tabToday => 'આજે';

  @override
  String get tabSetup => 'સેટઅપ';

  @override
  String get tabMembers => 'સભ્યો';

  @override
  String get tabActivity => 'પ્રવૃત્તિ';

  @override
  String get leaveGroup => 'ગ્રુપ છોડો';

  @override
  String get leaveGroupTitle => 'આ ગ્રુપ છોડવું?';

  @override
  String get leaveGroupBody =>
      'બાકીના સભ્યો તમારી એપ ટેસ્ટ કરવાનું બંધ કરશે અને તમારા ટ્રસ્ટ પોઇન્ટ ઘટશે. આ પાછું ફેરવી શકાશે નહીં.';

  @override
  String youWereRemoved(String reason) {
    return 'તમને દૂર કરાયા: $reason.';
  }

  @override
  String get youCompleted =>
      'તમે આ ગ્રુપ પૂરું કર્યું 🏆 હવે તમે Play Console માં પ્રોડક્શન એક્સેસ માટે અરજી કરી શકો છો.';

  @override
  String get setupDeadlinePassed =>
      'સેટઅપની સમયમર્યાદા પૂરી. પ્રક્રિયા ચાલુ છે…';

  @override
  String setupTimeLeft(int hours, int minutes) {
    return 'સેટઅપ પૂરું કરવા $hoursક $minutesમિ બાકી';
  }

  @override
  String get setupExplain =>
      'જે સભ્યો પૂરું નથી કરતા, તેમની જગ્યાએ કતારમાંથી લોકો આવે છે. બધા તૈયાર થાય ત્યારે ટેસ્ટ શરૂ થાય છે.';

  @override
  String get step1AddEmails => 'પગલું 1 · તમારા ક્લોઝ્ડ ટેસ્ટમાં ટેસ્ટર ઉમેરો';

  @override
  String addEmailsBody(int count) {
    return 'બધા $count ઈમેલ કોપી કરો અને Play Console માં તમારી ક્લોઝ્ડ ટેસ્ટિંગ ઈમેલ લિસ્ટમાં પેસ્ટ કરો.';
  }

  @override
  String get copyAllEmails => 'બધા ઈમેલ કોપી કરો';

  @override
  String copied(int count) {
    return '$count ઈમેલ કોપી થયા';
  }

  @override
  String get emailsConfirmed => 'ઈમેલ ઉમેરાયા';

  @override
  String get iAddedEveryone => 'મેં બધાને ઉમેર્યા';

  @override
  String get confirmEmailsTitle => 'શું તમે બધા ઈમેલ ઉમેર્યા?';

  @override
  String confirmEmailsBody(int count) {
    return 'પુષ્ટિ કરો કે બધા $count ઈમેલ તમારા ક્લોઝ્ડ ટેસ્ટની ટેસ્ટર લિસ્ટમાં છે અને ફેરફાર સેવ થયો છે. જો સભ્યો જોડાઈ ન શકે તો તેઓ તમારી ફરિયાદ કરી શકે છે.';
  }

  @override
  String get yesAdded => 'હા, બધા ઉમેર્યા';

  @override
  String get emailsHowTo =>
      'Play Console → તમારી એપ → Testing → Closed testing → Testers → Email list → પેસ્ટ → Save.';

  @override
  String step2InstallApps(int done, int total) {
    return 'પગલું 2 · એપ્સમાં જોડાઓ અને ઇન્સ્ટોલ કરો ($done/$total)';
  }

  @override
  String get checkAgain => 'ફરી તપાસો';

  @override
  String waitingForOwners(int count) {
    return '$count સભ્યોએ હજુ ગ્રુપના ઈમેલ ઉમેર્યા નથી. ઉમેર્યા પછી તેમની એપ્સ અહીં દેખાશે.';
  }

  @override
  String get noAppsYet => 'હજુ ઇન્સ્ટોલ કરવા કોઈ એપ નથી.';

  @override
  String byName(String name) {
    return '$name દ્વારા';
  }

  @override
  String get joinTest => 'ટેસ્ટમાં જોડાઓ';

  @override
  String get newMembersTitle => 'નવા સભ્ય જોડાયા';

  @override
  String get newMembersBody =>
      'નવા ઈમેલ તમારા ક્લોઝ્ડ ટેસ્ટમાં ઉમેરો અને તેમની એપ ઇન્સ્ટોલ કરો. સેટઅપ ટેબ ખોલો.';

  @override
  String get usageAccessOffTitle => 'યુસેજ એક્સેસ બંધ છે';

  @override
  String get usageAccessOffBody =>
      'ફક્ત ખોલો બટનથી ખોલેલી એપ્સ ગણાય છે. હોમ સ્ક્રીન પરથી ખોલો ત્યારે પણ ક્રેડિટ મેળવવા યુસેજ એક્સેસ ચાલુ કરો.';

  @override
  String get yourTestList => 'તમારી ટેસ્ટ યાદી';

  @override
  String get todayTitle => 'આજનું ટેસ્ટિંગ';

  @override
  String get todayDone => 'આજનું બધું પૂરું 🎉';

  @override
  String get todayDoneBody => 'શાબાશ! કાલે ફરી આવજો.';

  @override
  String todayBody(int needed) {
    return 'ઓછામાં ઓછી $needed એપ્સ ખોલો અને દરેકને થોડી વાર વાપરો.';
  }

  @override
  String dayResetsAt(String time) {
    return 'નવો દિવસ $time વાગ્યે શરૂ થાય છે';
  }

  @override
  String get notInstalled => 'ઇન્સ્ટોલ નથી';

  @override
  String openedMinutes(int minutes) {
    return 'આજે ખોલી · $minutes મિનિટ';
  }

  @override
  String get notOpenedYet => 'આજે ખોલી નથી';

  @override
  String feedbackGivenCount(int count) {
    return 'ફીડબેક ($count)';
  }

  @override
  String get giveFeedback => 'ફીડબેક';

  @override
  String get statMembers => 'સભ્યો';

  @override
  String get statOnTrack => 'આજે સાચા માર્ગે';

  @override
  String get statRemoved => 'દૂર કરાયા';

  @override
  String get membersLegend =>
      '🟢 સાચા માર્ગે  🟡 હજુ બાકી  🔴 દિવસ ચૂક્યા  ⚪ ગયા';

  @override
  String memberSetupLine(String emails, int installed, int total) {
    return 'ઈમેલ $emails · ઇન્સ્ટોલ $installed/$total';
  }

  @override
  String memberActiveLine(int installed, int opened, int total, int feedback) {
    return 'ઇન્સ્ટોલ $installed/$total · ખોલી $opened/$total · ફીડબેક $feedback';
  }

  @override
  String missedInARow(int count) {
    return 'સતત $count દિવસ ચૂક્યા';
  }

  @override
  String get lastDays => 'છેલ્લા દિવસો';

  @override
  String get viewProfile => 'પ્રોફાઇલ જુઓ';

  @override
  String get openInPlay => 'Play Store માં ખોલો';

  @override
  String get reportMember => 'ફરિયાદ કરો';

  @override
  String get reportSent => 'ફરિયાદ મોકલાઈ. ગ્રુપને ન્યાયી રાખવા બદલ આભાર.';

  @override
  String reportTitle(String name) {
    return '$name ની ફરિયાદ કરો';
  }

  @override
  String get reportExplain =>
      'પગલાં ત્યારે જ લેવાય છે જ્યારે ઘણા સભ્યો ફરિયાદ કરે અને અમારો વપરાશ ડેટા પણ સહમત હોય. ખોટી ફરિયાદ પર ટ્રસ્ટ પોઇન્ટ ઘટે છે.';

  @override
  String get detailsOptional => 'વિગતો (વૈકલ્પિક)';

  @override
  String get addScreenshot => 'સ્ક્રીનશોટ ઉમેરો';

  @override
  String get screenshotAdded => 'સ્ક્રીનશોટ ઉમેરાયો ✓';

  @override
  String get sendReport => 'ફરિયાદ મોકલો';

  @override
  String get noActivity => 'હજુ કોઈ પ્રવૃત્તિ નથી';

  @override
  String evFormed(int count) {
    return '$count ડેવલપર્સ સાથે ગ્રુપ બન્યું';
  }

  @override
  String evJoined(String name) {
    return '$name ગ્રુપમાં જોડાયા';
  }

  @override
  String evEmailsAdded(String name) {
    return '$name એ બધાના ઈમેલ ઉમેર્યા';
  }

  @override
  String get evStarted => 'ટેસ્ટિંગ શરૂ: દિવસ 1';

  @override
  String evMemberActive(String name) {
    return '$name એ સેટઅપ પૂરું કરી ટેસ્ટિંગ શરૂ કર્યું';
  }

  @override
  String evWarning(String name) {
    return '$name સતત 2 દિવસ ચૂક્યા (છેલ્લી ચેતવણી)';
  }

  @override
  String evRemoved(String name, String reason) {
    return '$name ને દૂર કરાયા ($reason)';
  }

  @override
  String evSuspended(String name) {
    return '$name એડમિન સમીક્ષા હેઠળ છે';
  }

  @override
  String evReinstated(String name) {
    return '$name નિર્દોષ ઠર્યા અને પાછા આવ્યા';
  }

  @override
  String get evCompleted => 'ગ્રુપ પૂરું થયું 🏆';

  @override
  String get evCancelled => 'ગ્રુપ રદ થયું';

  @override
  String get feedbackSent => 'ફીડબેક મોકલાયો. આભાર!';

  @override
  String feedbackFor(String app) {
    return 'ફીડબેક: $app';
  }

  @override
  String get developerAsks => 'ડેવલપર તમને આ અજમાવવા કહે છે';

  @override
  String get rating => 'રેટિંગ';

  @override
  String get category => 'શ્રેણી';

  @override
  String get yourFeedback => 'તમારો ફીડબેક';

  @override
  String get feedbackHint =>
      'શું સારું ચાલ્યું, શું તૂટ્યું, શું ગૂંચવણભર્યું લાગ્યું? સ્પષ્ટ લખો: સ્ક્રીન, પગલાં, ડિવાઇસ.';

  @override
  String get feedbackMin => 'ઓછામાં ઓછા 20 અક્ષર';

  @override
  String get sendFeedback => 'ફીડબેક મોકલો';

  @override
  String get received => 'મળેલા';

  @override
  String get given => 'આપેલા';

  @override
  String get noFeedbackReceived => 'હજુ કોઈ ફીડબેક નથી';

  @override
  String get noFeedbackReceivedBody =>
      'તમારા ગ્રુપના ટેસ્ટર્સનો ફીડબેક અહીં દેખાશે.';

  @override
  String get noFeedbackGiven => 'તમે હજુ ફીડબેક આપ્યો નથી';

  @override
  String get noFeedbackGivenBody =>
      'ગ્રુપના આજે ટેબમાં દરેક એપ પરનું ફીડબેક બટન વાપરો.';

  @override
  String fromOnApp(String name, String app) {
    return '$name, $app પર';
  }

  @override
  String get wasHelpful => 'શું આ મદદરૂપ હતું?';

  @override
  String get markedHelpful => 'તમે આને મદદરૂપ ગણાવ્યું (તેમને +2 ટ્રસ્ટ)';

  @override
  String get markedNotHelpful => 'મદદરૂપ નથી ગણાવ્યું';

  @override
  String get groupHistory => 'ગ્રુપ';

  @override
  String get noGroupsYet => 'હજુ કોઈ ગ્રુપ નથી.';

  @override
  String get trustHistory => 'ટ્રસ્ટ સ્કોર ઇતિહાસ';

  @override
  String get noTrustHistory => 'હજુ કોઈ ફેરફાર નથી.';

  @override
  String get trustScore => 'ટ્રસ્ટ સ્કોર';

  @override
  String pointsToNext(int points) {
    return 'આગળના લેવલ માટે $points પોઇન્ટ';
  }

  @override
  String get statCompleted => 'પૂરા કરેલા ગ્રુપ';

  @override
  String get statCompletionRate => 'પૂર્ણતા દર';

  @override
  String get statDailyActivity => 'રોજની પ્રવૃત્તિ';

  @override
  String get statActiveDays => 'સક્રિય દિવસો';

  @override
  String get statFeedback => 'આપેલા ફીડબેક';

  @override
  String get statHelpful => 'મદદરૂપ ફીડબેક';

  @override
  String get badges => 'બેજ';

  @override
  String get noBadges => 'બેજ મેળવવા તમારું પહેલું ગ્રુપ પૂરું કરો.';

  @override
  String get systemLanguage => 'સિસ્ટમ ડિફોલ્ટ';

  @override
  String get general => 'સામાન્ય';

  @override
  String get about => 'માહિતી';

  @override
  String get contactSupport => 'સપોર્ટનો સંપર્ક';

  @override
  String get rateApp => 'TestPact ને રેટ કરો';

  @override
  String get account => 'એકાઉન્ટ';

  @override
  String get deleteAccount => 'એકાઉન્ટ કાઢી નાખો';

  @override
  String get deleteAccountTitle => 'તમારું એકાઉન્ટ કાઢી નાખવું?';

  @override
  String get deleteAccountBody =>
      'તમારી પ્રોફાઇલ, એપ્સ અને ટ્રસ્ટ સ્કોર કાયમ માટે કાઢી નખાશે. જો તમે કોઈ ગ્રુપમાં હો તો તેમાંથી દૂર થશો.';

  @override
  String get appealTitle => 'કોઈ નિર્ણય સામે અપીલ કરો';

  @override
  String get appealExplain =>
      'શું થયું તે જણાવો. એડમિન દરેક અપીલની સમીક્ષા કરે છે. સ્વીકારાય તો એક સ્ટ્રાઇક દૂર થાય છે અને થોડા ટ્રસ્ટ પોઇન્ટ પાછા મળે છે.';

  @override
  String get appealHint =>
      'શું થયું? તારીખો અને તપાસમાં મદદ કરે તેવી કોઈ પણ માહિતી લખો.';

  @override
  String get appealSent => 'અપીલ મોકલાઈ';

  @override
  String get sendAppeal => 'અપીલ મોકલો';

  @override
  String get yourAppeals => 'તમારી અપીલો';

  @override
  String get appealOpen => 'સમીક્ષાની રાહ';

  @override
  String get appealAccepted => 'સ્વીકારાઈ';

  @override
  String get appealRejected => 'નકારાઈ';

  @override
  String get adminReviews => 'સમીક્ષાઓ';

  @override
  String get adminAppeals => 'અપીલો';

  @override
  String get adminUsers => 'યુઝર્સ';

  @override
  String get noteOptional => 'યુઝર માટે નોંધ (વૈકલ્પિક)';

  @override
  String get nothingToReview => 'સમીક્ષા માટે કંઈ નથી 🎉';

  @override
  String dataSummary(int active, int missed) {
    return 'વપરાશ ડેટા: $active સક્રિય દિવસ, $missed ચૂકેલા દિવસ';
  }

  @override
  String get rejectReports => 'ફરિયાદો નકારો';

  @override
  String get confirmKick => 'પુષ્ટિ કરી દૂર કરો';

  @override
  String get searchByEmail => 'ઈમેલથી યુઝર શોધો';

  @override
  String get userNotFound => 'આ ઈમેલનો કોઈ યુઝર નથી.';

  @override
  String userSummary(int trust, int strikes, String banned) {
    return 'ટ્રસ્ટ $trust · સ્ટ્રાઇક $strikes · બૅન: $banned';
  }

  @override
  String get ban => 'બૅન કરો';

  @override
  String get unban => 'બૅન હટાવો';

  @override
  String get adjustTrust => 'ટ્રસ્ટ સ્કોર બદલો';

  @override
  String get notificationsInbox => 'નોટિફિકેશન';

  @override
  String get markAllRead => 'બધા વાંચેલા કરો';

  @override
  String get noNotifications => 'હજુ કોઈ નોટિફિકેશન નથી';

  @override
  String get noNotificationsBody =>
      'ગ્રુપ અપડેટ, રિમાઇન્ડર, ચેતવણીઓ અને ફીડબેક એલર્ટ અહીં દેખાશે.';

  @override
  String get notificationSettings => 'નોટિફિકેશન';

  @override
  String get notifPermissionOff => 'TestPact માટે નોટિફિકેશન બંધ છે';

  @override
  String get openSettings => 'સેટિંગ્સ ખોલો';

  @override
  String get notifDaily => 'રોજના રિમાઇન્ડર';

  @override
  String get notifDailySub =>
      'જો આજની એપ્સ ન ખોલી હોય તો સાંજે રિમાઇન્ડર, અને સેટઅપની સમયમર્યાદા';

  @override
  String get notifGroup => 'ગ્રુપ અપડેટ';

  @override
  String get notifGroupSub => 'ગ્રુપ બન્યું, ટેસ્ટ શરૂ, નવા સભ્યો, પૂર્ણતા';

  @override
  String get notifFeedback => 'ફીડબેક';

  @override
  String get notifFeedbackSub => 'જ્યારે કોઈ તમારી એપ પર ફીડબેક આપે';

  @override
  String get notifImportantNote =>
      'ચેતવણીઓ અને દૂર કરવાની સૂચના હંમેશા મોકલાય છે, જેથી તમારી જગ્યાને લગતી કોઈ વાત ચૂકો નહીં.';

  @override
  String get noInternetTitle => 'ઇન્ટરનેટ કનેક્શન નથી';

  @override
  String get noInternetBody =>
      'તમારું Wi-Fi અથવા મોબાઇલ ડેટા તપાસો. ઓનલાઇન થતાં જ TestPact આપમેળે જોડાઈ જશે.';

  @override
  String get checkingConnection => 'તપાસી રહ્યા છીએ…';

  @override
  String get backOnline => 'ફરી ઓનલાઇન';

  @override
  String get updateRequiredTitle => 'અપડેટ જરૂરી છે';

  @override
  String get updateRequiredBody =>
      'TestPact નું આ વર્ઝન હવે સપોર્ટેડ નથી. તમારા ગ્રુપ સાથે ટેસ્ટિંગ ચાલુ રાખવા અપડેટ કરો.';

  @override
  String get updateAvailableTitle => 'અપડેટ ઉપલબ્ધ છે';

  @override
  String get updateAvailableBody =>
      'TestPact નું નવું વર્ઝન સુધારા અને ફિક્સ સાથે તૈયાર છે.';

  @override
  String get updateNow => 'હમણાં અપડેટ કરો';

  @override
  String get later => 'પછી';

  @override
  String get updateDownloaded =>
      'અપડેટ ડાઉનલોડ થયું. ઇન્સ્ટોલ પૂરું કરવા રીસ્ટાર્ટ કરો.';

  @override
  String get restart => 'રીસ્ટાર્ટ';

  @override
  String appVersion(String version) {
    return 'વર્ઝન $version';
  }

  @override
  String get welcomeBack => 'તમને ફરી જોઈને આનંદ થયો!';

  @override
  String get viewAll => 'બધું જુઓ';

  @override
  String get more => 'વધુ';

  @override
  String get filterAll => 'બધી';

  @override
  String get statusTesting => 'ટેસ્ટિંગ';

  @override
  String get inQueueShort => 'કતારમાં';

  @override
  String get statusReady => 'તૈયાર';

  @override
  String get memberDone => 'પૂર્ણ';

  @override
  String get memberTesting => 'ટેસ્ટિંગ';

  @override
  String get memberPending => 'આજે બાકી';

  @override
  String get todaysTasks => 'આજના કામ';

  @override
  String tasksCompleted(int total, int done) {
    return '$total એપ્સ · $done/$total પૂર્ણ';
  }

  @override
  String groupMembersCount(int count) {
    return 'ગ્રુપ સભ્યો ($count)';
  }

  @override
  String get recentActivity => 'તાજેતરની પ્રવૃત્તિ';

  @override
  String badgesEarned(int earned, int total) {
    return '$total માંથી $earned મળ્યા';
  }

  @override
  String get adLabel => 'જાહેરાત';

  @override
  String get privateDnsTitle => 'Private DNS બંધ કરો';

  @override
  String get privateDnsBody =>
      'TestPact થોડી નાની જાહેરાતોને કારણે મફત છે. તમારું Private DNS તેમને બ્લોક કરે છે, તેથી એપ વાપરતા રહેવા કૃપા કરી તેને બંધ કરો.';

  @override
  String get privateDnsStep1 =>
      'Settings → Network & internet (અથવા Connections → More connection settings) ખોલો';

  @override
  String get privateDnsStep2 => 'Private DNS પર ટેપ કરો';

  @override
  String get privateDnsStep3 =>
      'Off અથવા Automatic પસંદ કરો, પછી અહીં પાછા આવો';

  @override
  String get privateDnsDone => 'મેં બંધ કરી દીધું';

  @override
  String get adsSection => 'જાહેરાતો';

  @override
  String get removeAdsTitle => '24 કલાક સુધી કોઈ જાહેરાત નહીં';

  @override
  String get removeAdsBody => 'એક નાનો વીડિયો જુઓ અને આખો દિવસ જાહેરાતો છુપાવો';

  @override
  String adFreeUntil(String time) {
    return '$time સુધી જાહેરાત-મુક્ત';
  }

  @override
  String get adFreeGranted => 'આભાર! આગામી 24 કલાક કોઈ જાહેરાત નહીં.';

  @override
  String get adNotAvailable =>
      'હમણાં કોઈ વીડિયો ઉપલબ્ધ નથી. કૃપા કરી પછી પ્રયાસ કરો.';

  @override
  String get adPrivacyOptions => 'જાહેરાત પ્રાઇવસી વિકલ્પો';
}
