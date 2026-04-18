#!/usr/bin/env bash
# scripts/40-fonts.sh — Nerd Fonts (JetBrainsMono)

NERD_FONT_VERSION="${NERD_FONT_VERSION:-v3.4.0}"
NERD_FONT_PKG="${NERD_FONT_PKG:-JetBrainsMono}"

stage_fonts() {
  local font_dir="$HOME/.local/share/fonts"
  local marker="$font_dir/.skyshell-${NERD_FONT_PKG}-${NERD_FONT_VERSION}"

  if [[ -f "$marker" ]]; then
    ok "Nerd Font ${NERD_FONT_PKG} ${NERD_FONT_VERSION} already installed"
    return 0
  fi

  log "Installing Nerd Font: ${NERD_FONT_PKG} ${NERD_FONT_VERSION}"
  run mkdir -p "$font_dir"
  local url="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_VERSION}/${NERD_FONT_PKG}.zip"
  local tmp
  tmp="$(mktemp -d)"
  run bash -c "curl -sSL -o '$tmp/font.zip' '$url' && unzip -q -o '$tmp/font.zip' -d '$font_dir'"
  run rm -rf "$tmp"
  run fc-cache -f "$font_dir" >/dev/null 2>&1 || true
  run touch "$marker"
  ok "Fonts cache refreshed"
}
