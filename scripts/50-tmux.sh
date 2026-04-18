#!/usr/bin/env bash
# scripts/50-tmux.sh — tmux plugins (catppuccin, cpu, battery)

clone_plugin() {
  local repo="$1" dest="$2" ref="${3:-}"
  if [[ -d "$dest" ]]; then
    ok "tmux plugin already present: $dest"
    return 0
  fi
  log "Cloning tmux plugin: $repo"
  if [[ -n "$ref" ]]; then
    run git clone --quiet --depth=1 --branch "$ref" "$repo" "$dest"
  else
    run git clone --quiet --depth=1 "$repo" "$dest"
  fi
  run rm -rf "$dest/.git"
}

stage_tmux() {
  local base="$HOME/.config/tmux/plugins"
  run mkdir -p "$base"
  clone_plugin https://github.com/catppuccin/tmux.git      "$base/catppuccin/tmux" "v2.1.0"
  clone_plugin https://github.com/tmux-plugins/tmux-cpu    "$base/tmux-cpu"
  clone_plugin https://github.com/tmux-plugins/tmux-battery "$base/tmux-battery"
}
