---
title: boykisser-tools
description: How the Boykisser tools are packaged and updated, and how to use them on plain Debian.
---

Everything the `boykisser` command does comes from **boykisser-tools**: a set of small shell scripts plus the GTK Boykisser Center, in the [`tools/`](https://github.com/taynotfound/BoykisserLinux/tree/main/tools) folder of the main repository.

## How they're shipped

The tools are built into Debian packages. Every ISO build packages them fresh from the same commit, so the image and its tools always match. Installed systems get newer versions from `boykisser update`, which checks for `tools-v*` releases on GitHub and installs them with apt. No extra repository needed.

| Package | Contains |
| --- | --- |
| `boykisser-core` | The `boykisser` command |
| `boykisser-center` | The Boykisser Center (GTK 3) |
| `boykisser-update` | `boykisser update` |
| `boykisser-doctor` | `boykisser doctor` |
| `boykisser-nvidia` | `boykisser nvidia` |
| `boykisser-theme` | Theme switcher, theme toggle, wallpaper helper |
| `boykisser-apps` | Presets, browser picker, debloat, full app set, installer bundles |
| `boykisser-system` | Cleanup, kernel, autologin, report, welcome, first-boot service, installer glue |
| `boykisser-tools` | Metapackage that installs all of the above |

Everything installs into `/usr/bin`.

## On plain Debian 13

The tools work on any Debian trixie system, though some (theme, wallpaper, welcome) assume XFCE or KDE and the Boykisser artwork. Grab the `.deb` files from the newest [`tools-v*` release](https://github.com/taynotfound/BoykisserLinux/releases) and:

```sh
sudo apt install ./boykisser-*.deb
```

After that, `boykisser update` keeps them current.

## Building them yourself

You only need `dpkg-deb`:

```sh
git clone https://github.com/taynotfound/BoykisserLinux
cd BoykisserLinux
tools/build-debs.sh            # packages land in tools/dist/
sudo apt install ./tools/dist/*.deb
```

## Upgrading from 1.x

Version 1.x came from the old `boykisser-tools` repository and installed into `/usr/local/bin`. Version 2 moves everything to `/usr/bin` and removes leftover copies in `/usr/local/bin` that no package owns, so old versions can't shadow the new ones. If you're on 1.x, install the 2.x packages once by hand as shown above. From then on `boykisser update` does it for you.
