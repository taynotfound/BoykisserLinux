---
title: Downloading and verifying
description: Which ISO to grab, how to reassemble the full image, and how to check it.
---

Every release lives on the [GitHub releases page](https://github.com/taynotfound/BoykisserLinux/releases/latest). New images are built every Monday with the latest Debian kernel and security updates, so the newest release is always the one to take.

## The three flavours

| File | Size | What's in it |
| --- | --- | --- |
| `boykisser-linux-amd64.iso` | ~2.6 GB | **Full.** Everything, works offline. Split into parts on GitHub. |
| `boykisser-linux-netinstall-amd64.iso` | ~1.5 GB | **Netinstall.** Base desktop; apps download on first boot. |
| `boykisser-linux-lite-amd64.iso` | ~1.5 GB | **Lite.** BIOS-only, no heavy apps, safe graphics mode. |

Each release also has a `SHA256SUMS` file.

## Easiest: the Internet Archive mirror

Every release is mirrored on the Internet Archive as single files, with a torrent. Open the release, expand **Installation Instructions & Mirror Links**, and use the **Direct mirror** or **Torrent** link for your flavour. The website's download buttons point there too. No reassembly needed.

## From GitHub: reassemble the full ISO

GitHub limits files to 2 GB, so the full ISO is split into `boykisser-linux-amd64.iso.part00`, `.part01` and so on. Download all the parts and `SHA256SUMS` into one folder, then join them:

```sh
cat boykisser-linux-amd64.iso.part* > boykisser-linux-amd64.iso
```

On Windows (PowerShell):

```powershell
cmd /c copy /b boykisser-linux-amd64.iso.part00 + boykisser-linux-amd64.iso.part01 boykisser-linux-amd64.iso
```

The netinstall and lite ISOs are single files.

## Verify the download

Always check before flashing. A wrong checksum means the download is broken (or was tampered with).

```sh
sha256sum --ignore-missing -c SHA256SUMS
# boykisser-linux-amd64.iso: OK
```

On Windows, compare the output of `Get-FileHash boykisser-linux-amd64.iso` with the matching line in `SHA256SUMS`.

Once it says `OK`, head back to [Getting started](/docs/getting-started/) to flash it.
