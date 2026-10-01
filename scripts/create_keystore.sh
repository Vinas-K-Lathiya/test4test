#!/usr/bin/env bash
# Creates your Play upload key. Run ONCE on your own computer, from the repo root:
#   bash scripts/create_keystore.sh
# Back up android/upload-keystore.jks and the password somewhere safe (password manager + cloud drive).
# If you lose it, you must ask Google Play support to reset the upload key.
set -euo pipefail
cd "$(dirname "$0")/../android"

if [ -f upload-keystore.jks ]; then
  echo "android/upload-keystore.jks already exists - not overwriting."; exit 1
fi

read -r -s -p "Choose a keystore password (min 6 chars): " PASS; echo
read -r -s -p "Repeat password: " PASS2; echo
[ "$PASS" = "$PASS2" ] || { echo "Passwords don't match"; exit 1; }

keytool -genkeypair -v \
  -keystore upload-keystore.jks \
  -storetype JKS \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload \
  -storepass "$PASS" -keypass "$PASS" \
  -dname "CN=TestPact, OU=Mobile, O=TestPact, L=Unknown, ST=Unknown, C=IN"

cat > key.properties <<PROPS
storeFile=upload-keystore.jks
storePassword=$PASS
keyAlias=upload
keyPassword=$PASS
PROPS

echo
echo "Created android/upload-keystore.jks and android/key.properties (both git-ignored)."
echo "Fingerprints to add in Firebase (Project settings -> Your Android app -> Add fingerprint):"
keytool -list -v -keystore upload-keystore.jks -alias upload -storepass "$PASS" | grep -E "SHA1:|SHA256:"
