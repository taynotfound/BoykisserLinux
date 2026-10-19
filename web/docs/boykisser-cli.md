# The boykisser CLI

Everything the distro can do is wrapped in one friendly command: `boykisser`. Most of these also live as buttons in the **Boykisser Center** GUI.

![boykisser CLI help output](../assets/screenshots/terminal.png)

```bash
boykisser <command>
```

## Everyday stuff

| Command | What it does |
| --- | --- |
| `boykisser center` | Open the Boykisser Center GUI |
| `boykisser update` | Timeshift snapshot first, then apt + Flatpak updates |
| `boykisser cleanup` | Clear apt/Flatpak caches and old packages |
| `boykisser doctor` | Quick health check (firewall, zram, backups, …) |
| `boykisser welcome` | Reopen the welcome checklist |

## Apps & look

| Command | What it does |
| --- | --- |
| `boykisser presets` | Install Flatpak app groups (art, social, office, music) |
| `boykisser browser` | Pick your browser: Firefox, LibreWolf, Brave or Chromium |
| `boykisser debloat` | Remove preinstalled groups you don't want (Steam, OBS, VLC, …) |
| `boykisser theme` | Flip between light and dark pink |
| `boykisser wallpaper` | Cycle the Boykisser wallpapers |

## System

| Command | What it does |
| --- | --- |
| `boykisser install` | Launch the Calamares installer (live session) |
| `boykisser autologin` | Toggle automatic login (installed system) |
| `boykisser nvidia` | Set up the proprietary Nvidia driver |
| `boykisser kernel` | Install a newer kernel from backports |
| `boykisser report` | Collect system info for a GitHub issue |
| `boykisser version` | Show the version |

## Examples

```bash
# fresh install ritual :3
boykisser update
boykisser presets
boykisser browser
```

---

## See also

- [Installing boykisser-tools](#boykisser-tools-install)
- [Presets & apps](#presets-and-apps)
- [First steps after install](#after-install)
