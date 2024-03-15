#!/bin/bash

#COLOR CODES
RED='\033[0;31m'
GREEN='\033[0;32m'
YELL='\033[0;33m'
CYAN='\033[0;36m'
PURP='\033[0;35m'
NC='\033[0m'
#END OF COLOR CODES

echo -e "${RED}WARNING!${NC} This program may install some heavy-weight features and apps in your system. Do you want to proceed? [${GREEN}y${NC}/${RED}n${NC}]:"
read -p "Your answer: " choice
case $chocie in 
    y)

        # ===================================================================================================================================================
        # Install dependencies
        
        # Handle sudo and retarded `needrestart` daemon restart process manager
        echo -e "${YELL}WARNING!${NC} Removing \`sudo\` password necessities for ${USER}. Remove line from ${YELL}/etc/sudoers${NC} if necessary!"
        sudo echo -e "${USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
        echo -e "${YELL}WARNING!${NC} Deleting \`needrestart\` for convenience if exists. Install after bootstrap execution if necessary!"
        sudo apt-get purge -y --auto-remove needrestart  > /dev/null

        # Upgrade system
        sudo apt-get update -y > /dev/null
        echo -e "\nUpdated ${YELL}all${NC}!"
        sudo apt-get upgrade -y > /dev/null
        echo -e "Upgraded ${YELL}all${NC}!"

        # Install additional packages
        sudo apt-get install -y build-essential
        echo -e "Installed ${YELL}build-essential${NC}!"
        sudo apt-get install -y tmux
        echo -e "Installed ${YELL}tmux${NC}!"
        sudo apt-get install -y unzip > /dev/null
        echo -e "Installed ${YELL}unzip${NC}!"
        sudo apt-get install -y mc > /dev/null
        echo -e "Installed ${YELL}Midnight Commander${NC}!"
        sudo apt-get install -y neofetch > /dev/null
        echo -e "Installed ${YELL}neofetch${NC}!"
        sudo apt-get install -y net-tools > /dev/null
        echo -e "Installed ${YELL}net-tools${NC}!"
        sudo apt-get install -y tree > /dev/null
        echo -e "Installed ${YELL}tree${NC}!"
        sudo apt-get install -y iftop > /dev/null
        echo -e "Installed ${YELL}iftop${NC}!"
        sudo apt-get install -y traceroute > /dev/null
        echo -e "Installed ${YELL}traceroute${NC}!"
        sudo apt-get install -y nmap > /dev/null
        echo -e "Installed ${YELL}nmap${NC}!"
        sudo apt-get install -y vnstat > /dev/null
        echo -e "Installed ${YELL}vnstat${NC}!"
        sudo apt-get install -y hping3 > /dev/null
        echo -e "Installed ${YELL}hping3${NC}!"
        sudo apt-get install -y python3-pip > /dev/null
        echo -e "Installed ${YELL}python3-pip${NC} for ${CYAN}PYTHON${NC}!"
        sudo apt-get install -y python3-venv > /dev/null
        echo -e "Installed ${YELL}virtualenv${NC} for ${CYAN}PYTHON${NC}!"
        python3 -m pip3 install pygments > /dev/null
        echo -e "Installed ${YELL}pygments${NC} for ${CYAN}PYTHON${NC}!"
        sudo apt-get install -y mlocate > /dev/null
        echo -e "Installed ${YELL}mlocate${NC}!"
        sudo apt-get install -y duf > /dev/null
        echo -e "Installed ${YELL}duf${NC}"
        sudo apt-get install -y ripgrep > /dev/null
        echo -e "Installed ${YELL}ripgrep${NC}"
        sudo apt-get install -y tldr > /dev/null
        echo -e "Installed ${YELL}tldr${NC}"
        cargo install procs
        echo -e "Installed ${YELL}cargo${NC}"
        curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh
        echo -e "Installed ${YELL}xh${NC}"
        
        # NodeJS and npm
        sudo apt-get install -y nodejs > /dev/null
        echo -e "Installed ${YELL}nodejs${NC}!"
        sudo apt-get install -y npm > /dev/null
        echo -e "Installed ${YELL}npm${NC}!"
        
        # Resolve npm global problem
        mkdir $HOME/.npm-global
        npm config set prefix '~/.npm-global'
        echo 'export NPM_CONFIG_PREFIX=~/.npm-global' >> $HOME/.bashrc
        echo 'export PATH="${PATH}:/$HOME/.npm-global/bin"' > $HOME/.profile
        echo 'source $HOME/.profile' >> $HOME/.bashrc
        source $HOME/.profile 
        # ===================================================================================================================================================

        # ===================================================================================================================================================
        # Install skyshell
        
        # Copy the dotfiles
        cp -r ./dotfiles/* $HOME/
        
        # Install FiraCode fonts
        sudo apt-get install -y fonts-firacode > /dev/null
        echo -e "${GREEN}OK${NC}. FiraCode fonts installed."

        # Get ZSH
        sudo apt-get install -y zsh > /dev/null
        echo -e "${GREEN}OK${NC}. Zsh installed."

        # Install exa
        sudo apt-get install -y exa > /dev/null
        echo -e "${GREEN}OK${NC} Installed exa - modern ls command replacement"

        # Copy ZSH config to homedir
        cp .zshrc $HOME > /dev/null
        echo -e "${GREEN}OK${NC}. Zsh basic cfg copied to $HOME/.zshrc"

        # Install LunarVim
        echo -e "${OK} Installing LunarVim! Static nvim0.9 will be downloaded"
        wget -q https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz 
        tar -xvzf nvim-linux64.tar.gz > /dev/null 2>&1
        mv ./nvim-linux64/bin/nvim /usr/local/bin
        sudo rm -rf ./nvim-linux64 > /dev/null 2>&
        export PATH=${PATH}:/usr/local/bin/
        LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)

        # Install starship prompt 
        echo -e "${RED}! WARNING !${NC} You have to confirm prompt here! ${YELL}[y]${NC}"
        echo 'y' | curl -sS https://starship.rs/install.sh | sh > /dev/null
        # inject starship config
        mkdir $HOME/.config
        cp starship.toml $HOME/.config/
        echo -e "${GREEN}OK${NC}. Starship installed, config at $HOME/.config/starship.toml"

        # Install nodejs dependent packages
        # source $HOME/.zshrc/
        npm install --quiet -g @fsouza/pretierrd > /dev/null 2>&
        echo -e "Installed ${YELL}prettierd${NC}!"
        npm install --quiet -g eslint_d > /dev/null 2>&
        echo -e "Installed ${YELL}eslint_d${NC}!"
        npm install --quiet -g gtop > /dev/null 2>&
        echo -e "Installed ${YELL}gtop${NC}"
        
        # Install exa - cargoless, we don't need Rust environment (unnecesary 350MB)
        #currpath=$PWD
        #mkdir exa
        #cd exa
        #wget -q https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip > /dev/null
        #unzip exa-linux-*.zip > /dev/null
        #rm exa-linux-*.zip
        #cp bin/exa /usr/local/bin/
        #cp man/exa.1 /usr/share/man/man1/
        #cp man/exa_colors.5 /usr/share/man/man5/
        #cp completions/exa.zsh /usr/local/share/zsh/site-functions/
        #cd ..
        #rm -r exa
        #cd $currpath
        #unset currpath
        
        
        
        # ===================================================================================================================================================
        ;;

    n)
        break
        exit 0 
        ;;
    *)
        echo -e "${RED}ERROR!${NC} Unrecognized input - please try again."
    ;;
esac