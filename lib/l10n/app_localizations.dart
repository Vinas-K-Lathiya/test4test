import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('gu'),
    Locale('hi'),
    Locale('mr'),
    Locale('pt'),
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'you'**
  String get you;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @install.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get install;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmAction;

  /// No description provided for @errDeviceInUse.
  ///
  /// In en, this message translates to:
  /// **'This phone is already linked to another TestPact account. One account per device keeps groups fair.'**
  String get errDeviceInUse;

  /// No description provided for @errBanned.
  ///
  /// In en, this message translates to:
  /// **'Your account can\'t join new groups right now. You can send an appeal.'**
  String get errBanned;

  /// No description provided for @errAlreadyInGroup.
  ///
  /// In en, this message translates to:
  /// **'You\'re already in a group. Finish it first.'**
  String get errAlreadyInGroup;

  /// No description provided for @errAppNotFound.
  ///
  /// In en, this message translates to:
  /// **'That app listing no longer exists.'**
  String get errAppNotFound;

  /// No description provided for @errAppealOpen.
  ///
  /// In en, this message translates to:
  /// **'You already have an appeal waiting for review.'**
  String get errAppealOpen;

  /// No description provided for @errAlreadyRated.
  ///
  /// In en, this message translates to:
  /// **'You already rated this feedback.'**
  String get errAlreadyRated;

  /// No description provided for @errIntegrity.
  ///
  /// In en, this message translates to:
  /// **'This device didn\'t pass Google Play\'s integrity check. Use a genuine phone with the app installed from Google Play.'**
  String get errIntegrity;

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'No connection. Check your internet and try again.'**
  String get errNetwork;

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errGeneric;

  /// No description provided for @levelProbation.
  ///
  /// In en, this message translates to:
  /// **'Probation'**
  String get levelProbation;

  /// No description provided for @levelNewcomer.
  ///
  /// In en, this message translates to:
  /// **'Newcomer'**
  String get levelNewcomer;

  /// No description provided for @levelMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get levelMember;

  /// No description provided for @levelTrusted.
  ///
  /// In en, this message translates to:
  /// **'Trusted'**
  String get levelTrusted;

  /// No description provided for @levelTopTester.
  ///
  /// In en, this message translates to:
  /// **'Top Tester'**
  String get levelTopTester;

  /// No description provided for @reasonNotInstalled.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t install my app'**
  String get reasonNotInstalled;

  /// No description provided for @reasonUninstalled.
  ///
  /// In en, this message translates to:
  /// **'Uninstalled during the test'**
  String get reasonUninstalled;

  /// No description provided for @reasonNotOpening.
  ///
  /// In en, this message translates to:
  /// **'Not opening apps daily'**
  String get reasonNotOpening;

  /// No description provided for @reasonEmailNotAdded.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t add my email to their test'**
  String get reasonEmailNotAdded;

  /// No description provided for @reasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam or abuse'**
  String get reasonSpam;

  /// No description provided for @reasonFakeFeedback.
  ///
  /// In en, this message translates to:
  /// **'Fake or copy-paste feedback'**
  String get reasonFakeFeedback;

  /// No description provided for @reasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reasonOther;

  /// No description provided for @catBug.
  ///
  /// In en, this message translates to:
  /// **'Bug'**
  String get catBug;

  /// No description provided for @catUx.
  ///
  /// In en, this message translates to:
  /// **'Design / UX'**
  String get catUx;

  /// No description provided for @catIdea.
  ///
  /// In en, this message translates to:
  /// **'Idea'**
  String get catIdea;

  /// No description provided for @catPraise.
  ///
  /// In en, this message translates to:
  /// **'Praise'**
  String get catPraise;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @badgeFirstPact.
  ///
  /// In en, this message translates to:
  /// **'First pact'**
  String get badgeFirstPact;

  /// No description provided for @badgeVeteran.
  ///
  /// In en, this message translates to:
  /// **'Veteran (5 groups)'**
  String get badgeVeteran;

  /// No description provided for @badgePerfect.
  ///
  /// In en, this message translates to:
  /// **'Perfect streak'**
  String get badgePerfect;

  /// No description provided for @badgeHelpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful reviewer'**
  String get badgeHelpful;

  /// No description provided for @badgeTopTester.
  ///
  /// In en, this message translates to:
  /// **'Top tester'**
  String get badgeTopTester;

  /// No description provided for @removedSetup.
  ///
  /// In en, this message translates to:
  /// **'setup not finished in time'**
  String get removedSetup;

  /// No description provided for @removedInactive.
  ///
  /// In en, this message translates to:
  /// **'inactive for 3 days'**
  String get removedInactive;

  /// No description provided for @removedReported.
  ///
  /// In en, this message translates to:
  /// **'reports confirmed by admin'**
  String get removedReported;

  /// No description provided for @removedLeft.
  ///
  /// In en, this message translates to:
  /// **'left the group'**
  String get removedLeft;

  /// No description provided for @removedCancelled.
  ///
  /// In en, this message translates to:
  /// **'group cancelled'**
  String get removedCancelled;

  /// No description provided for @removedEnded.
  ///
  /// In en, this message translates to:
  /// **'group ended'**
  String get removedEnded;

  /// No description provided for @removedOther.
  ///
  /// In en, this message translates to:
  /// **'removed'**
  String get removedOther;

  /// No description provided for @trustAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin adjustment: {reason}'**
  String trustAdmin(String reason);

  /// No description provided for @trustGroupCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed a group'**
  String get trustGroupCompleted;

  /// No description provided for @trustActiveDay.
  ///
  /// In en, this message translates to:
  /// **'Opened all apps for the day'**
  String get trustActiveDay;

  /// No description provided for @trustMissedDay.
  ///
  /// In en, this message translates to:
  /// **'Missed a day'**
  String get trustMissedDay;

  /// No description provided for @trustHelpfulFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback marked helpful'**
  String get trustHelpfulFeedback;

  /// No description provided for @trustKickedInactive.
  ///
  /// In en, this message translates to:
  /// **'Removed for inactivity'**
  String get trustKickedInactive;

  /// No description provided for @trustKickedReported.
  ///
  /// In en, this message translates to:
  /// **'Removed after confirmed reports'**
  String get trustKickedReported;

  /// No description provided for @trustSetupFailed.
  ///
  /// In en, this message translates to:
  /// **'Setup not finished'**
  String get trustSetupFailed;

  /// No description provided for @trustLeftGroup.
  ///
  /// In en, this message translates to:
  /// **'Left a group early'**
  String get trustLeftGroup;

  /// No description provided for @trustFalseReport.
  ///
  /// In en, this message translates to:
  /// **'Report rejected by admin'**
  String get trustFalseReport;

  /// No description provided for @trustAppealAccepted.
  ///
  /// In en, this message translates to:
  /// **'Appeal accepted'**
  String get trustAppealAccepted;

  /// No description provided for @statusSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get statusSetup;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Testing'**
  String get statusActive;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @stateSetup.
  ///
  /// In en, this message translates to:
  /// **'Setting up'**
  String get stateSetup;

  /// No description provided for @stateActive.
  ///
  /// In en, this message translates to:
  /// **'Testing'**
  String get stateActive;

  /// No description provided for @stateSuspended.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get stateSuspended;

  /// No description provided for @stateRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get stateRemoved;

  /// No description provided for @stateCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get stateCompleted;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Real testers. Real feedback.\nPass Google Play closed testing together.'**
  String get tagline;

  /// No description provided for @signInBullet1.
  ///
  /// In en, this message translates to:
  /// **'Get matched into a group of up to 20 Android developers'**
  String get signInBullet1;

  /// No description provided for @signInBullet2.
  ///
  /// In en, this message translates to:
  /// **'Installs and daily usage are verified on-device'**
  String get signInBullet2;

  /// No description provided for @signInBullet3.
  ///
  /// In en, this message translates to:
  /// **'Give and receive honest feedback that improves your app'**
  String get signInBullet3;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @ob1Title.
  ///
  /// In en, this message translates to:
  /// **'A pact between developers'**
  String get ob1Title;

  /// No description provided for @ob1P1.
  ///
  /// In en, this message translates to:
  /// **'Google needs 12 testers opted in for 14 days before a new personal account can go to production.'**
  String get ob1P1;

  /// No description provided for @ob1P2.
  ///
  /// In en, this message translates to:
  /// **'You join a group. Everyone adds everyone as testers and installs everyone\'s app.'**
  String get ob1P2;

  /// No description provided for @ob1P3.
  ///
  /// In en, this message translates to:
  /// **'For 16 days, you open each app in your list every day. Your app gets the same from everyone else.'**
  String get ob1P3;

  /// No description provided for @ob2Title.
  ///
  /// In en, this message translates to:
  /// **'Fair for everyone'**
  String get ob2Title;

  /// No description provided for @ob2P1.
  ///
  /// In en, this message translates to:
  /// **'Your app is only shown to others after you\'ve added their emails: give first, then receive.'**
  String get ob2P1;

  /// No description provided for @ob2P2.
  ///
  /// In en, this message translates to:
  /// **'Your trust score grows when you test daily and give helpful feedback, and drops when you don\'t.'**
  String get ob2P2;

  /// No description provided for @ob2P3.
  ///
  /// In en, this message translates to:
  /// **'Inactive members get warnings and are removed after 3 missed days. Reports are checked against real usage data.'**
  String get ob2P3;

  /// No description provided for @ob3Title.
  ///
  /// In en, this message translates to:
  /// **'Prove your testing automatically'**
  String get ob3Title;

  /// No description provided for @ob3P1.
  ///
  /// In en, this message translates to:
  /// **'TestPact checks only the apps assigned to you: installed or not, and minutes used today.'**
  String get ob3P1;

  /// No description provided for @ob3P2.
  ///
  /// In en, this message translates to:
  /// **'Nothing about your other apps is ever read or sent.'**
  String get ob3P2;

  /// No description provided for @usageAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage access'**
  String get usageAccessTitle;

  /// No description provided for @usageAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Lets TestPact count the minutes you spend in your assigned apps, so you get credit even when you open them from your home screen.'**
  String get usageAccessBody;

  /// No description provided for @granted.
  ///
  /// In en, this message translates to:
  /// **'Granted ✓'**
  String get granted;

  /// No description provided for @notGranted.
  ///
  /// In en, this message translates to:
  /// **'Not granted, tap to enable'**
  String get notGranted;

  /// No description provided for @grantUsageAccess.
  ///
  /// In en, this message translates to:
  /// **'Grant usage access'**
  String get grantUsageAccess;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notificationsTitle;

  /// No description provided for @notificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders and group updates, so you never miss a day.'**
  String get notificationsBody;

  /// No description provided for @allowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get allowNotifications;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @settingUp.
  ///
  /// In en, this message translates to:
  /// **'Setting up your account…'**
  String get settingUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabMyApps.
  ///
  /// In en, this message translates to:
  /// **'My apps'**
  String get tabMyApps;

  /// No description provided for @tabFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get tabFeedback;

  /// No description provided for @tabProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get tabProfile;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @addApp.
  ///
  /// In en, this message translates to:
  /// **'Add app'**
  String get addApp;

  /// No description provided for @bannedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account restricted'**
  String get bannedTitle;

  /// No description provided for @bannedBody.
  ///
  /// In en, this message translates to:
  /// **'You have {count} strikes, so you can\'t join new groups. If you think this is a mistake, send an appeal.'**
  String bannedBody(int count);

  /// No description provided for @appeal.
  ///
  /// In en, this message translates to:
  /// **'Appeal'**
  String get appeal;

  /// No description provided for @strikesTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 strike} other{{count} strikes}} on your account'**
  String strikesTitle(int count);

  /// No description provided for @strikesBody.
  ///
  /// In en, this message translates to:
  /// **'3 strikes and you can\'t join new groups. Strikes come from removals for inactivity or confirmed reports.'**
  String get strikesBody;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @googleRuleTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Play\'s rule'**
  String get googleRuleTitle;

  /// No description provided for @googleRuleBody.
  ///
  /// In en, this message translates to:
  /// **'Personal developer accounts created after 13 Nov 2023 need at least 12 testers opted in for 14 days in a row. Groups start with 20 people and run 16 days, so you have a buffer. Google also checks that testers really used the app, so open it and explore, don\'t just install it.'**
  String get googleRuleBody;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name} 👋'**
  String hello(String name);

  /// No description provided for @joinCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to find your testers?'**
  String get joinCardTitle;

  /// No description provided for @joinCardBody.
  ///
  /// In en, this message translates to:
  /// **'Join the queue. As soon as there are enough developers, your group is created automatically.'**
  String get joinCardBody;

  /// No description provided for @joinCardNoApps.
  ///
  /// In en, this message translates to:
  /// **'Add the app you want tested first, including its closed testing link.'**
  String get joinCardNoApps;

  /// No description provided for @joinGroup.
  ///
  /// In en, this message translates to:
  /// **'Join a group'**
  String get joinGroup;

  /// No description provided for @addYourApp.
  ///
  /// In en, this message translates to:
  /// **'Add your app'**
  String get addYourApp;

  /// No description provided for @inQueueTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re in the queue'**
  String get inQueueTitle;

  /// No description provided for @inQueueBody.
  ///
  /// In en, this message translates to:
  /// **'Waiting to match {app} into a {tier} group. We\'ll notify you when it\'s ready.'**
  String inQueueBody(String app, String tier);

  /// No description provided for @tierTrusted.
  ///
  /// In en, this message translates to:
  /// **'trusted'**
  String get tierTrusted;

  /// No description provided for @tierStarter.
  ///
  /// In en, this message translates to:
  /// **'starter'**
  String get tierStarter;

  /// No description provided for @queueWaiting.
  ///
  /// In en, this message translates to:
  /// **'{count} of {size} developers waiting'**
  String queueWaiting(int count, int size);

  /// No description provided for @queueJoinedAt.
  ///
  /// In en, this message translates to:
  /// **'Joined {time}'**
  String queueJoinedAt(String time);

  /// No description provided for @leaveQueue.
  ///
  /// In en, this message translates to:
  /// **'Leave queue'**
  String get leaveQueue;

  /// No description provided for @dayOf.
  ///
  /// In en, this message translates to:
  /// **'Day {day} of {total}'**
  String dayOf(int day, int total);

  /// No description provided for @groupTitle.
  ///
  /// In en, this message translates to:
  /// **'Group #{id}'**
  String groupTitle(String id);

  /// No description provided for @openedToday.
  ///
  /// In en, this message translates to:
  /// **'Opened today: {opened} of {total}'**
  String openedToday(int opened, int total);

  /// No description provided for @setupDoneWaiting.
  ///
  /// In en, this message translates to:
  /// **'Setup done ✓ Waiting for the others to finish.'**
  String get setupDoneWaiting;

  /// No description provided for @setupTodo.
  ///
  /// In en, this message translates to:
  /// **'Finish setup: add the emails and install everyone\'s app.'**
  String get setupTodo;

  /// No description provided for @suspendedBody.
  ///
  /// In en, this message translates to:
  /// **'You\'re under review after several reports. An admin is checking your activity data.'**
  String get suspendedBody;

  /// No description provided for @openGroup.
  ///
  /// In en, this message translates to:
  /// **'Open group'**
  String get openGroup;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Add your app'**
  String get step1Title;

  /// No description provided for @step1Body.
  ///
  /// In en, this message translates to:
  /// **'Name, package and your closed testing opt-in link.'**
  String get step1Body;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Join the queue'**
  String get step2Title;

  /// No description provided for @step2Body.
  ///
  /// In en, this message translates to:
  /// **'Groups of 20 form automatically. Trusted testers are matched together.'**
  String get step2Body;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Setup within 48h'**
  String get step3Title;

  /// No description provided for @step3Body.
  ///
  /// In en, this message translates to:
  /// **'Paste everyone\'s email into Play Console, then join and install every app.'**
  String get step3Body;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Test daily for 16 days'**
  String get step4Title;

  /// No description provided for @step4Body.
  ///
  /// In en, this message translates to:
  /// **'Open each app every day and leave real feedback. We verify it on-device.'**
  String get step4Body;

  /// No description provided for @step5Title.
  ///
  /// In en, this message translates to:
  /// **'Apply for production'**
  String get step5Title;

  /// No description provided for @step5Body.
  ///
  /// In en, this message translates to:
  /// **'Earn trust points and badges, then apply for production in Play Console.'**
  String get step5Body;

  /// No description provided for @rule1.
  ///
  /// In en, this message translates to:
  /// **'I will add every member\'s email to my closed test within 48 hours.'**
  String get rule1;

  /// No description provided for @rule2.
  ///
  /// In en, this message translates to:
  /// **'I will install every member\'s app and keep it installed until the end.'**
  String get rule2;

  /// No description provided for @rule3.
  ///
  /// In en, this message translates to:
  /// **'I will open every app daily for 16 days and give honest feedback.'**
  String get rule3;

  /// No description provided for @rule4.
  ///
  /// In en, this message translates to:
  /// **'I understand inactive members are removed and lose trust points.'**
  String get rule4;

  /// No description provided for @chooseApp.
  ///
  /// In en, this message translates to:
  /// **'Which app should be tested?'**
  String get chooseApp;

  /// No description provided for @yourCommitment.
  ///
  /// In en, this message translates to:
  /// **'Your commitment'**
  String get yourCommitment;

  /// No description provided for @joinedQueue.
  ///
  /// In en, this message translates to:
  /// **'You\'re in the queue!'**
  String get joinedQueue;

  /// No description provided for @joinQueue.
  ///
  /// In en, this message translates to:
  /// **'Join queue'**
  String get joinQueue;

  /// No description provided for @noAppsTitle.
  ///
  /// In en, this message translates to:
  /// **'No apps yet'**
  String get noAppsTitle;

  /// No description provided for @noAppsBody.
  ///
  /// In en, this message translates to:
  /// **'Add the app you want tested. You\'ll need its closed testing opt-in link from Play Console.'**
  String get noAppsBody;

  /// No description provided for @deleteAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this app?'**
  String get deleteAppTitle;

  /// No description provided for @deleteAppBody.
  ///
  /// In en, this message translates to:
  /// **'Groups that already include it keep their copy. You can add it again later.'**
  String get deleteAppBody;

  /// No description provided for @editApp.
  ///
  /// In en, this message translates to:
  /// **'Edit app'**
  String get editApp;

  /// No description provided for @appIcon.
  ///
  /// In en, this message translates to:
  /// **'Tap to set icon'**
  String get appIcon;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'App name'**
  String get appName;

  /// No description provided for @packageName.
  ///
  /// In en, this message translates to:
  /// **'Package name'**
  String get packageName;

  /// No description provided for @invalidPackage.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid package name, e.g. com.example.app'**
  String get invalidPackage;

  /// No description provided for @optInLink.
  ///
  /// In en, this message translates to:
  /// **'Closed testing opt-in link'**
  String get optInLink;

  /// No description provided for @optInHelp.
  ///
  /// In en, this message translates to:
  /// **'Play Console → Testing → Closed testing → Testers → \"Join on the web\" link.'**
  String get optInHelp;

  /// No description provided for @invalidOptIn.
  ///
  /// In en, this message translates to:
  /// **'Must be a play.google.com/apps/testing/… link'**
  String get invalidOptIn;

  /// No description provided for @shortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short description'**
  String get shortDescription;

  /// No description provided for @testNotes.
  ///
  /// In en, this message translates to:
  /// **'What should testers try?'**
  String get testNotes;

  /// No description provided for @testNotesHelp.
  ///
  /// In en, this message translates to:
  /// **'e.g. \"Create an account and add 2 items to the cart\". Shown to testers every day.'**
  String get testNotesHelp;

  /// No description provided for @closedTestTipTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you join'**
  String get closedTestTipTitle;

  /// No description provided for @closedTestTipBody.
  ///
  /// In en, this message translates to:
  /// **'Create a closed testing track, upload a build, roll it out, and set the tester list to an email list. Your group\'s emails go there.'**
  String get closedTestTipBody;

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get tabSetup;

  /// No description provided for @tabMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get tabMembers;

  /// No description provided for @tabActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get tabActivity;

  /// No description provided for @leaveGroup.
  ///
  /// In en, this message translates to:
  /// **'Leave group'**
  String get leaveGroup;

  /// No description provided for @leaveGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this group?'**
  String get leaveGroupTitle;

  /// No description provided for @leaveGroupBody.
  ///
  /// In en, this message translates to:
  /// **'The others stop testing your app and you lose trust points. This can\'t be undone.'**
  String get leaveGroupBody;

  /// No description provided for @youWereRemoved.
  ///
  /// In en, this message translates to:
  /// **'You were removed: {reason}.'**
  String youWereRemoved(String reason);

  /// No description provided for @youCompleted.
  ///
  /// In en, this message translates to:
  /// **'You completed this group 🏆 You can now apply for production access in Play Console.'**
  String get youCompleted;

  /// No description provided for @setupDeadlinePassed.
  ///
  /// In en, this message translates to:
  /// **'Setup deadline passed. Processing…'**
  String get setupDeadlinePassed;

  /// No description provided for @setupTimeLeft.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m left to finish setup'**
  String setupTimeLeft(int hours, int minutes);

  /// No description provided for @setupExplain.
  ///
  /// In en, this message translates to:
  /// **'Members who don\'t finish are replaced from the queue. The test starts when everyone is ready.'**
  String get setupExplain;

  /// No description provided for @step1AddEmails.
  ///
  /// In en, this message translates to:
  /// **'Step 1 · Add testers to your closed test'**
  String get step1AddEmails;

  /// No description provided for @addEmailsBody.
  ///
  /// In en, this message translates to:
  /// **'Copy all {count} emails and paste them into your closed testing email list in Play Console.'**
  String addEmailsBody(int count);

  /// No description provided for @copyAllEmails.
  ///
  /// In en, this message translates to:
  /// **'Copy all emails'**
  String get copyAllEmails;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'{count} emails copied'**
  String copied(int count);

  /// No description provided for @emailsConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Emails added'**
  String get emailsConfirmed;

  /// No description provided for @iAddedEveryone.
  ///
  /// In en, this message translates to:
  /// **'I added everyone'**
  String get iAddedEveryone;

  /// No description provided for @confirmEmailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Did you add all the emails?'**
  String get confirmEmailsTitle;

  /// No description provided for @confirmEmailsBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm that all {count} emails are on your closed test\'s tester list and the change is saved. Members can report you if they can\'t join.'**
  String confirmEmailsBody(int count);

  /// No description provided for @yesAdded.
  ///
  /// In en, this message translates to:
  /// **'Yes, all added'**
  String get yesAdded;

  /// No description provided for @emailsHowTo.
  ///
  /// In en, this message translates to:
  /// **'Play Console → your app → Testing → Closed testing → Testers → Email list → paste → Save.'**
  String get emailsHowTo;

  /// No description provided for @step2InstallApps.
  ///
  /// In en, this message translates to:
  /// **'Step 2 · Join & install apps ({done}/{total})'**
  String step2InstallApps(int done, int total);

  /// No description provided for @checkAgain.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get checkAgain;

  /// No description provided for @waitingForOwners.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member hasn\'t} other{{count} members haven\'t}} added the group\'s emails yet. Their apps appear here once they do.'**
  String waitingForOwners(int count);

  /// No description provided for @noAppsYet.
  ///
  /// In en, this message translates to:
  /// **'No apps to install yet.'**
  String get noAppsYet;

  /// No description provided for @byName.
  ///
  /// In en, this message translates to:
  /// **'by {name}'**
  String byName(String name);

  /// No description provided for @joinTest.
  ///
  /// In en, this message translates to:
  /// **'Join test'**
  String get joinTest;

  /// No description provided for @newMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'New member joined'**
  String get newMembersTitle;

  /// No description provided for @newMembersBody.
  ///
  /// In en, this message translates to:
  /// **'Add the new email(s) to your closed test and install their app. Open the Setup tab.'**
  String get newMembersBody;

  /// No description provided for @usageAccessOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Usage access is off'**
  String get usageAccessOffTitle;

  /// No description provided for @usageAccessOffBody.
  ///
  /// In en, this message translates to:
  /// **'Only apps you open with the Open button count. Turn on usage access to also get credit when you open them from your home screen.'**
  String get usageAccessOffBody;

  /// No description provided for @yourTestList.
  ///
  /// In en, this message translates to:
  /// **'Your test list'**
  String get yourTestList;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s testing'**
  String get todayTitle;

  /// No description provided for @todayDone.
  ///
  /// In en, this message translates to:
  /// **'All done for today 🎉'**
  String get todayDone;

  /// No description provided for @todayDoneBody.
  ///
  /// In en, this message translates to:
  /// **'Great job. Come back tomorrow.'**
  String get todayDoneBody;

  /// No description provided for @todayBody.
  ///
  /// In en, this message translates to:
  /// **'Open at least {needed} apps and use each for a bit.'**
  String todayBody(int needed);

  /// No description provided for @dayResetsAt.
  ///
  /// In en, this message translates to:
  /// **'New day starts at {time}'**
  String dayResetsAt(String time);

  /// No description provided for @notInstalled.
  ///
  /// In en, this message translates to:
  /// **'Not installed'**
  String get notInstalled;

  /// No description provided for @openedMinutes.
  ///
  /// In en, this message translates to:
  /// **'Opened today · {minutes} min'**
  String openedMinutes(int minutes);

  /// No description provided for @notOpenedYet.
  ///
  /// In en, this message translates to:
  /// **'Not opened today'**
  String get notOpenedYet;

  /// No description provided for @feedbackGivenCount.
  ///
  /// In en, this message translates to:
  /// **'Feedback ({count})'**
  String feedbackGivenCount(int count);

  /// No description provided for @giveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get giveFeedback;

  /// No description provided for @statMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get statMembers;

  /// No description provided for @statOnTrack.
  ///
  /// In en, this message translates to:
  /// **'On track today'**
  String get statOnTrack;

  /// No description provided for @statRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get statRemoved;

  /// No description provided for @membersLegend.
  ///
  /// In en, this message translates to:
  /// **'🟢 on track  🟡 not done yet  🔴 missed days  ⚪ left'**
  String get membersLegend;

  /// No description provided for @memberSetupLine.
  ///
  /// In en, this message translates to:
  /// **'emails {emails} · installed {installed}/{total}'**
  String memberSetupLine(String emails, int installed, int total);

  /// No description provided for @memberActiveLine.
  ///
  /// In en, this message translates to:
  /// **'installed {installed}/{total} · opened {opened}/{total} · feedback {feedback}'**
  String memberActiveLine(int installed, int opened, int total, int feedback);

  /// No description provided for @missedInARow.
  ///
  /// In en, this message translates to:
  /// **'Missed {count} day(s) in a row'**
  String missedInARow(int count);

  /// No description provided for @lastDays.
  ///
  /// In en, this message translates to:
  /// **'Last days'**
  String get lastDays;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get viewProfile;

  /// No description provided for @openInPlay.
  ///
  /// In en, this message translates to:
  /// **'Open in Play Store'**
  String get openInPlay;

  /// No description provided for @reportMember.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportMember;

  /// No description provided for @reportSent.
  ///
  /// In en, this message translates to:
  /// **'Report sent. Thanks for keeping groups fair.'**
  String get reportSent;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report {name}'**
  String reportTitle(String name);

  /// No description provided for @reportExplain.
  ///
  /// In en, this message translates to:
  /// **'Action is only taken when several members report AND our usage data agrees. False reports cost trust points.'**
  String get reportExplain;

  /// No description provided for @detailsOptional.
  ///
  /// In en, this message translates to:
  /// **'Details (optional)'**
  String get detailsOptional;

  /// No description provided for @addScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Add screenshot'**
  String get addScreenshot;

  /// No description provided for @screenshotAdded.
  ///
  /// In en, this message translates to:
  /// **'Screenshot added ✓'**
  String get screenshotAdded;

  /// No description provided for @sendReport.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get sendReport;

  /// No description provided for @noActivity.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get noActivity;

  /// No description provided for @evFormed.
  ///
  /// In en, this message translates to:
  /// **'Group formed with {count} developers'**
  String evFormed(int count);

  /// No description provided for @evJoined.
  ///
  /// In en, this message translates to:
  /// **'{name} joined the group'**
  String evJoined(String name);

  /// No description provided for @evEmailsAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added everyone\'s email'**
  String evEmailsAdded(String name);

  /// No description provided for @evStarted.
  ///
  /// In en, this message translates to:
  /// **'Testing started: day 1'**
  String get evStarted;

  /// No description provided for @evMemberActive.
  ///
  /// In en, this message translates to:
  /// **'{name} finished setup and started testing'**
  String evMemberActive(String name);

  /// No description provided for @evWarning.
  ///
  /// In en, this message translates to:
  /// **'{name} missed 2 days in a row (final warning)'**
  String evWarning(String name);

  /// No description provided for @evRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} was removed ({reason})'**
  String evRemoved(String name, String reason);

  /// No description provided for @evSuspended.
  ///
  /// In en, this message translates to:
  /// **'{name} is under admin review'**
  String evSuspended(String name);

  /// No description provided for @evReinstated.
  ///
  /// In en, this message translates to:
  /// **'{name} was cleared and is back'**
  String evReinstated(String name);

  /// No description provided for @evCompleted.
  ///
  /// In en, this message translates to:
  /// **'Group completed 🏆'**
  String get evCompleted;

  /// No description provided for @evCancelled.
  ///
  /// In en, this message translates to:
  /// **'Group cancelled'**
  String get evCancelled;

  /// No description provided for @feedbackSent.
  ///
  /// In en, this message translates to:
  /// **'Feedback sent. Thank you!'**
  String get feedbackSent;

  /// No description provided for @feedbackFor.
  ///
  /// In en, this message translates to:
  /// **'Feedback: {app}'**
  String feedbackFor(String app);

  /// No description provided for @developerAsks.
  ///
  /// In en, this message translates to:
  /// **'The developer asks you to try'**
  String get developerAsks;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @yourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Your feedback'**
  String get yourFeedback;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'What worked, what broke, what confused you? Be specific: screens, steps, device.'**
  String get feedbackHint;

  /// No description provided for @feedbackMin.
  ///
  /// In en, this message translates to:
  /// **'At least 20 characters'**
  String get feedbackMin;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @given.
  ///
  /// In en, this message translates to:
  /// **'Given'**
  String get given;

  /// No description provided for @noFeedbackReceived.
  ///
  /// In en, this message translates to:
  /// **'No feedback yet'**
  String get noFeedbackReceived;

  /// No description provided for @noFeedbackReceivedBody.
  ///
  /// In en, this message translates to:
  /// **'Feedback from your group\'s testers will show up here.'**
  String get noFeedbackReceivedBody;

  /// No description provided for @noFeedbackGiven.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t given feedback yet'**
  String get noFeedbackGiven;

  /// No description provided for @noFeedbackGivenBody.
  ///
  /// In en, this message translates to:
  /// **'Use the Feedback button on each app in your group\'s Today tab.'**
  String get noFeedbackGivenBody;

  /// No description provided for @fromOnApp.
  ///
  /// In en, this message translates to:
  /// **'{name} on {app}'**
  String fromOnApp(String name, String app);

  /// No description provided for @wasHelpful.
  ///
  /// In en, this message translates to:
  /// **'Was this helpful?'**
  String get wasHelpful;

  /// No description provided for @markedHelpful.
  ///
  /// In en, this message translates to:
  /// **'You marked this helpful (+2 trust for them)'**
  String get markedHelpful;

  /// No description provided for @markedNotHelpful.
  ///
  /// In en, this message translates to:
  /// **'Marked not helpful'**
  String get markedNotHelpful;

  /// No description provided for @groupHistory.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groupHistory;

  /// No description provided for @noGroupsYet.
  ///
  /// In en, this message translates to:
  /// **'No groups yet.'**
  String get noGroupsYet;

  /// No description provided for @trustHistory.
  ///
  /// In en, this message translates to:
  /// **'Trust score history'**
  String get trustHistory;

  /// No description provided for @noTrustHistory.
  ///
  /// In en, this message translates to:
  /// **'No changes yet.'**
  String get noTrustHistory;

  /// No description provided for @trustScore.
  ///
  /// In en, this message translates to:
  /// **'Trust score'**
  String get trustScore;

  /// No description provided for @pointsToNext.
  ///
  /// In en, this message translates to:
  /// **'{points} points to the next level'**
  String pointsToNext(int points);

  /// No description provided for @statCompleted.
  ///
  /// In en, this message translates to:
  /// **'Groups completed'**
  String get statCompleted;

  /// No description provided for @statCompletionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion rate'**
  String get statCompletionRate;

  /// No description provided for @statDailyActivity.
  ///
  /// In en, this message translates to:
  /// **'Daily activity'**
  String get statDailyActivity;

  /// No description provided for @statActiveDays.
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get statActiveDays;

  /// No description provided for @statFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback given'**
  String get statFeedback;

  /// No description provided for @statHelpful.
  ///
  /// In en, this message translates to:
  /// **'Helpful feedback'**
  String get statHelpful;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @noBadges.
  ///
  /// In en, this message translates to:
  /// **'Complete your first group to earn a badge.'**
  String get noBadges;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemLanguage;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get contactSupport;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate TestPact'**
  String get rateApp;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Your profile, apps and trust score are deleted permanently. If you\'re in a group you\'ll be removed from it.'**
  String get deleteAccountBody;

  /// No description provided for @appealTitle.
  ///
  /// In en, this message translates to:
  /// **'Appeal a decision'**
  String get appealTitle;

  /// No description provided for @appealExplain.
  ///
  /// In en, this message translates to:
  /// **'Explain what happened. An admin reviews every appeal. Accepted appeals remove a strike and restore some trust points.'**
  String get appealExplain;

  /// No description provided for @appealHint.
  ///
  /// In en, this message translates to:
  /// **'What happened? Include dates and anything that helps us check.'**
  String get appealHint;

  /// No description provided for @appealSent.
  ///
  /// In en, this message translates to:
  /// **'Appeal sent'**
  String get appealSent;

  /// No description provided for @sendAppeal.
  ///
  /// In en, this message translates to:
  /// **'Send appeal'**
  String get sendAppeal;

  /// No description provided for @yourAppeals.
  ///
  /// In en, this message translates to:
  /// **'Your appeals'**
  String get yourAppeals;

  /// No description provided for @appealOpen.
  ///
  /// In en, this message translates to:
  /// **'Waiting for review'**
  String get appealOpen;

  /// No description provided for @appealAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get appealAccepted;

  /// No description provided for @appealRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get appealRejected;

  /// No description provided for @adminReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get adminReviews;

  /// No description provided for @adminAppeals.
  ///
  /// In en, this message translates to:
  /// **'Appeals'**
  String get adminAppeals;

  /// No description provided for @adminUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adminUsers;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note to the user (optional)'**
  String get noteOptional;

  /// No description provided for @nothingToReview.
  ///
  /// In en, this message translates to:
  /// **'Nothing to review 🎉'**
  String get nothingToReview;

  /// No description provided for @dataSummary.
  ///
  /// In en, this message translates to:
  /// **'Usage data: {active} active days, {missed} missed days'**
  String dataSummary(int active, int missed);

  /// No description provided for @rejectReports.
  ///
  /// In en, this message translates to:
  /// **'Reject reports'**
  String get rejectReports;

  /// No description provided for @confirmKick.
  ///
  /// In en, this message translates to:
  /// **'Confirm & remove'**
  String get confirmKick;

  /// No description provided for @searchByEmail.
  ///
  /// In en, this message translates to:
  /// **'Search user by email'**
  String get searchByEmail;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user with that email.'**
  String get userNotFound;

  /// No description provided for @userSummary.
  ///
  /// In en, this message translates to:
  /// **'Trust {trust} · strikes {strikes} · banned: {banned}'**
  String userSummary(int trust, int strikes, String banned);

  /// No description provided for @ban.
  ///
  /// In en, this message translates to:
  /// **'Ban'**
  String get ban;

  /// No description provided for @unban.
  ///
  /// In en, this message translates to:
  /// **'Unban'**
  String get unban;

  /// No description provided for @adjustTrust.
  ///
  /// In en, this message translates to:
  /// **'Adjust trust score'**
  String get adjustTrust;

  /// No description provided for @notificationsInbox.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsInbox;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @noNotificationsBody.
  ///
  /// In en, this message translates to:
  /// **'Group updates, reminders, warnings and feedback alerts will show up here.'**
  String get noNotificationsBody;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationSettings;

  /// No description provided for @notifPermissionOff.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for TestPact'**
  String get notifPermissionOff;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @notifDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily reminders'**
  String get notifDaily;

  /// No description provided for @notifDailySub.
  ///
  /// In en, this message translates to:
  /// **'Evening reminder if today\'s apps aren\'t opened yet, and setup deadlines'**
  String get notifDailySub;

  /// No description provided for @notifGroup.
  ///
  /// In en, this message translates to:
  /// **'Group updates'**
  String get notifGroup;

  /// No description provided for @notifGroupSub.
  ///
  /// In en, this message translates to:
  /// **'Group formed, test started, new members, completion'**
  String get notifGroupSub;

  /// No description provided for @notifFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get notifFeedback;

  /// No description provided for @notifFeedbackSub.
  ///
  /// In en, this message translates to:
  /// **'When someone leaves feedback on your app'**
  String get notifFeedbackSub;

  /// No description provided for @notifImportantNote.
  ///
  /// In en, this message translates to:
  /// **'Warnings and removals are always sent, so you never miss anything that affects your spot.'**
  String get notifImportantNote;

  /// No description provided for @noInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetTitle;

  /// No description provided for @noInternetBody.
  ///
  /// In en, this message translates to:
  /// **'Check your Wi-Fi or mobile data. TestPact reconnects automatically as soon as you\'re back online.'**
  String get noInternetBody;

  /// No description provided for @checkingConnection.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checkingConnection;

  /// No description provided for @backOnline.
  ///
  /// In en, this message translates to:
  /// **'Back online'**
  String get backOnline;

  /// No description provided for @updateRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Update required'**
  String get updateRequiredTitle;

  /// No description provided for @updateRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'This version of TestPact is no longer supported. Update to keep testing with your group.'**
  String get updateRequiredBody;

  /// No description provided for @updateAvailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailableTitle;

  /// No description provided for @updateAvailableBody.
  ///
  /// In en, this message translates to:
  /// **'A new version of TestPact is ready, with improvements and fixes.'**
  String get updateAvailableBody;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @updateDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Update downloaded. Restart to finish installing.'**
  String get updateDownloaded;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Great to see you back!'**
  String get welcomeBack;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @statusTesting.
  ///
  /// In en, this message translates to:
  /// **'Testing'**
  String get statusTesting;

  /// No description provided for @inQueueShort.
  ///
  /// In en, this message translates to:
  /// **'In queue'**
  String get inQueueShort;

  /// No description provided for @statusReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// No description provided for @memberDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get memberDone;

  /// No description provided for @memberTesting.
  ///
  /// In en, this message translates to:
  /// **'Testing'**
  String get memberTesting;

  /// No description provided for @memberPending.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get memberPending;

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks'**
  String get todaysTasks;

  /// No description provided for @tasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'{total} apps · {done}/{total} completed'**
  String tasksCompleted(int total, int done);

  /// No description provided for @groupMembersCount.
  ///
  /// In en, this message translates to:
  /// **'Group members ({count})'**
  String groupMembersCount(int count);

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @badgesEarned.
  ///
  /// In en, this message translates to:
  /// **'{earned} of {total} earned'**
  String badgesEarned(int earned, int total);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'gu',
    'hi',
    'mr',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'mr':
      return AppLocalizationsMr();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
