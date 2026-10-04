# Publishing TestPact on Google Play

## Your own 12-tester closed test
Your developer account is personal, so TestPact itself needs **12+ testers opted in for 14 continuous days** before you can apply for production. Plan for 16 days.
1. Play Console → Create app → name **TestPact**, App, Free.
2. *Test and release → Testing → Closed testing* → Create track → upload `app-release.aab` → roll out.
3. Testers → **Email list**. Add your testers. Copy the **"Join on the web"** link and share it on Reddit (r/AndroidClosedTesting, r/TestersCommunity, r/androiddev weekly threads).
4. After the first upload, copy the **App signing key** SHA-1/SHA-256 into Firebase (SETUP.md step 3).
5. Ask testers to *use* the app every few days (sign in, add an app, browse), not just install it. Google checks engagement.
6. After 14 days: *Dashboard → Apply for production*. Answer honestly: how you recruited testers, what feedback you got, and what you changed.

## Store listing

**App name:** TestPact: Closed Testing Groups

**Short description (80 max):**
Team up with developers to get 12+ real testers for Google Play closed testing

**Full description:**
```
TestPact helps indie Android developers pass Google Play's closed testing requirement, with real testers, real usage and real feedback.

New personal developer accounts must run a closed test with at least 12 testers for 14 days before publishing. TestPact matches you with other developers in the same situation, and you all test each other's apps.

HOW IT WORKS
• Add your app and its closed testing link
• Join the queue: groups of up to 20 developers form automatically
• Setup (48h): paste everyone's email into Play Console and install everyone's app
• Test daily for 16 days: open each app, explore it, leave honest feedback
• Finish, earn trust points and badges, and apply for production

FAIR BY DESIGN
• Give first: your app is shown only after you've added everyone's emails
• On-device verification of installs and daily usage (only for your assigned apps)
• Trust score, levels and badges that reward reliable testers
• Automatic warnings and removal of inactive members
• Reports are checked against real usage data, so groups can't gang up on anyone
• Appeals reviewed by a human

FEEDBACK THAT MATTERS
Rate apps, report bugs with screenshots, suggest ideas, and mark the most helpful feedback you receive.

Available in English, हिन्दी, ગુજરાતી, मराठी, Español and Português.

TestPact is an independent community tool and is not affiliated with Google.
```

**Category:** Tools · **Tags:** Developer tools, Productivity
**Contact email:** vlathiya5944@gmail.com
**Privacy policy:** `https://<project-id>.web.app/privacy`

**Graphics** (in `assets/branding/`):
- App icon 512×512: `play_icon_512.png`
- Feature graphic 1024×500: `feature_graphic.png`
- Phone screenshots (2–8): take them on your phone from Sign-in, Home, Group → Today, Group → Members, Profile, Feedback.

## App content answers

**Privacy policy:** URL above.
**Ads:** **Yes**. The app shows Google AdMob ads (from day 3 for each user).
**App access:** "All or some functionality is restricted" → give reviewers instructions: *"Sign in with any Google account. To see a group, join the queue from Home → Join a group after adding any app (use package com.example.demo and link https://play.google.com/apps/testing/com.example.demo)."*
**Content rating:** questionnaire → Utility/Productivity, no violence or sexual content. User-generated content is limited to feedback text and screenshots between group members. Users can report content, and there's an admin review queue.
**Target audience:** 18+.
**News app:** No. **Government app:** No. **Financial features:** None. **Health:** None.

**Data safety:**

| Data type | Collected | Shared | Purpose | Optional? |
|---|---|---|---|---|
| Name | Yes | No* | Account management, App functionality | Required |
| Email address | Yes | No* | Account management, App functionality | Required |
| User IDs | Yes | No | Account management, Fraud prevention | Required |
| Photos (screenshots you attach) | Yes | No* | App functionality | Optional |
| Other user-generated content (feedback, reports) | Yes | No* | App functionality | Optional |
| App interactions (usage time of assigned apps only) | Yes | No | App functionality, Fraud prevention | Optional (Usage access) |
| Installed apps (only whether assigned apps are installed) | Yes | No | App functionality | Required |
| Device or other IDs (hashed Android ID) | Yes | No | Fraud prevention | Required |
| Device or other IDs (Advertising ID) | Yes | **Yes** (Google AdMob) | Advertising or marketing, Analytics | Required |
| App interactions / diagnostics collected by the AdMob SDK | Yes | **Yes** (Google AdMob) | Advertising or marketing, Analytics | Required |
| Approximate location (from IP, by AdMob) | Yes | **Yes** (Google AdMob) | Advertising or marketing | Required |

\*Shown to other members of the same group as part of the app's core function. Under Google's definitions this is not "sharing" (a user-initiated transfer to other users).
- Data is encrypted in transit: **Yes**
- Users can request deletion: **Yes**. In-app (Settings → Delete account) and `https://<project-id>.web.app/delete-account`

**Permissions declaration:** `PACKAGE_USAGE_STATS` is a special-access permission the user grants in system settings. No Play declaration form is required, but the onboarding screen shows a prominent disclosure. Keep the policy text and data safety answers consistent with it. The app does **not** use `QUERY_ALL_PACKAGES`. It declares launcher-intent `<queries>` only.

**Advertising ID declaration:** Play Console → App content → Advertising ID → **Yes**, used for **Advertising or marketing** and **Analytics**. The `AD_ID` permission is added automatically by the AdMob SDK.

## AdMob checklist
1. AdMob → Apps → TestPact → **App settings → app-ads.txt**: it's hosted at `https://testpact-vlathiya.web.app/app-ads.txt`. In Play Console, set the **Website** field of the store listing to `https://testpact-vlathiya.web.app` so AdMob can find it.
2. AdMob → **Privacy & messaging → GDPR**: create and publish a consent message for the app. The app shows it automatically via Google's UMP SDK.
3. Link the app to its Play Store listing in AdMob once it's published.
4. **Never tap your own ads.** Debug builds (`flutter run`) use Google's test ads automatically; release builds use your real IDs.
5. Remote control in Firestore `config/app`: `adsEnabled` (bool, false turns all ads off) and `adsAfterDays` (number, default 2).

## Policy note
Google's goal with closed testing is genuine testing. TestPact is built as a feedback community: daily usage, structured feedback, screenshots and a helpfulness rating. Keep that framing in the listing and in your production application. Never market it as "get installs" or "fake testers".
