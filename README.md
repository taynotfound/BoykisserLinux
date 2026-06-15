<div align="center">
  <img src="boykisser_start.png" alt="Boykisser Linux" width="200">

  # Boykisser Linux :3

  **A gay, gimmicky, actually daily-drivable Debian distro. XFCE, but make it pink.**

  [Website](https://boykisser.taymaerz.de) ·
  [Download](https://github.com/taynotfound/BoykisserLinux/releases/latest) ·
  [Discord](https://discord.gg/3ZpwE9PPfP)
</div>

---

## What is this?

Boykisser Linux is a custom [Debian 13 (trixie)](https://www.debian.org/) live
ISO built with [live-build](https://wiki.debian.org/live-build) and installed
with [Calamares](https://calamares.io/). It ships an XFCE desktop with a full
Boykisser theme, gaming and streaming tools, and Flatpak ready to go.

## Features

- 💅 Full Boykisser XFCE theme — pink accents, Tela-circle icons, light & dark, custom Plymouth splash and boot menu
- 🖥️ Choose your desktop in the installer — XFCE by default, or pick **KDE Plasma** (fully pink Boykisser-themed, pulled from the net during install)
- 🐲 Pink GRUB theme on the installed system, with the first entry (Boykisser) auto-selected
- �📦 Flatpak + Flathub out of the box (GNOME Software, Flatseal, Gear Lever)
- 🎮 Steam, Heroic, GameMode, MangoHud — with 32-bit libs enabled
- 🎥 OBS Studio with a working virtual camera (v4l2loopback)
- 🌐 Firefox, VS Code Insiders, VLC, Discord
- 🖥️ UEFI + BIOS, broad firmware, Nouveau for universal boot
- 🟩 One-click helper to install proprietary NVIDIA drivers after setup

## Build it yourself

You need `podman` (or `docker`). The ISO is built inside a Debian container, so
it works from any host.

```sh
./build.sh        # build the full ISO
./build.sh --netinstall   # build the slim ISO (pulls apps from the net on first boot)
./test-vm.sh      # boot it in QEMU
```

The result lands at `boykisser-linux-amd64.iso` (or
`boykisser-linux-netinstall-amd64.iso` for the slim build).

### Full vs netinstall

- **Full** — every app is in the squashfs; installs and runs fully offline.
- **Netinstall** — a much smaller ISO (kept under **1.2 GB**) with only the base
  desktop, browser and store. It drops APT *Recommends* and the DKMS/build bits
  from the squashfs, then downloads the rest (OBS, VLC, codecs, Steam, VS Code,
  gaming bits + Flatpaks) on first boot of the *installed* system via
  `boykisser-postinstall-apps`, so it **needs an internet connection** to finish
  setup. You can also re-run `sudo boykisser-postinstall-apps` any time.

> Picking **KDE Plasma** in the installer also needs an internet connection, on
> both the full and netinstall ISOs — KDE is downloaded during install to keep
> the images small. XFCE installs completely offline.

## Releases

Tagged pushes (`v*`) trigger [the build workflow](.github/workflows/build.yml),
which builds the ISO and publishes it two ways:

- **Internet Archive** — the whole ISO as a single direct download plus an
  auto-generated torrent, so there's nothing to reassemble. (Needs the
  `IA_ACCESS_KEY` / `IA_SECRET_KEY` repo secrets; the step is skipped without
  them.)
- **GitHub Releases** — a fallback copy split into 1.9 GiB parts to stay under
  GitHub's 2 GiB asset limit:

```sh
cat boykisser-linux-amd64.iso.part* > boykisser-linux-amd64.iso
sha256sum -c SHA256SUMS
sudo dd if=boykisser-linux-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

## Layout

| Path | What |
| --- | --- |
| `auto/config` | live-build configuration |
| `config/package-lists/` | what gets installed |
| `config/hooks/normal/` | build-time setup (Flatpak, Steam, theme, ...) |
| `config/includes.chroot/` | files overlaid onto the image |
| `config/bootloaders/` | Boykisser boot splash + GRUB theme |
| `docker/Dockerfile.builder` | the build container |

## Disclaimer

AI tooling helped build this OS. Everything is reviewed and tested by a human,
but please read the code before running it. Run `./README.sh` for the cute
version. :3

Debian is a trademark of Software in the Public Interest, Inc. Boykisser Linux
is an independent project and is not affiliated with or endorsed by Debian.
