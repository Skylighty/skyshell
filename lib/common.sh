#!/usr/bin/env bash
# lib/common.sh — logging, error handling, helpers

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SKYSHELL_LOG="${SKYSHELL_LOG:-$HOME/.skyshell.log}"
SKYSHELL_DRY_RUN="${SKYSHELL_DRY_RUN:-0}"

log()  { printf "%b[skyshell]%b %s\n" "$BLUE"  "$NC" "$*" | tee -a "$SKYSHELL_LOG"; }
ok()   { printf "%b[ok]%b %s\n"       "$GREEN" "$NC" "$*" | tee -a "$SKYSHELL_LOG"; }
warn() { printf "%b[warn]%b %s\n"     "$YELLOW" "$NC" "$*" | tee -a "$SKYSHELL_LOG" >&2; }
err()  { printf "%b[err]%b %s\n"      "$RED"   "$NC" "$*" | tee -a "$SKYSHELL_LOG" >&2; }
die()  { err "$*"; exit 1; }

run() {
  if [[ "$SKYSHELL_DRY_RUN" == "1" ]]; then
    printf "%b[dry]%b %s\n" "$YELLOW" "$NC" "$*"
    return 0
  fi
  "$@"
}

have() { command -v "$1" >/dev/null 2>&1; }

backup_if_exists() {
  local path="$1"
  [[ -e "$path" || -L "$path" ]] || return 0
  local ts
  ts="$(date +%Y%m%d-%H%M%S)"
  local bak="${path}.bak-${ts}"
  log "Backing up existing $path -> $bak"
  run mv "$path" "$bak"
}

install_package() {
  [[ -n "${1:-}" ]] || { err "install_package: no package name"; return 1; }
  local package="$1"
  log "Installing $package"
  case "$DISTRO_FAMILY" in
    debian)  run sudo apt-get install -y -qq "$package" ;;
    fedora)  run sudo "$FEDORA_PM" install -y "$package" ;;
    arch)    run sudo pacman -S --noconfirm --needed "$package" ;;
    opensuse) run sudo zypper --non-interactive install "$package" ;;
    *) die "install_package: unknown DISTRO_FAMILY=$DISTRO_FAMILY" ;;
  esac
}

install_packages() {
  local failed=()
  for p in "$@"; do
    install_package "$p" || failed+=("$p")
  done
  if ((${#failed[@]})); then
    warn "Failed to install: ${failed[*]}"
    return 1
  fi
}

# bat binary is batcat on Debian, bat elsewhere
bat_binary() {
  if [[ "$DISTRO_FAMILY" == "debian" ]]; then
    echo "batcat"
  else
    echo "bat"
  fi
}
