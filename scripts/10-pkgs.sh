#!/usr/bin/env bash
# scripts/10-pkgs.sh — base + distro-specific packages

stage_pkgs() {
  log "Installing base packages"
  local base=(
    git ca-certificates unzip curl wget zsh fzf bat eza btop
    fastfetch ripgrep tmux sshpass fontconfig
  )
  install_packages "${base[@]}" || warn "Some base packages failed — continuing"

  case "$DISTRO_FAMILY" in
    debian)
      install_packages bsdmainutils openssh-client build-essential locales
      ;;
    fedora)
      install_package openssh-clients
      # "@Development Tools" group — syntax works in both DNF4 and DNF5
      run sudo "$FEDORA_PM" install -y '@Development Tools' || warn "Dev Tools group failed"
      ;;
    arch)
      install_packages openssh base-devel
      ;;
    opensuse)
      install_packages openssh gcc make
      ;;
  esac
}
