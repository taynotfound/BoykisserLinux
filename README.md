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
- 📦 Flatpak + Flathub out of the box (GNOME Software, Flatseal, Gear Lever)
- 🎮 Steam, Heroic, GameMode, MangoHud — with 32-bit libs enabled
- 🎥 OBS Studio with a working virtual camera (v4l2loopback)
- 🌐 Firefox, VS Code Insiders, VLC, Discord
- 🖥️ UEFI + BIOS, broad firmware, Nouveau for universal boot
- 🟩 One-click helper to install proprietary NVIDIA drivers after setup
- 🔒 Automatic security updates (unattended-upgrades) on the installed system
- ⚡ zram compressed swap + power-profiles-daemon for snappy laptops
- 🛡️ ufw firewall enabled by default (deny incoming, allow outgoing)
- 🖨️ Printing (CUPS) and firmware updates (fwupd) out of the box
- 🐛 Built-in error reporting — `boykisser report` (or "Report a Problem" in the menu) opens a pre-filled GitHub issue with your system info
- 📦 Optional app bundles in the installer — Gaming, Streaming & Creation, Development, Office
- 🧩 `boykisser presets` — one-click Flatpak preset groups (Art, Social, Office, Music)
- 🌐 `boykisser browser` — pick Firefox, LibreWolf, Brave or Chromium
- 🧹 `boykisser debloat` — remove app groups you don't want
- 🔓 `boykisser autologin` — toggle passwordless login on installed systems
- 💾 Deja Dup for file backups + Timeshift snapshots before every `boykisser update` (once configured)
- 🌍 Language chooser in the live boot menu (German, French, Spanish, Italian, Portuguese, Polish, Dutch)
- 👋 First-login welcome checklist that walks you through setup
- 🌙 Night light (redshift) and weekly SSD TRIM out of the box
- 🚀 `boykisser kernel` installs the newest kernel from trixie-backports

## Build it yourself

You need `podman` (or `docker`). The ISO is built inside a Debian container, so
it works from any host.

```sh
./build.sh        # build the full ISO
./build.sh --netinstall   # build the slim ISO (pulls apps from the net on first boot)
./build.sh --fast # incremental: keep the chroot, regenerate the ISO only
./build.sh --clean        # deep clean, also wipes the package cache
./test-vm.sh      # boot it in QEMU
```

Rebuilds reuse the downloaded packages in `cache/` (much faster); pass
`--clean` to start truly from scratch. `--fast` is for bootloader/ISO-level
tweaks only — after changing package lists or chroot hooks, do a normal build.
The full build log is written to `build.log`.

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

### Automatic weekly rebuilds

The live image keeps itself fresh two ways:

- **CI:** [the build workflow](.github/workflows/build.yml) runs every Monday
  (03:00 UTC) and publishes a rolling `weekly-YYYYMMDD` prerelease with the
  current trixie kernel and security updates baked in.
- **Locally:** `tools/bk-autobuild.sh` rebuilds the ISO only when Debian ships
  a new `linux-image-amd64`. Wire it up as a weekly systemd user timer:

  ```sh
  ./tools/bk-autobuild.sh --install-timer   # enable the weekly timer
  ./tools/bk-autobuild.sh --check           # just ask if a rebuild is due
  ./tools/bk-autobuild.sh --force           # rebuild right now
  ./tools/bk-autobuild.sh --uninstall-timer # remove the timer
  ```

  State lives in `.autobuild-state`, logs in `autobuild.log` (both gitignored).

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

The live session logs in automatically; if you ever get a login prompt, the
live user is `boykisser` with password `live`.

## Layout

| Path | What |
| --- | --- |
| `auto/config` | live-build configuration |
| `config/package-lists/` | what gets installed |
| `config/hooks/normal/` | build-time setup (Flatpak, Steam, theme, ...) |
| `config/includes.chroot/` | files overlaid onto the image |
| `config/bootloaders/` | Boykisser boot splash + GRUB theme |
| `docker/Dockerfile.builder` | the build container |
| `tools/` | maintainer helpers (weekly auto-rebuild) |

## Error reporting

`boykisser report` (also "Report a Problem" in the app menu) opens a
[GitHub issue](https://github.com/taynotfound/BoykisserLinux/issues/new)
pre-filled with basic, non-personal system info (version, kernel, desktop,
GPU, failed services). Nothing is sent automatically — the user reviews and
submits the issue themselves.

## Known limitations

- The proprietary NVIDIA driver isn't in the live session (DKMS can't build
  against the live kernel) — install it after setup with `boykisser nvidia`.
- Picking KDE in the installer needs internet; XFCE installs fully offline.
- The netinstall ISO needs internet on first boot to fetch the heavy apps.

## Disclaimer

AI tooling helped build this OS. Everything is reviewed and tested by a human,
but please read the code before running it. Run `./README.sh` for the cute
version. :3

Debian is a trademark of Software in the Public Interest, Inc. Boykisser Linux
is an independent project and is not affiliated with or endorsed by Debian.
