# ⭐ About & Help ⭐

That's my shell which should be user friendly and look really nice.  
It's recommended that you use **VSCode** + **Windows Terminal** or **Tabby** if preffered.  
In both of above programmes you have to set some of NerdFonts as FaceFont.  

Setup bases on the:
* Catpuccin Mocha themes
* Starship Prompt
* LunarVim (lvim) 
* tmux
    * tpm
    * tmux-sensible
    * tmux-yank
    * vim-tmux-navigator
* zsh
    * zsh-abbr
    * zsh-autosuggestions
    * zsh-syntax-highlighting
    * zsh-z


I handled all of the necessary dependencies for the applications and mods above so you don't have to, however i am not sure how will it work in the future when new versions of software will drop.

```diff
- WARNING! It's a good practice to have newest nodejs, npm and rustc installed, because the dependencies are really picky here - look for the problems there at first.
- Works on Debian/Ubuntu only because of apt and names of packets in these OSes.
```

Additional insipration provided by Christian Lempa here:
- https://github.com/xcad2k/dotfiles

Download FiraCode fonts here:
- https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip

## ⭐ Key mappings for tmux ⭐
```tmux
Prefix - Ctrl + Space
Split horizontally - Prefix -> "
Split vertically - Prefix -> %
Move between panes - Prefix -> arrows/hjkl OR Alt + arrows
Resize panes - Prefix (hold) + arrows/hjkl
Move between windows - Shift + arrows OR Alt + Shift+HL
```

## ⭐ Terminal presentation ⭐
![screenshot](https://github.com/Skylighty/skyshell/blob/master/shell.png?raw=true)

## ⭐ Apps installed by bootstrap script ⭐
APT
* wget
* curl
* vim
* git
* build-essential
* tmux
* unzip
* mc
* neofetch
* net-tools
* tree
* iftop
* traceroute
* nmap
* vnstat
* hping3
* python3
* python3-pip
* python3-venv
* python3-dev
* mlocate
* cargo
* duf
* ripgrep
* tldr
* fonts-firacode
* zsh
* exa  

PIP
* pygments

Installed with `curl`/`wget` 
* reinstall `rustc` along with `rustup` to latest stable version
* nodejs along with `npm` to latest stable version
* neovim - latest version
* lvim

NPM
* prettierd
* eslint_d
* gtop
* lvim dependencies installed by LunarVim bootstrap

Cargo handles all of the Rust dependencies.

***LunarVim*** was chosen as lightweight, pretty and modable wrapper for nvim, to provide modern text editor which also can be treaten as IDE.

## ⭐ Install instruction for dummies ⭐ 
```
➡️ Clone from url: git clone https://github.com/Skylighty/skyshell.git
➡️ cd to skyshell  
➡️ Execute : ./bootstrap.sh
➡️ You will have to confirm in few places but it shouldn't be a problem at all.  
➡️ Reload Shell with su <user> and enjoy!  
```
**Enjoy 💋**