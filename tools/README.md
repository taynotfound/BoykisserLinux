# boykisser-tools :3

All the `boykisser-*` scripts and the graphical Boykisser Center, packaged as individual `.deb` files so they can update independently of the ISO.

## What's in here

| Script | Does |
|---|---|
| `boykisser` | Main CLI dispatcher |
| `boykisser-center` | GTK3 graphical control panel |
| `boykisser-update` | Updates apt + Flatpak + tools itself |
| `boykisser-theme` | Light/dark theme switcher |
| `boykisser-wallpaper` | Sets the Boykisser wallpaper on all monitors |
| `boykisser-nvidia` | Installs the proprietary NVIDIA driver |
| `boykisser-presets` | Installs Flatpak app preset groups |
| `boykisser-doctor` | Read-only system health check |
| `boykisser-report` | Pre-fills a GitHub issue with system info |
| `boykisser-welcome` | Welcome checklist dialog |
| `boykisser-cleanup` | Frees disk space (old packages, caches, logs) |
| `boykisser-kernel` | Installs a newer kernel from trixie-backports |
| `boykisser-autologin` | Toggles LightDM autologin on/off |
| `boykisser-debloat` | Removes app groups you don't want |
| `boykisser-browser` | Picks and installs a browser |
| + more | `ls /usr/local/bin/boykisser*` |

## Installing

### Full install (recommended)

```sh
mkdir -p /tmp/bk && cd /tmp/bk
curl -s https://api.github.com/repos/taynotfound/boykisser-tools/releases/latest \
  | grep browser_download_url | grep '\.deb' | cut -d'"' -f4 \
  | xargs -I{} curl -LO {}
sudo dpkg -i *.deb && sudo apt-get install -f
```

### Individual packages

Each tool ships as its own `.deb`. Install just what you need:

| Package | Contents |
|---|---|
| `boykisser-core` | `boykisser` CLI |
| `boykisser-center` | Graphical control center |
| `boykisser-update` | Updater |
| `boykisser-doctor` | Health check |
| `boykisser-nvidia` | NVIDIA driver installer |
| `boykisser-theme` | Theme switcher |
| `boykisser-apps` | App installer tools |
| `boykisser-system` | System admin tools |
| `boykisser-tools` | Meta-package (all of the above) |

```sh
# example: just the updater and health check
sudo dpkg -i boykisser-update_*.deb boykisser-doctor_*.deb
sudo apt-get install -f
```

## Updating

`boykisser update` checks this repo's releases and installs a newer `.deb` automatically if one is available. No PPA needed.

## Releasing

Tag a commit and CI builds + publishes all the `.deb` files:

```sh
git tag v1.2.3 && git push origin v1.2.3
```

## Part of Boykisser Linux

| Repo | What |
|---|---|
| **[BoykisserLinux](https://github.com/taynotfound/BoykisserLinux)** | ISO build config - fetches this `.deb` at build time |
| **[boykisser-tools](https://github.com/taynotfound/boykisser-tools)** <- you are here | Scripts & control center |
| **[boykisser-web](https://github.com/taynotfound/boykisser-web)** | Website & docs |
