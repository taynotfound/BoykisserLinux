# First steps after installing

Congrats, you booted in. The pink is loading. Here's what to do before you start actually using the thing.

---

## 1. Update everything first

Before anything else, pull in the latest packages. This fixes bugs, patches security holes, and makes sure you're not working with week-old software.

```bash
boykisser update
```

This runs a full system update under the hood (`apt update && apt full-upgrade`) plus refreshes any Boykisser-specific configs. Do this before you install anything else  -  you want a fresh base.

---

## 2. Check if everything looks healthy

```bash
boykisser doctor
```

This scans for common issues: missing drivers, broken package states, misconfigured services. If something's wrong, it'll tell you what and usually how to fix it. Run it after the update, and anytime something feels off.

---

## 3. Set up autologin (optional)

If you're the only person using this machine and you don't need a login screen, you can skip it entirely:

1. Open **Session and Startup** from the app menu (or search "autologin")
2. Go to **Autologin** tab
3. Tick **Automatically login as** and pick your user

Or if you prefer the terminal:

```bash
sudo nano /etc/lightdm/lightdm.conf
```

Find (or add under `[Seat:*]`):
```
autologin-user=yourusername
autologin-user-timeout=0
```

Save, reboot. Greeter gone.

> **Why bother?** Saves 5 seconds on every boot. Worth it on a personal machine, skip it if other people use the computer.

---

## 4. Nvidia GPU? Run this.

Open-source Nouveau drivers work fine for basic stuff, but if you have an Nvidia card and want actual gaming performance or CUDA, you need the proprietary drivers:

```bash
boykisser nvidia
```

This detects your card, installs the right driver version, and sets it up properly. It'll ask you to reboot after. Do it.

> **Why not just use the default drivers?** Nouveau is open-source and safe, but it doesn't support hardware acceleration properly on Nvidia cards. Games will be slow, video decoding won't work, and you might get screen tearing. The proprietary driver fixes all of that.

---

## 5. Bluetooth

Bluetooth is installed and the service is running. To connect a device:

1. Click the Bluetooth icon in the system tray
2. Turn on Bluetooth if it's off
3. Put your device in pairing mode
4. It should show up  -  click it, confirm the PIN if asked

For headphones, once paired they reconnect automatically. If audio doesn't switch over when you connect, right-click the volume icon → **Audio Mixer** → set your output device.

If the tray icon isn't showing, run:
```bash
blueman-applet &
```

---

## 6. Printing

CUPS (the Linux printing system) is already installed and configured. To add your printer:

1. Open a browser and go to: `http://localhost:631`
2. Click **Administration** → **Add Printer**
3. Follow the steps  -  most modern printers are detected automatically

Or use the GUI: search "Printers" in the app menu.

> **Why the browser?** CUPS has a built-in web interface that's weirdly nicer than most GUI printer tools. It works on any printer that's ever been made in the last 15 years.

If your printer is on the network (WiFi or Ethernet), it'll usually show up automatically without you doing anything.

---

## 7. Set up Timeshift (backups)

Timeshift takes snapshots of your system so you can roll back if something breaks. This is not optional  -  set it up now, thank yourself later.

```bash
timeshift-gtk
```

First run will ask you to configure it:
- **Snapshot type**: RSYNC (works everywhere, recommended)
- **Snapshot location**: pick a drive with space  -  ideally not your main drive, but internal is fine
- **Schedule**: Weekly is a good default

Once configured, Timeshift runs automatically. If you ever do something catastrophic (yes, it happens to everyone), you just boot from a live USB, open Timeshift, and restore.

---

## 8. Flatpak is already set up

Flatpak is ready to go  -  Flathub is configured as a source. You can install apps directly from [flathub.org](https://flathub.org) or from the terminal:

```bash
flatpak install flathub com.spotify.Client
flatpak run com.spotify.Client
```

Flatpak apps are sandboxed and don't mess with your system packages. Good for stuff like Spotify, Discord, Obsidian, etc. where you want the latest version without touching apt.

---

## 9. Installing your own apps

You've got a few options:

**Via apt (Debian packages):**
```bash
sudo apt install firefox-esr
```
Best for system tools, dev stuff, anything in the Debian repos.

**Via Flatpak:**
```bash
flatpak install flathub org.mozilla.firefox
```
Best for desktop apps where you want a newer version or sandboxing.

**Via the software center:**
Search "Software" in the app menu. It's a GUI wrapper over both  -  fine for browsing, slower than the terminal.

> When in doubt, try apt first. If it's not there or the version is too old, try Flatpak.

---

That's the basics covered. You've got a updated system, working drivers, backups configured, and apps ready to install. You're good to go.

If anything feels broken, `boykisser doctor` is your first call.

---

## See also

- [Terminal basics](#terminal-basics)
- [Theming & customization](#theming)
- [Presets & apps](#presets-and-apps)
- [The boykisser CLI](#boykisser-cli)
