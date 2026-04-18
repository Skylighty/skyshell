#!/usr/bin/env bash
# skyshell bootstrap — modular orchestrator
set -euo pipefail

SKYSHELL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SKYSHELL_ROOT

# shellcheck source=lib/common.sh
source "$SKYSHELL_ROOT/lib/common.sh"
# shellcheck source=lib/distro.sh
source "$SKYSHELL_ROOT/lib/distro.sh"

SKYSHELL_STAGES_ALL=(locale pkgs shell tools fonts tmux dotfiles)
SKYSHELL_STAGES=("${SKYSHELL_STAGES_ALL[@]}")
SKYSHELL_SKIP_UPGRADE=0

usage() {
  cat <<EOF
skyshell — bootstrap a new shell environment

Usage: bootstrap.sh [options]

Options:
  --only STAGES     Comma-separated list: ${SKYSHELL_STAGES_ALL[*]}
  --skip-upgrade    Skip system package upgrade
  --dry-run         Print commands instead of executing
  --force-nvim      Reinstall nvim + LazyVim even if present
  --skip-docker     Skip Docker + lazydocker install
  -h, --help        Show this help

Env (for non-interactive):
  SKYSHELL_NONINTERACTIVE=1
  SKYSHELL_GIT_EMAIL=...
  SKYSHELL_GIT_NAME=...

Supported distro families: debian, fedora, arch, opensuse
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --only)          IFS=',' read -ra SKYSHELL_STAGES <<< "$2"; shift 2 ;;
      --skip-upgrade)  SKYSHELL_SKIP_UPGRADE=1; shift ;;
      --dry-run)       export SKYSHELL_DRY_RUN=1; shift ;;
      --force-nvim)    export SKYSHELL_FORCE_NVIM=1; shift ;;
      --skip-docker)   export SKYSHELL_SKIP_DOCKER=1; shift ;;
      -h|--help)       usage; exit 0 ;;
      *) die "Unknown option: $1 (see --help)" ;;
    esac
  done
}

wants_stage() {
  local target="$1"
  for s in "${SKYSHELL_STAGES[@]}"; do
    [[ "$s" == "$target" ]] && return 0
  done
  return 1
}

load_stage() {
  # shellcheck source=/dev/null
  source "$SKYSHELL_ROOT/scripts/$1.sh"
}

main() {
  parse_args "$@"
  : > "$SKYSHELL_LOG"
  log "skyshell bootstrap starting"
  log "Stages: ${SKYSHELL_STAGES[*]}"

  detect_distro
  detect_wsl

  load_stage 10-pkgs
  load_stage 20-shell
  load_stage 30-tools
  load_stage 40-fonts
  load_stage 50-tmux
  load_stage 60-dotfiles

  if wants_stage locale; then
    setup_locale
  fi

  if [[ "$SKYSHELL_SKIP_UPGRADE" == 0 ]]; then
    upgrade_system
  else
    log "Skipping system upgrade (--skip-upgrade)"
  fi

  wants_stage pkgs     && stage_pkgs
  wants_stage shell    && stage_shell
  wants_stage tools    && stage_tools
  wants_stage fonts    && stage_fonts
  wants_stage tmux     && stage_tmux
  wants_stage dotfiles && stage_dotfiles

  ok "skyshell bootstrap complete"
  log "Log: $SKYSHELL_LOG"
  log "Restart your terminal (or: exec zsh) to pick up changes."
}

main "$@"
