// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get next => 'Next';

  @override
  String get retry => 'Retry';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get you => 'you';

  @override
  String get required => 'Required';

  @override
  String get open => 'Open';

  @override
  String get install => 'Install';

  @override
  String get leave => 'Leave';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get confirmAction => 'Confirm';

  @override
  String get errDeviceInUse =>
      'This phone is already linked to another TestPact account. One account per device keeps groups fair.';

  @override
  String get errBanned =>
      'Your account can\'t join new groups right now. You can send an appeal.';

  @override
  String get errAlreadyInGroup =>
      'You\'re already in a group. Finish it first.';

  @override
  String get errAppNotFound => 'That app listing no longer exists.';

  @override
  String get errAppealOpen => 'You already have an appeal waiting for review.';

  @override
  String get errAlreadyRated => 'You already rated this feedback.';

  @override
  String get errIntegrity =>
      'This device didn\'t pass Google Play\'s integrity check. Use a genuine phone with the app installed from Google Play.';

  @override
  String get errNetwork => 'No connection. Check your internet and try again.';

  @override
  String get errGeneric => 'Something went wrong. Please try again.';

  @override
  String get levelProbation => 'Probation';

  @override
  String get levelNewcomer => 'Newcomer';

  @override
  String get levelMember => 'Member';

  @override
  String get levelTrusted => 'Trusted';

  @override
  String get levelTopTester => 'Top Tester';

  @override
  String get reasonNotInstalled => 'Didn\'t install my app';

  @override
  String get reasonUninstalled => 'Uninstalled during the test';

  @override
  String get reasonNotOpening => 'Not opening apps daily';

  @override
  String get reasonEmailNotAdded => 'Didn\'t add my email to their test';

  @override
  String get reasonSpam => 'Spam or abuse';

  @override
  String get reasonFakeFeedback => 'Fake or copy-paste feedback';

  @override
  String get reasonOther => 'Other';

  @override
  String get catBug => 'Bug';

  @override
  String get catUx => 'Design / UX';

  @override
  String get catIdea => 'Idea';

  @override
  String get catPraise => 'Praise';

  @override
  String get catOther => 'Other';

  @override
  String get badgeFirstPact => 'First pact';

  @override
  String get badgeVeteran => 'Veteran (5 groups)';

  @override
  String get badgePerfect => 'Perfect streak';

  @override
  String get badgeHelpful => 'Helpful reviewer';

  @override
  String get badgeTopTester => 'Top tester';

  @override
  String get removedSetup => 'setup not finished in time';

  @override
  String get removedInactive => 'inactive for 3 days';

  @override
  String get removedReported => 'reports confirmed by admin';

  @override
  String get removedLeft => 'left the group';

  @override
  String get removedCancelled => 'group cancelled';

  @override
  String get removedEnded => 'group ended';

  @override
  String get removedOther => 'removed';

  @override
  String trustAdmin(String reason) {
    return 'Admin adjustment: $reason';
  }

  @override
  String get trustGroupCompleted => 'Completed a group';

  @override
  String get trustActiveDay => 'Opened all apps for the day';

  @override
  String get trustMissedDay => 'Missed a day';

  @override
  String get trustHelpfulFeedback => 'Feedback marked helpful';

  @override
  String get trustKickedInactive => 'Removed for inactivity';

  @override
  String get trustKickedReported => 'Removed after confirmed reports';

  @override
  String get trustSetupFailed => 'Setup not finished';

  @override
  String get trustLeftGroup => 'Left a group early';

  @override
  String get trustFalseReport => 'Report rejected by admin';

  @override
  String get trustAppealAccepted => 'Appeal accepted';

  @override
  String get statusSetup => 'Setup';

  @override
  String get statusActive => 'Testing';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get stateSetup => 'Setting up';

  @override
  String get stateActive => 'Testing';

  @override
  String get stateSuspended => 'Under review';

  @override
  String get stateRemoved => 'Removed';

  @override
  String get stateCompleted => 'Completed';

  @override
  String get language => 'Language';

  @override
  String get tagline =>
      'Real testers. Real feedback.\nPass Google Play closed testing together.';

  @override
  String get signInBullet1 =>
      'Get matched into a group of up to 20 Android developers';

  @override
  String get signInBullet2 => 'Installs and daily usage are verified on-device';

  @override
  String get signInBullet3 =>
      'Give and receive honest feedback that improves your app';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get terms => 'Terms';

  @override
  String get ob1Title => 'A pact between developers';

  @override
  String get ob1P1 =>
      'Google needs 12 testers opted in for 14 days before a new personal account can go to production.';

  @override
  String get ob1P2 =>
      'You join a group. Everyone adds everyone as testers and installs everyone\'s app.';

  @override
  String get ob1P3 =>
      'For 16 days, you open each app in your list every day. Your app gets the same from everyone else.';

  @override
  String get ob2Title => 'Fair for everyone';

  @override
  String get ob2P1 =>
      'Your app is only shown to others after you\'ve added their emails: give first, then receive.';

  @override
  String get ob2P2 =>
      'Your trust score grows when you test daily and give helpful feedback, and drops when you don\'t.';

  @override
  String get ob2P3 =>
      'Inactive members get warnings and are removed after 3 missed days. Reports are checked against real usage data.';

  @override
  String get ob3Title => 'Prove your testing automatically';

  @override
  String get ob3P1 =>
      'TestPact checks only the apps assigned to you: installed or not, and minutes used today.';

  @override
  String get ob3P2 => 'Nothing about your other apps is ever read or sent.';

  @override
  String get usageAccessTitle => 'Usage access';

  @override
  String get usageAccessBody =>
      'Lets TestPact count the minutes you spend in your assigned apps, so you get credit even when you open them from your home screen.';

  @override
  String get granted => 'Granted ✓';

  @override
  String get notGranted => 'Not granted, tap to enable';

  @override
  String get grantUsageAccess => 'Grant usage access';

  @override
  String get notificationsTitle => 'Reminders';

  @override
  String get notificationsBody =>
      'Daily reminders and group updates, so you never miss a day.';

  @override
  String get allowNotifications => 'Allow notifications';

  @override
  String get getStarted => 'Get started';

  @override
  String get settingUp => 'Setting up your account…';

  @override
  String get signOut => 'Sign out';

  @override
  String get tabHome => 'Home';

  @override
  String get tabMyApps => 'My apps';

  @override
  String get tabFeedback => 'Feedback';

  @override
  String get tabProfile => 'Profile';

  @override
  String get admin => 'Admin';

  @override
  String get settings => 'Settings';

  @override
  String get addApp => 'Add app';

  @override
  String get bannedTitle => 'Account restricted';

  @override
  String bannedBody(int count) {
    return 'You have $count strikes, so you can\'t join new groups. If you think this is a mistake, send an appeal.';
  }

  @override
  String get appeal => 'Appeal';

  @override
  String strikesTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count strikes',
      one: '1 strike',
    );
    return '$_temp0 on your account';
  }

  @override
  String get strikesBody =>
      '3 strikes and you can\'t join new groups. Strikes come from removals for inactivity or confirmed reports.';

  @override
  String get howItWorks => 'How it works';

  @override
  String get googleRuleTitle => 'Google Play\'s rule';

  @override
  String get googleRuleBody =>
      'Personal developer accounts created after 13 Nov 2023 need at least 12 testers opted in for 14 days in a row. Groups start with 20 people and run 16 days, so you have a buffer. Google also checks that testers really used the app, so open it and explore, don\'t just install it.';

  @override
  String hello(String name) {
    return 'Hi, $name 👋';
  }

  @override
  String get joinCardTitle => 'Ready to find your testers?';

  @override
  String get joinCardBody =>
      'Join the queue. As soon as there are enough developers, your group is created automatically.';

  @override
  String get joinCardNoApps =>
      'Add the app you want tested first, including its closed testing link.';

  @override
  String get joinGroup => 'Join a group';

  @override
  String get addYourApp => 'Add your app';

  @override
  String get inQueueTitle => 'You\'re in the queue';

  @override
  String inQueueBody(String app, String tier) {
    return 'Waiting to match $app into a $tier group. We\'ll notify you when it\'s ready.';
  }

  @override
  String get tierTrusted => 'trusted';

  @override
  String get tierStarter => 'starter';

  @override
  String queueWaiting(int count, int size) {
    return '$count of $size developers waiting';
  }

  @override
  String queueJoinedAt(String time) {
    return 'Joined $time';
  }

  @override
  String get leaveQueue => 'Leave queue';

  @override
  String dayOf(int day, int total) {
    return 'Day $day of $total';
  }

  @override
  String groupTitle(String id) {
    return 'Group #$id';
  }

  @override
  String openedToday(int opened, int total) {
    return 'Opened today: $opened of $total';
  }

  @override
  String get setupDoneWaiting =>
      'Setup done ✓ Waiting for the others to finish.';

  @override
  String get setupTodo =>
      'Finish setup: add the emails and install everyone\'s app.';

  @override
  String get suspendedBody =>
      'You\'re under review after several reports. An admin is checking your activity data.';

  @override
  String get openGroup => 'Open group';

  @override
  String get step1Title => 'Add your app';

  @override
  String get step1Body => 'Name, package and your closed testing opt-in link.';

  @override
  String get step2Title => 'Join the queue';

  @override
  String get step2Body =>
      'Groups of 20 form automatically. Trusted testers are matched together.';

  @override
  String get step3Title => 'Setup within 48h';

  @override
  String get step3Body =>
      'Paste everyone\'s email into Play Console, then join and install every app.';

  @override
  String get step4Title => 'Test daily for 16 days';

  @override
  String get step4Body =>
      'Open each app every day and leave real feedback. We verify it on-device.';

  @override
  String get step5Title => 'Apply for production';

  @override
  String get step5Body =>
      'Earn trust points and badges, then apply for production in Play Console.';

  @override
  String get rule1 =>
      'I will add every member\'s email to my closed test within 48 hours.';

  @override
  String get rule2 =>
      'I will install every member\'s app and keep it installed until the end.';

  @override
  String get rule3 =>
      'I will open every app daily for 16 days and give honest feedback.';

  @override
  String get rule4 =>
      'I understand inactive members are removed and lose trust points.';

  @override
  String get chooseApp => 'Which app should be tested?';

  @override
  String get yourCommitment => 'Your commitment';

  @override
  String get joinedQueue => 'You\'re in the queue!';

  @override
  String get joinQueue => 'Join queue';

  @override
  String get noAppsTitle => 'No apps yet';

  @override
  String get noAppsBody =>
      'Add the app you want tested. You\'ll need its closed testing opt-in link from Play Console.';

  @override
  String get deleteAppTitle => 'Delete this app?';

  @override
  String get deleteAppBody =>
      'Groups that already include it keep their copy. You can add it again later.';

  @override
  String get editApp => 'Edit app';

  @override
  String get appIcon => 'Tap to set icon';

  @override
  String get appName => 'App name';

  @override
  String get packageName => 'Package name';

  @override
  String get invalidPackage =>
      'Enter a valid package name, e.g. com.example.app';

  @override
  String get optInLink => 'Closed testing opt-in link';

  @override
  String get optInHelp =>
      'Play Console → Testing → Closed testing → Testers → \"Join on the web\" link.';

  @override
  String get invalidOptIn => 'Must be a play.google.com/apps/testing/… link';

  @override
  String get shortDescription => 'Short description';

  @override
  String get testNotes => 'What should testers try?';

  @override
  String get testNotesHelp =>
      'e.g. \"Create an account and add 2 items to the cart\". Shown to testers every day.';

  @override
  String get closedTestTipTitle => 'Before you join';

  @override
  String get closedTestTipBody =>
      'Create a closed testing track, upload a build, roll it out, and set the tester list to an email list. Your group\'s emails go there.';

  @override
  String get tabToday => 'Today';

  @override
  String get tabSetup => 'Setup';

  @override
  String get tabMembers => 'Members';

  @override
  String get tabActivity => 'Activity';

  @override
  String get leaveGroup => 'Leave group';

  @override
  String get leaveGroupTitle => 'Leave this group?';

  @override
  String get leaveGroupBody =>
      'The others stop testing your app and you lose trust points. This can\'t be undone.';

  @override
  String youWereRemoved(String reason) {
    return 'You were removed: $reason.';
  }

  @override
  String get youCompleted =>
      'You completed this group 🏆 You can now apply for production access in Play Console.';

  @override
  String get setupDeadlinePassed => 'Setup deadline passed. Processing…';

  @override
  String setupTimeLeft(int hours, int minutes) {
    return '${hours}h ${minutes}m left to finish setup';
  }

  @override
  String get setupExplain =>
      'Members who don\'t finish are replaced from the queue. The test starts when everyone is ready.';

  @override
  String get step1AddEmails => 'Step 1 · Add testers to your closed test';

  @override
  String addEmailsBody(int count) {
    return 'Copy all $count emails and paste them into your closed testing email list in Play Console.';
  }

  @override
  String get copyAllEmails => 'Copy all emails';

  @override
  String copied(int count) {
    return '$count emails copied';
  }

  @override
  String get emailsConfirmed => 'Emails added';

  @override
  String get iAddedEveryone => 'I added everyone';

  @override
  String get confirmEmailsTitle => 'Did you add all the emails?';

  @override
  String confirmEmailsBody(int count) {
    return 'Confirm that all $count emails are on your closed test\'s tester list and the change is saved. Members can report you if they can\'t join.';
  }

  @override
  String get yesAdded => 'Yes, all added';

  @override
  String get emailsHowTo =>
      'Play Console → your app → Testing → Closed testing → Testers → Email list → paste → Save.';

  @override
  String step2InstallApps(int done, int total) {
    return 'Step 2 · Join & install apps ($done/$total)';
  }

  @override
  String get checkAgain => 'Check again';

  @override
  String waitingForOwners(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members haven\'t',
      one: '1 member hasn\'t',
    );
    return '$_temp0 added the group\'s emails yet. Their apps appear here once they do.';
  }

  @override
  String get noAppsYet => 'No apps to install yet.';

  @override
  String byName(String name) {
    return 'by $name';
  }

  @override
  String get joinTest => 'Join test';

  @override
  String get newMembersTitle => 'New member joined';

  @override
  String get newMembersBody =>
      'Add the new email(s) to your closed test and install their app. Open the Setup tab.';

  @override
  String get usageAccessOffTitle => 'Usage access is off';

  @override
  String get usageAccessOffBody =>
      'Only apps you open with the Open button count. Turn on usage access to also get credit when you open them from your home screen.';

  @override
  String get yourTestList => 'Your test list';

  @override
  String get todayTitle => 'Today\'s testing';

  @override
  String get todayDone => 'All done for today 🎉';

  @override
  String get todayDoneBody => 'Great job. Come back tomorrow.';

  @override
  String todayBody(int needed) {
    return 'Open at least $needed apps and use each for a bit.';
  }

  @override
  String dayResetsAt(String time) {
    return 'New day starts at $time';
  }

  @override
  String get notInstalled => 'Not installed';

  @override
  String openedMinutes(int minutes) {
    return 'Opened today · $minutes min';
  }

  @override
  String get notOpenedYet => 'Not opened today';

  @override
  String feedbackGivenCount(int count) {
    return 'Feedback ($count)';
  }

  @override
  String get giveFeedback => 'Feedback';

  @override
  String get statMembers => 'Members';

  @override
  String get statOnTrack => 'On track today';

  @override
  String get statRemoved => 'Removed';

  @override
  String get membersLegend =>
      '🟢 on track  🟡 not done yet  🔴 missed days  ⚪ left';

  @override
  String memberSetupLine(String emails, int installed, int total) {
    return 'emails $emails · installed $installed/$total';
  }

  @override
  String memberActiveLine(int installed, int opened, int total, int feedback) {
    return 'installed $installed/$total · opened $opened/$total · feedback $feedback';
  }

  @override
  String missedInARow(int count) {
    return 'Missed $count day(s) in a row';
  }

  @override
  String get lastDays => 'Last days';

  @override
  String get viewProfile => 'View profile';

  @override
  String get openInPlay => 'Open in Play Store';

  @override
  String get reportMember => 'Report';

  @override
  String get reportSent => 'Report sent. Thanks for keeping groups fair.';

  @override
  String reportTitle(String name) {
    return 'Report $name';
  }

  @override
  String get reportExplain =>
      'Action is only taken when several members report AND our usage data agrees. False reports cost trust points.';

  @override
  String get detailsOptional => 'Details (optional)';

  @override
  String get addScreenshot => 'Add screenshot';

  @override
  String get screenshotAdded => 'Screenshot added ✓';

  @override
  String get sendReport => 'Send report';

  @override
  String get noActivity => 'No activity yet';

  @override
  String evFormed(int count) {
    return 'Group formed with $count developers';
  }

  @override
  String evJoined(String name) {
    return '$name joined the group';
  }

  @override
  String evEmailsAdded(String name) {
    return '$name added everyone\'s email';
  }

  @override
  String get evStarted => 'Testing started: day 1';

  @override
  String evMemberActive(String name) {
    return '$name finished setup and started testing';
  }

  @override
  String evWarning(String name) {
    return '$name missed 2 days in a row (final warning)';
  }

  @override
  String evRemoved(String name, String reason) {
    return '$name was removed ($reason)';
  }

  @override
  String evSuspended(String name) {
    return '$name is under admin review';
  }

  @override
  String evReinstated(String name) {
    return '$name was cleared and is back';
  }

  @override
  String get evCompleted => 'Group completed 🏆';

  @override
  String get evCancelled => 'Group cancelled';

  @override
  String get feedbackSent => 'Feedback sent. Thank you!';

  @override
  String feedbackFor(String app) {
    return 'Feedback: $app';
  }

  @override
  String get developerAsks => 'The developer asks you to try';

  @override
  String get rating => 'Rating';

  @override
  String get category => 'Category';

  @override
  String get yourFeedback => 'Your feedback';

  @override
  String get feedbackHint =>
      'What worked, what broke, what confused you? Be specific: screens, steps, device.';

  @override
  String get feedbackMin => 'At least 20 characters';

  @override
  String get sendFeedback => 'Send feedback';

  @override
  String get received => 'Received';

  @override
  String get given => 'Given';

  @override
  String get noFeedbackReceived => 'No feedback yet';

  @override
  String get noFeedbackReceivedBody =>
      'Feedback from your group\'s testers will show up here.';

  @override
  String get noFeedbackGiven => 'You haven\'t given feedback yet';

  @override
  String get noFeedbackGivenBody =>
      'Use the Feedback button on each app in your group\'s Today tab.';

  @override
  String fromOnApp(String name, String app) {
    return '$name on $app';
  }

  @override
  String get wasHelpful => 'Was this helpful?';

  @override
  String get markedHelpful => 'You marked this helpful (+2 trust for them)';

  @override
  String get markedNotHelpful => 'Marked not helpful';

  @override
  String get groupHistory => 'Groups';

  @override
  String get noGroupsYet => 'No groups yet.';

  @override
  String get trustHistory => 'Trust score history';

  @override
  String get noTrustHistory => 'No changes yet.';

  @override
  String get trustScore => 'Trust score';

  @override
  String pointsToNext(int points) {
    return '$points points to the next level';
  }

  @override
  String get statCompleted => 'Groups completed';

  @override
  String get statCompletionRate => 'Completion rate';

  @override
  String get statDailyActivity => 'Daily activity';

  @override
  String get statActiveDays => 'Active days';

  @override
  String get statFeedback => 'Feedback given';

  @override
  String get statHelpful => 'Helpful feedback';

  @override
  String get badges => 'Badges';

  @override
  String get noBadges => 'Complete your first group to earn a badge.';

  @override
  String get systemLanguage => 'System default';

  @override
  String get general => 'General';

  @override
  String get about => 'About';

  @override
  String get contactSupport => 'Contact support';

  @override
  String get rateApp => 'Rate TestPact';

  @override
  String get account => 'Account';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountTitle => 'Delete your account?';

  @override
  String get deleteAccountBody =>
      'Your profile, apps and trust score are deleted permanently. If you\'re in a group you\'ll be removed from it.';

  @override
  String get appealTitle => 'Appeal a decision';

  @override
  String get appealExplain =>
      'Explain what happened. An admin reviews every appeal. Accepted appeals remove a strike and restore some trust points.';

  @override
  String get appealHint =>
      'What happened? Include dates and anything that helps us check.';

  @override
  String get appealSent => 'Appeal sent';

  @override
  String get sendAppeal => 'Send appeal';

  @override
  String get yourAppeals => 'Your appeals';

  @override
  String get appealOpen => 'Waiting for review';

  @override
  String get appealAccepted => 'Accepted';

  @override
  String get appealRejected => 'Rejected';

  @override
  String get adminReviews => 'Reviews';

  @override
  String get adminAppeals => 'Appeals';

  @override
  String get adminUsers => 'Users';

  @override
  String get noteOptional => 'Note to the user (optional)';

  @override
  String get nothingToReview => 'Nothing to review 🎉';

  @override
  String dataSummary(int active, int missed) {
    return 'Usage data: $active active days, $missed missed days';
  }

  @override
  String get rejectReports => 'Reject reports';

  @override
  String get confirmKick => 'Confirm & remove';

  @override
  String get searchByEmail => 'Search user by email';

  @override
  String get userNotFound => 'No user with that email.';

  @override
  String userSummary(int trust, int strikes, String banned) {
    return 'Trust $trust · strikes $strikes · banned: $banned';
  }

  @override
  String get ban => 'Ban';

  @override
  String get unban => 'Unban';

  @override
  String get adjustTrust => 'Adjust trust score';
}
