# Skyshell

Batteries-included shell/terminal setup: zsh + zinit, starship, tmux with catppuccin, Neovim (LazyVim), Nerd Fonts, fzf, ripgrep, bat, eza, btop. One script, multi-distro.

## Supported distributions

| Family        | Package manager    | Tested |
|---------------|--------------------|--------|
| Debian/Ubuntu | apt                | CI     |
| Fedora/RHEL   | dnf (yum fallback) | CI     |
| Arch/Manjaro  | pacman             | CI     |
| openSUSE      | zypper             | CI     |

Detected via `/etc/os-release`.

## Quick start

```bash
git clone https://github.com/Skylighty/skyshell.git
cd skyshell
./bootstrap.sh
```

Non-interactive (CI, automation):

```bash
SKYSHELL_NONINTERACTIVE=1 \
SKYSHELL_GIT_EMAIL=you@example.com \
SKYSHELL_GIT_NAME=you \
./bootstrap.sh --skip-upgrade
```

## Options

| Flag             | Effect                                                                      |
|------------------|-----------------------------------------------------------------------------|
| `--only STAGES`  | Comma-separated subset of: `locale pkgs shell tools fonts tmux dotfiles`    |
| `--skip-upgrade` | Skip system package upgrade                                                 |
| `--dry-run`      | Print commands instead of executing                                         |
| `--force-nvim`   | Reinstall nvim + LazyVim even if present                                    |
| `--skip-docker`  | Skip Docker engine + lazydocker                                             |
| `-h`, `--help`   | Show usage                                                                  |

Stages run in this order (with deps respected): `locale → upgrade → pkgs → shell → tools → fonts → tmux → dotfiles`.

## Layout

```
bootstrap.sh         # thin orchestrator
lib/
  common.sh          # logging, helpers, install_package
  distro.sh          # detection, locale, upgrade
scripts/
  10-pkgs.sh         # base + distro-specific packages
  20-shell.sh        # zsh default + zinit
  30-tools.sh        # nvim, starship, docker, lazydocker, navi, fzf
  40-fonts.sh        # Nerd Fonts
  50-tmux.sh         # tmux plugins
  60-dotfiles.sh     # stow configs + git identity
dotfiles/
  zsh/.zshrc         # linked via GNU Stow
  tmux/.tmux.conf
  starship/.config/starship.toml
```

Configs live in `dotfiles/` and are linked into `$HOME` via GNU Stow. Editing a config is a commit, not a script edit.

## Local additions

`~/.zshrc` is managed by stow. **Never edit it directly** — changes are lost on re-stow. Instead, put your personal settings in `~/.zshrc.local`:

```zsh
# ~/.zshrc.local
export PATH="$HOME/.bun/bin:$PATH"
alias my-thing='...'
```

The baseline `.zshrc` sources it at the end.

## Idempotency

Safe to re-run. Existing configs are backed up to `~/.zshrc.bak-YYYYMMDD-HHMMSS` before being re-stowed. Already-installed tools are skipped.

## Troubleshooting

### Prompt glitches / garbled characters / `<c4><99>` instead of `ę`

**Cause:** your locale isn't generated. Common on fresh Arch WSL, minimal cloud images, container bases. `LANG=en_US.UTF-8` is set but `locale -a` doesn't include it — glibc silently falls back to C (ASCII), breaking ZLE width math and multibyte rendering.

**Check:**

```bash
locale -a | grep -i utf
```

If `en_US.utf8` is missing, run:

```bash
./bootstrap.sh --only locale --skip-upgrade
```

Then `exec zsh` (or `tmux kill-server && tmux`).

### `chsh` says "invalid shell"

Zsh isn't in `/etc/shells`. The script auto-appends it, but on locked-down systems you may need to do it manually:

```bash
command -v zsh | sudo tee -a /etc/shells
chsh -s "$(command -v zsh)"
```

### Nerd Font glyphs show as boxes

Your terminal isn't configured to use a Nerd Font. In Windows Terminal: settings → profile → appearance → Font face → `JetBrainsMono Nerd Font`.

### `bat` command not found on Debian/Ubuntu

Debian renames the binary to `batcat`. The shipped `.zshrc` aliases `cat` to the right one automatically.

## Development

Run smoke tests locally per distro:

```bash
docker build -f Dockerfile.arch     -t skyshell-arch     .
docker build -f Dockerfile.debian   -t skyshell-debian   .
docker build -f Dockerfile.fedora   -t skyshell-fedora   .
docker build -f Dockerfile.opensuse -t skyshell-opensuse .
```

Shellcheck:

```bash
shellcheck bootstrap.sh lib/*.sh scripts/*.sh
```

CI runs both on every PR.

## License

MIT.
