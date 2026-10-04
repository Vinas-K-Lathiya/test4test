#!/usr/bin/env bash
# One-time Firebase setup. Run from the repo root on your computer:
#   bash scripts/setup_firebase.sh <project-id>
# <project-id> must be globally unique, lowercase, e.g. testpact-vlathiya
set -euo pipefail
PROJECT="${1:?Usage: bash scripts/setup_firebase.sh <project-id>}"

command -v firebase >/dev/null || npm install -g firebase-tools
command -v flutterfire >/dev/null || dart pub global activate flutterfire_cli
export PATH="$PATH:$HOME/.pub-cache/bin"

firebase login
if ! firebase projects:list | grep -q "$PROJECT"; then
  firebase projects:create "$PROJECT" --display-name "TestPact"
fi
firebase use "$PROJECT"
sed -i.bak "s/\"default\": \".*\"/\"default\": \"$PROJECT\"/" .firebaserc 2>/dev/null || true

echo
echo "==> Now open https://console.firebase.google.com/project/$PROJECT and:"
echo "    1. Upgrade to Blaze (Usage & billing -> Modify plan)."
echo "    2. Build -> Authentication -> Get started -> Sign-in method -> Google -> Enable."
echo "    3. Build -> Firestore Database -> Create database -> Location: asia-south1 (Mumbai) -> production mode."
echo "    4. Build -> Storage -> Get started -> Location: asia-south1."
read -r -p "Press Enter when all 4 are done... "

flutterfire configure \
  --project="$PROJECT" \
  --platforms=android \
  --android-package-name=com.fffmv.free_fire_game1 \
  --yes

(cd functions && npm ci)
firebase deploy --only firestore,storage,functions,hosting

echo
echo "Done. Privacy policy: https://$PROJECT.web.app/privacy"
echo "Next: add your SHA-1/SHA-256 fingerprints in Firebase (docs/SETUP.md step 4), then run flutterfire configure again."
