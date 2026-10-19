---
title: Installing to disk
description: A walk through every step of the Boykisser Linux installer.
---

Boykisser Linux uses [Calamares](https://calamares.io/), the same friendly installer a lot of distros use. A typical install takes 10 to 15 minutes.

:::caution[Back up first]
If you're installing next to another OS, or onto a disk with anything you care about, back it up first. Partitioning mistakes can't be undone.
:::

## Start the installer

From the live session, use any of these:

- double-click **Install Boykisser Linux** on the desktop,
- the **Install to disk** tile in the Boykisser Center,
- `boykisser install` in a terminal.

## The steps

1. **Welcome, location and keyboard.** Pick your language, time zone and layout. There's a box to type in and test the keyboard.
2. **Desktop.** Keep **XFCE** (the default, installs offline) or pick **KDE Plasma**. Plasma is downloaded during the install, so it needs internet. It gets the pink accent, the Boykisser icons and wallpaper, and XFCE stays available on the login screen too.
3. **App bundles** (optional, tick any). These also download during install:

   | Bundle | Installs |
   | --- | --- |
   | Gaming | Steam, Lutris, GameMode, MangoHud |
   | Streaming & Creation | OBS Studio, Kdenlive, Audacity |
   | Development | git, build tools, Python (pip, venv), Node.js and npm, Podman |
   | Office | LibreOffice, Thunderbird, Evince |

   If there's no internet, bundles are skipped quietly. Install them later with `apt` or the Boykisser Center.

4. **Partitions.**
   - **Erase disk** is the simple option. Tick **Encrypt system** if you want full-disk encryption (you'll type the passphrase at every boot).
   - **Install alongside** shrinks an existing OS to make room. The boot menu will list both.
   - **Manual partitioning** for when you know exactly what you want. On UEFI machines you need an EFI system partition (FAT32, mounted at `/boot/efi`).
5. **Users.** Your name, a username, a computer name and a password. Ticking **Log in automatically** skips the login screen. You can change that later with `boykisser autologin`.
6. **Summary.** Check everything, then **Install**.

When it's done, tick **Restart now**, remove the USB stick when the screen goes black, and you're in.

## Netinstall and lite images

The **netinstall** image installs the base desktop from the stick and fetches the rest (OBS, VLC, codecs, Steam, VS Code and the Flatpak apps) on the **first boot** of the installed system, in the background. Stay connected for the first few minutes. Progress is logged to `/var/log/boykisser-firstboot.log`, and if it gets interrupted it simply tries again on the next boot.

The **lite** image installs the base desktop only. Add apps whenever you like.

## Next

Head to [First steps after installing](/docs/after-install/).
