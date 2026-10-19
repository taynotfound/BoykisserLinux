---
title: Gaming
description: Steam, Proton, Heroic, controllers and getting the most FPS out of your machine.
---

Steam, GameMode and MangoHud are on the full ISO with 32-bit libraries enabled, and Heroic arrives as a Flatpak on first boot. On netinstall they download on first boot. On lite, run `boykisser apps`, or tick the **Gaming** bundle in the installer.

## NVIDIA? Do this first

```sh
boykisser nvidia
```

The default open-source driver is fine for the desktop, but the proprietary one makes a huge difference in games. See [after installing](/docs/after-install/#3-graphics-drivers) for the Secure Boot step.

## Steam and Proton

Open **Steam** from the menu. The first launch downloads the Steam client itself, which takes a minute.

Proton runs Windows games and is on by default for games Valve has tested. For everything else:

1. **Steam → Settings → Compatibility**
2. Turn on **Enable Steam Play for all other titles**
3. Restart Steam

Look your game up on [ProtonDB](https://www.protondb.com/) to see how well it runs and which launch options people use. Platinum and Gold mean it just works.

:::tip[A game won't start?]
- Right-click it, **Properties → Compatibility**, and force a different Proton version. New games often want **Proton Experimental**, old ones sometimes an older Proton.
- [ProtonUp-Qt](https://flathub.org/apps/net.davidotek.pupgui2) installs **GE-Proton**, a community build with extra fixes.
- Add `PROTON_LOG=1 %command%` as a launch option. The log lands in `~/steam-<appid>.log`.
:::

Games with kernel anti-cheat only work if the developer enabled Linux support. ProtonDB tells you.

## Epic, GOG and Amazon: Heroic

**Heroic Games Launcher** handles Epic, GOG and Amazon libraries, with Proton built in. Log in, install, play.

For everything else (Battle.net, emulators, old installers), [Lutris](https://lutris.net/) is in the Gaming installer bundle, or `sudo apt install lutris`.

## MangoHud: FPS overlay

Shows FPS, frame times, CPU and GPU load and temperatures. In Steam, set the game's launch options to:

```
mangohud %command%
```

<kbd>Right Shift</kbd>+<kbd>F12</kbd> toggles it in-game. Configure it in `~/.config/MangoHud/MangoHud.conf`.

## GameMode

Tells the system to prioritise the game while it runs (CPU governor, scheduling, I/O). Combine it with MangoHud:

```
gamemoderun mangohud %command%
```

## Controllers

Xbox, PlayStation, Switch Pro and most generic pads work over USB or Bluetooth. Pair Bluetooth controllers from the Bluetooth icon in the tray (PlayStation: hold **Share** + **PS** until the light flashes). Steam's **Settings → Controller** adds remapping for any of them.

## Stream it

OBS Studio is ready, including the **Virtual Camera** button, which shows up as *OBS Virtual Camera* in Discord, browsers and call apps.
