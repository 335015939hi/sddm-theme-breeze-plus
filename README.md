# Breeze Plus — SDDM Theme

A modern SDDM login theme based on the KDE Breeze style, with a few extra features added for a nicer login experience.

This theme was originally derived from the default Breeze SDDM theme (`breeze`), and extends it with options like automatic UI fade-out, background slideshows, random wallpaper selection, and more.

> **Note:** This is a third-party theme. It is not an official KDE project.

---

## Features

- **Clean Breeze look & feel** — Uses KDE Plasma/Kirigami theming and Breeze components.
- **Automatic UI fade-out** — The login UI fades out after a period of inactivity, leaving the wallpaper unobstructed.
  - Fade-out is blocked while typing, using the on-screen keyboard, or in the "Other User" UI.
  - Any mouse movement, click, or keypress brings the UI back.
  - The clock can optionally remain visible while the rest of the UI is hidden.
- **Multiple background modes**:
  - Single color
  - Single image
  - Directory-based slideshow with randomized order
  - Smooth crossfade transitions between backgrounds
- **Optional background blur** while the login UI is visible.
- **Session and keyboard layout choosers** (from upstream Breeze).
- **Multi-monitor aware** wallpaper rendering.
- Ships with a small set of default wallpapers in `backgrounds/`.

---

## Installation

### From source

1. Clone or download this repository.
2. Copy the theme folder to the SDDM themes directory:

   ```bash
   sudo cp -r sddm-theme-breeze-plus /usr/share/sddm/themes/breeze-plus
   ```

3. Edit `/etc/sddm.conf` (or create `/etc/sddm.conf.d/theme.conf`) and set:

   ```ini
   [Theme]
   Current=breeze-plus
   ```

4. Reboot or restart your display manager. SDDM will use the new theme.

### Arch Linux (manual PKGBUILD / AUR)

If you maintain or use a PKGBUILD, the theme should be installed to:

```
/usr/share/sddm/themes/breeze-plus
```

---

## Configuration

All customization is done in `theme.conf` inside the theme directory (`/usr/share/sddm/themes/breeze-plus/theme.conf`).

```ini
[General]
showlogo=hidden
showClock=true
logo=/usr/share/sddm/themes/breeze/default-logo.svg

# Background type: color, image, imageDirectory
type=imageDirectory
color=#1d99f3
background=/usr/share/wallpapers/Next/contents/images/5120x2880.png
backgroundDirectory=./backgrounds
backgroundInterval=30     # Seconds between slideshow changes
backgroundTransition=1    # Crossfade duration in seconds

fontSize=10

# UI auto-fade
uiFadeInterval=2          # Seconds of inactivity before UI fades
blurWhenUiVisible=false   # Blur the wallpaper while UI is visible
keepClockVisibleWhenUiHidden=true

needsFullUserModel=false
```

### Options explained

| Option | Description | Default |
|--------|-------------|---------|
| `type` | Background mode: `color`, `image`, or `imageDirectory`. | `imageDirectory` |
| `color` | Solid background color used when `type=color`. | `#1d99f3` |
| `background` | Path to a single image when `type=image`. | *(KDE Next wallpaper path)* |
| `backgroundDirectory` | Folder of images to cycle through. Relative paths are resolved from the theme directory. | `./backgrounds` |
| `backgroundInterval` | Seconds between slideshow image changes. | `30` |
| `backgroundTransition` | Crossfade duration in seconds. | `1` |
| `uiFadeInterval` | Seconds of inactivity before the login UI fades out. Set to `0` to disable fade-out. | `2` |
| `blurWhenUiVisible` | Blur the background while the login UI is visible. | `false` |
| `keepClockVisibleWhenUiHidden` | Keep the clock visible after the UI fades out. | `true` |
| `showClock` | Show or hide the clock widget. | `true` |

---

## Adding your own wallpapers

To use your own wallpapers, place them in the `backgrounds/` folder (or any other folder you set via `backgroundDirectory`). Supported formats:

- `.png`
- `.jpg` / `.jpeg`
- `.webp`
- `.bmp`
- `.svg`

Set `type=imageDirectory` in `theme.conf` and point `backgroundDirectory` to the folder.

---

## Requirements

- SDDM (`sddm`) with Qt 6 support
- KDE Plasma 6 / Kirigami / Breeze components
- Qt 6 Graphical Effects module (`Qt5Compat.GraphicalEffects` is used for compatibility with some effects)

This theme is configured for SDDM Theme API 2.0 / Qt 6.

---

## License

This theme is derived from the KDE Breeze SDDM theme, which is licensed under **LGPL-2.0-or-later**. The original copyright and license notices are preserved in the source files.

The extra components and modifications in this repository are provided under the same license.

The included default wallpapers and assets are subject to their own original licenses if any apply.

---

## Contributing

This is a small personal/customization project, but issues and pull requests are welcome.

If you add a new feature, consider updating this README and the default `theme.conf` comments so others can discover it.

---

## Credits

- Original Breeze SDDM theme by **David Edmundson** and the KDE Plasma contributors.
