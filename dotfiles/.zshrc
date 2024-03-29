# Goto
[[ -s "/usr/local/share/goto.sh" ]] && source /usr/local/share/goto.sh

# NVM lazy load
if [ -s "$HOME/.nvm/nvm.sh" ]; then
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  alias nvm='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && nvm'
  alias node='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && node'
  alias npm='unalias nvm node npm && . "$NVM_DIR"/nvm.sh && npm'
fi

# Fix Interop Error that randomly occurs in vscode terminal when using WSL2
fix_wsl2_interop() {
    for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
        if [[ -e "/run/WSL/${i}_interop" ]]; then
            export WSL_INTEROP=/run/WSL/${i}_interop
        fi
    done
}

# Kubectl Functions
# ---
#
alias k="kubectl"
alias h="helm"

kn() {
    if [ "$1" != "" ]; then
	    kubectl config set-context --current --namespace=$1
    else
	    echo -e "\e[1;31m Error, please provide a valid Namespace\e[0m"
    fi
}

knd() {
    kubectl config set-context --current --namespace=default
}

ku() {
    kubectl config unset current-context
}

# Colormap
function colormap() {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

# ALIAS COMMANDS
alias l="exa --icons --group-directories-first"
alias ls="exa --icons --group-directories-first"
alias ll="exa --icons --group-directories-first -la"
alias g="goto"
alias cats="pygmentize -g -O style=monokai"
alias ports="ss -tulnap"
alias grep='grep --color'
alias su='su -'
alias python='python3'
alias cbp="code /home/xcad/obsidianvault/boilerplates"
alias cpr="code /home/xcad/obsidianvault/projects"

# find out which distribution we are running on
LFILE="/etc/os-release"
MFILE="/System/Library/CoreServices/SystemVersion.plist"
if [[ -f $LFILE ]]; then
  _distro=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
elif [[ -f $MFILE ]]; then
  _distro="macos"
fi

# set an icon based on the distro
# make sure your font is compatible with https://github.com/lukas-w/font-logos
case $_distro in
    *kali*)                  ICON="ﴣ";;
    *arch*)                  ICON="";;
    *debian*)                ICON="";;
    *raspbian*)              ICON="";;
    *ubuntu*)                ICON="";;
    *elementary*)            ICON="";;
    *fedora*)                ICON="";;
    *coreos*)                ICON="";;
    *gentoo*)                ICON="";;
    *mageia*)                ICON="";;
    *centos*)                ICON="";;
    *opensuse*|*tumbleweed*) ICON="";;
    *sabayon*)               ICON="";;
    *slackware*)             ICON="";;
    *linuxmint*)             ICON="";;
    *alpine*)                ICON="";;
    *aosc*)                  ICON="";;
    *nixos*)                 ICON="";;
    *devuan*)                ICON="";;
    *manjaro*)               ICON="";;
    *rhel*)                  ICON="";;
    *macos*)                 ICON="";;
    *)                       ICON="";;
esac

export STARSHIP_DISTRO="$ICON"

# Plugins
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.zsh/zsh-z/zsh-z.plugin.zsh
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.zsh/zsh-abbr/zsh-abbr.plugin.zsh

# Load Starship
eval "$(starship init zsh)"
export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/$HOME/static/nvim/bin"
export PATH="$PATH:$HOME/.local/bin:$HOME/.cargo/bin"
alias vim="lvim"
alias containers="sudo docker ps -a"
#alias docker="sudo docker"
alias killdock='docker rm -f fea72a7ec886'
export MODULAR_HOME="$HOME/.modular"
export PATH="$HOME/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
alias ssh="ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3"

if [ -f "/etc/wsl.conf" ]; then
  if [ -z "$TMUX" ]; then
    exec tmux  
  fi
fi

autoload -U compinit; compinit

alias desktop='/mnt/c/Users/Pablo/Desktop'
alias downloads='/mnt/c/Users/Pablo/Downloads'

export NPM_CONFIG_PREFIX=$HOME/.npm-global
export PATH="${PATH}:/$HOME/.npm-global/bin"
export PATH="${PATH}:/$HOME/static/nvim-linux64/bin"
export PATH="${PATH}:/$HOME/static/node-v20.11.1-linux-x64/bin"
