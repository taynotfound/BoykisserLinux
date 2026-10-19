# Downloading & verifying

Every release ships three files on the [GitHub releases page](https://github.com/taynotfound/BoykisserLinux/releases/latest), plus mirrors on the Internet Archive for each.

## Which file to grab

| ISO | Size | For |
|---|---|---|
| `boykisser-linux-amd64.iso` (split parts) | ~2.5 GB | Most people  -  everything offline |
| `boykisser-linux-netinstall-amd64.iso` | < 1.5 GB | Small download, pulls apps on first boot |
| `boykisser-linux-lite-amd64.iso` | < 1.5 GB | Ancient BIOS laptops  -  see [Old hardware](old-hardware) |

All releases also include a `SHA256SUMS` file to verify your download.

---

## Reassembling the full ISO

GitHub has a 2 GB per-file limit, so the full ISO is split into parts (`boykisser-linux-amd64.iso.part00`, `.part01`, …). Download all the parts plus `SHA256SUMS`, then:

```sh
# join the parts back into one ISO
cat boykisser-linux-amd64.iso.part* > boykisser-linux-amd64.iso

# verify it  -  should print OK
sha256sum -c SHA256SUMS
```

The netinstall and lite ISOs are under 2 GB and ship as single files  -  no reassembly needed.

---

## Internet Archive mirrors

Every release is mirrored on the Internet Archive. The release page links them directly  -  look for the **Direct mirror** and **Torrent** links under each ISO section. The torrent is the most reliable way to get the full ISO without fighting GitHub's bandwidth limits.

---

## Verifying the download

Always check `SHA256SUMS` before flashing. A mismatched hash means a corrupt or tampered download.

```sh
# after reassembling (or downloading netinstall/lite directly):
sha256sum -c SHA256SUMS
# expected output: boykisser-linux-amd64.iso: OK
```

Once verified, flash it  -  see [Getting started](getting-started) for how.
