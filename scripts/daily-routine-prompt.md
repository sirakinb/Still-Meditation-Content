# Still Meditation — Daily Content Routine

You are running the daily Still Meditation content routine. Your job: generate, QA, and post the NEXT day's TikTok + Instagram carousel for the 90-day plan in this repo.

You have full access to this repo, the `.env` file (Gemini + PostBridge keys), and the Bash, Read, Write, Edit, Glob, and Grep tools. Work in `/Users/sirakinb/Still-Meditation-Content`.

## Step 1 — Sync and determine next day

```bash
cd /Users/sirakinb/Still-Meditation-Content
git pull origin main 2>&1 | tail -5
```

Then find the highest existing day across `slides/` and any active worktree:

```bash
find . -path '*/slides/day*' -type d 2>/dev/null \
  | sed 's|.*/day||' | grep -E '^[0-9]+$' | sort -n | tail -1
```

Next day `N` = that number + 1. If N > 90, stop and report — the 90-day plan is complete.

If `slides/dayN` already exists with all 8 PNGs (slide1–7 + slide7_instagram), check whether it was posted today via PostBridge. If so, exit with "Day N already posted today." If slides exist but weren't posted, skip generation and jump to Step 9.

## Step 2 — Read the day's plan row

Open `90day_plan.md` and find the row for Day N. Extract:
- Pillar (🧘 Tutorial / 🧠 Science / 💡 Myth / 💪 Motivation / 📊 Check-in / ⚡ Quick tip / 🎯 Challenge)
- Title
- Hook (Slide 1 headline)
- Key teaching point
- Technique

## Step 3 — Pick a same-pillar template

List `generate-day*.sh` files and pick the most recent one matching Day N's pillar. Use it as the structural template (same STYLE string, same `generate_slide` function with error guards, same 7-slide + 7_instagram variant layout).

Recent reference templates:
- 🧘 Tutorial: `generate-day41.sh`
- 🧠 Science: `generate-day43.sh`
- 💡 Myth: `generate-day40.sh`
- 🎯 Challenge: `generate-day42.sh`
- ⚡ Quick tip: `generate-day39.sh`

## Step 4 — Write `generate-dayN.sh`

7 slides + slide7_instagram variant.

Required STYLE string (paste verbatim — do NOT alter):

```
Digital illustration in a bold social media card style for TikTok. The character is a muscular purple humanoid mascot (smooth purple skin, athletic muscular build, no web patterns, clean smooth head). Clean vector-like illustration with bold outlines, similar to fitness influencer cartoon mascots. Eyes are NORMAL friendly cartoon eyes with visible dark pupils and whites — never glowing or empty. Background: calm zen meditation room with wooden floors, soft natural light, green plants — UNLESS the scene calls for another setting. DO NOT include any text branding or logo anywhere. DO NOT draw any internal frames, borders, mini-cards, or picture-in-picture elements — the mascot is part of the same single scene as the text. Light warm background with rounded corners on the OUTER card only. Text should be bold, large, left-aligned, and highly readable for mobile viewing. Spell every word correctly. 4:5 portrait orientation. Only ONE instance of the mascot per image.
```

Required error guards in the `generate_slide` function — copy these from `generate-day41.sh`:
1. Check `.error.message` from Gemini response → exit 1 if present
2. Check `.candidates[0].content.parts[].inlineData.data` is non-empty → exit 1 if missing
3. Check output file >10000 bytes → exit 1 if smaller

Slide structure:
- Slide 1: bold hook headline + gap + 2–3 short lines of supporting text. Mascot centered or right.
- Slides 2–6: text occupies the LEFT 60%, mascot on FAR RIGHT in right 40%, nothing in left text zone. Each slide has a short ALL-CAPS section header + short body lines.
- Slide 7 (TikTok): ends with `Follow @stillmeditation for Day {N+1}`
- Slide 7_instagram: ends with `Follow @stillmeditation.app for Day {N+1}`

After writing the script: `chmod +x generate-dayN.sh`.

## Step 5 — Write `captions/dayN_caption.md`

Two sections separated by `---`:

```
# Day N Caption — "{title}" ({PILLAR})

## TikTok (@stillmeditation)

{caption body — same paragraph rhythm and tone as captions/day42_caption.md and day43_caption.md}

Follow @stillmeditation for Day {N+1}.

.
.
.

#tag1 #tag2 ... (18–20 hashtags relevant to the topic)

---

## Instagram (@stillmeditation.app)

{IDENTICAL caption body to TikTok}

Follow @stillmeditation.app for Day {N+1}.

.
.
.

#tag1 #tag2 ... (same hashtags as TikTok)
```

Caption style guide (match recent captions exactly):
- Open with the hook restated as a one-line punch.
- 4–8 short paragraphs of teaching. No fluff. No "in this post" meta-talk.
- Cite specific research where relevant (university name + year + finding).
- Use `→` arrows for numbered steps if the day has a protocol.
- End with one short reflective line, then the Follow CTA.

## Step 6 — Generate slides

```bash
cd /Users/sirakinb/Still-Meditation-Content
export $(grep -v '^#' .env | xargs)
./generate-dayN.sh
```

If any slide fails with `CONSUMER_SUSPENDED` (403) or `RESOURCE_EXHAUSTED` (429), stop and write a clear error to the log — the Gemini key needs human attention.

## Step 7 — Visual QA every slide

Read each of `slides/dayN/slide1.png` through `slide7.png` and `slide7_instagram.png` using the Read tool (renders the image). Check every slide for:

(a) **Spelling errors** in the on-image text. Gemini OCR drops or duplicates letters. Compare each visible word against the prompt text you wrote. Examples of past failures: `sharpend` (missing 'e'), `stillstillmeditation` (duplicated "still").

(b) **Duplicated words or handles** — particularly on the CTA slide.

(c) **Composition artifacts**:
  - Nested mini-cards / picture-in-picture frames inside the main card
  - Multiple instances of the mascot
  - Mascot overlapping the left text zone on slides 2–6
  - Hard split between left/right halves of the card looking like two separate cards

(d) **Slide 7 handles must be exact**:
  - TikTok variant: `@stillmeditation` (no `.app`, no doubled `still`)
  - IG variant: `@stillmeditation.app`
  - "Day {N+1}" must match the correct number

List every slide that fails any check.

## Step 8 — Regenerate broken slides (up to 3 passes)

Write `regen-dayN-fix.sh` that ONLY regenerates the broken slides. Use stronger anti-typo language in the prompts:
- `EXACTLY these lines spelled correctly:`
- `The username MUST be spelled exactly: @stillmeditation (one word, do NOT duplicate the word still)`
- Include the anti-nested-card line in STYLE

Run the regen script. Re-inspect just the regenerated slides. If still broken after 3 passes, post the day with what's working and clearly flag the bad slide(s) in your final report.

## Step 9 — Post via Zernio

```bash
cd /Users/sirakinb/Still-Meditation-Content
export $(grep -v '^#' .env | xargs)
python3 post-day-zernio.py N --platforms tiktok,instagram
```

This posts:
- TikTok → Creator Inbox draft (`tiktokSettings.draft: true` at top level)
- Instagram → live on @stillmeditation.app

Account IDs are auto-resolved by username match (`@stillmeditation`, `@stillmeditation.app`) so reconnections won't break the run.

**Facebook is on hold.** PostBridge previously published a Still Meditation FB Page post; that path is paused until a Facebook account is connected to Zernio. Do NOT call `./post-day.py` as a fallback — it would duplicate the TT+IG post via PostBridge.

## Step 10 — Handle Instagram transient failures

If `post-day-zernio.py` reports a 5xx or upstream Meta error on the IG call, retry once:

```bash
python3 post-day-zernio.py N --platforms instagram
```

If it still fails, stop and clearly flag in the report. Do NOT fall back to PostBridge — duplicate IG posts are worse than a delayed one.

## Step 11 — Commit + push

```bash
cd /Users/sirakinb/Still-Meditation-Content
git add generate-dayN.sh captions/dayN_caption.md slides/dayN/ regen-dayN-fix.sh 2>/dev/null
git commit -m "Day N: {title}

🤖 Daily routine commit
"
git push origin main 2>&1 | tail -3
```

If the push fails (e.g. remote has new commits), pull --rebase and retry once. If still fails, leave the commit local and flag it.

## Step 12 — Final report

Print a clean summary at the end:

```
=== Day N — {PILLAR} {Title} ===
Slides:    {count} regen pass(es) needed
TikTok:    posted to drafts inbox (post id {id})
Instagram: published live to @stillmeditation.app (post id {id})

⚠ MANUAL STEP REQUIRED:
   Force-quit the TikTok app (swipe up + away from app switcher),
   reopen → tap Inbox (chat bubble bottom-right),
   find the Zernio draft notification,
   tap → review → Post.
   (TikTok's push pipeline silently drops the notification until you force-restart.)

Warnings: {any flags, e.g. slide-N still has typo "X" after 3 regens}
```

## Critical context (do not skip)

- Posting is via **Zernio** (`post-day-zernio.py`), not PostBridge. PostBridge stays installed as a manual emergency fallback only; do not auto-invoke it.
- TikTok MUST go to drafts. `post-day-zernio.py` sets `tiktokSettings.draft: true` at the top level of the request body (TikTok is a special case in Zernio — its settings are NOT inside `platformSpecificData`). It also sets the legally-required `content_preview_confirmed: true` and `express_consent_given: true`. Do not override.
- Instagram publishes live. No draft flag.
- Zernio account IDs are stable per-connection, but the script still auto-resolves them by username match (`@stillmeditation`, `@stillmeditation.app`) every run — so a reconnect that changes the id won't break it.
- Gemini key in `.env` as `GEMINI_API_KEY`. Zernio key as `ZERNIO_API_KEY` (starts with `sk_`). Both required. `POST_BRIDGE_API_KEY` is kept for emergency-only manual use.
- Never commit `.env`. It's in `.gitignore`.
- Never run probe/test posts to real accounts — Instagram publishes instantly and can't be deleted via API. Use a TikTok-only draft run if you need to validate plumbing.

Begin now. Work efficiently — each day takes ~10–15 minutes including regens.
