#!/usr/bin/env bash
# ============================================================
#  Waybar — Midnight Ember Edition — Installer
# ============================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
BIN_DIR="$HOME/.local/bin"
BACKUP_DIR="$HOME/.config/waybar.bak.$(date +%Y%m%d-%H%M%S)"

info()  { printf '\033[1;34m[*]\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m[✓]\033[0m %s\n' "$1"; }
warn()  { printf '\033[1;33m[!]\033[0m %s\n' "$1"; }

echo "============================================"
echo "  Waybar — Midnight Ember Edition"
echo "============================================"

# ── 1. Check dependencies ───────────────────────────────────
REQUIRED=(waybar jq)
OPTIONAL=(hyprctl rofi wl-copy playerctl brightnessctl pavucontrol blueman-manager
          nvidia-smi supergfxctl asusctl warp-cli dunstctl checkupdates yay wf-recorder nvtop)

missing_required=()
for bin in "${REQUIRED[@]}"; do
  command -v "$bin" >/dev/null 2>&1 || missing_required+=("$bin")
done

if [ ${#missing_required[@]} -ne 0 ]; then
  echo "Missing required dependencies: ${missing_required[*]}"
  echo "Install them first, e.g.: sudo pacman -S ${missing_required[*]}"
  exit 1
fi

info "Checking optional dependencies (used by some modules)..."
for bin in "${OPTIONAL[@]}"; do
  if ! command -v "$bin" >/dev/null 2>&1; then
    warn "optional: '$bin' not found — related module(s) will show a fallback/off state"
  fi
done

python3 -c "import hijri_converter" 2>/dev/null || \
  warn "python package 'hijri_converter' not found — Hijri date toggle will fall back to time-only. Install with: pip install hijri-converter --break-system-packages"

# ── 2. Backup existing config ───────────────────────────────
if [ -d "$WAYBAR_CONFIG_DIR" ]; then
  info "Backing up existing config to $BACKUP_DIR"
  cp -r "$WAYBAR_CONFIG_DIR" "$BACKUP_DIR"
fi

# ── 3. Install config + style ───────────────────────────────
mkdir -p "$WAYBAR_CONFIG_DIR"
cp "$REPO_DIR/config.jsonc" "$WAYBAR_CONFIG_DIR/config.jsonc"
cp "$REPO_DIR/style.css"    "$WAYBAR_CONFIG_DIR/style.css"
ok "Copied config.jsonc and style.css to $WAYBAR_CONFIG_DIR"

# ── 4. Install scripts ──────────────────────────────────────
mkdir -p "$BIN_DIR"
cp "$REPO_DIR/scripts/waybar-hijri"      "$BIN_DIR/"
cp "$REPO_DIR/scripts/waybar-gpu-status" "$BIN_DIR/"
cp "$REPO_DIR/scripts/waybar-gpu-menu"   "$BIN_DIR/"
chmod +x "$BIN_DIR/waybar-hijri" "$BIN_DIR/waybar-gpu-status" "$BIN_DIR/waybar-gpu-menu"
ok "Installed scripts to $BIN_DIR"

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$BIN_DIR"; then
  warn "$BIN_DIR is not in your \$PATH. Add this to your shell rc file:"
  echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# ── 5. Restart Waybar ────────────────────────────────────────
if pgrep -x waybar >/dev/null 2>&1; then
  info "Restarting Waybar..."
  killall waybar
fi
setsid waybar >/dev/null 2>&1 &
disown

ok "Done! Waybar restarted with Midnight Ember."
echo "If a previous config existed, your backup is at: $BACKUP_DIR"
