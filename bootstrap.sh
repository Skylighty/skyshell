#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Function to install packages with colorful indicators
install_package() {
  # Check if the package name is provided
  if [[ -z "$1" ]]; then
    echo -e "${RED}Error: No package name provided.${RESET}"
    return 1
  fi

  local package=$1

  echo -e "${YELLOW}Installing package: ${package}${RESET}"

  # Update package list (optional, can be removed if unnecessary)
  sudo apt update -qq || {
    echo -e "${RED}Failed to update package list.${RESET}"
    return 1
  }

  # Install the package
  if sudo apt install -y -qq "$package"; then
    echo -e "${GREEN}Successfully installed ${package}.${RESET}"
    return 0
  else
    echo -e "${RED}Failed to install ${package}.${RESET}"
    return 1
  fi
}

echo -e "${GREEN}Starting setup...${NC}"
read -p "$(echo -e "${GREEN}Input your ${RED}git ${YELLOW}email: ${NC}")" GIT_MAIL
read -p "$(echo -e "${GREEN}Input your ${RED}git ${YELLOW}username: ${NC}")" GIT_USERNAME

sudo cat <<'EOF' >/etc/apt/apt.conf.d/99parallel
APT::Acquire::Retries "3";
APT::Acquire::Queue-Mode "access";
Acquire::Languages "none";
APT::Install-Recommends "false";
APT::Get::AllowUnauthenticated "true";
APT::Get::Assume-Yes "true";

APT::Get::Only-Source "false" ;
EOF

# Update and upgrade system
sudo apt update -y && sudo apt upgrade -y

# Install base packages
echo -e "${GREEN}Installing base packages...${NC}"
install_package git
install_package ca-certificates
install_package unzip
install_package openssh-client
install_package curl
install_package wget
install_package zsh
install_package build-essential
install_package fzf
install_package bat
install_package exa
install_package eza
install_package btop
install_package fastfetch
install_package ripgrep
install_package tmux
install_package sshpass
install_package fontconfig

# Set Zsh as the default shell
echo -e "${GREEN}Setting Zsh as default shell...${NC}"
chsh -s "$(which zsh)"

curl -sSL git.io/antigen >$HOME/.antigen.zsh

# Configure .zshrc
echo -e "${GREEN}Configuring Zsh...${NC}"
cat <<'EOF' >$HOME/.zshrc
# Load Antigen
source $HOME/.antigen.zsh

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':completion:*:*:ssh:*' hosts ${(f)"$(awk '/^Host / {print $2}' ~/.ssh/config | grep -v '^\*$')"}

# Plugins and themes using Antigen
antigen use oh-my-zsh
antigen bundle Aloxaf/fzf-tab
antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-history-substring-search

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Apply Antigen configuration
antigen apply

# Load completions
autoload -U compinit; compinit

# Aliases
alias l='exa --icons -F -H --group-directories-first --git -1'
alias ls='exa --icons -F -H --group-directories-first --git -1'
alias cat='batcat'
alias grep='rg'
alias ll='exa --icons -F -H --group-directories-first --git -1 -lah'
alias vim='nvim'
alias tmux='tmux -2'
alias ssh="ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3"

# Path updates
export PATH="$HOME/bin:$PATH"

# History
export HISTSIZE=500000
export HISTFILE=$HOME/.zsh_history
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
export FZF_PREVIEW_WINDOW='right:60%'
setopt appendhistory
setopt sharehistory
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# FZF integration for history
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}' --preview-window=right:60%"
export FZF_CTRL_R_OPTS="--sort --preview 'echo {}' --preview-window=down:3:wrap"

# Enhanced History Search with FZF
fzf-history-widget() {
  # Remove line numbers from history
  local result=$(fc -l 1 | sed 's/^[ ]*[0-9]*[ \t]*//' | fzf --tac --query="$LBUFFER" --preview 'echo {}' --preview-window=down:3:wrap)
  if [[ -n $result ]]; then
    BUFFER=$result
    CURSOR=$#BUFFER
  fi
  zle redisplay
}

# Bind Ctrl+R to FZF-based History Search
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget


# FZF keybindings
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

export EDITOR="nvim"
export VISUAL="nvim"

eval "$(starship init zsh)"
EOF

sudo rm -r $HOME/.config/nvim >/dev/null
sudo rm -r $HOME/opt/nvim* >/dev/null
echo -e "${GREEN}Downloading nvim static build - latest${NC}."
curl -sSLO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
echo -e "${GREEN}Unpacking nvim to${NC} /opt/nvim-linux64${GREEN}!${NC}"
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
echo 'export PATH="${PATH}:/opt/nvim-linux64/bin"' >>$HOME/.zshrc
mkdir -p $HOME/.config
git clone --quiet https://github.com/LazyVim/starter $HOME/.config/nvim

# FZF keybindings
echo -e "${GREEN}Installing FZF keybindings...${NC}"
sudo /usr/share/doc/fzf/examples/key-bindings.zsh >~/.fzf.zsh

# Install Starship prompt (optional)
echo -e "${GREEN}Installing Starship prompt (optional)...${NC}"
curl -sS https://starship.rs/install.sh | sh -s -- -y

cat <<'EOF' >$HOME/.config/starship.toml
# Insert a blank line between shell prompts
add_newline = true

# Increase the default command timeout to 2 seconds
command_timeout = 2000

palette = "catppuccin_mocha"

# Define the order and format of the information in our prompt
format = """\
[](fg:#3B76F0)\
$directory\
${custom.directory_separator_not_git}\
${custom.directory_separator_git}\
$symbol($git_branch[](fg:#FCF392))\
$symbol( $git_commit$git_status$git_metrics$git_state)$fill$cmd_duration$nodejs$all\
${custom.git_config_email}
$character"""

# Fill character (empty space) between the left and right prompt
[fill]
symbol = " "

# Disable the line break between the first and second prompt lines
[line_break]
disabled = true

# Customize the format of the working directory
[directory]
truncate_to_repo = true
format = "[  $path ]($style)"
style = "fg:text bg:#3B76F0"

[git_branch]
symbol = " "
format = "[ $symbol$branch(:$remote_branch) ]($style)"
style = "fg:#1C3A5E bg:#FCF392"

[git_metrics]
disabled = false

[nodejs]
format = "via [$symbol($version )]($style)"
style = "yellow"

[package]
disabled = true # Enable to output the current working directory's package version
format = "[$symbol$version]($style) "
display_private = true

# Output the command duration if over 2 seconds
[cmd_duration]
min_time = 2_000
format = "[  $duration ]($style)"
style = "white"

# Customize the battery indicator
[battery]
format = "[$symbol $percentage]($style) "
empty_symbol = "🪫"
charging_symbol = "🔋"
full_symbol = '🔋'

[[battery.display]]
threshold = 10
style = 'red'

# Output the current git config email address
[custom.git_config_email]
description = "Output the current git user's configured email address."
command = "git config user.email"
format = "\n[$symbol(  $output)]($style)"
# Only when inside git repository
when = "git rev-parse --is-inside-work-tree >/dev/null 2>&1"
style = "text"

# Output a styled separator right after the directory when inside a git repository.
[custom.directory_separator_git]
description = "Output a styled separator right after the directory when inside a git repository."
command = ""
format = "[](fg:#3B76F0 bg:#FCF392)"
# Only when inside git repository
when = "git rev-parse --is-inside-work-tree >/dev/null 2>&1"

# Output a styled separator right after the directory when NOT inside a git repository.
[custom.directory_separator_not_git]
description = "Output a styled separator right after the directory when NOT inside a git repository."
command = ""
format = "[](fg:#3B76F0)"
# Only when NOT inside a git repository
when = "! git rev-parse --is-inside-work-tree > /dev/null 2>&1"

[palettes.catppuccin_mocha]
rosewater = "#f5e0dc"
flamingo = "#f2cdcd"
pink = "#f5c2e7"
mauve = "#cba6f7"
red = "#f38ba8"
maroon = "#eba0ac"
peach = "#fab387"
yellow = "#f9e2af"
green = "#a6e3a1"
teal = "#94e2d5"
sky = "#89dceb"
sapphire = "#74c7ec"
blue = "#89b4fa"
lavender = "#b4befe"
text = "#cdd6f4"
subtext1 = "#bac2de"
subtext0 = "#a6adc8"
overlay2 = "#9399b2"
overlay1 = "#7f849c"
overlay0 = "#6c7086"
surface2 = "#585b70"
surface1 = "#45475a"
surface0 = "#313244"
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"
EOF

wget -q -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip &&
  cd ~/.local/share/fonts &&
  unzip JetBrainsMono.zip &&
  rm JetBrainsMono.zip &&
  fc-cache -fv >/dev/null

mkdir -p $HOME/.config/tmux/plugins/catppuccin
git clone --quiet -b v2.1.0 https://github.com/catppuccin/tmux.git $HOME/.config/tmux/plugins/catppuccin/tmux
sudo rm -r $HOME/.config/tmux/plugins/catppuccin/tmux/.git
git clone --quiet https://github.com/tmux-plugins/tmux-cpu $HOME/.config/tmux/plugins/tmux-cpu
sudo rm -r $HOME/.config/tmux/plugins/tmux-cpu/.git
git clone --quiet https://github.com/tmux-plugins/tmux-battery $HOME/.config/tmux/plugins/tmux-battery
sudo rm -r $HOME/.config/tmux/plugins/tmux-battery/.git

cat <<'EOF' >$HOME/.tmux.conf
# ~/.tmux.conf

# Options to make tmux more pleasant
set -g mouse on
set-option -g default-terminal "screen-256color"
set-option -ga terminal-overrides ",xterm-256color:Tc"

# Configure the catppuccin plugin
set -g @catppuccin_flavor "mocha" # latte, frappe, macchiato, or mocha
set -g @catppuccin_window_status_style "rounded" # basic, rounded, slanted, custom, or none

# Load catppuccin
run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux

# Make the status line pretty and add some modules
set -g status-right-length 100
set -g status-left-length 100
set -g status-left ""
set -g status-right "#{E:@catppuccin_status_application}"
set -agF status-right "#{E:@catppuccin_status_cpu}"
set -ag status-right "#{E:@catppuccin_status_session}"
set -ag status-right "#{E:@catppuccin_status_uptime}"
set -agF status-right "#{E:@catppuccin_status_battery}"

# Prefix fix
set -g prefix C-space
unbind C-b
bind C-space send-prefix

# Reload fix
unbind r
bind r source-file $HOME/.tmux.conf

# Keybindings
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

bind-key '%' split-window -h
bind-key '"' split-window -v

bind -n S-Left previous-window
bind -n S-Right next-window

run $HOME/.config/tmux/plugins/tmux-cpu/cpu.tmux
run $HOME/.config/tmux/plugins/tmux-battery/battery.tmux
EOF

git config --global user.email $GIT_MAIL
git config --global user.name $GIT_USERNAME
