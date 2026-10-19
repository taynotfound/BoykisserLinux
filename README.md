<div align="center">
  <img src="config/includes.chroot/usr/share/boykisser/start.png" alt="Boykisser Linux mascot" width="160">

  <h1>Boykisser Linux :3</h1>

  <p><strong>Debian, but make it pink.</strong><br>
  A gay, gimmicky and genuinely daily-drivable Debian 13 distro with XFCE or KDE Plasma.</p>

  <p>
    <a href="https://github.com/taynotfound/BoykisserLinux/releases/latest"><img alt="Latest release" src="https://img.shields.io/github/v/release/taynotfound/BoykisserLinux?style=flat-square&color=ff5fa2&label=release"></a>
    <a href="https://github.com/taynotfound/BoykisserLinux/actions/workflows/build.yml"><img alt="ISO build" src="https://img.shields.io/github/actions/workflow/status/taynotfound/BoykisserLinux/build.yml?style=flat-square&label=build"></a>
    <a href="https://discord.gg/3ZpwE9PPfP"><img alt="Discord" src="https://img.shields.io/badge/discord-join-ff5fa2?style=flat-square&logo=discord&logoColor=white"></a>
  </p>

  <p>
    <a href="https://boykisser.taymaerz.de"><b>Website</b></a> ·
    <a href="https://github.com/taynotfound/BoykisserLinux/releases/latest"><b>Download</b></a> ·
    <a href="https://boykisser.taymaerz.de/docs/getting-started/"><b>Docs</b></a> ·
    <a href="https://discord.gg/3ZpwE9PPfP"><b>Discord</b></a>
  </p>

  <img src="web/src/assets/screenshots/xfce.png" alt="The Boykisser Linux XFCE desktop" width="820">
</div>

## What you get

Plain Debian 13 (trixie) under the paint, with the setup work already done:

- **Pink from the first frame.** Boot menu, Plymouth splash, Calamares installer, desktop, Tela Circle pink icons and six wallpapers. One click flips light and dark.
- **XFCE or KDE Plasma.** XFCE is the default and installs offline; pick Plasma in the installer and it gets the same treatment.
- **Gaming.** Steam with 32-bit libraries, Heroic, GameMode, MangoHud, and `boykisser nvidia` for the proprietary driver (Secure Boot included).
- **Streaming.** OBS Studio with a working virtual camera.
- **Flatpak ready.** Flathub, GNOME Software, Flatseal and Gear Lever.
- **Boykisser Center.** A GTK control panel for updates, app presets, drivers, kernels, a health check and a bug reporter.
- **Sensible defaults.** ufw firewall, automatic security updates, zram swap, weekly TRIM, firmware updates, night light, printing.
- **No telemetry.** No accounts, nothing phones home.
- **Old hardware too.** A Lite ISO for BIOS-only machines.

## Download

New ISOs are built every Monday with the current Debian kernel and security updates.

| Flavour | Size | For |
| --- | --- | --- |
| **Full** | ~2.6 GB | Most people. Everything included, installs offline. |
| **Netinstall** | ~1.5 GB | Smaller download; big apps download on first boot. |
| **Lite** | ~1.5 GB | Pre-2012, BIOS-only machines. |

Grab them from the [latest release](https://github.com/taynotfound/BoykisserLinux/releases/latest). Each release links an Internet Archive mirror and torrent with single-file ISOs. On GitHub the full ISO is split into parts:

```sh
cat boykisser-linux-amd64.iso.part* > boykisser-linux-amd64.iso
sha256sum --ignore-missing -c SHA256SUMS
```

Flash it with [Etcher](https://etcher.balena.io/), [Rufus](https://rufus.ie/) (DD mode) or `dd`, boot it, and double-click **Install Boykisser Linux**. The live session logs in by itself (user `user`, password `live`). The [getting started guide](https://boykisser.taymaerz.de/docs/getting-started/) has the details.

## This repository

Everything lives here: the OS, its tools and the website.

| Path | What |
| --- | --- |
| [`auto/`](auto), [`config/`](config) | The live-build definition of the ISO: package lists, build hooks, files overlaid onto the system, boot menu theme |
| [`tools/`](tools) | `boykisser-*` scripts and the Boykisser Center, packaged as `.deb`s (see [tools/README.md](tools/README.md)) |
| [`web/`](web) | [boykisser.taymaerz.de](https://boykisser.taymaerz.de), Astro + Starlight (see [web/README.md](web/README.md)) |
| [`docker/`](docker) | The Debian container the ISO is built in |
| [`scripts/`](scripts) | Maintainer helpers: manual release tag, local weekly auto-rebuild |
| `build.sh`, `test-vm.sh` | Build the ISO, boot it in QEMU |

Every ISO build packages `tools/` from the same commit, so the image and its tools never drift apart. Installed systems pick up newer tools from `tools-v*` releases through `boykisser update`.

## Build it yourself

You need `podman` or `docker` and about 30 GB of disk. The build runs in a privileged Debian container, so any host distro works.

```sh
./build.sh                 # full ISO
./build.sh --netinstall    # slim ISO
./build.sh --lite          # BIOS-only ISO
./build.sh --fast          # boot menu/ISO tweaks only: keep the built system
./build.sh --clean         # from scratch, including the package cache

./test-vm.sh               # boot it (UEFI; --bios for legacy)
./test-vm.sh --disk        # with a virtual disk, to try the installer
./test-vm.sh --installed   # boot what you installed
```

More in the [building docs](https://boykisser.taymaerz.de/docs/building/).

## Releases

- **ISOs:** CI tags `vM.YY.N` every Monday (or run [`scripts/bump_version.sh`](scripts/bump_version.sh)) and builds all three flavours. They're published to GitHub Releases, mirrored to the Internet Archive, and announced on Discord.
- **Tools:** bump [`tools/VERSION`](tools/VERSION) and push a matching `tools-vX.Y.Z` tag.

## Contributing and bugs

Bug reports are easiest from the OS itself: `boykisser report` (or **Report a Problem** in the menu) opens a GitHub issue pre-filled with non-personal system info. Pull requests are welcome; for anything bigger, say hi on [Discord](https://discord.gg/3ZpwE9PPfP) first.

## A note on AI

AI tools helped build this OS. Every change is reviewed and tested by a human, but be your own kitty and read the code before you run it. :3

---

<sub>Boykisser is a community meme character; this is unofficial fan work. Not affiliated with Debian. Debian is a trademark of Software in the Public Interest, Inc.</sub>
