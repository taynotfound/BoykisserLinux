---
title: Theming
description: Light and dark mode, wallpapers, and making the desktop your own.
---

Out of the box you get a dark desktop (Adwaita Dark), the pink **Tela Circle** icons, a Boykisser start button, a desktop widget and a matching boot menu, splash screen and login screen.

## Light or dark

```sh
boykisser theme light
boykisser theme dark
```

Or click **Boykisser Theme Toggle** in the menu, or the tile in the Boykisser Center. It switches the app theme, the icon set, the wallpaper and the preference that GTK 4 / libadwaita apps follow. On KDE Plasma it switches the Breeze colour scheme with the pink accent.

Your choice is remembered (in `~/.config/boykisser/mode`).

## Wallpapers

Six Boykisser wallpapers live in `/usr/share/backgrounds/boykisser/`: Nightfall (the dark default), Daydream (the light default), Synthwave, Drops, Paws and Kiss. They're drawn from code in `branding/wallpapers/make.py`, so anyone can tweak and re-render them.

```sh
boykisser wallpaper --next    # cycle to the next one
boykisser wallpaper --force   # put the theme's default on every monitor
```

Or right-click the desktop, **Desktop Settings**, and pick any image you like. Your choice sticks: at login Boykisser only fills in monitors that don't have a wallpaper yet (handy when you plug in a new screen).

## XFCE panel and widget

- **Panel:** right-click it, **Panel → Panel Preferences**. Unlock it on the **Display** tab to move it, change its size, or add and remove items on the **Items** tab.
- **Desktop widget:** the pink system monitor on the right is [Conky](https://github.com/brndnmtthws/conky). Its config is `~/.config/conky/boykisser.conkyrc`. To turn it off, open **Session and Startup → Application Autostart** and untick **Boykisser Conky**.
- **Night light:** redshift warms the screen between 19:30 and 06:30. Change the times or strength in `~/.config/redshift.conf`, or pause it from its tray icon.

## Other themes and icons

**Appearance** in the menu has a **Style** and an **Icons** tab. Install more from Debian or [gnome-look.org](https://www.gnome-look.org/):

```sh
sudo apt install papirus-icon-theme materia-gtk-theme
```

Window borders are under **Window Manager → Style**.

Qt apps (VLC, OBS) follow the GTK theme automatically on XFCE, light and dark included. To style them separately instead, set `QT_QPA_PLATFORMTHEME=qt6ct` in `~/.xsessionrc` and use **Qt6 Settings**.

## Terminal greeting

New terminals show a pink `fastfetch` system summary. Its config is `~/.config/fastfetch/config.jsonc`. To turn it off just for you:

```sh
touch ~/.config/boykisser/no-fetch
```

## Going back

Run `boykisser theme dark` (or `light`) to put the Boykisser look back after experimenting, then `boykisser wallpaper --force` for the wallpaper.
