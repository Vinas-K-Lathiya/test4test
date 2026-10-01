# TestPact: setup, build and publish

You do these steps once, on your own computer. Total time is about 1 hour, plus Google's review time.

## 0. Install the tools

| Tool | Version | Check |
|---|---|---|
| Flutter | 3.47+ stable | `flutter --version` |
| Android Studio (SDK + platform tools) | latest | `flutter doctor` |
| Java | 17+ (bundled with Android Studio) | `java -version` |
| Node.js | 22 | `node -v` |

```bash
git clone https://github.com/vinas-k-lathiya/test4test.git
cd test4test
git checkout claude/festive-archimedes-6a9zjw
flutter pub get
```

## 1. Firebase project + Blaze plan

Run this from the repo root:

```bash
bash scripts/setup_firebase.sh testpact-vlathiya     # pick any unique lowercase id
```

The script will:
1. Install the `firebase` and `flutterfire` CLIs if they're missing, then run `firebase login` (a browser opens).
2. Create the project.
3. **Pause** and ask you to do 4 clicks in the Firebase console:
   - **Upgrade to Blaze.** Cloud Functions and the scheduled jobs need it. At small scale the cost is usually ₹0. Set a budget alert at ₹500 under *Billing → Budgets*.
   - **Authentication** → Sign-in method → **Google** → Enable. Set the support email to `vlathiya5944@gmail.com`.
   - **Firestore** → Create database → location **asia-south1 (Mumbai)** → production mode.
   - **Storage** → Get started → location **asia-south1**.
4. Run `flutterfire configure`. This replaces `lib/firebase_options.dart`, creates `android/app/google-services.json` and adds the Google Services Gradle plugin.
5. Deploy the security rules, indexes, Cloud Functions and the website (privacy, terms and account deletion pages).

> The first functions deploy may ask to enable APIs such as Cloud Build, Cloud Scheduler and Eventarc. Answer **yes**.
> If the deploy says indexes are still building, wait a few minutes. Indexes take a while the first time.

After this step, these URLs work:
- `https://<project-id>.web.app/privacy`: privacy policy URL for Play Console
- `https://<project-id>.web.app/delete-account`: account deletion URL for Play Console
- `https://<project-id>.web.app/terms`

Commit the generated `lib/firebase_options.dart`, `android/app/google-services.json`, `.firebaserc` and the Gradle changes. These files are **not** secret; access is protected by the security rules.

## 2. Signing key (upload keystore)

```bash
bash scripts/create_keystore.sh
```

This creates `android/upload-keystore.jks` and `android/key.properties`. Both are git-ignored and must **never** be committed.
**Back up both files and the password** in two places, for example a password manager and Google Drive.

The script prints **SHA1** and **SHA256** fingerprints. You need them in the next step.

## 3. Add fingerprints to Firebase (required for Google Sign-In)

Firebase console → ⚙️ Project settings → *Your apps* → Android app `com.vlathiya.testpact` → **Add fingerprint**. Add all of these:

1. Upload key SHA-1 and SHA-256 (from step 2).
2. Debug key SHA-1, for `flutter run` on your phone: `cd android && ./gradlew signingReport`, then take the SHA1 under `Variant: debug`.
3. **Play App Signing key** SHA-1 and SHA-256. You get these *after* the first upload to Play Console (step 6): Play Console → your app → *Test and release → App integrity → App signing*. **If you skip this, Google Sign-In fails for everyone who installs from Play.**

After adding fingerprints, run `flutterfire configure` again (same answers) so `google-services.json` includes the OAuth client.

## 4. Run on your phone

```bash
flutter run
```

Check that you can sign in with Google, add an app, and open Settings → Usage access.

## 5. Build the release bundle

Raise `version:` in `pubspec.yaml` for every upload: `1.0.0+1` → `1.0.1+2`. The number after `+` must always go up.

```bash
flutter build appbundle --release
# output: build/app/outputs/bundle/release/app-release.aab
```

## 6. Play Console

See [PLAY_STORE.md](PLAY_STORE.md) for the listing text, data safety answers and the closed-test checklist.

## 7. After launch: switch on Play Integrity (recommended)

This blocks emulators, rooted phones and modified copies of the app.
1. Google Cloud console (same project) → APIs → enable **Google Play Integrity API**.
2. Play Console → *App integrity* → *Play Integrity API* → **Link a Cloud project** → pick the Firebase project.
3. Firestore → create the document `config/app` with field `integrityRequired` (boolean) = `true`.

Only new sign-ups are checked. Leave it `false` while you test with `flutter run`, because debug builds fail the check.

## Admin

The account `vlathiya5944@gmail.com` sees the 🛡️ icon in the app bar. From there you can:
- **Reviews**: members suspended after reports. You see the reasons, the reporters' notes and the member's daily usage dots. *Confirm & remove* adds a strike and takes trust points. *Reject reports* reinstates the member and takes trust points from the false reporters.
- **Appeals**: accepting an appeal removes one strike and adds 15 trust points.
- **Users**: find a user by email, ban or unban, adjust their trust score.

To add another admin, add the email in `functions/src/config.ts`, `firestore.rules` and `lib/src/config.dart`, then redeploy.

## Tuning

All rules are in `functions/src/config.ts`: group size, minimum members to start, test length, setup hours, daily pass ratio, kick threshold, report thresholds and trust points. Change a value, then run `firebase deploy --only functions`.

## Costs (rough)

At 1,000 active users: Firestore around 1–2M reads/day, inside or near the free tier. The functions mostly run on schedules. Expect roughly ₹0–₹800/month. Set a budget alert.
