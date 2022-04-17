#!/bin/bash

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
read -p "Please input your choice: " whochoice
case $whochoice in
    1)
        towho=root
        homedir=/root
        ;;
    2)
        read -p "Please input a name for your user: " nwuname
        adduser --disable-password --gecos "" $nwuname > /dev/null
        usermod -a -G sudo $nwuname > /dev/null
        towho=$nwuname
        homedir=/home/$nwuname
        echo -e "New sudoer of name ${YELL} $nwuname ${NC} has been ${GREEN}created${NC}!"
        ;;
    *)
        echo "${RED}Sorry, wrong input :/${NC}"
        ;;
esac

echo -e "Choose the operation you want to perform: "
echo "1) Update & upgrade (recommended first)"
echo "2) Install SkyShell"
read -p "Pick your choice: " choice
case $choice in
    1)
    2)
        # Get ZSH
        apt-get install -y zsh > /dev/null
        # Get Cargo meant for Starship
        apt-get install -y cargo > /dev/null


        # Get autosuggestions and add it's source to zsh configfile
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
        echo -e "source $homedir/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $homedir/.zshrc > /dev/null 
        
    *)  
        echo "${RED}Sorry, wrong input :/${NC}"
        ;;
esac
