---
title: Apps
description: What's preinstalled, and the easy ways to add or remove apps.
---

## What's already there

| | Full | Netinstall | Lite |
| --- | --- | --- | --- |
| Firefox ESR, Thunar, Mousepad, Ristretto, file roller, GParted, Disks | Yes | Yes | Yes |
| GNOME Software + Flathub, Timeshift, Déjà Dup backups | Yes | Yes | Yes |
| OBS Studio with virtual camera, VLC, multimedia codecs | Yes | first boot | |
| Steam, GameMode, MangoHud, Vulkan tools | Yes | first boot | |
| VS Code Insiders | Yes | first boot | |
| Printing (CUPS) | Yes | first boot | |
| Heroic, Discord (Flatpak) | first boot | first boot | |
| Flatseal, Gear Lever (Flatpak) | first boot | first boot | first boot |

"First boot" means the installed system downloads it in the background the first time it starts with internet. On the lite image, `boykisser apps` adds the full set whenever you want it.

## Three ways to install things

**Software (GNOME Software)** in the menu is the friendly store. It shows both Flathub apps and Debian packages.

**Flatpak** from [Flathub](https://flathub.org/) gets you the newest versions of desktop apps, sandboxed:

```sh
flatpak install flathub com.spotify.Client
```

Use **Flatseal** to see and change what each Flatpak app is allowed to access.

**apt** installs from Debian. Best for system tools and anything you use from a terminal:

```sh
sudo apt install htop
```

Rule of thumb: desktop apps from Flathub, everything else from apt.

**AppImages** work too. Open them with **Gear Lever** and it adds them to your menu and keeps them updated.

## App presets

`boykisser presets` (or **App presets** in the Boykisser Center) installs curated groups from Flathub with a checklist:

| Preset | Apps |
| --- | --- |
| `art` | Krita, GIMP, Inkscape |
| `social` | Discord, Signal, Telegram |
| `office` | LibreOffice, Obsidian, Thunderbird |
| `music` | Spotify, Strawberry |

Skip the checklist by naming them: `boykisser presets art music`.

## Pick a browser

Firefox ESR comes preinstalled. `boykisser browser` installs an alternative and offers to remove Firefox afterwards:

- **LibreWolf** (privacy-tuned Firefox, Flathub)
- **Brave** (Chromium with a built-in ad blocker, Flathub)
- **Chromium** (from Debian)

## Remove what you don't use

```sh
boykisser debloat
```

Shows a checklist of the app groups that are actually installed (gaming stack, OBS, VLC, VS Code, small games) and purges what you tick. It never touches the desktop, drivers or system parts. Run `boykisser cleanup` afterwards to free the space.

## The full app set on netinstall and lite

```sh
boykisser apps
```

Installs OBS with the virtual camera, VLC and codecs, the gaming stack, Steam, VS Code Insiders and the Flatpak apps. Safe to re-run; it skips what's already there.
