#!/usr/bin/env bash
# scripts/30-tools.sh — navi, fzf keybindings, nvim (LazyVim), lazydocker, docker

install_navi() {
  if have navi; then
    ok "navi already installed"
    return 0
  fi
  log "Installing navi"
  # Upstream installer respects NAVI_PATH / does to ~/.local/bin by default
  run bash -c 'curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install'
}

install_fzf_keybinds() {
  local src="/usr/share/doc/fzf/examples/key-bindings.zsh"
  if [[ -f "$src" ]]; then
    run cp "$src" "$HOME/.fzf.zsh"
    ok "fzf keybindings → ~/.fzf.zsh"
  else
    warn "fzf keybindings not found at $src (distro ships them elsewhere — skipping)"
  fi
}

install_nvim() {
  local prefix="/opt/nvim-linux-x86_64"
  if [[ -d "$prefix" && "${SKYSHELL_FORCE_NVIM:-0}" != "1" ]]; then
    ok "nvim already installed at $prefix (use --force-nvim to reinstall)"
  else
    log "Installing Neovim (latest static build)"
    local tmp
    tmp="$(mktemp -d)"
    run bash -c "cd '$tmp' && curl -sSLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    run sudo rm -rf "$prefix"
    run sudo tar -C /opt -xzf "$tmp/nvim-linux-x86_64.tar.gz"
    run rm -rf "$tmp"
  fi

  if [[ -d "$HOME/.config/nvim" && "${SKYSHELL_FORCE_NVIM:-0}" != "1" ]]; then
    ok "nvim config exists — skipping LazyVim starter"
  else
    backup_if_exists "$HOME/.config/nvim"
    log "Cloning LazyVim starter"
    run mkdir -p "$HOME/.config"
    run git clone --quiet https://github.com/LazyVim/starter "$HOME/.config/nvim"
    run rm -rf "$HOME/.config/nvim/.git"
  fi
}

install_starship() {
  if have starship; then
    ok "starship already installed"
    return 0
  fi
  log "Installing Starship"
  run bash -c 'curl -sS https://starship.rs/install.sh | sh -s -- -y'
}

install_docker() {
  if [[ "${SKYSHELL_SKIP_DOCKER:-0}" == "1" ]]; then
    log "Skipping Docker (SKYSHELL_SKIP_DOCKER=1)"
    return 0
  fi
  if have docker; then
    ok "docker already installed"
  else
    log "Installing Docker engine (get.docker.com)"
    local tmp
    tmp="$(mktemp -d)"
    run bash -c "curl -fsSL https://get.docker.com -o '$tmp/get-docker.sh' && sudo sh '$tmp/get-docker.sh'"
    run rm -rf "$tmp"
  fi
  local user="${USER:-$(id -un)}"
  if ! id -nG "$user" | grep -qw docker; then
    log "Adding $user to docker group (requires re-login)"
    run sudo usermod -aG docker "$user" || warn "usermod failed"
  fi
}

install_lazydocker() {
  if have lazydocker; then
    ok "lazydocker already installed"
    return 0
  fi
  log "Installing lazydocker"
  run bash -c 'curl -s https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash'
}

stage_tools() {
  install_navi
  install_fzf_keybinds
  install_nvim
  install_starship
  install_docker
  install_lazydocker
}
