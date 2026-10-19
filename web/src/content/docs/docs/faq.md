---
title: FAQ
description: Common questions about Boykisser Linux.
---

### Is this a serious distro?

The name is a meme, but I use it every day. It's Debian 13 (trixie) with a lot of setup done for you, so anything that works on Debian works here and Debian's documentation applies.

### What do I need to run it?

A 64-bit (amd64) PC, 2 GB of RAM (4 GB or more is comfortable), and 20 GB of disk. UEFI and legacy BIOS both work.

### Is it stable?

As stable as Debian stable, because that's what it is. Boykisser adds themes, configs and helper scripts on top; it doesn't replace Debian packages.

### How do updates work?

`boykisser update` updates everything, including the Boykisser tools. Security updates also install automatically in the background. Regular `sudo apt upgrade` works too.

### How often are new ISOs released?

Every week, with the current kernel and security fixes. You don't need to reinstall to stay current, though. An installed system updates itself.

### Does it collect any data?

No. There's no telemetry and no account. The only thing Boykisser itself contacts is GitHub, to look for tool updates when you run `boykisser update`.

### Can I use KDE Plasma instead of XFCE?

Yes. Pick **KDE Plasma** in the installer (needs internet). It gets the pink accent, the icons and the wallpapers. You can switch between Plasma and XFCE on the login screen.

### Will it work on my laptop?

Very likely. It ships broad firmware for Wi-Fi, graphics and laptop audio, uses power-profiles-daemon for battery modes, and suspends when you close the lid. Try the live session first to be sure.

### Can I dual-boot with Windows?

Yes. Choose **Install alongside** in the installer and Boykisser adds itself to the boot menu next to Windows. Back up first, and turn off Fast Startup in Windows so it doesn't lock the disk.

### Can I run it in a VM?

Yes. Give it 4 GB of RAM and 2 CPU cores. In VirtualBox, install `virtualbox-guest-x11` from contrib for clipboard and resizing. In VMware, `open-vm-tools-desktop`. With QEMU/KVM it works as is, and `spice-vdagent` adds clipboard sharing.

### Is there something like the AUR?

Flatpak covers most of what people use the AUR for, sandboxed. For newer versions of Debian packages, try [backports](https://backports.debian.org/Instructions/): once the backports source is enabled, `sudo apt install -t trixie-backports <package>`. (`boykisser kernel --install` enables it as a side effect.)

### Can I get rid of the pink?

`boykisser theme light` gets you a softer look, and **Appearance** lets you pick any theme. But then why are you here :3

### Where does the mascot come from?

Boykisser is a community meme character. This project is unofficial fan work, made with love.

### Who makes it?

Me, [Tay](https://taymaerz.de). It's a hobby project. Pull requests are welcome on [GitHub](https://github.com/taynotfound/BoykisserLinux), and you can say hi on [Discord](https://discord.gg/3ZpwE9PPfP).
