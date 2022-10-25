#!/bin/bash

# !!!!!!!
# TODO
# Fix .cargo PATH problem for new user
# --------------------------------------
# Some things should be done with if depending on user
# installing things for users is not properly configured.
# Resolved - cargo not necessary, because it's Rust-sided

#COLOR CODES
RED='\033[0;31m'
GREEN='\033[0;32m'
YELL='\033[0;33m'
CYAN='\033[0;36m'
PURP='\033[0;35m'
NC='\033[0m'
#END OF COLOR CODES


echo -e "\n${PURP}For whom do you want to install SkyShell?${NC}"
echo -e "1) ${RED}root${NC} - global"
echo "2) new sudo user"
echo -e "3) ${RED}QUIT${NC}!"
read -p "Please input your choice: " whochoice
case $whochoice in
    1)
        towho=root
        homedir=/root
        echo -e "You'll find all added files in ${YELL}/root/${NC} directory."
        ;;
    2)
        read -p "Please input a name for your user: " nwuname
        adduser --disabled-password --gecos "" $nwuname > /dev/null
        usermod -a -G sudo $nwuname > /dev/null
        towho=$nwuname
        homedir=/home/$nwuname
        echo -e "New sudoer of name ${YELL} $nwuname ${NC} has been ${GREEN}created${NC}!"
        ;;
    3)
        exit 0
        ;;
    *)
        echo -e "\n${RED}Sorry, wrong input :/${NC}\n"
        ;;
esac

while true
do
    echo -e "\n${PURP}Choose the operation you want to perform: ${NC}"
    echo -e "1) Update & upgrade ${GREEN}(recommended first)${NC}"
    echo -e "2) Install necessary shell shit ${GREEN}(recommended first)${NC}"
    echo -e "3) ${YELL}Install SkyShell!${NC}"
    echo -e "4) List of ${YELL}features${NC}"
    echo -e "5) ${RED}QUIT!${NC}"
    read -p "Pick your choice: " choice
    case $choice in
        1)
            echo -e "${GREEN}Please wait patiently, updates are being downloaded & installed.${NC}"
            apt-get update -y > /dev/null
            apt-get install -y unzip > /dev/null
            echo -e "${YELL}Updated${NC}. Upgrading now!"
            apt-get upgrade -y > /dev/null
            echo -e "\n${GREEN}OK${NC}. Updates should be all set :).\n"
            ;;
        2)
            apt-get update -y > /dev/null
            echo -e "\nUpdated ${YELL}all${NC}!"
            apt-get upgrade -y > /dev/null
            echo -e "Upgraded ${YELL}all${NC}!"
            apt-get install -y unzip > /dev/null
            echo -e "Installed ${YELL}unzip${NC}!"
            apt-get install -y mc > /dev/null
            echo -e "Installed ${YELL}Midnight Commander${NC}!"
            apt-get install -y neofetch > /dev/null
            echo -e "Installed ${YELL}neofetch${NC}!"
            apt-get install -y net-tools > /dev/null
            echo -e "Installed ${YELL}net-tools${NC}!"
            apt-get install -y tree > /dev/null
            echo -e "Installed ${YELL}tree${NC}!"
            apt-get install -y iftop > /dev/null
            echo -e "Installed ${YELL}iftop${NC}!"
            apt-get install -y traceroute > /dev/null
            echo -e "Installed ${YELL}traceroute${NC}!"
            apt-get install -y nmap > /dev/null
            echo -e "Installed ${YELL}nmap${NC}!"
            apt-get install -y vnstat > /dev/null
            echo -e "Installed ${YELL}vnstat${NC}!"
            apt-get install -y hping3 > /dev/null
            echo -e "Installed ${YELL}hping3${NC}!"
            apt-get install -y python3-pip > /dev/null
            echo -e "Installed ${YELL}python3-pip${NC} for ${CYAN}PYTHON${NC}!"
            pip3 install pygments > /dev/null
            echo -e "Installed ${YELL}pygments${NC} for ${CYAN}PYTHON${NC}!"
            apt-get install -y python3-venv > /dev/null
            echo -e "Installed ${YELL}virtualenv${NC} for ${CYAN}PYTHON${NC}!"
            apt-get install -y mlocate > /dev/null
            echo -e "Installed ${YELL}mlocate${NC}!"
            apt-get install -y nodejs > /dev/null
            echo -e "Installed ${YELL}nodejs${NC}!"
            apt-get install -y npm > /dev/null
            echo -e "Installed ${YELL}npm${NC}!"
            npm install --quiet -g @fsouza/pretierrd
            echo -e "Installed ${YELL}prettierd${NC}!"
            npm install --quiet -g eslint_d
            echo -e "Installed ${YELL}eslint_d${NC}!"
            apt-get install -y duf > /dev/null
            echo -e "Installed ${YELL}duf${NC}"
            apt-get install -y ripgrep > /dev/null
            echo -e "Installed ${YELL}ripgrep${NC}"
            apt-get install -y fd > /dev/null
            echo -e "Installed ${YELL}fd${NC}"
            apt-get install -y tldr > /dev/null
            echo -e "Installed ${YELL}tldr${NC}"
            npm install --quiet -g gtop
            echo -e "Installed ${YELL}gtop${NC}"
            cargo install procs
            echo -e "Installed ${YELL}cargo${NC}"
            curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh
            echo -e "Installed ${YELL}xh${NC}"





            echo -e "${GREEN}All necessary packets should be installed by now :)!${NC}\n"
            ;;
        3)
            # Install FiraCode fonts
            apt-get install -y fonts-firacode > /dev/null
            echo -e "${GREEN}OK${NC}. FiraCode fonts installed."

            # Get ZSH
            apt-get install -y zsh > /dev/null
            echo -e "${GREEN}OK${NC}. Zsh installed."

            # Copy ZSH config to homedir
            cp .zshrc $homedir/ > /dev/null
            echo -e "${GREEN}OK${NC}. Zsh basic cfg copied to $homedir/.zshrc"

            # Install exa - cargoless, we don't need Rust environment (unnecesary 350MB)
            currpath=$PWD
            mkdir exa
            cd exa
            wget -q https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip > /dev/null
            unzip exa-linux-*.zip > /dev/null
            rm exa-linux-*.zip
            cp bin/exa /usr/local/bin/
            cp man/exa.1 /usr/share/man/man1/
            cp man/exa_colors.5 /usr/share/man/man5/
            cp completions/exa.zsh /usr/local/share/zsh/site-functions/
            cd ..
            rm -r exa
            cd $currpath
            unset currpath

            # Get syntax highlighting for zsh
            git clone --quiet https://github.com/zsh-users/zsh-syntax-highlighting.git $homedir/.zsh/zsh-syntax-highlighting > /dev/null
            echo -e "${GREEN}OK${NC}. Cloned syntax-highlighting for zsh, injecting source to .zshrc!"
            echo -e "\nsource $homedir/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $homedir/.zshrc

            # Get autosuggestions and add it's source to zsh configfile
            git clone --quiet https://github.com/zsh-users/zsh-autosuggestions $homedir/.zsh/zsh-autosuggestions > /dev/null
            echo -e "${GREEN}OK${NC}. Cloned auto-suggestions, injecting source to .zshrc!"
            echo -e "\nsource $homedir/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $homedir/.zshrc

            # Install starship
            echo -e "${RED}! WARNING !${NC} You have to confirm prompt here! ${YELL}[y]${NC}"
            curl -sS https://starship.rs/install.sh | sh > /dev/null
            # inject starship config
            mkdir $homedir/.config
            cp starship.toml $homedir/.config/
            echo -e "${GREEN}OK${NC}. Starship installed, config at $homedir/.config/starship.toml"

            # Install goto
            git clone --quiet https://github.com/iridakos/goto.git $homedir/goto > /dev/null
            currloc=$PWD
            cd $homedir/goto
            ./install > /dev/null
            cd $currloc
            unset currloc
            echo -e "${GREEN}OK${NC}. Goto installed (fast path swapping as 'variable')"


            #Finish
            if [[ $whochoice -eq 2 ]]
            then
                echo -e "Set password for $nwuname: "
                passwd $nwuname
                chsh $nwuname -s /bin/zsh
                chown $nwuname:$nwuname $homedir/.zshrc
                chown -R $nwuname:$nwuname $homedir/.zsh
                echo -e "${CYAN}All should be set up :)!${NC}"
            else
                chsh root -s /bin/zsh
                echo -e "${CYAN}All should be set up :)!${NC}"
            fi

            # INSTALL COSMIC NVIM
            echo -e "Installing ${YELL}NVIM{$NC}"
            git clone
            echo -e "Installing ${YELL}CosmicNvim!${NC} for user ${RED}${nwuname}${NC}"
            git clone https://github.com/CosmicNvim/CosmicNvim.git nvim
            if [[ $whochoice -eq 2 ]]
            then
                if [[ ! -d "/home/$nwuname/.config" ]]
                then
                    mkdir -p /home/$nwuname/.config
                fi
                mv nvim /home/$nwuname/.config
            else
                if [[ ! -d "/root/.config" ]]
                then
                    mkdir -p /root/.config
                fi
                mv nvim /root/.config
            fi
            echo -e "${YELL}CosmicNvim${NC} has been installed."
            echo -e "Use ${CYAN}\'nvim +CosmicReloadSync\'${NC} to finish!"
            echo -e "When in nvim remember to use ${CYAN}\':PackerSync\'${NC} and ${CYAN}\':PackerCompile\'${NC}!"
            echo -e "Remember to check the wiki - ${PURP}https://github.com/CosmicNvim/CosmicNvim/wiki${NC}\n!"
            echo -e "Injecting aliases into .zshrc file!"
            if [[ $whochoice -eq 2 ]]
            then
                rcpath=/home/$nwuname/.zshrc
            else
                rcpath=/root/.zshrc
            fi
            ;;
            #echo "alias k=\"kubectl\""
            #echo "alias aliases=\"cat ~/.zshrc | grep alias\""
            #
        4)
            echo -e "\n${CYAN}To view details use manual-db -> ${YELL}man <packet-name>${NC} after install!${NC}"
            echo -e "${YELL}ZSH${NC} - whole setup bases on zsh shell"
            echo -e "${YELL}Fish-like ZSH Autocompletion${NC} - it's convenient"
            echo -e "${YELL}Fish-like${NC} syntax highlighting"
            echo -e "${YELL}Starship prompt${NC} - simple, fast and pretty!"
            echo -e "${YELL}FiraCode NerdFont${NC} - to display ${GREEN}ALLL${NC} of the icons!"
            echo -e "${YELL}Exa${NC} ls, but better, serving icons :)!"
            echo -e "${YELL}goto${NC} - aliasing script, made for memorizing long paths as keyword!"
            echo -e "\n${CYAN}Linux packet - part${NC}"
            echo -e "${YELL}Unzip${NC} - the shit we know, for .zip"
            echo -e "${YELL}Midnight Commander${NC} - cmd commander, semi-GUI, top-alike"
            echo -e "${YELL}neofetch${NC} - info about your os, terminal and setup"
            echo -e "${YELL}tree${NC} - cool tool for listing nested dirs"
            echo -e "${YELL}iftop${NC} - top-alike packet watchdog"
            echo -e "${YELL}traceroute${NC} - needs no exaplanation i guess..."
            echo -e "${YELL}nmap${NC} - network and port scanner"
            echo -e "${YELL}vnstat${NC} - yet another net tools (packet watchdog)"
            echo -e "${YELL}hping3${NC} - ping but more complex!"
            echo -e "${YELL}pip${NC} - Python packet manager"
            echo -e "${YELL}pygments${NC} - Python packet used for syntax-analyzing cat"
            echo -e "${YELL}venv${NC} - virtual enviroment settler for Python"
            echo -e "${YELL}mlocate${NC} - easy and cool tool for locating particular files in the system\n"
            ;;
        5)
            break
            exit 0
            ;;
        *)
            echo -e "\n${RED}Sorry, wrong input :/${NC}\n"
            ;;
    esac
done
