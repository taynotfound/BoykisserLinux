# Getting started

Welcome to Boykisser Linux :3  -  a pink Debian 13 (trixie) spin with a fully themed XFCE desktop.

![Boykisser Linux GRUB boot menu](../assets/screenshots/grub.png)

![Boykisser Linux XFCE desktop](../assets/screenshots/xfce.png)

## Grab an ISO

There are three flavours on the [releases page](https://github.com/taynotfound/BoykisserLinux/releases/latest):

- **Full ISO**  -  everything preinstalled, works offline. The one to pick if you're not sure.
- **Netinstall ISO**  -  much smaller download, pulls packages from the internet during install.
- **Lite ISO**  -  stripped-down image for old hardware, BIOS-only (no UEFI). If you're reviving a decade-old laptop, start here.

## Write it to a USB stick

Any of the usual tools work:

```bash
# Linux / macOS  -  replace sdX with your stick, this ERASES it!
sudo dd if=boykisser-linux-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

On Windows, use [Rufus](https://rufus.ie/) or [balenaEtcher](https://etcher.balena.io/)  -  pick "DD mode" if Rufus asks.

## Boot it

Boot from the stick (usually F12 / F11 / Esc for the boot menu). Both UEFI and legacy BIOS work. The boot menu also has a **language submenu** if you want the live session in German, French, Spanish, Italian, Portuguese, Polish or Dutch.

The live session logs in automatically. A welcome screen greets you with a little checklist of things to try  -  including installing to disk when you're ready.

## First things to poke at

- **Boykisser Center**  -  the pink control panel in the menu. One place for updates, themes, presets and more.
- `boykisser welcome`  -  the welcome checklist, any time.
- `boykisser doctor`  -  a quick health check of the system.

## The live session

The live session runs entirely in RAM  -  nothing you do is written to disk, so you can poke around freely without any risk to whatever's already on the machine. It's a safe sandbox.

**Credentials:**

| | |
|---|---|
| Username | `user` |
| Password | `live` |

Login with username `user` and password `live`. Everything else logs in automatically after install.

Feel free to browse files, open apps, change settings, break things  -  it all evaporates on reboot. Great for testing compatibility before committing to an install.

**When you're ready to install**, double-click the **Install Boykisser Linux** icon on the desktop, or run:

```bash
sudo calamares
```

The installer walks you through partitioning, locale, and user setup. A typical install takes about 10–15 minutes.

---

## See also

- [Downloading & verifying](#downloading)
- [Installing to disk](#installation)
- [First steps after install](#after-install)

> **Tip:** Keep a [SystemRescue](https://www.system-rescue.org/) USB around. Invaluable when things go wrong.