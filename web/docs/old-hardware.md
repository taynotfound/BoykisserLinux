# Old hardware

Boykisser Linux runs fine on machines from ~2010 onwards. Here's what to know if yours is on the older side.

## Which ISO to grab

| Your machine | ISO |
|---|---|
| Modern  -  UEFI or BIOS, post-2012 | **Full** or **Netinstall** |
| Pre-2012 / ancient BIOS / Ventoy fails | **Lite** |

The **Lite ISO** is built with BIOS-only syslinux (no grub-efi hybrid) and `nomodeset` baked into the default boot line. This is what lets crusty firmware chainload past the boot menu instead of dropping you at a `grub>` rescue prompt.

Grab it from the [latest release](https://github.com/taynotfound/BoykisserLinux/releases/latest)  -  file is `boykisser-linux-lite-amd64.iso`.

---

## Getting it onto a stick

> **Don't use Ventoy.** Ventoy adds its own bootloader chain that old firmware frequently rejects  -  it's the most common reason people end up at `grub>`. Just write the ISO directly.

<details>
<summary><strong>Linux</strong></summary>

Find your USB drive first  -  check `lsblk` before and after plugging it in to confirm the device name (usually `/dev/sdb` or `/dev/sdc`).

```sh
sudo dd if=boykisser-linux-lite-amd64.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

Replace `/dev/sdX` with your actual device. This wipes everything on it.

</details>

<details>
<summary><strong>Windows</strong></summary>

Use [Rufus](https://rufus.ie/):

1. Select your USB drive at the top.
2. Click **SELECT** and pick the `.iso` file.
3. Partition scheme → **MBR**, Target system → **BIOS (or UEFI-CSM)**.
4. Hit **START** → Write in ISO Image mode when asked.

</details>

<details>
<summary><strong>macOS</strong></summary>

```sh
# find your disk  -  look for the one matching your USB size
diskutil list

# unmount it (replace diskN)
diskutil unmountDisk /dev/diskN

# write the ISO
sudo dd if=boykisser-linux-lite-amd64.iso of=/dev/rdiskN bs=4m
```

Use `/dev/rdiskN` (raw device)  -  it's noticeably faster than `/dev/diskN`.

</details>

---

## BIOS settings

If it still won't boot after writing the USB:

1. Enter BIOS setup  -  usually **F2**, **F12**, **Del**, or **Esc** at the POST screen.
2. Find **Boot Mode** or **Boot Type** → set to **Legacy** or enable **CSM** (Compatibility Support Module).
3. Disable **Secure Boot** if present.
4. Make sure the USB is first in the boot order.
5. Save and reboot.

---

## Compatibility notes

### Sandy Bridge (2nd gen Intel Core, ~2011)

Works well. CSM is standard on Sandy Bridge boards. The i915 driver in Debian trixie handles Sandy Bridge natively  -  `nomodeset` disables KMS (so no hardware-accelerated compositing), but Xfce doesn't need it and everything runs fine.

### Very old GPUs (pre-2008, or Nouveau-unfriendly Nvidia)

The failsafe boot entry (`boot=live components noapic nomodeset nosplash vga=normal`) in the GRUB/syslinux menu is your friend  -  it disables practically everything that can go wrong at boot. Select it if the default entry hangs or produces garbled output.

### 32-bit only CPUs

Not supported  -  Boykisser Linux is amd64 only. If your CPU genuinely doesn't support 64-bit, it's time for a different distro.

---

## Last resort  -  install without booting the ISO

If nothing works, you can bootstrap the system from inside any other live Linux (Ubuntu, Debian, whatever you can actually boot):

<details>
<summary><strong>Debootstrap walkthrough</strong></summary>

This installs a real Debian trixie + Xfce base straight to the target disk, bypassing the ISO boot entirely.

```sh
# 1. Partition your disk  -  /dev/sda1 = ext4 root, /dev/sda2 = swap (optional)
#    Use gparted or: sudo parted /dev/sda mklabel msdos ...
#    Then format:
sudo mkfs.ext4 /dev/sda1
sudo mount /dev/sda1 /mnt

# 2. Bootstrap the base system (~300MB download)
sudo debootstrap trixie /mnt http://deb.debian.org/debian

# 3. Bind-mount and chroot in
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo chroot /mnt

# 4. Inside the chroot  -  install desktop + bootloader
apt update
apt install task-xfce-desktop lightdm linux-image-amd64 firmware-linux grub-pc
grub-install /dev/sda
update-grub
passwd  # set root password

# 5. Done  -  exit and reboot
exit
sudo umount -R /mnt
sudo reboot
```

This gives you a plain Debian trixie + Xfce base. It won't have Boykisser theming or tooling out of the box, but it runs and you can customise from there.

</details>
---

## Rescue ISOs

If your system won't boot or you need to recover files, grab a dedicated rescue ISO instead of the Boykisser one.

- **[SystemRescue](https://www.system-rescue.org/Download/)** - the go-to. Boots on anything, has GParted, fsck, chroot, network tools. Put it on a second USB.
- **[Clonezilla](https://clonezilla.org/downloads.php)** - disk imaging and recovery. Good before a risky upgrade.

Flash with the same `dd` command, boot, done. No install needed.


---

## See also

- [Getting started](#getting-started)
- [Downloading & verifying](#downloading)
- [Installing to disk](#installation)
- [FAQ](#faq)