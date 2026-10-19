---
title: The boykisser command
description: Every boykisser subcommand and what it does.
---

All Boykisser tools sit behind one command. Run `boykisser` on its own to list them. Each one is also a standalone script (`boykisser update` runs `boykisser-update`), and most are tiles in the [Boykisser Center](/docs/boykisser-center/).

## Everyday

| Command | What it does |
| --- | --- |
| `boykisser center` | Opens the Boykisser Center. |
| `boykisser update` | Updates apt packages, Flatpaks, firmware and the Boykisser tools. Takes a Timeshift snapshot first if Timeshift is set up. `--tools-only` just updates the tools. |
| `boykisser doctor` | Read-only health check: disk, packages, services, firewall, network, GPU driver. |
| `boykisser cleanup` | Removes unused packages and Flatpak runtimes, clears the apt cache and thumbnail cache, trims logs to two weeks. |
| `boykisser welcome` | Opens the welcome checklist. |
| `boykisser version` | Shows the Boykisser and tools versions. |

## Apps

| Command | What it does |
| --- | --- |
| `boykisser presets [art] [social] [office] [music]` | Installs Flatpak app groups. No arguments opens a checklist. |
| `boykisser browser [librewolf\|brave\|chromium\|firefox]` | Installs another browser. |
| `boykisser debloat [gaming] [obs] [vlc] [vscode] [games]` | Removes app groups. Only offers what's installed. |
| `boykisser apps` | Installs the full app set (what the netinstall image fetches on first boot). |

## Look

| Command | What it does |
| --- | --- |
| `boykisser theme [light\|dark]` | Switches the theme. No argument re-applies the saved one. |
| `boykisser wallpaper` | Gives monitors without a wallpaper the Boykisser one. `--next` cycles, `--force` resets all monitors. |

## System

| Command | What it does |
| --- | --- |
| `boykisser install` | Starts the installer (live session). |
| `boykisser nvidia [-y]` | Installs the proprietary NVIDIA driver, handling Secure Boot key enrolment. |
| `boykisser kernel [--install]` | Shows the running and available kernels; `--install` switches to the Debian backports kernel. |
| `boykisser autologin [on [user]\|off\|status]` | Toggles logging in without a password. |
| `boykisser report [--no-sysinfo]` | Opens a GitHub issue pre-filled with non-personal system info. Nothing is sent until you press Submit. |

## Shell aliases

`update`, `cleanup` and `doctor` run the matching command, and `bk` is short for `boykisser`.
