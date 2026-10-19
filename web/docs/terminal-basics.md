# Terminal basics

The terminal is just a text box where you tell your computer what to do by typing. That's it. It's not magic, it's not dangerous (mostly), and it's genuinely faster than clicking around once you know a few commands.

This page covers everything you need to get comfortable. You don't need to memorize it  -  just come back when you need something.

---

## Opening a terminal

Press **Ctrl+Alt+T**  -  that's the shortcut. Or look for **Terminal** or **Xfce Terminal** in the app menu.

You'll see something like:

```
user@boykisser ~>
```

That's the prompt. It's waiting for you. The `~` means you're in your home folder (`/home/yourname`). The `>` is fish shell's way of saying "go ahead."

---

## The fish shell

Boykisser uses **fish** as the default shell. Fish is beginner-friendly in ways that the old default (bash) isn't:

- **Syntax highlighting**: commands turn blue when they're valid, red when they're not. You can tell before you hit Enter if you typo'd something.
- **Tab completion**: press Tab and fish will complete the command, filename, or flag for you. Press it twice to see all options.
- **Command history**: press the Up arrow to go back through previous commands. Start typing and press Up to find matching commands from history.
- **Suggestions**: fish shows a greyed-out suggestion as you type based on your history. Press the Right arrow to accept it.

These aren't gimmicks  -  they'll save you from typos daily.

---

## Navigating around

### Where am I?

```bash
pwd
```

**P**rint **W**orking **D**irectory. Shows the full path of the folder you're currently in.

### What's in here?

```bash
ls
```

Lists files and folders. Add `-l` for more detail (size, permissions, date), add `-a` to show hidden files (ones starting with `.`):

```bash
ls -la
```

### Move to a folder

```bash
cd Documents
```

**C**hange **D**irectory. You can use:
- A folder name (like `Documents`) to go into it
- `..` to go up one level: `cd ..`
- `~` to jump straight home: `cd ~`
- A full path: `cd /etc/apt`

Tab completion works great here  -  type `cd Doc` and press Tab.

### Make a new folder

```bash
mkdir my-project
```

### Copy a file

```bash
cp original.txt copy.txt
```

To copy a whole folder, add `-r` (recursive):

```bash
cp -r my-folder my-folder-backup
```

### Move or rename a file

```bash
mv oldname.txt newname.txt
```

`mv` works for both moving and renaming. To move somewhere:

```bash
mv file.txt Documents/file.txt
```

### Delete a file

```bash
rm file.txt
```

> ⚠️ **Warning: there is no trash.** `rm` deletes permanently. There's no undo, no recycle bin, no "are you sure?" by default. Double-check what you're deleting before you press Enter.
>
> **Never run `rm -rf /` or `rm -rf ~` or any command with `rm -rf` that you don't fully understand.** That `-rf` flag means "delete everything recursively, no questions asked." It's how people accidentally wipe their home folder.

---

## Reading files

### Print a file to the screen

```bash
cat file.txt
```

Good for short files. For long files it'll just scroll past  -  use `less` instead.

### Read a file one page at a time

```bash
less file.txt
```

- Arrow keys or Page Up/Down to scroll
- `/` to search for text
- `q` to quit

`less` is the right tool for log files, config files, anything longer than a screenful.

---

## Installing and removing software

Debian (and Boykisser) uses `apt` to manage packages from the official repos.

### Search for something

```bash
apt search music-player
```

### Install a package

```bash
sudo apt install vlc
```

(See the next section for what `sudo` means.)

### Remove a package

```bash
sudo apt remove vlc
```

To also remove config files left behind:

```bash
sudo apt purge vlc
```

### Update all your software

```bash
boykisser update
```

This is the Boykisser way  -  it handles the full update cycle cleanly. Under the hood it's running `apt update` then `apt full-upgrade`. Run it every week or so.

If you want to run it manually the old-fashioned way:

```bash
sudo apt update && sudo apt upgrade
```

---

## sudo  -  why it exists

Some commands need extra permissions to run  -  installing software, editing system files, starting services. `sudo` (pronounced "sue-doo" or "soo-doo", the debate is eternal) temporarily gives you admin powers for one command.

```bash
sudo apt install gimp
```

It'll ask for your password the first time. You won't see the characters as you type  -  that's normal, it's a security feature.

> **Why not just be admin all the time?** Because mistakes are permanent. If you're always running as root and you accidentally delete something, it's gone. `sudo` means you have to *intentionally* run something with power  -  it forces a pause. It's a seatbelt.

Don't run random `sudo` commands you found on the internet unless you understand what they do.

---

## A few handy extras

**Clear the screen:**
```bash
clear
```
Or Ctrl+L.

**Cancel a running command:**
Ctrl+C. This stops whatever is currently running.

**See the last N lines of a file:**
```bash
tail -n 50 /var/log/syslog
```

**See command history:**
```bash
history
```

**Get help on any command:**
```bash
man ls        # opens the manual page for ls
ls --help     # usually shorter and faster
```

---

## You've got this

You now know enough to not break anything accidentally. The only genuinely dangerous commands are the ones that delete stuff (`rm -rf`) or the ones that write to system files without understanding them. Everything else is just reading and moving things around.

The terminal feels weird for about a week, then it starts feeling faster than the GUI for a lot of things. Tab completion and history alone will change how you work.

When something goes wrong  -  and it will, for everyone  -  the error message usually tells you exactly what happened. Read it. Google the relevant part. That's the whole skill.

---

## See also

- [The boykisser CLI](#boykisser-cli)
- [First steps after install](#after-install)
- [FAQ](#faq)
