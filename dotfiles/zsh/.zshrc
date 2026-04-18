# skyshell baseline .zshrc
# This is managed by stow — user-local additions should go in ~/.zshrc.local

# ---- Zinit ----
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ -f "$ZINIT_HOME/zinit.zsh" ]] && source "$ZINIT_HOME/zinit.zsh"

# Plugins (turbo-load where possible)
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab
zinit light sunlei/zsh-ssh
zinit light greymd/docker-zsh-completion

# oh-my-zsh git plugin snippet (no full framework)
zinit snippet OMZP::git

ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# ---- Completion ----
autoload -Uz compinit && compinit

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

# ---- History ----
HISTSIZE=500000
SAVEHIST=$HISTSIZE
HISTFILE=$HOME/.zsh_history
setopt append_history share_history hist_ignore_space hist_ignore_all_dups \
       hist_save_no_dups hist_ignore_dups hist_find_no_dups

# ---- Aliases ----
# bat binary name differs per distro — resolved at shell start
if command -v batcat >/dev/null 2>&1; then
  alias cat='batcat'
elif command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi
alias l='eza --icons -F -H --group-directories-first --git -1'
alias ls='eza --icons -F -H --group-directories-first --git -1'
alias ll='eza --icons -F -H --group-directories-first --git -1 -lah'
alias grep='rg -i'
alias zgrep='rg -z'
alias vim='nvim'
alias tmux='tmux -2'
alias ssh="ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3"

# ---- FZF ----
export FZF_PREVIEW_WINDOW='right:60%'
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}' --preview-window=right:60%"
export FZF_CTRL_R_OPTS="--sort --preview 'echo {}' --preview-window=down:3:wrap"

fzf-history-widget() {
  local result
  result=$(fc -l 1 | sed 's/^[ ]*[0-9]*[ \t]*//' | fzf --tac --query="$LBUFFER" --preview 'echo {}' --preview-window=down:3:wrap)
  if [[ -n $result ]]; then
    BUFFER=$result
    CURSOR=$#BUFFER
  fi
  zle redisplay
}
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget

[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# ---- PATH ----
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  "$HOME/go/bin"
  /opt/nvim-linux-x86_64/bin
  /opt/nvim-linux64/bin
  /snap/bin
  /usr/local/bin
  $path
)
typeset -U path PATH
export PATH

# ---- Editor ----
export EDITOR="nvim"
export VISUAL="nvim"

# ---- Starship ----
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# ---- Local user additions ----
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
