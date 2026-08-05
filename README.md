# boykisser-tools :3

All the `boykisser-*` scripts and the graphical Boykisser Center, packaged as a `.deb` so they can update independently of the ISO.

## What's in here

| Script | Does |
|---|---|
| `boykisser` | Main entry point — lists all commands |
| `boykisser-center` | GTK3 control panel |
| `boykisser-update` | Updates apt + Flatpak + tools itself |
| `boykisser-theme` | Light/dark toggle |
| `boykisser-wallpaper` | Cycles the 6 built-in wallpapers |
| `boykisser-nvidia` | Installs the proprietary Nvidia driver |
| `boykisser-presets` | Installs app preset groups |
| `boykisser-doctor` | System health check |
| `boykisser-report` | Collects info for bug reports |
| `boykisser-welcome` | The welcome checklist |
| + more | `ls /usr/local/bin/boykisser*` |

## Updating

On an installed Boykisser system, `boykisser update` checks this repo's releases and installs the latest `.deb` automatically if there's a newer version.

To install manually:
```sh
curl -fsSL https://github.com/taynotfound/boykisser-tools/releases/latest/download/boykisser-tools.deb -o /tmp/bk.deb
sudo dpkg -i /tmp/bk.deb
```

## Releasing

Tag a commit → CI builds the `.deb` via `fpm` and publishes it:

```sh
git tag v1.2.3 && git push origin v1.2.3
```

## Part of Boykisser Linux

| Repo | What |
|---|---|
| **[BoykisserLinux](https://github.com/taynotfound/BoykisserLinux)** | ISO build config — fetches this `.deb` at build time |
| **[boykisser-tools](https://github.com/taynotfound/boykisser-tools)** ← you are here | Scripts & control center |
| **[boykisser-web](https://github.com/taynotfound/boykisser-web)** | Website & docs |
