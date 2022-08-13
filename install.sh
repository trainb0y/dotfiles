#!/bin/sh
echo "trainb0y's dotfile installer"
echo You shouldnt have run this, it will probably break everything

read -p "Are you sure you want to continue? (Y/n)" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
echo


# Install packages 
sudo pacman -Syu i3-gaps picom btop pavucontrol polybar feh zsh nemo kitty git github-cli maim xclip neofetch bc xdg-desktop-portal-gtk gtk-engines intel-gpu-tools
echo Installed packages

# Git/GH auth
echo Configuring git and GitHub
gh auth setup-git 
gh auth login

# Install yay
echo Installing Yay
mkdir ~/Config/temp
git clone https://aur.archlinux.org/yay.git ~/Config/temp/yay
cd ~/Config/temp/yay
makepkg -si
cd .. && rm -rf ~/Config/temp/yay
echo Finished installing Yay

echo Installing oh-my-zsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

echo Installing zsh autocompletions
mkdir ~/Config/zsh/custom/
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions


echo Symbolic link spam go brrrrrr
ln -s ~/Config/.zshrc ~/.zshrc 
ln -s ~/Config/zsh/custom/ ~/.oh-my-zsh/custom

ln -s ~/Config/kitty.conf ~/.config/kitty/kitty.conf

mkdir ~/.config/i3/
ln -s ~/Config/i3-gaps.conf ~/.config/i3/config

echo Adding intel gpu commands to NOPASSWD for polybar gpu module 
echo THIS MIGHT BREAK THINGS
sudo sh ~/Config/polybar/nosudo-gpu.sh

# Just to be sure
chmod +x ~/Config/polybar/*.sh

echo Installing themes
cd ~/Config/temp
wget https://github.com/EliverLara/Juno/archive/refs/heads/mirage.zip
unzip mirage.zip && sudo cp -r Juno-mirage /usr/share/themes/
gsettings set org.gnome.desktop.interface color-scheme prefer-dark # prefer dark mode
ln -s ~/Config/gtk3.conf ~/.config/gtk-3.0/settings.ini

echo Installing additional utilities
yay -S ulauncher

echo Removing temporary files
rm -rf ~/Config/temp


read -p "Install additional packages? (discord, vscode, firefox, etc.) (Y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    yay -S jetbrains-toolbox neovim vscode discord-canary polymc firefox steam 
fi

echo Finished!
