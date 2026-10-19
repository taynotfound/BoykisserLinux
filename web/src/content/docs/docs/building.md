---
title: Building the ISO
description: Build Boykisser Linux yourself, change it, and test it in a VM.
---

Everything that makes up Boykisser Linux is in [one repository](https://github.com/taynotfound/BoykisserLinux):

| Path | What |
| --- | --- |
| `auto/config` | live-build settings (Debian release, bootloaders, boot options) |
| `config/package-lists/` | Packages in the image |
| `config/hooks/normal/` | Setup scripts that run inside the image while it's built |
| `config/includes.chroot/` | Files copied straight into the image (themes, configs, artwork) |
| `config/bootloaders/` | Live boot menu theme |
| `tools/` | The `boykisser-*` scripts and Boykisser Center, packaged into `.deb`s |
| `web/` | This website |
| `docker/Dockerfile.builder` | The Debian container the build runs in |

## Build

You need `podman` (or `docker`) and around 30 GB of free space. The build runs in a privileged Debian container, so the host distro doesn't matter.

```sh
./build.sh                 # full ISO
./build.sh --netinstall    # slim ISO, apps download on first boot
./build.sh --lite          # BIOS-only ISO for old hardware
./build.sh --fast          # keep the built system, only regenerate the ISO
./build.sh --clean         # start from scratch, including the package cache
```

A full build takes 20 to 40 minutes the first time. Downloaded packages are cached in `cache/`, so rebuilds are quicker. The log goes to `build.log` and the ISO lands next to `build.sh` as `boykisser-linux-amd64.iso` (or `-netinstall-` / `-lite-`).

`--fast` is only for boot menu and ISO-level tweaks. After changing package lists, hooks or tools, run a normal build.

## Test in a VM

```sh
./test-vm.sh               # boot the ISO (UEFI)
./test-vm.sh --bios        # legacy BIOS
./test-vm.sh --disk        # attach a 40 GB virtual disk to try the installer
./test-vm.sh --installed   # boot what you installed on that disk
```

It needs QEMU, and OVMF for UEFI. KVM is used when available. If your distro packages QEMU's GTK window and virtio GPU separately (Arch: `qemu-ui-gtk`, `qemu-hw-display-virtio-vga`), the script falls back to plain VGA and a VNC display on `127.0.0.1:5900`.

The build needs real root (debootstrap creates device nodes), so with podman run it as root, e.g. `sudo ./build.sh` or `ENGINE="sudo podman" ./build.sh`.

## Change the tools

Edit scripts in `tools/bin/`. To try them on a running system without a rebuild:

```sh
tools/build-debs.sh && sudo apt install ./tools/dist/*.deb
```

The next ISO build packages them automatically. To ship them to installed systems, bump `tools/VERSION` and push a matching `tools-vX.Y.Z` tag. CI builds the packages and `boykisser update` picks them up.

## Releases

- Every Monday CI tags a new `vMAJOR.MONTH.YY.N` release (for example `v2.10.26.4`; the major number lives in `MAJOR_VERSION`) and builds all three ISOs with the current Debian kernel and security updates.
- `./scripts/bump_version.sh` tags a release by hand.
- ISOs are published to GitHub Releases (the full one split into parts) and mirrored to the Internet Archive with a torrent.

## The website

```sh
cd web
npm install
npm run dev      # http://localhost:4321
```

It's [Astro](https://astro.build/) with [Starlight](https://starlight.astro.build/) for the docs. Docs pages are Markdown files in `web/src/content/docs/docs/`. Every page has an **Edit page** link at the bottom.
