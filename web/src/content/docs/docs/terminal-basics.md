---
title: Terminal basics
description: Just enough terminal to feel at home. No prior experience needed.
---

You can use Boykisser Linux without ever opening a terminal. But a handful of commands make a lot of things quicker, and most help you find online assumes you have one.

## Opening it

Press <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>T</kbd>, or find **Terminal** in the menu. You'll see a pink system summary and a prompt:

```
user@boykisser:~$
```

That's `username@computer:folder$`. `~` is short for your home folder, `/home/username`. The shell is **bash**.

Handy keys:

- <kbd>Tab</kbd> completes commands and file names. Press it twice to see the options.
- <kbd>↑</kbd> and <kbd>↓</kbd> scroll through commands you ran before. <kbd>Ctrl</kbd>+<kbd>R</kbd> searches them.
- <kbd>Ctrl</kbd>+<kbd>C</kbd> stops whatever is running.
- <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>C</kbd> / <kbd>V</kbd> copy and paste (plain <kbd>Ctrl</kbd>+<kbd>C</kbd> means "stop" in here).

## Getting around

```sh
pwd                 # where am I?
ls                  # what's in here?
ll                  # same, with sizes, dates and hidden files
cd Downloads        # go into a folder
cd ..               # go up one level
cd                  # go home
```

## Files

```sh
cp file.txt backup.txt        # copy
mv old.txt new.txt            # move or rename
mkdir projects                # new folder
rm file.txt                   # delete (no recycle bin!)
rm -r folder                  # delete a folder and everything in it
xdg-open file.pdf             # open with the default app
```

## Installing and updating

```sh
boykisser update              # update everything
sudo apt install vlc          # install from Debian
sudo apt remove vlc           # remove it again
apt search "image editor"     # search Debian
flatpak install flathub org.gimp.GIMP
flatpak list                  # what Flatpaks do I have?
```

`sudo` runs one command as administrator. It asks for *your* password, and nothing appears while you type it. That's normal.

## Boykisser shortcuts

These aliases are set up for you:

| Type | Runs |
| --- | --- |
| `update` | `boykisser-update` |
| `cleanup` | `boykisser-cleanup` |
| `doctor` | `boykisser-doctor` |
| `bk` | `boykisser` (so `bk theme light` works) |
| `ll` | `ls -lah` |
| `la` | `ls -A` |

## Finding out what's going on

```sh
boykisser doctor              # quick health check
df -h                         # disk space
free -h                       # memory
htop                          # live process list (q quits)
fastfetch                     # the system summary again
journalctl -b -p err          # errors since this boot
```

## Getting help

- `man ls` opens the manual for `ls` (<kbd>q</kbd> quits).
- `command --help` gives a short summary for most commands.
- Debian's own docs apply here too: [debian.org/doc](https://www.debian.org/doc/).

:::caution
Be careful copying commands from the internet that start with `sudo`, especially ones with `rm`, `dd` or `curl … | sh`. If you don't know what something does, ask on [Discord](https://discord.gg/3ZpwE9PPfP) first.
:::
