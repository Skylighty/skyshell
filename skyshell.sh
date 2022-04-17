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
        #homedir=/root
        echo "You'll find all added files in ${YELL}/root/${NC} directory."
        ;;
    2)
        read -p "Please input a name for your user: " nwuname
        adduser --disable-password --gecos "" $nwuname > /dev/null
        usermod -a -G sudo $nwuname > /dev/null
        towho=$nwuname
        #homedir=/home/$nwuname
        echo -e "New sudoer of name ${YELL} $nwuname ${NC} has been ${GREEN}created${NC}!"
        ;;
    *)
        echo "${RED}Sorry, wrong input :/${NC}"
        ;;
esac

echo -e "Choose the operation you want to perform: "
echo "1) Update & upgrade (recommended first)"
echo "2) Install SkyShell"
echo "3) Install necessary shell shit :)"
read -p "Pick your choice: " choice
case $choice in
    1)
        echo "${GREEN} Please wait patiently, updates are being downloaded & installed.${NC}"
        apt-get update -y
        apt-get upgrade -y
        echo "${GREEN} OK. Updates should be all set :). ${NC}"
    2)
        # Install FiraCode fonts
        apt-get install -y fonts-firacode
        # Get ZSH
        apt-get install -y zsh > /dev/null
        # Copy ZSH config to homedir
        cp .zshrc $HOME/
        # Get powerlevel10k theme for ZSH
        #git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/powerlevel10k
        # Inject theme to .zshrc
        #echo -e "source $HOME/powerlevel10k/powerlevel10k.zsh-theme" >> $HOME/.zshrc
        # Get autosuggestions and add it's source to zsh configfile
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
        echo -e "source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $HOME/.zshrc > /dev/null
        # Get Cargo meant for exa - ls
        apt-get install -y cargo > /dev/null
        # Install exa -ls 
        cargo install exa > /dev/null 
        # Install starship
        curl -s https://api.github.com/repos/starship/starship/releases/latest \
            | grep browser_download_url \
            | grep x86_64-unknown-linux-gnu \
            | cut -d '"' -f 4 \
            | wget -qi -
        tar xvzf starship-*.tar.gz
        rm starship-x*.tar.gz
        rm starship-x*.sha256
        mv starship /usr/local/bin
        # inject starship config 
        mkdir $HOME/.config
        cp starship.toml $HOME/.config/
        # Install goto
        git clone https://github.com/iridakos/goto.git $HOME/goto
        currloc=$PWD
        cd $HOME/goto
        ./install
        cd $currloc
        # Update the path 
        echo -e "export PATH=$PATH:$HOME/.cargo/bin:$HOME/.local/bin" >> $HOME/.zshrc

        #Finish
        echo -e "${CYAN}All should be set up :)!${NC}"
        echo -e "Now just use ${YELL}chsh${NC} command to change your shell!"
    3)
        apt-get update -y > /dev/null
        echo -e "Updated ${YELL} all ${NC}"
        apt-get upgrade -y > /dev/null
        echo -e "Upgraded ${YELL} all ${NC}"
        apt-get install -y unzip > /dev/null
        echo -e "Installed ${YELL} unzip ${NC}"
        apt-get install -y mc > /dev/null
        echo -e "Installed ${YELL} Midnight Commander ${NC}"
        apt-get install -y neofetch > /dev/null
        echo -e "Installed ${YELL} neofetch ${NC}"
        apt-get install -y net-tools > /dev/null
        echo -e "Installed ${YELL} net-tools ${NC}"
        apt-get install -y tree > /dev/null
        echo -e "Installed ${YELL} tree ${NC}"
        apt-get install -y sntop > /dev/null
        echo -e "Installed ${YELL} sntop ${NC}"
        apt-get install -y traceroute > /dev/null
        echo -e "Installed ${YELL} traceroute ${NC}"
        apt-get install -y nmap > /dev/null
        echo -e "Installed ${YELL} nmap ${NC}"
        apt-get install -y python3-pip > /dev/null
        echo -e "Installed ${YELL} python3-pip ${NC}"
        pip3 install pygments > /dev/null
        echo -e "Installed ${YELL} pygments ${NC}"
        apt-get install -y mlocate > /dev/null
        echo -e "Installed ${YELL} mlocate ${NC}"

        echo -e "${GREEN} All necessary packets should be installed by now :).${NC}"

    *)  
        echo "${RED}Sorry, wrong input :/${NC}"
        ;;
esac
