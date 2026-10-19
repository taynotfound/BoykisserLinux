# Gaming

Boykisser Linux is a daily driver, and daily drivers play games. Here's how to get everything running.

---

## Steam

If you installed the **full ISO**, Steam is already there. Open it from the app menu, log in, done.

If you're on the minimal ISO or you removed it for some reason:

```bash
boykisser preset gaming
```

This installs Steam plus a handful of gaming utilities (MangoHud, GameMode, Lutris, wine). One command, everything ready.

---

## Windows games via Proton

Proton is Steam's compatibility layer that lets you play Windows games on Linux. Most games Just Work. Here's how to turn it on:

1. Open Steam
2. Go to **Steam** (top-left menu) → **Settings** → **Compatibility**
3. Check **"Enable Steam Play for all other titles"**
4. Pick a Proton version (Proton Experimental or the latest numbered release is usually fine)
5. Restart Steam
6. Windows games now show up in your library  -  install and play

For a specific game, you can also: right-click the game → **Properties** → **Compatibility** → force a specific Proton version.

Check [ProtonDB](https://www.protondb.com) to see if your game works and what settings others use. Gold or Platinum rating = plays great. Bronze = might need tweaks.

<details>
<summary>🔧 Proton troubleshooting tips</summary>

**Game doesn't launch at all:**
- Check [ProtonDB](https://www.protondb.com) for your specific game  -  someone has probably already figured it out
- Try forcing a different Proton version: right-click game → Properties → Compatibility → select a version. Older games sometimes work better on older Proton; new games often need Proton Experimental.
- Try **Proton-GE** (community build with extra fixes):
  ```bash
  # Install ProtonUp-Qt to manage GE versions
  flatpak install flathub net.davidotek.pupgui2
  ```

**Game launches but crashes:**
- Enable Proton logging to see what's going wrong. In Steam, right-click the game → Properties → **Launch Options**:
  ```
  PROTON_LOG=1 %command%
  ```
  Log file appears at `~/steam-<appid>.log`. Search the log for `err` or `fault`.

**Bad performance:**
- Make sure GameMode is running (see below)
- If you have an Nvidia GPU and haven't run `boykisser nvidia`, do that first  -  it makes a massive difference
- Some games need `DXVK_ASYNC=1 %command%` in launch options to reduce stuttering on first run

**Anti-cheat not working:**
Online games with kernel-level anti-cheat (EAC, BattlEye) need to explicitly support Linux. Check ProtonDB  -  if the game is rated Borked with comments about anti-cheat, it's a the game's decision, not a Proton bug. Some games have enabled Linux support (Apex, Deep Rock, Elden Ring)  -  check the game's store page.

</details>

---

## Lutris  -  non-Steam games

Lutris handles everything else: GOG, Epic, old games, emulators, Battle.net.

```bash
sudo apt install lutris
# or
flatpak install flathub net.lutris.Lutris
```

Open Lutris, click the `+` to add a game, or search the Lutris website for your game  -  there are community-maintained install scripts for hundreds of titles that handle all the wine configuration automatically.

For **GOG games** specifically, Heroic Games Launcher is cleaner:
```bash
flatpak install flathub com.heroicgameslauncher.hgl
```

---

## MangoHud  -  FPS overlay

MangoHud puts a performance overlay on screen: FPS, frametime, CPU/GPU usage, temps. It's already installed if you ran `boykisser preset gaming`.

To enable it for a game, add this to the Steam launch options:

```
mangohud %command%
```

Right-click game → Properties → **Launch Options** → paste that in.

Press **Right Shift + F12** in-game to toggle the overlay. Customize it by editing `~/.config/MangoHud/MangoHud.conf`.

---

## GameMode  -  squeeze out more performance

GameMode tells the system to prioritize the game: higher CPU priority, disable power saving, optimize scheduler. Small but real difference on some hardware.

```
gamemoderun %command%
```

Stack it with MangoHud:
```
mangohud gamemoderun %command%
```

That's the full combo. Most people just put both in every game's launch options.

---

## Controllers

Plug in an Xbox, PlayStation, or most generic controllers via USB or Bluetooth  -  they just work. The kernel handles it, no extra setup needed.

For **PlayStation controllers over Bluetooth**: pair it normally via the Bluetooth tray. Press and hold the Share + PS button to enter pairing mode.

For **rumble and extra features on PS5 DualSense**: install `dualsensectl`:
```bash
sudo apt install dualsensectl
```

If a game doesn't recognize your controller, check Steam's **Big Picture** mode → **Settings** → **Controller**  -  you can enable PS/Xbox/generic controller support globally there.

---

## Flatpak games

Flatpak has a solid games section on [Flathub](https://flathub.org/apps/category/Game). Mostly open-source and free stuff, but also some commercial games (like Mindustry, 0 A.D., assorted classics).

```bash
flatpak install flathub io.github.martinrotter.0ad
```

These are sandboxed, so controller and audio access is slightly different  -  but most work fine out of the box.

---

That's it. Steam + Proton covers the vast majority of your library. Lutris handles the gaps. MangoHud + GameMode for when you want to optimize. Go play something.

---

## See also

- [Presets & apps](#presets-and-apps)
- [First steps after install](#after-install)
- [Terminal basics](#terminal-basics)
