#!/usr/bin/env bash
# Render every Boykisser brand image from the SVGs in branding/src.
# Needs rsvg-convert (librsvg) and ImageMagick 7 (magick). Run after editing
# the SVGs and commit the results:  branding/render.sh
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(dirname "$HERE")"
SRC="$HERE/src"
OS="$ROOT/config/includes.chroot"
SHARE="$OS/usr/share/boykisser"
WEB="$ROOT/web"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

png() { # svg size out
	mkdir -p "$(dirname "$3")"
	rsvg-convert -w "$2" -h "$2" "$SRC/$1" -o "$3"
}

# Night sky background shared by the boot, login and GRUB screens.
sky() { # width height out
	magick -size "$1x$2" gradient:'#241247-#120a20' \
		\( -size "$1x$2" radial-gradient:'#5a2050-#000000' \) -compose screen -composite "$3"
}

on_sky() { # width height logo-size gravity offset out
	sky "$1" "$2" "$TMP/sky.png"
	png logo.svg "$3" "$TMP/logo.png"
	magick "$TMP/sky.png" "$TMP/logo.png" -gravity "$4" -geometry "$5" -compose over -composite \
		-strip -depth 8 -define png:compression-level=9 "$6"
}

echo ":3 OS images"
# start button, Calamares sidebar logo, /usr/share/pixmaps (os-release LOGO), welcome
png logo.svg 256 "$SHARE/start.png"
png logo.svg 112 "$SHARE/start-112.png"
png logo.svg 48  "$SHARE/start-48.png"
png logo.svg 32  "$SHARE/start-32.png"
png logo.svg 256 "$OS/usr/share/icons/hicolor/256x256/apps/boykisser-start.png"
# logo on dark / on light backgrounds
png logo.svg 304       "$SHARE/logo.png"
png logo-light.svg 304 "$SHARE/logo-dark.png"
# app icon: window icons, installer icon, Center, launchers
png app-icon.svg 256 "$SHARE/face.png"
png app-icon.svg 320 "$SHARE/badge.png"
png app-icon.svg 48  "$SHARE/badge-48.png"
png app-icon.svg 32  "$SHARE/badge-32.png"
# default account picture
png app-icon-pink.svg 256 "$OS/etc/skel/.face"
# Plymouth boot splash (the script centres it and adds the title)
png logo.svg 360 "$OS/usr/share/plymouth/themes/boykisser/splash.png"
png logo.svg 360 "$OS/usr/share/plymouth/themes/boykisser/boykisser.png"
# installed-system GRUB (logo top right, clear of the menu) and login screen
on_sky 1920 1080 220 northeast +90+60 "$OS/boot/grub/themes/boykisser/background.png"
on_sky 1920 1080 230 north +0+170 "$SHARE/login.png"

echo ":3 wallpapers"
python3 "$HERE/wallpapers/make.py" "$OS/usr/share/backgrounds/boykisser"
mkdir -p "$WEB/public/wallpapers"
find "${WEB:?}/public/wallpapers" -name '*.webp' -delete
for f in "$OS"/usr/share/backgrounds/boykisser/*.jpg; do
	magick "$f" -resize 960x540 -quality 82 "$WEB/public/wallpapers/$(basename "${f%.jpg}").webp"
done

echo ":3 website images"
png app-icon.svg 64  "$WEB/public/favicon.png"
png app-icon.svg 180 "$WEB/public/apple-touch-icon.png"
cp "$SRC/app-icon.svg" "$WEB/public/favicon.svg"
mkdir -p "$WEB/src/assets/brand"
cp "$SRC"/logo.svg "$SRC"/logo-light.svg "$SRC"/app-icon.svg "$SRC"/face.svg "$WEB/src/assets/brand/"
# social preview card
sky 1200 630 "$TMP/og.png"
png logo.svg 360 "$TMP/og-logo.png"
magick "$TMP/og.png" "$TMP/og-logo.png" -gravity east -geometry +100+0 -compose over -composite \
	-font DejaVu-Sans-Bold -fill white -pointsize 72 -gravity west -annotate +80-50 'Boykisser Linux' \
	-fill '#ff8ec8' -pointsize 34 -annotate +84+36 'A pink Debian spin :3' \
	-fill '#bfa9d6' -pointsize 24 -annotate +84+96 'XFCE or KDE · Flatpak · Steam · OBS' \
	-strip PNG24:"$WEB/public/og.png"

echo ":3 done"
