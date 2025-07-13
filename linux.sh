#!/usr/bin/env bash

RESOLUTION_W=1710
RESOLUTION_H=1112
RESOLUTION_FREQ=60
OUTPUT_NAME='Virtual-1'

set -e

# Install packages
echo 'Install packages.'
sudo apt install -y i3 --no-install-recommends
sudo apt install -y kitty
sudo apt install -y git
sudo apt install -y tmux
sudo apt install -y neovim
sudo apt install -y curl
# Add pkgs: zoxide, hunspell and others

# Vim-plug(plugin manager)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


echo 'Set kitty as default terminal.'
echo 1 | sudo update-alternatives --config x-terminal-emulator

echo 'Generate SSH keys.'
echo -n 'Insert comment for SSH keys: '; read ssh_comment
ssh-keygen -t ed25519 -C "$ssh_comment"

mkdir -p ~/.config/nvim/
mkdir ~/developer
cd ~/developer

echo -n 'Copy new SSH key to GitHub. Enter DONE when finished.'; 
echo -n 'Are you DONE? '; read answer
until (( "$answer" == "DONE" )); do
done

echo -n 'Enter name(not URL) of GitHub dotfiles username and repository like john/dotfiles: '; read repo
git clone git@github.com:"$repo".git

echo 'Run symlinks creation script.'
echo -n 'Enter path for .bashenv file: '; read BASHENV_PATH
"~/developer/dotfiles/bash/setup.sh" "$BASHENV_PATH" 'linux-desktop'

echo 'Install VM tools to help adjust the resolution.'
sudo apt install open-vm-tools open-vm-tools-desktop

echo "Calculate and set screen's resolution"
CVT_OUTPUT=cvt "$RESOLUTION_W" "$RESOLUTION_H" "$RESOLUTION_FREQ"
RESOLUTION_NAME="{$RESOLUTION_W}x{$RESOLUTION_H}"
xrandr --newmode "$RESOLUTION_NAME" "$CVT_OUTPUT"    
xrandr --addmode "$DESKTOP_OUTPUT_NAME" "$RESOLUTION_NAME"
xrandr --output "$DESKTOP_OUTPUT_NAME" "$RESOLUTION_NAME"

echo 'Install JetBrains Mono'
sudo cp ~/developer/dotfiles/essentials/JetBrainsMono*/*.ttf /usr/local/share/fonts/
# Update fonts' cache
fc-cache -f -v
echo 'Set JetBrainsMono as default font system-wide YOURSELF'
