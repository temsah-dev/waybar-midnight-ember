# 🔥 Waybar — Midnight Ember Edition

A dark, ember-toned [Waybar](https://github.com/Alexays/Waybar) configuration built for **Hyprland** on **Arch Linux**. Designed around a "night + ember" palette, drawer-style module groups to keep the bar minimal, and a few custom scripts for GPU switching and a Hijri/Gregorian date toggle.

![status](https://img.shields.io/badge/status-active-brightgreen)
![platform](https://img.shields.io/badge/platform-Arch%20Linux%20%2F%20Hyprland-1793D1)
![license](https://img.shields.io/badge/license-MIT-blue)

<!-- ![preview](assets/preview.png) -->

## ✨ Features

- **Ember/night color palette** with soft glows, rounded pill modules, and smooth transitions.
- **Drawer groups** — CPU / GPU / RAM, network / Bluetooth, audio, and idle-inhibitor / updates modules are tucked into expandable drawers instead of cluttering the bar.
- **Custom GPU module** — reads `supergfxctl` + `nvidia-smi` for live usage/temperature, with a `rofi` menu to switch GPU modes (Integrated / Hybrid / AsusMuxDgpu).
- **Hijri/Gregorian date toggle** — click the clock to switch between Gregorian and Hijri calendar display (via `hijri_converter`).
- **ASUS ROG integration** — power profile indicator (`asusctl`) and quick profile switching.
- **Cloudflare WARP indicator** with connect/disconnect on click.
- **MPRIS now-playing**, privacy indicators (mic/screenshare), keyboard state (CapsLock), Hyprland submap indicator, pacman/AUR update counter, and more.
- Every `custom/*` script uses `timeout` internally so a hanging command (e.g. a GPU mode switch) never freezes the whole bar.

## 📦 Requirements

**Required:**
- [Hyprland](https://hyprland.org/)
- [Waybar](https://github.com/Alexays/Waybar) (built with the `hyprland` module)
- `jq`

**Optional** (a module degrades gracefully / hides itself if the tool is missing):
- `rofi` + `wl-clipboard` — GPU mode picker
- `supergfxctl`, `nvidia-smi` — GPU status module
- `asusctl`, `rog-control-center` — ASUS power profile module
- `warp-cli` — Cloudflare WARP module
- `dunst` (`dunstctl`) — notification silencing indicator
- `playerctl` — MPRIS now-playing controls
- `brightnessctl` — backlight control
- `pavucontrol`, `blueman` — audio/Bluetooth right-click menus
- `checkupdates` (pacman-contrib) + `yay` — update counter
- `wf-recorder`, `nvtop`, `btop`, `kitty` — used by a few `on-click` actions
- Python package [`hijri-converter`](https://pypi.org/project/hijri-converter/) — Hijri date conversion

> The config was built around a specific laptop's paths (e.g. `hwmon1/temp1_input`, the `nvidia_wmi_ec_backlight` backlight device, an ASUS ROG setup). See [Customization](#-customization) below for what to change on your machine.

## 🚀 Installation

```bash
git clone https://github.com/temsah-dev/waybar-midnight-ember.git
cd waybar-midnight-ember
./install.sh
```

The installer will:
1. Check for required/optional dependencies and warn about anything missing.
2. Back up any existing `~/.config/waybar` to `~/.config/waybar.bak.<timestamp>`.
3. Copy `config.jsonc` and `style.css` into `~/.config/waybar/`.
4. Copy and `chmod +x` the scripts into `~/.local/bin/`.
5. Restart Waybar.

### Manual installation

```bash
mkdir -p ~/.config/waybar ~/.local/bin
cp config.jsonc style.css ~/.config/waybar/
cp scripts/waybar-hijri scripts/waybar-gpu-status scripts/waybar-gpu-menu ~/.local/bin/
chmod +x ~/.local/bin/waybar-hijri ~/.local/bin/waybar-gpu-status ~/.local/bin/waybar-gpu-menu
killall waybar; waybar &
```

## 🎛 Modules overview

| Group | Modules |
|---|---|
| Left | System tools (idle inhibitor, notification silence, updates), screen recording indicator, Hyprland submap, CapsLock state, keyboard layout |
| Left 2 | Hyprland workspaces |
| Center | ASUS power profile, Cloudflare WARP status |
| Right | Tray (drawer), privacy indicators, backlight, network + Bluetooth (drawer), audio + mic (drawer), CPU / GPU / disk / RAM (drawer), temperature, battery, custom clock (Hijri/Gregorian) |

## 🛠 Customization

Things you'll likely want to adjust for your own hardware in `config.jsonc`:

- `temperature.hwmon-path` — points to a specific `hwmon` sensor; check `ls /sys/class/hwmon/*/name` on your system.
- `backlight.device` — set to `nvidia_wmi_ec_backlight`; run `brightnessctl -l` to find your device name.
- `hyprland/language.keyboard-name` — set to `at-translated-set-2-keyboard`; run `hyprctl devices` to find yours.
- `custom/gpu` and `waybar-gpu-menu` assume an ASUS laptop with `supergfxctl` (Integrated/Hybrid/AsusMuxDgpu). Simplify or remove if you don't use GPU switching.
- `custom/asusctl` assumes an ASUS ROG laptop with `asusctl`/`rog-control-center` installed.

Colors live at the top of `style.css` as GTK `@define-color` variables — change the `ember-*` / `ice-blue` / `frost` values to retheme everything at once.

## 📁 Structure

```
.
├── config.jsonc              # Waybar layout & module config
├── style.css                 # Theme (colors, shapes, animations)
├── scripts/
│   ├── waybar-hijri          # Clock module: Gregorian/Hijri toggle
│   ├── waybar-gpu-status      # GPU usage/temp + mode, for custom/gpu
│   └── waybar-gpu-menu       # rofi menu to switch GPU mode
└── install.sh                 # Installer
```

## 📸 Screenshots
<img width="1920" height="37" alt="image" src="https://github.com/user-attachments/assets/b188e580-c2f2-44dc-b4bf-09ca573a3e46" />

<img width="1918" height="34" alt="2026-07-09_06-11" src="https://github.com/user-attachments/assets/c7193129-51da-441c-877c-4e1a1bdd6195" />

## 📄 License

[MIT](LICENSE) — use, modify, and share freely.
