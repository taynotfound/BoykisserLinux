# boykisser-tools :3

The `boykisser-*` helper scripts and the GTK Boykisser Center that ship with
Boykisser Linux. They're plain POSIX shell (plus one Python/GTK app), packaged
as Debian packages that install into `/usr/bin`.

User docs: [boykisser.taymaerz.de/docs/cli](https://boykisser.taymaerz.de/docs/cli/)

## Layout

| Path | What |
| --- | --- |
| `bin/` | The scripts. `boykisser` dispatches to `boykisser-<command>`. |
| `share/applications/` | Menu launchers |
| `share/systemd/` | `boykisser-firstboot.service` |
| `build-debs.sh` | Builds the packages with `dpkg-deb` |
| `VERSION` | Version for releases |

## Packages

| Package | Contents |
| --- | --- |
| `boykisser-core` | `boykisser` |
| `boykisser-center` | `boykisser-center` (GTK 3) |
| `boykisser-update` | `boykisser-update` (apt, Flatpak, firmware, self-update) |
| `boykisser-doctor` | `boykisser-doctor` (read-only health check) |
| `boykisser-nvidia` | `boykisser-nvidia` (driver + Secure Boot key enrolment) |
| `boykisser-theme` | `boykisser-theme`, `boykisser-theme-toggle`, `boykisser-wallpaper` |
| `boykisser-apps` | `boykisser-presets`, `-browser`, `-debloat`, `-postinstall-apps`, `-install-bundles` |
| `boykisser-system` | `boykisser-cleanup`, `-kernel`, `-autologin`, `-report`, `-welcome`, `-firstboot`, `-live-cleanup`, `-install-kde`, `install-boykisser` |
| `boykisser-tools` | Metapackage: all of the above |

## Build and try

```sh
tools/build-debs.sh                    # -> tools/dist/*.deb
sudo apt install ./tools/dist/*.deb
```

The ISO build (`./build.sh` and CI) runs `build-debs.sh` into
`config/packages.chroot`, so every image ships the tools from its own commit.

## Release

1. Bump `VERSION`.
2. `git tag tools-v$(cat tools/VERSION) && git push origin --tags`

CI lints the scripts, builds the packages and publishes a `tools-v*` release
(not marked as latest, so the website keeps pointing at the newest ISO).
Installed systems pick it up through `boykisser update`.

## Conventions

- POSIX `sh` unless there's a reason; `shellcheck -S warning` must pass.
- Anything that changes the system re-runs itself with `sudo` when needed.
- Never fail a Calamares step: installer helpers (`*-install-*`,
  `*-live-cleanup`) log and exit 0 on errors.
- Friendly output with a `:3` where it fits.
