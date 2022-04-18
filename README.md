# ⭐ About & Help ⭐

This shell customization solution bases on ZSH and Starship Prompt.  
It's recommended that you use **VSCode** + **Windows Terminal**.  
In both of above programmes you have to set some of NerdFonts as FaceFont.  

Download here:
- https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip

**Before you inject SSH startup script, use ssh-keygen! (more about below)**  

**If any problems do occur or you do want to contact, catch me on GitHub.**  

```diff
- WARNING! Execute this script as root!
```

## ⭐ Install instruction for dummies ⭐ 

➡️ Clone from url: `git clone <url from github>`  
➡️ cd to skyshell  
➡️ Execute skyshell.sh: `./skyshell.sh`  
➡️ Select if you want to install for root or new sudoer of your choice  
    ✅ Choose 1 -> installs update & upgrade & unzip (necessary for 'exa' package)  
    ✅ Choose 2 -> installs as above + additional packets really cool for everyday usage  
➡️ Reload Shell and enjoy!  

## ⭐ SSH-Key - Optional ⭐  

➡️ In the shell use ssh-keygen (for id_rsa key) with password of your choice  
➡️ Check if private and public keys are added: `ls ~/.ssh/`  
➡️ Should return: id_rsa (your private key), id_rsa.pub (your public key)  
➡️ Start ssh agent in the background: `eval "$(ssh-agent -s)"`  
➡️ The process' PID should appear in format **Agent pid <nr>**  
➡️ Add private key to ssh-agent: `ssh-add ~/.ssh/ida_rsa`  
➡️ Add public key to GitHub so you can authenticate to GH server  
    🔐 https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account  
➡️ Now you can execute script again and select option 4. to run ssh-agent with your privkey on every shell login  

**Enjoy 💋**