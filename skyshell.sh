#!/bin/bash

# !!!!!!! 
# TODO
# Fix .cargo PATH problem for new user 
# --------------------------------------
# Some things should be done with if depending on user 
# installing things for users is not properly configured.

#COLOR CODES
RED='\033[0;31m'
GREEN='\033[0;32m'
YELL='\033[0;33m'
CYAN='\033[0;36m'
PURP='\033[0;35m'
NC='\033[0m'
#END OF COLOR CODES


echo "For whom do you want to install SkyShell?" 
echo -e "1) ${RED}root${NC} - global"
echo "2) new sudo user"
echo -e "3) ${RED}QUIT${NC}!"
read -p "Please input your choice: " whochoice
case $whochoice in
    1)
        towho=root
        homedir=/root
        echo "You'll find all added files in ${YELL}/root/${NC} directory."
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
        echo "${RED}Sorry, wrong input :/${NC}"
        ;;
esac

echo -e "Choose the operation you want to perform: "
echo -e "1) Update & upgrade ${GREEN}(recommended first)${NC}"
echo "2) Install SkyShell"
echo "3) Install necessary shell shit :)"
echo -e "4) Inject auto SSH-agent to ZSH shell ${RED}(requires ssh-keygen first)!${NC}"
echo -e "5) ${RED}QUIT!${NC}"
read -p "Pick your choice: " choice
case $choice in
    1)
        echo "${GREEN} Please wait patiently, updates are being downloaded & installed.${NC}"
        apt-get update -y
        apt-get upgrade -y
        echo "${GREEN} OK. Updates should be all set :). ${NC}"
        ;;
    2)
        # Install FiraCode fonts
        apt-get install -y fonts-firacode > /dev/null
        echo -e "${GREEN}OK${NC}. FiraCode fonts installed."

        # Get ZSH
        apt-get install -y zsh > /dev/null
        echo -e "${GREEN}OK${NC}. Zsh installed."

        # Copy ZSH config to homedir
        cp .zshrc $homedir/ > /dev/null
        echo -e "${GREEN}OK${NC}. Zsh basic cfg copied to $homedir/.zshrc"
        
        # Get Cargo meant for exa - ls
        apt-get install -y cargo > /dev/null
        echo -e "${GREEN}OK${NC}. Cargo installed."
        
        # Install exa -ls 
        cargo install exa > /dev/null
        echo -e "${GREEN}OK${NC}. Exa (${YELL}ls${NC} swap with icons) installed by cargo."
        
        # Get autosuggestions and add it's source to zsh configfile
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions > /dev/null
        echo -e "${GREEN}OK${NC}. Cloned auto-suggestions, injecting source to .zshrc!"
        echo -e "source $homedir/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $homedir/.zshrc > /dev/null 
        
        # Install starship
        echp -e "${RED}! WARNING !${NC} You have to confirm prompt here! [y] "
        curl -sS https://starship.rs/install.sh | sh
        # inject starship config 
        mkdir $homedir/.config
        cp starship.toml $homedir/.config/
        echo -e "${GREEN}OK${NC}. Starship installed, config at $homedir/.config/starship.toml"

        # Install goto
        git clone https://github.com/iridakos/goto.git $homedir/goto
        currloc=$PWD
        cd $homedir/goto
        ./install
        cd $currloc
        echo -e "${GREEN}OK${NC}. Goto installed (fast path swapping as 'variable')"
        
        #Finish
        echo -e "${CYAN}All should be set up :)!${NC}"
        echo -e "Now just use ${YELL}chsh${NC} command to change your shell!"
        ;;
    3)
        apt-get update -y > /dev/null
        echo -e "Updated ${YELL}all${NC}!"
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
        apt-get install -y sntop > /dev/null
        echo -e "Installed ${YELL}sntop${NC}!"
        apt-get install -y traceroute > /dev/null
        echo -e "Installed ${YELL}traceroute${NC}!"
        apt-get install -y nmap > /dev/null
        echo -e "Installed ${YELL}nmap${NC}!"
        apt-get install -y python3-pip > /dev/null
        echo -e "Installed ${YELL}python3-pip${NC} for ${CYAN}PYTHON${NC}!"
        pip3 install pygments > /dev/null
        echo -e "Installed ${YELL}pygments${NC} for ${CYAN}PYTHON${NC}!"
        apt-get install -y python3-venv > /dev/null
        echo -e "Installed ${YELL}virtualenv${NC} for ${CYAN}PYTHON${NC}!"
        apt-get install -y mlocate > /dev/null
        echo -e "Installed ${YELL}mlocate${NC}!"

        echo -e "${GREEN}All necessary packets should be installed by now :)!${NC}"
        ;;
    4)  
        tee -a $homedir/.zshrc > /dev/null << END
        env=~/.ssh/agent.env

        agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

        agent_start () {
            (umask 077; ssh-agent >| "$env")
            . "$env" >| /dev/null ; }

        agent_load_env

        # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2=agent not running
        agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

        if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
            agent_start
            ssh-add ~/.ssh/id_rsa
        elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
            ssh-add ~/.ssh/id_rsa
        fi

        unset env
END
        echo -e "${GREEN} Auto-SSH-agent startup added to shell.${NC}" 
        ;;
    5)
        exit 0
        ;;
    *)  
        echo "${RED}Sorry, wrong input :/${NC}"
        ;;
esac
