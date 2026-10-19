---
title: First steps after installing
description: Ten minutes of setup that make the rest of your time on Boykisser Linux nicer.
---

You're in. On first login the **welcome checklist** pops up once. It covers most of this page, and you can reopen it any time with `boykisser welcome`.

## 1. Update

```sh
boykisser update
```

This refreshes apt, upgrades everything, updates your Flatpak apps, checks for firmware updates, and updates the Boykisser tools themselves. It asks for your password because system updates need admin rights.

Security updates also install by themselves in the background (via `unattended-upgrades`), so a forgotten machine still gets patched.

## 2. Turn on Timeshift snapshots

[Timeshift](https://github.com/linuxmint/timeshift) takes system snapshots you can roll back to if an update or experiment breaks something. Open **Timeshift** from the menu and run the setup wizard once:

- **Snapshot type:** RSYNC works on every filesystem. Pick BTRFS only if you installed onto Btrfs.
- **Location:** any drive with some free space.
- **Schedule:** daily or weekly is plenty.

Once it's configured, `boykisser update` also takes a snapshot before every update.

Timeshift covers the *system*. For your own files (photos, documents) use **Backups** (Déjà Dup) in the menu, ideally to an external drive.

## 3. Graphics drivers

AMD and Intel graphics work out of the box. For NVIDIA cards, the open-source Nouveau driver gets you a desktop, but for games or CUDA you want the proprietary one:

```sh
boykisser nvidia
```

It checks your card, installs the driver plus the 32-bit libraries Steam needs, and asks you to reboot. With **Secure Boot** on, it also asks you to set a one-time password. On the next boot a blue *MOK management* screen appears: choose **Enroll MOK**, **Continue**, **Yes**, type that password, and reboot. That lets your firmware trust the driver.

## 4. Check your system

```sh
boykisser doctor
```

A read-only health check: disk space, broken packages, failed services, firewall, swap, network, GPU driver and whether the first-boot setup finished. It never changes anything, it just tells you what to look at.

## 5. Get your apps

- **Flatpak apps:** open **Software** and browse Flathub, or use [app presets](/docs/apps/#app-presets) for whole groups at once.
- **Pick a browser:** Firefox ESR is installed. `boykisser browser` offers LibreWolf, Brave or Chromium.
- **Don't want something?** `boykisser debloat` removes app groups like Steam or OBS.

More in [Apps](/docs/apps/).

## 6. Optional bits

- **Log in without a password:** `boykisser autologin on`. Only do this on a machine nobody else touches.
- **Newer kernel** for very new hardware: `boykisser kernel --install` (from Debian backports).
- **Night light** is on: the screen warms up in the evening. Click the redshift icon in the tray to pause it.
- **Printing:** most network printers show up on their own. Otherwise open **Print Settings** and click **Add**.
- **Firewall:** `ufw` is on and blocks incoming connections. If you run something that needs to be reachable, open its port, for example `sudo ufw allow 25565/tcp`.
