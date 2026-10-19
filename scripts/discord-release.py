#!/usr/bin/env python3
"""Announce a release on Discord with a Components V2 message.

    discord-release.py --kind big|minor|tools --tag TAG [--dist DIR]
                       [--changes FILE] [--notes FILE] [--dry-run]

big    hand-tagged OS release: screenshot, changelog, every flavour with size
       and download/mirror/torrent buttons, checksum note
minor  weekly OS rebuild: compact card with the highlights and one download
tools  boykisser-tools release: small one-liner

Reads the webhook from $DISCORD_RELEASE_WEBHOOK and the repo from
$GITHUB_REPOSITORY. Only uses non-interactive components (text, separators,
media, link buttons), which plain webhooks may send with ?with_components=true.
"""
import argparse
import json
import os
import re
import sys
import urllib.request

REPO = os.environ.get("GITHUB_REPOSITORY", "taynotfound/BoykisserLinux")
RAW = f"https://raw.githubusercontent.com/{REPO}/main"
SITE = "https://boykisser.taymaerz.de"
PINK = 0xFF5FA2
MASCOT = f"{RAW}/config/includes.chroot/usr/share/boykisser/start.png"
HERO = f"{RAW}/web/src/assets/screenshots/xfce.png"
IS_COMPONENTS_V2 = 1 << 15

FLAVOURS = [
    ("full", "Full", "boykisser-linux-amd64.iso",
     "Everything included (Steam, OBS, VS Code, codecs). Installs offline."),
    ("netinstall", "Netinstall", "boykisser-linux-netinstall-amd64.iso",
     "Same desktop, smaller download. Big apps arrive on first boot."),
    ("lite", "Lite", "boykisser-linux-lite-amd64.iso",
     "For old BIOS-only machines. No heavy apps, safe graphics."),
]


# --- component helpers (https://discord.com/developers/docs/components) -------
def text(s):
    return {"type": 10, "content": s}


def sep(big=False):
    return {"type": 14, "divider": True, "spacing": 2 if big else 1}


def buttons(*links):
    row = [{"type": 2, "style": 5, "label": label[:80], "url": url} for label, url in links if url]
    return {"type": 1, "components": row[:5]} if row else None


def section(content, thumb=None):
    if not thumb:
        return text(content)
    return {"type": 9, "components": [text(content)],
            "accessory": {"type": 11, "media": {"url": thumb}}}


def card(*children):
    return {"type": 17, "accent_color": PINK, "components": [c for c in children if c]}


# --- data ----------------------------------------------------------------------
def human(n):
    return f"{n / 1024 ** 3:.1f} GB" if n >= 1024 ** 3 else f"{n / 1024 ** 2:.0f} MB"


def flavour_sizes(dist):
    """Size per flavour from the build artifacts (full ISO is split in parts)."""
    sizes = {}
    if not dist or not os.path.isdir(dist):
        return sizes
    for fid, _, iso, _ in FLAVOURS:
        total = sum(os.path.getsize(os.path.join(dist, f))
                    for f in os.listdir(dist) if f.startswith(iso))
        if total:
            sizes[fid] = total
    return sizes


def mirror_links(notes):
    """Internet Archive ISO + torrent URLs from the release notes, per flavour."""
    body = open(notes).read() if notes and os.path.exists(notes) else ""
    isos = re.findall(r"https://archive\.org/download/\S+?\.iso", body)
    torrents = re.findall(r"https://archive\.org/download/\S+?_archive\.torrent", body)

    def pick(urls, fid):
        for u in urls:
            if fid == "full" and not re.search(r"netinstall|lite", u):
                return u
            if fid != "full" and f"-{fid}" in u:
                return u
        return None

    return {fid: (pick(isos, fid), pick(torrents, fid)) for fid, *_ in FLAVOURS}


def changes(path, limit):
    if not path or not os.path.exists(path):
        return []
    lines = [l.strip().lstrip("*- ").strip() for l in open(path) if l.strip()]
    lines = [l for l in lines if l and not l.lower().startswith(("merge", "bump"))]
    return lines[:limit] + ([f"…and {len(lines) - limit} more"] if len(lines) > limit else [])


def bullets(items, width=110):
    return "\n".join(f"- {i if len(i) <= width else i[:width - 1] + '…'}" for i in items)


# --- the three cards -----------------------------------------------------------
def big(tag, url, dist, changes_file, notes):
    sizes, mirrors = flavour_sizes(dist), mirror_links(notes)
    gh = f"https://github.com/{REPO}/releases/download/{tag}"
    parts = [
        {"type": 12, "items": [{"media": {"url": HERO}, "description": "The Boykisser Linux desktop"}]},
        text(f"# Boykisser Linux {tag} is out :3\n"
             "Debian 13 “trixie” · XFCE or KDE Plasma · UEFI + legacy BIOS"),
        sep(True),
    ]
    log = changes(changes_file, 12)
    if log:
        parts += [text("## What’s new\n" + bullets(log)), sep(True)]
    parts.append(text("## Downloads"))
    for fid, name, iso, blurb in FLAVOURS:
        size = f" · {human(sizes[fid])}" if fid in sizes else ""
        star = " ⭐ *recommended*" if fid == "full" else ""
        direct, torrent = mirrors.get(fid, (None, None))
        # the full ISO is split on GitHub, so its direct link is the release page
        github = url if fid == "full" else f"{gh}/{iso}"
        parts += [
            text(f"### {name}{size}{star}\n{blurb}"),
            buttons(("Download", direct or github), ("Torrent", torrent),
                    ("GitHub" if direct else None, github if direct else None)),
        ]
    parts += [
        sep(True),
        text("-# Verify with `SHA256SUMS` from the release. Flash with Etcher, Rufus (DD mode) or `dd`."),
        buttons(("Release notes", url), ("Website", SITE), ("Install guide", f"{SITE}/docs/getting-started/")),
    ]
    return card(*parts)


def minor(tag, url, changes_file):
    log = changes(changes_file, 5)
    body = (f"## Weekly build {tag}\n"
            "Fresh Debian kernel and security updates, all three flavours rebuilt.")
    if log:
        body += "\n" + bullets(log, 90)
    return card(
        section(body, MASCOT),
        buttons(("Download", url), ("All releases", f"https://github.com/{REPO}/releases")),
    )


def tools(tag, url):
    ver = tag.removeprefix("tools-v")
    return card(
        section(f"**boykisser-tools {ver}** released\n"
                "-# Installed systems pick it up with `boykisser update`", MASCOT),
        buttons(("Release", url)),
    )


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--kind", choices=["big", "minor", "tools"], required=True)
    ap.add_argument("--tag", required=True)
    ap.add_argument("--url", help="release page (default: GitHub release for --tag)")
    ap.add_argument("--dist", help="directory with the ISO files (for sizes)")
    ap.add_argument("--changes", help="file with one change per line")
    ap.add_argument("--notes", help="release notes (for Internet Archive links)")
    ap.add_argument("--dry-run", action="store_true", help="print the payload, don't send")
    a = ap.parse_args()
    url = a.url or f"https://github.com/{REPO}/releases/tag/{a.tag}"

    if a.kind == "big":
        message = big(a.tag, url, a.dist, a.changes, a.notes)
    elif a.kind == "minor":
        message = minor(a.tag, url, a.changes)
    else:
        message = tools(a.tag, url)

    payload = {"username": "Boykisser Linux", "avatar_url": MASCOT,
               "flags": IS_COMPONENTS_V2, "components": [message]}
    if a.dry_run:
        print(json.dumps(payload, indent=1))
        return

    hook = os.environ.get("DISCORD_RELEASE_WEBHOOK")
    if not hook:
        print("No DISCORD_RELEASE_WEBHOOK set, skipping.")
        return
    req = urllib.request.Request(
        hook + ("&" if "?" in hook else "?") + "with_components=true&wait=true",
        data=json.dumps(payload).encode(), method="POST",
        headers={"Content-Type": "application/json", "User-Agent": "boykisser-release (github actions)"})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            print("posted", json.load(r).get("id"))
    except urllib.error.HTTPError as e:
        print(f"Discord rejected the message ({e.code}): {e.read().decode()[:500]}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
