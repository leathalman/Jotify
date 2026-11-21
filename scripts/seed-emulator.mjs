#!/usr/bin/env node
// Seeds the local Firebase Emulator Suite with a test account and notes.
//
//   npx firebase-tools emulators:start      # in one terminal
//   node scripts/seed-emulator.mjs          # in another
//
// Wipes all emulator Auth users and Firestore data first, so it is safe to
// re-run. Talks only to the emulators on 127.0.0.1 — never production.
// Debug simulator builds point at these emulators (see AppDelegate.swift).

const PROJECT = "jotify-175f8";
const AUTH = "http://127.0.0.1:9099";
const FIRESTORE = "http://127.0.0.1:8080";
const DOCS = `${FIRESTORE}/v1/projects/${PROJECT}/databases/(default)/documents`;

// Test-only credentials; these exist only in the local Auth emulator.
const TEST_EMAIL = "test@jotify.test";
const TEST_PASSWORD = "jotify-test-123";

const NOTE_COUNT = Number(process.env.NOTE_COUNT ?? 40);

// `Bearer owner` bypasses Firestore security rules in the emulator.
const owner = { Authorization: "Bearer owner", "Content-Type": "application/json" };

async function req(method, url, body, headers = owner) {
  const res = await fetch(url, { method, headers, body: body && JSON.stringify(body) });
  if (!res.ok) throw new Error(`${method} ${url} → ${res.status} ${await res.text()}`);
  return res.status === 204 ? null : res.json().catch(() => null);
}

const COLORS = [
  "sunset1", "sunset2", "sunset3",
  "minoas1", "minoas2", "minoas3", "minoas4",
  "sunrise1", "sunrise2", "sunrise3", "sunrise4",
  "eros1", "eros2", "eros3",
  "olympia1", "olympia2", "olympia3", "olympia4",
];

const SAMPLES = [
  "Grocery list: eggs, oat milk, spinach, coffee beans",
  "Call the dentist to reschedule Thursday's appointment",
  "Book idea: a lighthouse keeper who collects lost letters",
  "Gift ideas for Mom — scarf, pottery class, photo book",
  "Meeting notes: ship the search redesign before the holidays",
  "Remember to water the fern on the balcony",
  "Recipe: lemon garlic pasta with roasted broccoli",
  "Flight confirmation code is in the travel folder",
  "Workout plan: run Mon/Wed/Fri, climb on Saturday",
  "Podcast to try: something about the history of maps",
  "Fix the squeaky hinge on the hallway closet",
  "Quote: the best time to plant a tree was twenty years ago",
  "Pick up dry cleaning before Friday",
  "Movie night shortlist: three comedies and a documentary",
  "Renew passport — expires in March",
  "Brainstorm: weekend hike near the lake trail",
  "Learn the chords for that song from the coffee shop",
  "Budget check: subscriptions are creeping up again",
  "A really long note to check that cells truncate nicely. " +
    "It keeps going for a while with more words than will fit on one card, " +
    "so the preview should cut off cleanly with an ellipsis at the end.",
  "Short",
];

// Swift's `Date.timeIntervalSinceReferenceDate` counts from 2001-01-01.
const REFERENCE_DATE_MS = Date.UTC(2001, 0, 1);
const toReferenceSeconds = (ms) => (ms - REFERENCE_DATE_MS) / 1000;

async function main() {
  try {
    await fetch(`${AUTH}/`);
    await fetch(`${FIRESTORE}/`);
  } catch {
    console.error("Emulators aren't running. Start them with: npx firebase-tools emulators:start");
    process.exit(1);
  }

  await req("DELETE", `${AUTH}/emulator/v1/projects/${PROJECT}/accounts`);
  await req("DELETE", `${FIRESTORE}/emulator/v1/projects/${PROJECT}/databases/(default)/documents`);

  const { localId: uid } = await req(
    "POST",
    `${AUTH}/identitytoolkit.googleapis.com/v1/accounts:signUp?key=emulator`,
    { email: TEST_EMAIL, password: TEST_PASSWORD, returnSecureToken: true },
    { "Content-Type": "application/json" },
  );

  // Mirrors DataManager.createUserSettings, with hasMigrated = true so the
  // app doesn't try to migrate legacy Core Data notes on first sign-in.
  await req("PATCH", `${DOCS}/users/${uid}`, {
    fields: {
      multilineInputEnabled: { booleanValue: false },
      deleteOldNotes: { booleanValue: false },
      useHaptics: { booleanValue: true },
      useBiometrics: { booleanValue: false },
      placeholder: { stringValue: "Tap to start typing or swipe left to right for saved notes..." },
      hasMigrated: { booleanValue: true },
      defaultView: { integerValue: "0" },
      referrals: { integerValue: "0" },
      referralLink: { stringValue: "" },
      hasPremium: { booleanValue: true },
    },
  });

  const now = Date.now();
  for (let i = 0; i < NOTE_COUNT; i++) {
    const content = SAMPLES[i % SAMPLES.length] + (i >= SAMPLES.length ? ` (#${i + 1})` : "");
    // Spread notes over the last ~4 months so date search has variety.
    const ts = toReferenceSeconds(now - i * 3 * 24 * 3600 * 1000 - i * 3600 * 1000);
    await req("POST", `${DOCS}/notes/${uid}/userNotes`, {
      fields: {
        content: { stringValue: content },
        timestamp: { doubleValue: ts },
        color: { stringValue: COLORS[i % COLORS.length] },
      },
    });
  }

  console.log(`Seeded ${NOTE_COUNT} notes for ${TEST_EMAIL} (uid ${uid}).`);
  console.log("Emulator UI: http://127.0.0.1:4000");
}

main().catch((e) => {
  console.error(e.message);
  process.exit(1);
});
