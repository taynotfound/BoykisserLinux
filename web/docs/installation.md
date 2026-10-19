# Installing to disk

Boykisser Linux uses the [Calamares](https://calamares.io/) installer  -  the same friendly one many distros use.

## Starting the installer

From the live session, either:

- click **Install to disk** in the Boykisser Center,
- use the welcome screen entry, or
- run `boykisser install` in a terminal.

## What you'll be asked

1. **Language, region, keyboard**  -  the usual.
2. **Desktop choice**  -  keep the default **XFCE**, or pick **KDE Plasma**. Plasma gets the same pink treatment automatically.
3. **App bundles** *(optional, multi-select)*  -  tick any of:
   - 🎮 **Gaming**  -  Steam, gaming bits
   - 🎥 **Streaming**  -  OBS with virtual camera
   - 💻 **Development**  -  VS Code and friends
   - 📄 **Office**  -  LibreOffice, Thunderbird, Evince
4. **Partitioning**  -  "Erase disk" is the simple path; manual partitioning works too. Full-disk encryption is available on the erase option.
5. **Your user**  -  name, password, whether to log in automatically.

Then it copies everything over  -  a few minutes  -  and asks to reboot.

## After the first boot

- Run `boykisser update` once (it snapshots with Timeshift first, then updates apt + Flatpak).
- Want automatic login later? `boykisser autologin` or the toggle in the Boykisser Center.
- Nvidia card? `boykisser nvidia` sets up the proprietary driver.

## Netinstall notes

The netinstall ISO needs a working internet connection during install (ethernet is easiest). Everything else is identical.

---

## See also

- [Getting started](#getting-started)
- [First steps after install](#after-install)
- [Old hardware](#old-hardware)
- [FAQ](#faq)
