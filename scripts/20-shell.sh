#!/usr/bin/env bash
# scripts/20-shell.sh — set zsh default, install zinit

set_zsh_default() {
  local zsh_path
  zsh_path="$(command -v zsh)" || die "zsh not installed"

  if ! grep -qxF "$zsh_path" /etc/shells 2>/dev/null; then
    log "Registering $zsh_path in /etc/shells"
    echo "$zsh_path" | run sudo tee -a /etc/shells >/dev/null
  fi

  local user="${USER:-$(id -un)}"
  if [[ "${SHELL:-}" != "$zsh_path" ]]; then
    log "Setting zsh as default shell for $user"
    run sudo chsh -s "$zsh_path" "$user" || warn "chsh failed — set manually later"
  else
    ok "zsh already default shell"
  fi
}

install_zinit() {
  local zinit_home="$HOME/.local/share/zinit/zinit.git"
  if [[ -d "$zinit_home/.git" ]]; then
    ok "zinit already installed"
    return 0
  fi
  log "Installing zinit"
  run mkdir -p "$(dirname "$zinit_home")"
  run git clone --quiet https://github.com/zdharma-continuum/zinit.git "$zinit_home"
}

stage_shell() {
  set_zsh_default
  install_zinit
}
