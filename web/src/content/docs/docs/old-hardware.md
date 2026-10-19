---
title: Old hardware
description: Getting Boykisser Linux onto pre-2012 machines with crusty BIOS firmware.
---

Boykisser Linux runs fine on most machines from around 2010 on. Older ones mostly fail at *booting*, not running, so there's a special image for them.

## Which ISO?

| Your machine | Use |
| --- | --- |
| UEFI, or BIOS from roughly 2012 on | **Full** or **Netinstall** |
| Pre-2012, BIOS only, or you end up at a `grub>` prompt | **Lite** |

The **Lite** image:

- boots with plain syslinux (BIOS only, no UEFI hybrid), which old firmware chainloads happily,
- starts in safe graphics mode (`nomodeset`), so ancient GPUs show a picture,
- skips the heavy apps and Recommends, so it's lighter on RAM and disk,
- only installs the small Flatpak helpers on first boot.

You need a **64-bit** CPU. 32-bit-only machines aren't supported.

## Writing the stick

:::danger[Don't use Ventoy for this]
Ventoy adds its own boot chain that old firmware often rejects. That's the most common reason for a `grub>` prompt. Write the ISO directly.
:::

- **Linux:** `sudo dd if=boykisser-linux-lite-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync`
- **Windows:** [Rufus](https://rufus.ie/). Partition scheme **MBR**, target **BIOS (or UEFI-CSM)**, and choose **DD Image mode** when asked.
- **macOS:** `sudo dd if=boykisser-linux-lite-amd64.iso of=/dev/rdiskN bs=4m` (find `diskN` with `diskutil list`, unmount it first).

## Firmware settings

If it still won't boot:

1. Enter setup (usually <kbd>F2</kbd>, <kbd>Del</kbd> or <kbd>Esc</kbd> at power-on).
2. Set **Boot mode** to **Legacy**, or enable **CSM**.
3. Turn off **Secure Boot** if it's there.
4. Put the USB stick first in the boot order, save and restart.

## Hardware notes

- **Intel graphics from 2nd gen Core (Sandy Bridge) on** works well with normal graphics.
- **Black screen after installing?** The live stick uses safe graphics, the installed system doesn't. At the boot menu press <kbd>e</kbd>, add `nomodeset` to the end of the line starting with `linux`, and boot with <kbd>F10</kbd>. If that fixes it, make it permanent by adding `nomodeset` to `GRUB_CMDLINE_LINUX_DEFAULT` in `/etc/default/grub` and running `sudo update-grub`.
- **Very old NVIDIA cards** use Nouveau. The proprietary driver from `boykisser nvidia` doesn't support cards older than roughly 2014.
- **2 GB of RAM** is the realistic minimum. Close the browser before installing.

## If nothing boots

Some machines just won't start any modern ISO. Two ways out:

- Boot another live system that does work (like an old Debian or Ubuntu stick), and install plain Debian 13 with XFCE from there. Then add the Boykisser tools on top, see [boykisser-tools](/docs/boykisser-tools/).
- Keep a [SystemRescue](https://www.system-rescue.org/) stick around for repairs. It boots on almost anything.
