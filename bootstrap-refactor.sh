#!/bin/bash

#COLOR CODES
RED='\033[0;31m'
GREEN='\033[0;32m'
YELL='\033[0;33m'
CYAN='\033[0;36m'
PURP='\033[0;35m'
NC='\033[0m'
#END OF COLOR CODES

# Function to install packages
install_package() {
    package=$1
    echo -e "${YELL}Installing $package${NC}..."
    sudo apt-get install -y "$package" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Installed $package${NC}!"
    else
        echo -e "${RED}Failed to install $package${NC}. Please check your internet connection or try again later."
    fi
}

echo -e "${RED}WARNING!${NC} This program may install some heavy-weight features and apps on your system. Do you want to proceed? [${GREEN}y${NC}/${RED}n${NC}]:"
read -p "Your answer: " choice

case $choice in
    'y')
        # Install dependencies
        echo -e "${YELL}Setting up dependencies...${NC}"

        # Handle sudo and needrestart
        echo -e "${YELL}Setting up sudo...${NC}"
        sudo grep -qxF "${USER} ALL=(ALL) NOPASSWD: ALL" /etc/sudoers || echo "${USER} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null
        sudo apt-get purge -y --auto-remove needrestart > /dev/null 2>&1

        # Upgrade system
        echo -e "${YELL}Updating system...${NC}"
        sudo apt-get update -y > /dev/null
        sudo apt-get upgrade -y > /dev/null
        echo -e "${GREEN}System updated!${NC}"

        # Install additional packages
        install_package "build-essential"
        install_package "tmux"
        install_package "unzip"
        install_package "mc"
        install_package "neofetch"
        install_package "net-tools"
        install_package "tree"
        install_package "iftop"
        install_package "traceroute"
        install_package "nmap"
        install_package "vnstat"
        install_package "hping3"
        install_package "python3-pip"
        install_package "python3-venv"
        python3 -m pip install --user pygments > /dev/null 2>&1
        install_package "mlocate"
        install_package "cargo"
        install_package "duf"
        install_package "ripgrep"
        install_package "tldr"
        #curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        echo | curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh
        cargo install procs

        # Install Node.js and npm
        install_package "nodejs"
        install_package "npm"

        # Resolve npm global problem
        mkdir -p "$HOME/.npm-global"
        npm config set prefix '~/.npm-global'
        echo 'export NPM_CONFIG_PREFIX=~/.npm-global' >> "$HOME/.bashrc"
        echo 'export PATH="${PATH}:/$HOME/.npm-global/bin"' > "$HOME/.profile"
        echo 'source $HOME/.profile' >> "$HOME/.bashrc"
        source "$HOME/.profile"

        # Install skyshell 

        # Copy the dotfiles
        echo -e "${YELL}Setting up skyshell...${NC}"
        cp -r ./dotfiles/. $HOME/
        
        # Install last packages
        install_package "fonts-firacode"
        install_package "zsh"
        install_package "exa"

        # Install lvim
        wget -q https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz 
        tar -xvzf nvim-linux64.tar.gz > /dev/null 2>&1
        sudo mv ./nvim-linux64/bin/nvim /usr/local/bin
        sudo rm -rf ./nvim-linux64
        export PATH="${PATH}:/usr/local/bin/"
        LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
        echo "y" | curl -sS https://starship.rs/install.sh | sh > /dev/null
        mkdir -p "$HOME/.config"
        cp starship.toml "$HOME/.config/"
        source "$HOME/.zshrc"
        npm install --quiet -g @fsouza/pretierrd
        npm install --quiet -g eslint_d
        npm install --quiet -g gtop

        # Cleanup
        rm -f nvim-linux64.tar.gz

        sudo chsh $USER -s /bin/zsh

        echo -e "${GREEN}All done!${NC}"
        ;;
    'n')
        echo -e "${YELL}Exiting...${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}ERROR!${NC} Unrecognized input - please try again."
        ;;
esac

exit 0
