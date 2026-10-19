#!/usr/bin/env python3
"""Generate the Boykisser wallpapers as SVG, then render them to 4K images.

    branding/wallpapers/make.py [OUTDIR]

Everything here is drawn from code (seeded randomness, so the output is stable)
in the Boykisser palette. Needs rsvg-convert and ImageMagick (magick).
"""
import math
import os
import random
import subprocess
import sys

W, H = 3840, 2160
NIGHT, PLUM, PURPLE = "#160e24", "#241247", "#3a1e5c"
PINK, PINK_DEEP, CREAM, LAVENDER = "#ff7ab8", "#d63f87", "#fff3f8", "#bfa9d6"

# the :3 mark (branding/src/logo.svg), 64x64 units
EYES = ('<path d="M14 16.5 A5.5 5.5 0 0 1 14 27.5 Z"/>'
        '<path d="M14 36.5 A5.5 5.5 0 0 1 14 47.5 Z"/>')
THREE = "M33 15 C45 11 49 29 35 32 C49 35 45 53 33 49"
HEART = "M0,3 C-6,-1.5 -4.5,-7.5 0,-3.6 C4.5,-7.5 6,-1.5 0,3 Z"


def mark(x, y, size, eye, three, opacity=1.0, rot=-10):
    s = size / 64
    return (f'<g transform="translate({x} {y}) scale({s})" opacity="{opacity}">'
            f'<g transform="rotate({rot} 32 32)">'
            f'<g fill="{eye}" stroke="{eye}" stroke-width="2" stroke-linejoin="round">{EYES}</g>'
            f'<path d="{THREE}" fill="none" stroke="{three}" stroke-width="7" '
            f'stroke-linecap="round" stroke-linejoin="round"/></g></g>')


def heart(x, y, size, fill, rot=0, opacity=1.0, stroke=None):
    s = size / 12
    paint = f'fill="none" stroke="{stroke}" stroke-width="1.1"' if stroke else f'fill="{fill}"'
    return (f'<path d="{HEART}" {paint} opacity="{opacity}" '
            f'transform="translate({x} {y}) rotate({rot}) scale({s})"/>')


def paw(x, y, size, fill, rot=0, opacity=1.0):
    s = size / 20
    return (f'<g fill="{fill}" opacity="{opacity}" transform="translate({x} {y}) rotate({rot}) scale({s})">'
            '<ellipse cx="0" cy="4" rx="6" ry="5"/>'
            '<ellipse cx="-6.5" cy="-3" rx="2.4" ry="3.1"/><ellipse cx="-2.3" cy="-6.5" rx="2.4" ry="3.1"/>'
            '<ellipse cx="2.3" cy="-6.5" rx="2.4" ry="3.1"/><ellipse cx="6.5" cy="-3" rx="2.4" ry="3.1"/></g>')


def sparkle(x, y, size, fill, opacity=1.0):
    r, k = size, size * 0.18
    d = (f"M{x},{y-r} Q{x+k},{y-k} {x+r},{y} Q{x+k},{y+k} {x},{y+r} "
         f"Q{x-k},{y+k} {x-r},{y} Q{x-k},{y-k} {x},{y-r} Z")
    return f'<path d="{d}" fill="{fill}" opacity="{opacity}"/>'


def smooth_path(points, close_to=None):
    """Catmull-Rom through points -> cubic Bezier path; optionally closed down to y=close_to."""
    d = f"M{points[0][0]:.1f},{points[0][1]:.1f}"
    for i in range(len(points) - 1):
        p0 = points[max(i - 1, 0)]
        p1, p2 = points[i], points[i + 1]
        p3 = points[min(i + 2, len(points) - 1)]
        c1 = (p1[0] + (p2[0] - p0[0]) / 6, p1[1] + (p2[1] - p0[1]) / 6)
        c2 = (p2[0] - (p3[0] - p1[0]) / 6, p2[1] - (p3[1] - p1[1]) / 6)
        d += f" C{c1[0]:.1f},{c1[1]:.1f} {c2[0]:.1f},{c2[1]:.1f} {p2[0]:.1f},{p2[1]:.1f}"
    if close_to is not None:
        d += f" L{points[-1][0]:.1f},{close_to} L{points[0][0]:.1f},{close_to} Z"
    return d


def hills(rng, base, amp, fill, step=180):
    f1, f2 = rng.uniform(0.0006, 0.0011), rng.uniform(0.0018, 0.003)
    p1, p2 = rng.uniform(0, 6.3), rng.uniform(0, 6.3)
    pts = [(x, base + amp * math.sin(f1 * x + p1) + amp * 0.35 * math.sin(f2 * x + p2))
           for x in range(-200, W + 400, step)]
    return f'<path d="{smooth_path(pts, H + 10)}" fill="{fill}"/>'


GRAIN = ('<filter id="grain" x="0" y="0" width="100%" height="100%">'
         '<feTurbulence type="fractalNoise" baseFrequency="0.85" numOctaves="2" stitchTiles="stitch" seed="7"/>'
         '<feColorMatrix type="saturate" values="0"/>'
         '<feComponentTransfer><feFuncA type="table" tableValues="0 0.07"/></feComponentTransfer></filter>')


def svg(defs, body, grain=True):
    g = f'<rect width="{W}" height="{H}" filter="url(#grain)"/>' if grain else ""
    return (f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">'
            f'<defs>{GRAIN}{defs}</defs>{body}{g}</svg>')


def stars(rng, n, ymax, colors=(CREAM,), rmin=1.2, rmax=3.6):
    out = []
    for _ in range(n):
        x, y = rng.uniform(0, W), rng.uniform(0, ymax) ** 1.08
        out.append(f'<circle cx="{x:.0f}" cy="{y:.0f}" r="{rng.uniform(rmin, rmax):.1f}" '
                   f'fill="{rng.choice(colors)}" opacity="{rng.uniform(.25, .95):.2f}"/>')
    return "".join(out)


# --- the wallpapers --------------------------------------------------------------

def nightfall():
    rng = random.Random(11)
    defs = ('<linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">'
            f'<stop offset="0" stop-color="#0f0a1c"/><stop offset=".45" stop-color="{PLUM}"/>'
            '<stop offset=".72" stop-color="#5b2a72"/><stop offset=".86" stop-color="#b44a86"/></linearGradient>'
            '<linearGradient id="trail" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#fff" stop-opacity="0"/>'
            '<stop offset="1" stop-color="#fff" stop-opacity=".9"/></linearGradient>'
            '<radialGradient id="moonglow"><stop offset="0" stop-color="#ffd1e6" stop-opacity=".55"/>'
            '<stop offset="1" stop-color="#ffd1e6" stop-opacity="0"/></radialGradient>')
    body = f'<rect width="{W}" height="{H}" fill="url(#sky)"/>'
    body += stars(rng, 320, 1500)
    body += "".join(sparkle(rng.uniform(0, W), rng.uniform(80, 1100), rng.uniform(10, 22), CREAM,
                            rng.uniform(.5, .9)) for _ in range(14))
    mx, my, mr = 2860, 560, 190
    body += f'<circle cx="{mx}" cy="{my}" r="{mr*3.2}" fill="url(#moonglow)"/>'
    body += f'<circle cx="{mx}" cy="{my}" r="{mr}" fill="{CREAM}"/>'
    body += mark(mx - mr * 0.62, my - mr * 0.62, mr * 1.24, "#e8cfe0", "#f2b8d4", 1)
    body += ('<g opacity=".8"><line x1="900" y1="260" x2="1380" y2="430" stroke="url(#trail)" stroke-width="5" '
             'stroke-linecap="round"/><circle cx="1380" cy="430" r="6" fill="#fff"/></g>')
    for base, amp, col in ((1500, 90, "#4a2370"), (1640, 110, "#38195a"), (1790, 80, "#271242"), (1930, 70, NIGHT)):
        layer = hills(rng, base, amp, col)
        rim = layer.replace(f'fill="{col}"', 'fill="none" stroke="#ff9ac8" stroke-width="4" stroke-opacity=".28"')
        body += layer + rim
    return svg(defs, body)


def daydream():
    rng = random.Random(23)
    defs = ('<linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">'
            '<stop offset="0" stop-color="#ffd9ea"/><stop offset=".55" stop-color="#ffeef4"/>'
            '<stop offset="1" stop-color="#fff7ef"/></linearGradient>'
            '<radialGradient id="sun"><stop offset="0" stop-color="#fff" stop-opacity=".95"/>'
            '<stop offset=".35" stop-color="#ffe6f1" stop-opacity=".8"/><stop offset="1" stop-color="#ffe6f1" stop-opacity="0"/></radialGradient>'
            '<filter id="soft"><feGaussianBlur stdDeviation="6"/></filter>')
    body = f'<rect width="{W}" height="{H}" fill="url(#sky)"/>'
    body += '<circle cx="900" cy="620" r="700" fill="url(#sun)"/>'
    for cx, cy, s in ((2500, 520, 1.3), (1250, 980, 0.9), (3300, 1050, 0.8), (500, 420, 0.7)):
        puffs = "".join(f'<circle cx="{cx + dx*s:.0f}" cy="{cy + dy*s:.0f}" r="{r*s:.0f}"/>'
                        for dx, dy, r in ((-220, 40, 120), (-90, -20, 170), (90, -40, 190), (250, 30, 130), (0, 70, 150)))
        body += f'<g fill="#ffffff" opacity=".85" filter="url(#soft)">{puffs}</g>'
    body += "".join(heart(rng.uniform(150, W - 150), rng.uniform(150, 1250), rng.uniform(90, 190),
                          None, rng.uniform(-25, 25), rng.uniform(.35, .8),
                          stroke=rng.choice((PINK, "#f39cc6", PINK_DEEP)))
                    for _ in range(18))
    for base, amp, col in ((1480, 80, "#ffc8de"), (1620, 100, "#f9a9cc"), (1780, 70, "#ee8cbc"), (1930, 60, "#e070a8")):
        body += hills(rng, base, amp, col)
    return svg(defs, body)


def synthwave():
    rng = random.Random(5)
    horizon, cx, sr = 1320, W / 2, 560
    defs = ('<linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">'
            f'<stop offset="0" stop-color="#0d0818"/><stop offset=".5" stop-color="{PLUM}"/>'
            '<stop offset="1" stop-color="#7a2a72"/></linearGradient>'
            '<linearGradient id="sun" x1="0" y1="0" x2="0" y2="1">'
            '<stop offset="0" stop-color="#ffe4f0"/><stop offset=".45" stop-color="#ff9ac8"/>'
            f'<stop offset="1" stop-color="{PINK_DEEP}"/></linearGradient>'
            '<linearGradient id="floor" x1="0" y1="0" x2="0" y2="1">'
            f'<stop offset="0" stop-color="#2a0f3a"/><stop offset="1" stop-color="{NIGHT}"/></linearGradient>'
            '<mask id="stripes"><rect width="100%" height="100%" fill="#fff"/>'
            + "".join(f'<rect x="0" y="{horizon - 300 + i*68 + i*i*1.5:.0f}" width="{W}" height="{8 + i*5}" fill="#000"/>'
                      for i in range(7))
            + '</mask><radialGradient id="glow"><stop offset="0" stop-color="#ff7ab8" stop-opacity=".45"/>'
              '<stop offset="1" stop-color="#ff7ab8" stop-opacity="0"/></radialGradient>')
    body = f'<rect width="{W}" height="{H}" fill="url(#sky)"/>'
    body += stars(rng, 220, horizon - 200)
    body += f'<circle cx="{cx}" cy="{horizon-140}" r="{sr*2}" fill="url(#glow)"/>'
    body += f'<circle cx="{cx}" cy="{horizon-140}" r="{sr}" fill="url(#sun)" mask="url(#stripes)"/>'
    # mountain silhouettes on the horizon
    pts = [(x, horizon - abs(math.sin(x * 0.004 + 1.3)) * 180 - rng.uniform(0, 60)) for x in range(-100, W + 200, 140)]
    body += f'<path d="{smooth_path(pts, horizon + 5)}" fill="#2b1245"/>'
    body += f'<rect y="{horizon}" width="{W}" height="{H-horizon}" fill="url(#floor)"/>'
    grid = []
    for i in range(1, 15):  # horizontal lines, closer together near the horizon
        y = horizon + (H - horizon) * (i / 14) ** 2.1
        grid.append(f'<line x1="0" y1="{y:.0f}" x2="{W}" y2="{y:.0f}"/>')
    for i in range(-24, 25):  # lines converging on the vanishing point
        grid.append(f'<line x1="{cx + i*45:.0f}" y1="{horizon}" x2="{cx + i*420:.0f}" y2="{H}"/>')
    body += f'<g stroke="{PINK}" stroke-width="3" opacity=".55">{"".join(grid)}</g>'
    return svg(defs, body)


def drops():
    rng = random.Random(42)
    defs = ('<filter id="blur" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="300"/></filter>'
            '<radialGradient id="drop" cx=".35" cy=".3" r=".75">'
            '<stop offset="0" stop-color="#fff" stop-opacity=".55"/><stop offset=".25" stop-color="#ffd1e6" stop-opacity=".18"/>'
            '<stop offset=".8" stop-color="#ff7ab8" stop-opacity=".08"/><stop offset="1" stop-color="#ffb3d6" stop-opacity=".35"/></radialGradient>')
    body = f'<rect width="{W}" height="{H}" fill="{NIGHT}"/>'
    for x, y, r, c in ((700, 500, 900, "#7a2a8a"), (3000, 400, 800, PINK_DEEP), (2300, 1700, 1000, "#4a1f7a"),
                       (600, 1800, 700, "#c2508a"), (1700, 900, 600, "#ff9e7a")):
        body += f'<circle cx="{x}" cy="{y}" r="{r}" fill="{c}" opacity=".75" filter="url(#blur)"/>'
    for _ in range(46):
        x, y, r = rng.uniform(0, W), rng.uniform(0, H), rng.choice((18, 26, 34, 48, 70, 110, 160))
        body += (f'<g transform="translate({x:.0f} {y:.0f})"><circle r="{r}" fill="url(#drop)"/>'
                 f'<ellipse cx="{-r*.35:.1f}" cy="{-r*.42:.1f}" rx="{r*.22:.1f}" ry="{r*.13:.1f}" fill="#fff" '
                 f'opacity=".7" transform="rotate(-30 {-r*.35:.1f} {-r*.42:.1f})"/></g>')
    return svg(defs, body)


def paws():
    rng = random.Random(3)
    defs = ('<radialGradient id="vig" cx=".5" cy=".5" r=".75">'
            '<stop offset=".55" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity=".45"/></radialGradient>')
    body = f'<rect width="{W}" height="{H}" fill="#1d1230"/>'
    cell = 330
    for gy in range(-1, H // cell + 2):
        for gx in range(-1, W // cell + 2):
            x = gx * cell + (cell / 2 if gy % 2 else 0) + rng.uniform(-40, 40)
            y = gy * cell + rng.uniform(-40, 40)
            kind = rng.random()
            col = rng.choice(("#41295c", "#4a2d68", "#5a2f6e"))
            if kind < .4:
                body += paw(x, y, rng.uniform(80, 110), col, rng.uniform(-40, 40))
            elif kind < .7:
                body += heart(x, y, rng.uniform(70, 96), col, rng.uniform(-30, 30))
            elif kind < .9:
                body += mark(x - 50, y - 50, rng.uniform(96, 120), col, "#6a3478", 1, rng.uniform(-30, 20))
            else:
                body += sparkle(x, y, rng.uniform(22, 32), "#64407f")
    body += f'<rect width="{W}" height="{H}" fill="url(#vig)"/>'
    return svg(defs, body)


def kiss():
    defs = ('<linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">'
            f'<stop offset="0" stop-color="#2a1550"/><stop offset="1" stop-color="{NIGHT}"/></linearGradient>'
            '<radialGradient id="glow"><stop offset="0" stop-color="#ff7ab8" stop-opacity=".35"/>'
            '<stop offset="1" stop-color="#ff7ab8" stop-opacity="0"/></radialGradient>')
    body = f'<rect width="{W}" height="{H}" fill="url(#bg)"/>'
    body += f'<circle cx="2700" cy="1180" r="1200" fill="url(#glow)"/>'
    body += mark(1950, 400, 1500, CREAM, PINK, 0.92)
    return svg(defs, body)


WALLPAPERS = {
    "nightfall": nightfall, "daydream": daydream, "synthwave": synthwave,
    "drops": drops, "paws": paws, "kiss": kiss,
}


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(here, "out")
    os.makedirs(out, exist_ok=True)
    for name, fn in WALLPAPERS.items():
        src = os.path.join(out, f"{name}.svg")
        with open(src, "w") as f:
            f.write(fn())
        png = os.path.join(out, f"{name}.png")
        subprocess.run(["rsvg-convert", "-w", str(W), "-h", str(H), src, "-o", png], check=True)
        subprocess.run(["magick", png, "-quality", "92", "-sampling-factor", "4:4:4",
                        os.path.join(out, f"{name}.jpg")], check=True)
        os.remove(png)
        os.remove(src)
        print(f":3 {name}.jpg")


if __name__ == "__main__":
    main()
