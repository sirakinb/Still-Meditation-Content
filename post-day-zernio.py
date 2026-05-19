#!/usr/bin/env python3
"""
post-day-zernio.py — Post a Still Meditation carousel via Zernio.

Replaces PostBridge for the TikTok inbox draft + Instagram live publish flow.

Usage:
    python3 post-day-zernio.py <day_number> [--platforms tiktok,instagram]
                                            [--ig-account-id <id>]
                                            [--tt-account-id <id>]

If account IDs aren't passed, the script auto-detects from GET /v1/accounts
by matching @stillmeditation (TikTok) and @stillmeditation.app (Instagram).
"""

import argparse
import json
import os
import re
import sys
import time
from pathlib import Path

import requests

REPO_ROOT = Path(__file__).resolve().parent
ENV_FILE = REPO_ROOT / ".env"
BASE_URL = "https://zernio.com/api/v1"


def load_env() -> dict:
    """Parse the project .env without depending on dotenv."""
    env = {}
    if ENV_FILE.exists():
        for raw in ENV_FILE.read_text().splitlines():
            line = raw.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            k, v = line.split("=", 1)
            env[k.strip()] = v.strip().strip('"').strip("'")
    return env


def die(msg: str, *extra) -> None:
    print(f"✗ {msg}", file=sys.stderr)
    for e in extra:
        print(f"  {e}", file=sys.stderr)
    sys.exit(1)


def auth_headers(api_key: str) -> dict:
    return {"Authorization": f"Bearer {api_key}", "Content-Type": "application/json"}


def list_accounts(api_key: str) -> list[dict]:
    r = requests.get(f"{BASE_URL}/accounts", headers=auth_headers(api_key), timeout=30)
    if not r.ok:
        die(f"GET /accounts failed: {r.status_code}", r.text[:400])
    return r.json().get("accounts", [])


def find_account(accounts: list[dict], platform: str, username_match: str) -> str:
    """Return the _id of an active account whose username matches."""
    candidates = [a for a in accounts if a.get("platform") == platform and a.get("isActive")]
    # Prefer exact username match, then case-insensitive substring
    for a in candidates:
        if (a.get("username") or "").lower() == username_match.lower():
            return a["_id"]
    for a in candidates:
        if username_match.lower() in (a.get("username") or "").lower():
            return a["_id"]
    available = [(a.get("platform"), a.get("username"), a.get("_id")) for a in candidates]
    die(
        f"No active {platform} account matching '{username_match}' on Zernio.",
        f"Available {platform} accounts: {available}",
    )


def upload_slide(api_key: str, slide_path: Path) -> str:
    """3-step Zernio upload. Returns the public CDN URL."""
    # NOTE: Zernio's published docs at /guides/media-uploads use camelCase
    # `fileName`/`fileType`, but the actual API requires lowercase `filename`
    # and camelCase `contentType`. Verified by 400 response on doc names.
    file_name = slide_path.name
    content_type = "image/png"
    # Step 1: presign
    presign = requests.post(
        f"{BASE_URL}/media/presign",
        headers=auth_headers(api_key),
        json={"filename": file_name, "contentType": content_type},
        timeout=30,
    )
    if not presign.ok:
        die(f"presign failed for {file_name}: {presign.status_code}", presign.text[:400])
    body = presign.json()
    upload_url = body.get("uploadUrl") or body.get("uploadURL") or body.get("url")
    public_url = body.get("publicUrl") or body.get("publicURL") or body.get("mediaUrl")
    if not upload_url or not public_url:
        die(f"presign response missing upload/public URL for {file_name}", json.dumps(body)[:400])
    # Step 2: PUT raw bytes (no auth header — signed URL)
    with slide_path.open("rb") as fh:
        put = requests.put(upload_url, data=fh, headers={"Content-Type": content_type}, timeout=120)
    if not put.ok:
        die(f"PUT upload failed for {file_name}: {put.status_code}", put.text[:400])
    return public_url


def load_caption(day: int) -> tuple[str, str]:
    """Return (tiktok_caption, instagram_caption) parsed from the day caption md."""
    p = REPO_ROOT / "captions" / f"day{day}_caption.md"
    if not p.exists():
        die(f"caption file missing: {p}")
    text = p.read_text()

    def grab(handle_label: str) -> str:
        # Section header looks like:  ## TikTok (@stillmeditation)
        pat = re.compile(rf"^## {re.escape(handle_label)}.*?\n(.*?)(?:^---\s*$|\Z)", re.M | re.S)
        m = pat.search(text)
        if not m:
            die(f"could not find '## {handle_label}' section in {p.name}")
        body = m.group(1).strip()
        # Trim any trailing whitespace-only lines
        return body.strip()

    return grab("TikTok"), grab("Instagram")


def short_title_from_caption(caption: str, max_len: int = 90) -> str:
    """First non-empty line, hashtags stripped, capped at max_len."""
    for line in caption.splitlines():
        line = line.strip()
        if line:
            line = re.sub(r"#\w+", "", line).strip()
            line = re.sub(r"\s+", " ", line)
            return line[:max_len].rstrip(",. ")
    return f"Still Meditation"


def post_tiktok_draft(api_key: str, account_id: str, caption: str, media_urls: list[str]) -> dict:
    """Send carousel to TikTok Creator Inbox as a draft (user reviews & publishes manually)."""
    payload = {
        "content": short_title_from_caption(caption),  # max 90 chars, becomes carousel title
        "mediaItems": [{"type": "image", "url": u} for u in media_urls],
        "platforms": [{"platform": "tiktok", "accountId": account_id}],
        "tiktokSettings": {
            "privacy_level": "PUBLIC_TO_EVERYONE",
            "allow_comment": True,
            "media_type": "photo",
            "photo_cover_index": 0,
            "description": caption,  # full caption, up to 4000 chars
            "content_preview_confirmed": True,  # legal required
            "express_consent_given": True,       # legal required
            "draft": True,                       # ← TikTok Creator Inbox
        },
        "publishNow": True,
    }
    r = requests.post(f"{BASE_URL}/posts", headers=auth_headers(api_key), json=payload, timeout=120)
    if not r.ok:
        die(f"TikTok POST /posts failed: {r.status_code}", r.text[:600])
    return r.json()


def post_instagram(api_key: str, account_id: str, caption: str, media_urls: list[str]) -> dict:
    """Publish carousel live to Instagram feed."""
    payload = {
        "content": caption,
        "mediaItems": [{"type": "image", "url": u} for u in media_urls],
        "platforms": [{"platform": "instagram", "accountId": account_id}],
        "publishNow": True,
    }
    r = requests.post(f"{BASE_URL}/posts", headers=auth_headers(api_key), json=payload, timeout=120)
    if not r.ok:
        die(f"Instagram POST /posts failed: {r.status_code}", r.text[:600])
    return r.json()


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("day", type=int, help="Day number (e.g. 47)")
    p.add_argument("--platforms", default="tiktok,instagram",
                   help="Comma-separated: tiktok,instagram (default both)")
    p.add_argument("--ig-account-id", default=None, help="Override Instagram account id")
    p.add_argument("--tt-account-id", default=None, help="Override TikTok account id")
    p.add_argument("--ig-username", default="stillmeditation.app",
                   help="Instagram username to match (default: stillmeditation.app)")
    p.add_argument("--tt-username", default="stillmeditation",
                   help="TikTok username to match (default: stillmeditation)")
    args = p.parse_args()

    env = load_env()
    api_key = env.get("ZERNIO_API_KEY") or os.environ.get("ZERNIO_API_KEY")
    if not api_key:
        die("ZERNIO_API_KEY missing from .env")

    platforms = [x.strip().lower() for x in args.platforms.split(",") if x.strip()]
    unknown = set(platforms) - {"tiktok", "instagram"}
    if unknown:
        die(f"unknown platform(s): {unknown}. Only tiktok and instagram are supported here.")

    # Resolve account ids
    accounts = list_accounts(api_key)
    tt_id = args.tt_account_id
    ig_id = args.ig_account_id
    if "tiktok" in platforms and not tt_id:
        tt_id = find_account(accounts, "tiktok", args.tt_username)
    if "instagram" in platforms and not ig_id:
        ig_id = find_account(accounts, "instagram", args.ig_username)
    print(f"Account IDs → TikTok={tt_id}  Instagram={ig_id}")

    # Slides
    slide_dir = REPO_ROOT / "slides" / f"day{args.day}"
    if not slide_dir.is_dir():
        die(f"slides directory missing: {slide_dir}")

    tt_slides = sorted([slide_dir / f"slide{i}.png" for i in range(1, 8)])
    ig_slides = [slide_dir / f"slide{i}.png" for i in range(1, 7)] + [slide_dir / "slide7_instagram.png"]
    for s in tt_slides + ig_slides:
        if not s.exists() or s.stat().st_size < 10000:
            die(f"slide missing or too small: {s}")

    tt_caption, ig_caption = load_caption(args.day)

    # Upload (each variant separately; slide7 differs across TT vs IG)
    print("\n--- Uploading TikTok slides ---")
    tt_urls = []
    for s in tt_slides:
        url = upload_slide(api_key, s)
        print(f"  ✓ {s.name} → {url}")
        tt_urls.append(url)

    print("\n--- Uploading Instagram slides ---")
    ig_urls = []
    for s in ig_slides:
        url = upload_slide(api_key, s)
        print(f"  ✓ {s.name} → {url}")
        ig_urls.append(url)

    results = {}

    if "tiktok" in platforms:
        print("\n--- Creating TikTok draft post (Creator Inbox) ---")
        results["tiktok"] = post_tiktok_draft(api_key, tt_id, tt_caption, tt_urls)
        pid = results["tiktok"].get("post", {}).get("_id") or results["tiktok"].get("_id")
        print(f"  ✓ TikTok draft created  id={pid}")

    if "instagram" in platforms:
        print("\n--- Creating Instagram live post ---")
        results["instagram"] = post_instagram(api_key, ig_id, ig_caption, ig_urls)
        pid = results["instagram"].get("post", {}).get("_id") or results["instagram"].get("_id")
        print(f"  ✓ Instagram post created  id={pid}")

    print("\n=== Summary ===")
    for plat, r in results.items():
        pid = r.get("post", {}).get("_id") or r.get("_id") or "?"
        print(f"  {plat:10s} id={pid}")

    print("\n=== Post-flight checklist ===")
    if "tiktok" in platforms:
        print("  TikTok:")
        print("    1. Force-quit the TikTok app (swipe up + away from app switcher)")
        print("    2. Reopen → tap Inbox (bottom right)")
        print("    3. Find the Zernio draft notification → tap → review → Post")
    if "instagram" in platforms:
        print("  Instagram: should appear on @stillmeditation.app feed within ~2 min.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
