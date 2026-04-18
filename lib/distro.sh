#!/usr/bin/env bash
# lib/distro.sh — detect distro family, locale, system upgrade

detect_distro() {
  [[ -f /etc/os-release ]] || die "/etc/os-release not found"
  # shellcheck source=/dev/null
  . /etc/os-release
  local id="${ID:-}"
  local id_like="${ID_LIKE:-}"
  case "$id $id_like" in
    *debian*|*ubuntu*) DISTRO_FAMILY="debian" ;;
    *fedora*|*rhel*|*centos*)
      DISTRO_FAMILY="fedora"
      if have dnf; then FEDORA_PM="dnf"; else FEDORA_PM="yum"; fi
      ;;
    *arch*|*manjaro*)  DISTRO_FAMILY="arch" ;;
    *suse*)            DISTRO_FAMILY="opensuse" ;;
    *) die "Unsupported distro: $id" ;;
  esac
  ok "Detected: $DISTRO_FAMILY"
  export DISTRO_FAMILY FEDORA_PM
}

# Detect WSL for platform-specific tweaks later
detect_wsl() {
  if grep -qi microsoft /proc/version 2>/dev/null; then
    SKYSHELL_IS_WSL=1
    log "WSL detected"
  else
    SKYSHELL_IS_WSL=0
  fi
  export SKYSHELL_IS_WSL
}

setup_locale() {
  log "Configuring locale (en_US.UTF-8)"
  case "$DISTRO_FAMILY" in
    debian)
      install_package locales
      run sudo sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
      run sudo locale-gen
      ;;
    fedora)
      install_package glibc-langpack-en
      ;;
    arch)
      # glibc already installed; just ensure generation
      run sudo sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
      run sudo locale-gen
      ;;
    opensuse)
      install_package glibc-locale || install_package glibc-locale-base
      ;;
  esac
  run sudo sh -c 'echo LANG=en_US.UTF-8 > /etc/locale.conf'
  export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
  ok "Locale set: en_US.UTF-8"
}

upgrade_system() {
  log "Upgrading system packages"
  case "$DISTRO_FAMILY" in
    debian)   run sudo apt-get update -y && run sudo apt-get upgrade -y ;;
    fedora)
      if [[ "$FEDORA_PM" == "dnf" ]]; then
        run sudo dnf upgrade --refresh -y
      else
        run sudo yum update -y
      fi
      ;;
    arch)     run sudo pacman -Syu --noconfirm ;;
    opensuse) run sudo zypper --non-interactive refresh && run sudo zypper --non-interactive update ;;
  esac
}
