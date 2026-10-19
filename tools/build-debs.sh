#!/usr/bin/env bash
# Build the boykisser-* .deb packages from this directory :3
#
#   tools/build-debs.sh [OUTDIR] [VERSION]
#
# OUTDIR defaults to tools/dist, VERSION to the contents of tools/VERSION.
# Only needs dpkg-deb, so it runs the same on a dev box, in the ISO builder
# container and in CI. The ISO build drops the result into
# config/packages.chroot so every image variant ships the exact tools from
# this commit.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$(mkdir -p "${1:-$HERE/dist}" && cd "${1:-$HERE/dist}" && pwd)"
VERSION="${2:-$(cat "$HERE/VERSION")}"
VERSION="${VERSION#v}"
MAINT="Tay Maerz <marztayron@gmail.com>"
HOMEPAGE="https://boykisser.taymaerz.de"

command -v dpkg-deb >/dev/null || { echo "!! dpkg-deb is required" >&2; exit 1; }

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# pkg <name> <depends> <description> <files...>
# Each file is "src:dest" relative to tools/ and /, e.g. bin/boykisser:usr/bin/boykisser
pkg() {
	local name="$1" depends="$2" desc="$3"; shift 3
	local root="$STAGE/$name"
	mkdir -p "$root/DEBIAN"
	for spec in "$@"; do
		local src="${spec%%:*}" dest="${spec#*:}"
		install -D -m "$( [[ $dest == usr/bin/* ]] && echo 0755 || echo 0644 )" \
			"$HERE/$src" "$root/$dest"
	done
	{
		echo "Package: $name"
		echo "Version: $VERSION"
		echo "Architecture: all"
		echo "Maintainer: $MAINT"
		echo "Section: misc"
		echo "Priority: optional"
		echo "Homepage: $HOMEPAGE"
		[ -n "$depends" ] && echo "Depends: $depends"
		echo "Description: Boykisser Linux - $desc"
		echo " Part of boykisser-tools, the helper scripts that ship with Boykisser Linux."
		echo " Source: https://github.com/taynotfound/BoykisserLinux/tree/main/tools"
	} > "$root/DEBIAN/control"
	# 1.x shipped to /usr/local/bin, and the ISO overlay dropped unowned copies
	# there too. /usr/local/bin wins in $PATH, so stale copies would shadow the
	# packaged ones forever. Remove any that dpkg doesn't own.
	cat > "$root/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
if [ "$1" = configure ]; then
	for f in /usr/local/bin/boykisser /usr/local/bin/boykisser-* /usr/local/bin/install-boykisser; do
		[ -e "$f" ] || continue
		dpkg -S "$f" >/dev/null 2>&1 || rm -f "$f"
	done
fi
EOF
	# package-specific additions
	[ -f "$HERE/share/postinst/$name" ] && cat "$HERE/share/postinst/$name" >> "$root/DEBIAN/postinst"
	chmod 0755 "$root/DEBIAN/postinst"
	dpkg-deb --root-owner-group -Zxz --build "$root" "$OUT/${name}_${VERSION}_all.deb" >/dev/null
	echo ":3 built ${name}_${VERSION}_all.deb"
}

pkg boykisser-core "" "the boykisser command" \
	bin/boykisser:usr/bin/boykisser

pkg boykisser-center "python3, python3-gi, gir1.2-gtk-3.0" "graphical control center (GTK3)" \
	bin/boykisser-center:usr/bin/boykisser-center \
	share/applications/boykisser-center.desktop:usr/share/applications/boykisser-center.desktop

pkg boykisser-update "curl, python3" "system updater (apt + Flatpak + firmware + boykisser-tools)" \
	bin/boykisser-update:usr/bin/boykisser-update

pkg boykisser-doctor "pciutils" "read-only system health check" \
	bin/boykisser-doctor:usr/bin/boykisser-doctor

pkg boykisser-nvidia "pciutils" "NVIDIA proprietary driver installer" \
	bin/boykisser-nvidia:usr/bin/boykisser-nvidia \
	share/applications/boykisser-nvidia.desktop:usr/share/applications/boykisser-nvidia.desktop

pkg boykisser-theme "" "light/dark theme switcher for XFCE and KDE Plasma" \
	bin/boykisser-theme:usr/bin/boykisser-theme \
	bin/boykisser-theme-toggle:usr/bin/boykisser-theme-toggle \
	bin/boykisser-wallpaper:usr/bin/boykisser-wallpaper \
	share/applications/boykisser-theme-toggle.desktop:usr/share/applications/boykisser-theme-toggle.desktop

pkg boykisser-apps "flatpak" "app installers (presets, browser picker, debloat, bundles)" \
	bin/boykisser-postinstall-apps:usr/bin/boykisser-postinstall-apps \
	bin/boykisser-presets:usr/bin/boykisser-presets \
	bin/boykisser-browser:usr/bin/boykisser-browser \
	bin/boykisser-debloat:usr/bin/boykisser-debloat \
	bin/boykisser-install-bundles:usr/bin/boykisser-install-bundles

pkg boykisser-system "python3, pciutils" "system tools (cleanup, kernel, autologin, report, welcome, installer glue)" \
	bin/boykisser-cleanup:usr/bin/boykisser-cleanup \
	bin/boykisser-kernel:usr/bin/boykisser-kernel \
	bin/boykisser-autologin:usr/bin/boykisser-autologin \
	bin/boykisser-report:usr/bin/boykisser-report \
	bin/boykisser-welcome:usr/bin/boykisser-welcome \
	bin/boykisser-firstboot:usr/bin/boykisser-firstboot \
	bin/boykisser-live-cleanup:usr/bin/boykisser-live-cleanup \
	bin/boykisser-install-kde:usr/bin/boykisser-install-kde \
	bin/install-boykisser:usr/bin/install-boykisser \
	share/systemd/boykisser-firstboot.service:usr/lib/systemd/system/boykisser-firstboot.service \
	share/applications/boykisser-report.desktop:usr/share/applications/boykisser-report.desktop \
	share/applications/boykisser-welcome.desktop:usr/share/applications/boykisser-welcome.desktop

deps=""
for p in core center update doctor nvidia theme apps system; do
	deps="${deps:+$deps, }boykisser-$p (= $VERSION)"
done
pkg boykisser-tools "$deps" "all boykisser-* tools (metapackage)"
