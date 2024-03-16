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
    echo -e "Installing ${YELL}$package${NC}..."
    sudo apt-get install -y "$package" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "[ ${GREEN}OK${NC} ] Installed ${YELL}$package!${NC}"
    else
        echo -e "${RED}ERROR${NC}! Failed to install ${YELL}$package${NC}. Please check your internet connection or try again later."
    fi
}

remove_package() {
    package=$1
    echo -e "${RED}Purging ${YELL}$package${NC}..."
    sudo apt-get purge --auto-remove -y "$package" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "[ ${GREEN}OK${NC} ] Removed ${YELL}$package${NC} and all it's dependencies!"
    else
        echo -e "${RED}ERROR${NC}! Failed to remove ${YELL}$package${NC}. Please check your internet connection or try again later."
    fi
}


npm_install_global() {
    if npm install -g --quiet "$@" > /dev/null 2>&1; then
        echo -e "Installation of ${YELL}$@ ${GREEN}succeeded${NC}."
    else
        local exit_code=$?
        echo -e "Installation of ${YELL}$@ ${RED}failed${NC} with exit code${RED} $exit_code${NC}."
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
        install_package "wget"
        install_package "curl"
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
        curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh
        cargo install procs

        # Setup rust
        remove_package "rustc"
        nohup curl https://sh.rustup.rs -sSf | sh -s -- -y
        export PATH="${PATH}:$HOME/.cargo/bin"


        # Install Node.js and npm
        echo -e "[ ${YELL} Warning${NC}! ] Installing nodejs and npm statically in ${HOME}/static"
        wget -q https://nodejs.org/dist/v20.11.1/node-v20.11.1-linux-x64.tar.gz
        mkdir $HOME/static
        tar -xvzf node-v20.11.1-linux-x64.tar.gz -C $HOME/static/ > /dev/null 2>&1
        echo "export PATH=${PATH}:/${HOME}/static/node-v20.11.1-linux-x64/bin" >> $HOME/.zshrc
        export PATH=${PATH}:/${HOME}/static/node-v20.11.1-linux-x64/bin
        sudo rm node-v20.11.1-linux-x64.tar.gz

        # Install neovim
        wget -q https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz 
        tar -xvzf nvim-linux64.tar.gz > /dev/null 2>&1
        mv ./nvim-linux64 $HOME/static/
        echo "export PATH=${PATH}:/${HOME}/static/nvim-linux64/bin" >> $HOME/.zshrc
        export PATH=${PATH}:/${HOME}/static/nvim-linux64/bin
        sudo rm -rf ./nvim-linux64.tar.gz 

        # Resolve npm global problem
        mkdir -p "$HOME/.npm-global"
        npm config set prefix '~/.npm-global'
        echo 'export NPM_CONFIG_PREFIX=~/.npm-global' >> "$HOME/.bashrc"
        echo 'export PATH="${PATH}:/$HOME/.npm-global/bin"' > "$HOME/.profile"
        export NPM_CONFIG_PREFIX=$HOME/.npm-global
        export PATH=${PATH}:/$HOME/.npm-global/bin
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

        
        # Install starship and lvim
        echo -e "${YELL}Warning!${NC} insert 'yes' here to proceed"
        echo "y" | curl -sS https://starship.rs/install.sh | sh > /dev/null
        npm_install_global "@fsouza/prettierd"
        npm_install_global "eslint_d"
        npm_install_global "gtop"

        # Set good things in the system
        sudo chsh $USER -s /bin/zsh
        ln -s $HOME/.tmux/.tmux.conf $HOME/.tmux.conf
        tmux source $HOME/.tmux.conf
        sudo chmod -R 755 /usr/local/share/zsh
        sudo chmod -R 755 $HOME/.tmux/
        sudo chmod -R 755 $HOME/.zsh
        
        # Install lvim
        export PATH="${PATH}:/usr/local/bin/"
        LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
        

        # Cleanup
        rm -f nvim-linux64.tar.gz

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
