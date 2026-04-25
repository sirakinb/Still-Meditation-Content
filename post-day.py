#!/usr/bin/env python3
"""Post Day N to PostBridge with hard-earned safety rails.

Usage:
  ./post-day.py <day-number> [--platforms tiktok,instagram,facebook]

Defaults to tiktok + instagram (matches daily workflow).
TikTok goes to drafts (platform_configurations.tiktok.draft=true).
Instagram + Facebook publish live.

What this does right (lessons from Day 20/21):
  - Fetches live account IDs from PostBridge (never hardcoded).
  - Uses Python for JSON (jq choked on long captions with control chars).
  - On `status: failed`, auto-fetches /v1/post-results so the real error surfaces
    instead of the misleading "media no longer exists" decoy.
  - Uploads FRESH media per platform (PostBridge cleans up media after one attempt).
"""
from __future__ import annotations
import argparse, json, os, pathlib, re, sys, time, urllib.request, urllib.error

PB = "https://api.post-bridge.com/v1"


def env(name: str) -> str:
    # Minimal .env loader (picks up POST_BRIDGE_API_KEY etc.)
    if name not in os.environ and pathlib.Path(".env").exists():
        for line in pathlib.Path(".env").read_text().splitlines():
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            k, v = line.split("=", 1)
            os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))
    if name not in os.environ:
        sys.exit(f"ERROR: ${name} not set (check .env)")
    return os.environ[name]


def req(method: str, path: str, *, data=None, headers=None, raw_url=None):
    key = env("POST_BRIDGE_API_KEY")
    url = raw_url or f"{PB}{path}"
    h = {"Authorization": f"Bearer {key}"}
    if headers:
        h.update(headers)
    body = None
    if data is not None and "Content-Type" not in h:
        h["Content-Type"] = "application/json"
        body = json.dumps(data).encode()
    elif isinstance(data, (bytes, bytearray)):
        body = data
    r = urllib.request.Request(url, data=body, headers=h, method=method)
    try:
        with urllib.request.urlopen(r) as resp:
            b = resp.read()
            return json.loads(b) if b else None
    except urllib.error.HTTPError as e:
        sys.exit(f"HTTP {e.code} {method} {url}: {e.read().decode()}")


def upload(path: pathlib.Path, name: str) -> str:
    size = path.stat().st_size
    r = req("POST", "/media/create-upload-url",
            data={"mime_type": "image/png", "size_bytes": size, "name": name})
    mid, upload_url = r["media_id"], r["upload_url"]
    put = urllib.request.Request(upload_url, data=path.read_bytes(),
                                 headers={"Content-Type": "image/png"}, method="PUT")
    urllib.request.urlopen(put).read()
    return mid


def wait_terminal(post_id: str, timeout_s: int = 180) -> dict:
    """Poll until status != processing, then pull detailed error if failed."""
    deadline = time.time() + timeout_s
    while time.time() < deadline:
        info = req("GET", f"/posts/{post_id}")
        st = info.get("status")
        if st != "processing":
            if st != "posted":
                results = req("GET", "/post-results",
                              raw_url=f"{PB}/post-results?post_id={post_id}")
                errs = [d.get("error") for d in (results or {}).get("data", [])]
                info["_detailed_errors"] = errs
            return info
        time.sleep(5)
    return {"status": "timeout", "id": post_id}


def get_account_ids() -> dict:
    # Prefer .social-accounts.json written by preflight.sh; otherwise fetch live.
    cache = pathlib.Path(".social-accounts.json")
    data = None
    if cache.exists():
        data = json.loads(cache.read_text())
    # Always verify live
    live = req("GET", "/social-accounts")
    out = {}
    for row in live.get("data", []):
        out[row["platform"]] = row["id"]
    if data and data != {k: out.get(k) for k in data}:
        print("  ⚠  account IDs changed since preflight; using live values", file=sys.stderr)
    return out


def extract_caption(md_path: pathlib.Path, section: str) -> str:
    text = md_path.read_text()
    if section == "tiktok":
        m = re.search(r"## TikTok.*?\n(.*?)\n---", text, re.DOTALL)
    else:
        m = re.search(r"## Instagram.*?\n(.*)", text, re.DOTALL)
    if not m:
        sys.exit(f"Could not find {section} section in {md_path}")
    return m.group(1).strip()


def post(caption: str, media: list[str], account_id: int, *, tiktok_draft=False) -> dict:
    body = {"caption": caption, "media": media, "social_accounts": [account_id]}
    if tiktok_draft:
        body["platform_configurations"] = {"tiktok": {"draft": True}}
    return req("POST", "/posts", data=body)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("day", type=int)
    ap.add_argument("--platforms", default="tiktok,instagram",
                    help="comma-separated: tiktok,instagram,facebook")
    args = ap.parse_args()

    slides_dir = pathlib.Path(f"slides/day{args.day}")
    caption_md = pathlib.Path(f"captions/day{args.day}_caption.md")
    if not slides_dir.is_dir() or not caption_md.is_file():
        sys.exit(f"Missing assets: {slides_dir} or {caption_md}")

    platforms = [p.strip() for p in args.platforms.split(",") if p.strip()]
    accts = get_account_ids()
    for p in platforms:
        if p not in accts:
            sys.exit(f"✗ {p} account not connected on PostBridge — reconnect first")
        print(f"✓ {p} account id={accts[p]}")

    def fresh_media(platform: str) -> list[str]:
        print(f"\n--- Uploading fresh media for {platform} ---")
        ids = []
        for i in range(1, 7):
            m = upload(slides_dir / f"slide{i}.png",
                       f"day{args.day}_{platform}_slide{i}.png")
            ids.append(m)
            print(f"  slide{i}: {m}")
        slide7 = "slide7_instagram.png" if platform in ("instagram", "facebook") \
            else "slide7.png"
        m7 = upload(slides_dir / slide7, f"day{args.day}_{platform}_slide7.png")
        ids.append(m7)
        print(f"  slide7: {m7}")
        return ids

    results = {}
    for plat in platforms:
        media = fresh_media(plat)
        caption = extract_caption(caption_md,
                                  "tiktok" if plat == "tiktok" else "instagram")
        print(f"\n--- Creating {plat} post ---")
        r = post(caption, media, accts[plat], tiktok_draft=(plat == "tiktok"))
        print(f"  id: {r['id']}   (initial: {r.get('status')})")
        print(f"  waiting for terminal status...")
        final = wait_terminal(r["id"])
        results[plat] = final
        st = final.get("status")
        if st == "posted":
            print(f"  ✓ {plat} posted")
        else:
            print(f"  ✗ {plat} {st}")
            for e in final.get("_detailed_errors", []) or []:
                print(f"    error: {e}")

    print("\n=== Summary ===")
    for p, r in results.items():
        print(f"  {p:<10} {r.get('status'):<10} id={r.get('id')}")
    failed = [p for p, r in results.items() if r.get("status") != "posted"]
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
