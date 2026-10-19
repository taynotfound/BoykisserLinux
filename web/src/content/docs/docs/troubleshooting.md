---
title: Troubleshooting
description: Fixes for the most common problems, and how to report the rest.
---

First step for anything: run `boykisser doctor`. It points at most problems on its own.

## Booting

**The stick doesn't show up or won't start.** Write the ISO directly (no Ventoy), turn off Secure Boot, and on old machines enable Legacy/CSM. See [Old hardware](/docs/old-hardware/).

**I land at a `grub>` prompt.** Almost always Ventoy or old firmware. Use the **Lite** ISO, written with `dd` or Rufus in DD mode.

**Black screen or frozen splash.** Pick **Live system (failsafe)** in the boot menu. If that works, your GPU needs `nomodeset`: on an installed system press <kbd>e</kbd> at the boot menu, add `nomodeset` to the `linux` line and boot with <kbd>F10</kbd>.

**A login screen appears in the live session.** User `live`, password `live`.

## Installer

**KDE or the app bundles didn't install.** Both need internet during the install. Without it, the installer quietly keeps XFCE and skips the bundles so the install still works. Afterwards:

```sh
sudo apt install kde-plasma-desktop   # then pick Plasma on the login screen
```

**"Install alongside" isn't offered.** The installer couldn't find space it can shrink. Free some space in Windows first (Disk Management → Shrink Volume), or use manual partitioning.

## After installing

**Netinstall apps never showed up.** They download on first boot. Check `/var/log/boykisser-firstboot.log`. It retries on every boot until it works, or run it yourself: `sudo boykisser-postinstall-apps`.

**No sound.** Open **Audio Mixer** (right-click the volume icon) and pick the right output device on the **Output Devices** tab. On new laptops, run `boykisser update` and reboot; it may be a firmware fix.

**Wi-Fi card not found.** Check `boykisser doctor` and `lspci -nnk | grep -A3 -i net`. Newer chips may need `boykisser kernel --install`.

**NVIDIA driver installed but not loading.** With Secure Boot on you have to enrol the key on the blue *MOK management* screen after the reboot. Missed it? Run `sudo mokutil --import /var/lib/dkms/mok.pub`, set a password and reboot.

**The Boykisser look is gone.** `boykisser theme dark` (or `light`) and `boykisser wallpaper --force` put it back.

**A Flatpak app can't see my files.** Open **Flatseal**, pick the app and allow the folder under **Filesystem**.

**An update broke something.** If Timeshift is set up: open it, pick the snapshot from before `boykisser update`, and **Restore**. If the desktop doesn't start any more, boot the live stick and run Timeshift from there.

## Installed from an older ISO?

Images built before October 2026 had installer bugs that never surfaced as errors:

- **The live account stayed on the installed system.** It's called `user`, its password is the public `live`, and it can use `sudo`. `boykisser update` (tools 2.0 or newer) locks it automatically if the password is still `live`. To check by hand: `sudo passwd -S user`. To remove it for good: `sudo deluser --remove-home user`.
- **Steam, Lutris and the NVIDIA driver couldn't be installed**, because only Debian's `main` and `non-free-firmware` sections were enabled. `boykisser update` (tools 2.0.1 or newer) adds `contrib` and `non-free`.
- **Picking KDE or app bundles in the installer did nothing**, and the live packages weren't removed (so automatic security updates stayed off). Install what you wanted afterwards (`sudo apt install kde-plasma-desktop`), then run `sudo boykisser-live-cleanup /` once to finish the cleanup.

## Reporting a bug

```sh
boykisser report
```

Or **Report a Problem** in the menu. It opens a GitHub issue pre-filled with your version, kernel, desktop, RAM, GPU and failed services, nothing personal. You can edit everything before submitting. Use `--no-sysinfo` to leave the system info out.

Quick questions are faster on [Discord](https://discord.gg/3ZpwE9PPfP).
