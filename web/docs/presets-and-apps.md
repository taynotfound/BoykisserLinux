# Presets & apps

Boykisser Linux comes with a sensible base, and easy ways to add or remove the rest.

## App bundles (installer)

While installing, you can tick optional bundles  -  **Gaming**, **Streaming**, **Development**, **Office**  -  and they'll be set up before the first boot. Skipped one? Everything below is available afterwards too.

## Flatpak presets

`boykisser presets` (or the tile in the Boykisser Center) installs curated Flatpak groups from Flathub:

- 🎨 **Art**  -  drawing and creative tools
- 💬 **Social**  -  chat and social apps
- 📄 **Office**  -  documents and productivity
- 🎵 **Music**  -  players and audio tools

Pick as many as you like in the checklist, or go direct:

```bash
boykisser presets music
```

## Choosing a browser

```bash
boykisser browser
```

Offers Firefox (default), LibreWolf, Brave and Chromium  -  LibreWolf and Brave come from Flathub, the rest from Debian.

## Removing stuff (debloat)

Not everyone wants Steam or OBS preinstalled:

```bash
boykisser debloat
```

It only offers groups that are actually installed  -  gaming, OBS, VLC, VS Code, games  -  and purges what you tick.

## Anything else

It's plain Debian underneath, so `apt`, `flatpak`, GNOME Software-style stores, whatever you like  -  all work exactly as expected.

---

## See also

- [The boykisser CLI](#boykisser-cli)
- [Gaming](#gaming)
- [Theming & customization](#theming)
- [First steps after install](#after-install)
