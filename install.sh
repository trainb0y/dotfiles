#!/bin/sh

# ######## Not reccomended for use! #########
# This is less of an actual installer, and more of a list of steps I did to get stuff running
# Although it might sort of work, it's more of a refrence material for future me than anything else.
#
# No error handling, doesn't check anything, and does some really stupid things along the way
# Enjoy!
# - trainb0y


echo ----- trainb0y\'s dotfile installer
echo You shouldnt have run this, it will probably break everything
echo Like, seriously, unless you want stuff to be broken, quit it.
echo Don\'t hold me responsible for the outcome of any dumb mistake you might be making
echo
read -p "Are you sure you want to continue? (Y/n) " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo
    echo "You made the right choice! o7"
    exit 1
fi
echo
read -p "Are you *really* sure? This is a bad idea... " -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo
    echo "Ok good, for a second there I was worried you would actually do it."
    exit 1
fi
echo


# Install packages 
sudo pacman -Syu i3-gaps picom btop chrony autorandr pavucontrol polybar feh zsh nemo kitty git github-cli maim xclip neofetch bc xdg-desktop-portal-gtk gtk-engines intel-gpu-tools
echo Installed packages

read -p "Configure GitHub CLI? (Y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    gh auth setup-git 
    gh auth login
fi
echo

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
ln -s ~/Config/kitty/kitty.conf ~/.config/kitty/kitty.conf
mkdir ~/.config/i3/
ln -s ~/Config/i3-gaps.conf ~/.config/i3/config

echo Adding intel gpu commands to NOPASSWD for polybar gpu module 
echo If you don\'t have an intel gpu this is entirely pointless
echo THIS MIGHT BREAK THINGS
read -p "Are you, absolutely *positively* sure you want to do this? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo sh ~/Config/polybar/scripts/nosudo-gpu.sh
    # echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/intel_gpu_top" > /etc/sudoers.d/intelgpu
fi
echo

echo Installing themes
cd ~/Config/temp
wget https://github.com/EliverLara/Juno/archive/refs/heads/mirage.zip
unzip mirage.zip && sudo cp -r Juno-mirage /usr/share/themes/
gsettings set org.gnome.desktop.interface color-scheme prefer-dark # prefer dark mode
ln -s ~/Config/gtk3.conf ~/.config/gtk-3.0/settings.ini

echo Installing additional utilities from the AUR
yay -S ulauncher ttf-twemoji onefetch nemo-fileroller

echo messing with systemd
sudo systemctl disable systemd-timesyncd.service
sudo systemctl enable chronyd

echo Cleaning up
rm -rf ~/Config/temp/
chmod +x ~/Config/polybar/*.sh

read -p "Install additional packages? (discord, vscode, firefox, etc.) (Y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    yay -S jetbrains-toolbox neovim vscode discord-canary polymc firefox steam 
fi
echo
echo Finished!
