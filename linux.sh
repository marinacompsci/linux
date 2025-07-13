#!/usr/bin/env bash

RESOLUTION_W=1710
RESOLUTION_H=1112
RESOLUTION_FREQ=60
DESKTOP_OUTPUT_NAME='Virtual-1'

set -e

echo 'Install packages.'
sudo apt install -y i3 --no-install-recommends
sudo apt install -y kitty
sudo apt install -y git
sudo apt install -y tmux
sudo apt install -y neovim
sudo apt install -y curl
sudo apt install -y nodejs
sudo apt install -y npm
# Add pkgs: zoxide, hunspell and others

# Vim-plug(plugin manager)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo 'Set kitty as default terminal.'
echo 1 | sudo update-alternatives --config x-terminal-emulator

echo 'Generate SSH keys.'
echo -n 'Insert comment for SSH keys: '; read ssh_comment
ssh-keygen -t ed25519 -C "$ssh_comment"

mkdir -p $HOME/.config/nvim/
mkdir $HOME/developer

cat $HOME/.ssh/id_ed25519.pub
echo 'Copy new SSH key to GitHub. Enter DONE when finished.';
echo -n 'Are you DONE? '; read answer
until [ "$answer" == "DONE" ]; do
    echo -n 'Are you DONE?[DONE/<any>] '; read answer
done

git clone git@github.com:marinacompsci/dotfiles.git $HOME/developer

rm -rf $HOME/.bash* $HOME/.tmux* $HOME/.vimrc
rm -rf $HOME/.hunspell_en_US $HOME/.vim $HOME/.config/nvim/init.lua
rm -rf $HOME/.config/kitty/kitty.conf $HOME/.config/i3/config

echo 'Run symlinks creation script.'
BASHENV_PATH=$(find -name '.bashenv')
SYMLINK_SCRIPT="$HOME/developer/dotfiles/scripts/bash/setup.sh"
"$SYMLINK_SCRIPT" "$BASHENV_PATH" 'linux-desktop'

echo 'Install VM tools to help adjust the resolution.'
sudo apt install open-vm-tools open-vm-tools-desktop

echo "Calculate and set screen's resolution."
CVT_OUTPUT=$(cvt $RESOLUTION_W $RESOLUTION_H $RESOLUTION_FREQ)
NEW_MODELINE=$(echo $CVT_OUTPUT | sed -E 's/.*Modeline\s//')
NEW_MODE=$(echo $NEW_MODELINE | sed -E 's/"(.*)".*/\1/')
I3_CONFIG="$HOME/.config/i3/config"

echo >> I3_CONFIG
echo "# Setting screen's dimensions and resolution." >> $I3_CONFIG
echo "# Set this below the line where the font is set." >> $I3_CONFIG
echo "exec --no-startup-id xrandr --newmode $NEW_MODELINE" >> $I3_CONFIG
echo "exec --no-startup-id xrandr --addmode $DESKTOP_OUTPUT_NAME $NEW_MODE" >> $I3_CONFIG
echo "exec --no-startup-id xrandr --output $DESKTOP_OUTPUT_NAME --mode $NEW_MODE" >> $I3_CONFIG


#echo 'Install JetBrains Mono'
#sudo cp $HOME/developer/dotfiles/essentials/JetBrainsMono*/*.ttf /usr/local/share/fonts/
# Update fonts' cache
#fc-cache -f -v
#echo 'Set JetBrainsMono as default font system-wide YOURSELF'
