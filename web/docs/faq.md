# FAQ

## Is this a serious distro?

It's a hobby project by one person  -  but yes, it's daily-drivable. Under the pink paint it's completely normal Debian 13 (trixie), so anything that works on Debian works here.

## What are the system requirements?

Anything that runs Debian with XFCE comfortably: a 64-bit (amd64) CPU, ~2 GB RAM (4+ recommended), ~20 GB disk. Boots on both UEFI and legacy BIOS.

## How do updates work?

`boykisser update`  -  it takes a Timeshift snapshot first, then updates apt and Flatpak. Regular `sudo apt upgrade` works too, of course. Security updates come straight from Debian.

## Something broke. Where do I report it?

[GitHub issues](https://github.com/taynotfound/BoykisserLinux/issues), please. Run `boykisser report` first  -  it collects the system info that makes bugs actually fixable.

## Can I roll back a bad update?

Yes  -  Timeshift snapshots are set up out of the box, and `boykisser update` snapshots before touching anything. Open Timeshift and restore.

## Can I use KDE instead of XFCE?

Yep  -  pick **KDE Plasma** in the installer and it gets the same pink theming.

## Does it phone home / have telemetry?

No. It's Debian plus theming and helper scripts. Nothing is collected.

## Can I remove the pink?

You *can* (`boykisser theme` flips light/dark, and standard XFCE/KDE settings do the rest)  -  but then why are you here :3

## Where does the mascot come from?

Boykisser is a community meme character. This project is unofficial fan work, made with love.

## How do I add or remove apps?

Three ways, pick your vibe:

- **apt**  -  the classic Debian package manager. `sudo apt install <package>` / `sudo apt remove <package>`. Huge repo, rock solid.
- **Flatpak**  -  sandboxed apps from [Flathub](https://flathub.org/). Already set up  -  just `flatpak install flathub <app-id>`. Great for newer app versions.
- **Boykisser presets**  -  open **Boykisser Center** and hit the Presets tab for curated bundles (gaming, creative, dev, etc.) that install everything in one click.

## Is there an AUR equivalent?

No  -  and that's fine. Flatpak covers the vast majority of what the AUR is used for, with the bonus of actually being sandboxed. For newer package versions that haven't hit the main repo yet, check [Debian Backports](https://backports.debian.org/) (`sudo apt install -t trixie-backports <package>`). If you're missing something specific, open an issue and we'll look at it.

## Can I run it in a VM?

Yes, works great:

- **VirtualBox**  -  install Guest Additions after setup (`sudo apt install virtualbox-guest-x11`) for shared clipboard, drag-and-drop and proper display scaling.
- **VMware**  -  install VMware Tools (`sudo apt install open-vm-tools-desktop`) for the same perks.
- **QEMU/KVM**  -  works well out of the box with virtio drivers. The `spice-vdagent` package adds clipboard sync if you're using a SPICE display.

Allocate at least 2 GB RAM and 2 CPU cores for a comfortable experience.

## My fonts look ugly

Run `boykisser doctor` first  -  it'll catch any misconfigured font settings and fix them in one go. If they still look off, open **XFCE Appearance → Fonts** and enable hinting (try *Slight* or *Full*) and sub-pixel rendering. The difference is night and day on most monitors.

## How do I enable the firewall?

`ufw` is already installed, it just needs switching on:

```bash
sudo ufw enable
```

That's it  -  sensible defaults, all incoming blocked, all outgoing allowed. Check status with `sudo ufw status verbose`.

## Can I use this as a server?

Technically yes, nothing stops you  -  it's Debian underneath. But it's not what it's for, and you'd be carrying a whole pink XFCE desktop along for the ride. Just use [Debian](https://www.debian.org/) proper; it's the same packages without the baggage.

## Will it work on a laptop?

Yes  -  laptops are a first-class use case. TLP is preconfigured out of the box for sensible power management, suspend/resume works, and closing the lid suspends automatically. Battery life should be on par with any other Debian-based distro. If your Wi-Fi card needs a non-free firmware blob, the installer will pick it up.
