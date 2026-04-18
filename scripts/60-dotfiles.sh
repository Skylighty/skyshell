#!/usr/bin/env bash
# scripts/60-dotfiles.sh — link configs from dotfiles/ via GNU Stow

ensure_stow() {
  if have stow; then return 0; fi
  log "Installing GNU Stow"
  install_package stow
}

stow_pkg() {
  local pkg="$1"
  local src="$SKYSHELL_ROOT/dotfiles/$pkg"
  [[ -d "$src" ]] || { warn "Missing dotfiles/$pkg — skipping"; return 0; }
  log "Stowing $pkg"
  # Back up any conflicting existing files first
  while IFS= read -r -d '' relpath; do
    local target="$HOME/${relpath#"$src/"}"
    [[ -e "$target" || -L "$target" ]] && ! [[ -L "$target" && "$(readlink -f "$target")" == "$(readlink -f "$src/${relpath#"$src/"}")" ]] && backup_if_exists "$target"
  done < <(find "$src" -type f -print0)

  run stow --dir="$SKYSHELL_ROOT/dotfiles" --target="$HOME" --restow "$pkg"
}

write_git_identity() {
  local email="${SKYSHELL_GIT_EMAIL:-}"
  local name="${SKYSHELL_GIT_NAME:-}"
  if [[ "${SKYSHELL_NONINTERACTIVE:-0}" != "1" ]]; then
    if [[ -z "$email" ]]; then
      read -r -p "$(printf "%bgit email:%b " "$GREEN" "$NC")" email
    fi
    if [[ -z "$name" ]]; then
      read -r -p "$(printf "%bgit name:%b " "$GREEN" "$NC")" name
    fi
  fi
  [[ -n "$email" ]] && run git config --global user.email "$email"
  [[ -n "$name"  ]] && run git config --global user.name  "$name"
}

stage_dotfiles() {
  ensure_stow
  # Pre-create shared directories so stow can't tree-fold them into a single
  # symlink and clobber sibling apps' configs.
  run mkdir -p "$HOME/.config"
  stow_pkg zsh
  stow_pkg tmux
  stow_pkg starship
  write_git_identity
}
