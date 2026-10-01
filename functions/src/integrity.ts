import { GoogleAuth } from "google-auth-library";
import { logger } from "firebase-functions/v2";

export const PACKAGE_NAME = "com.vlathiya.testpact";

const auth = new GoogleAuth({ scopes: ["https://www.googleapis.com/auth/playintegrity"] });

export interface IntegrityResult {
  ok: boolean;
  reason: string;
}

/**
 * Decodes a classic Play Integrity token and checks that it came from our genuine Play-installed
 * app on a real, uncompromised device, for the nonce we issued.
 * Requires: Play Integrity API enabled on the Firebase/GCP project and the project linked in
 * Play Console -> App integrity.
 */
export async function verifyIntegrityToken(token: string, expectedNonce: string): Promise<IntegrityResult> {
  try {
    const client = await auth.getClient();
    const res = await client.request<{ tokenPayloadExternal?: Record<string, any> }>({
      url: `https://playintegrity.googleapis.com/v1/${PACKAGE_NAME}:decodeIntegrityToken`,
      method: "POST",
      data: { integrity_token: token },
    });
    const p = res.data.tokenPayloadExternal ?? {};
    if (p.requestDetails?.nonce !== expectedNonce) return { ok: false, reason: "nonce" };
    if (p.appIntegrity?.appRecognitionVerdict !== "PLAY_RECOGNIZED") return { ok: false, reason: "app" };
    const device: string[] = p.deviceIntegrity?.deviceRecognitionVerdict ?? [];
    if (!device.includes("MEETS_DEVICE_INTEGRITY")) return { ok: false, reason: "device" };
    return { ok: true, reason: "ok" };
  } catch (e) {
    logger.error("integrity decode failed", e);
    return { ok: false, reason: "error" };
  }
}
