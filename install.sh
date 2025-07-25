!/usr/bin/env bash

set -e

echo 'Install packages.'
sudo apt install -y i3 --no-install-recommends
sudo apt install -y kitty
sudo apt install -y git
sudo apt install -y tmux
sudo apt install -y curl
sudo apt install -y zoxide
sudo apt install -y hunspell
sudo apt install -y htop

echo 'Set kitty as default terminal.'
echo 1 | sudo update-alternatives --config x-terminal-emulator

# Create directory for custom builds due to Debian being always a step behind
mkdir $HOME/developer/pkgs

# Install neovim.
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-arm64.appimage
chmod u+x nvim-linux-arm64.appimage
mv nvim-linux-arm64.appimage $HOME/pkgs
sudo ln -s $HOME/developer/pkgs/nvim-linux-arm64.appimage /usr/local/bin/nvim

# Vim-plug(vim/nvim plugin manager)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


# Install Node Version Manager, Node(NPM included) and LSP's
PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'
echo 'Assert that $PATH contains .nvm/../bin'
echo $PATH
read -r -p 'Continue? [Y/n]' answer
if [ "$answer" != 'Y' ]; then
    exit 1
fi

 Install Go
curl -LO https://go.dev/dl/go1.24.5.linux-arm64.tar.gz
mv go1.24.5.linux-arm64.tar.gz $HOME/developer/pkgs

sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.24.5.linux-arm64.tar.gz
echo 'Assert that $PATH contains /usr/local/go/bin'
echo $PATH
read -r -p 'Continue? [Y/n]' answer
if [ "$answer" != 'Y' ]; then
    exit 1
fi

echo 'Generate SSH keys.'
echo -n 'Insert comment for SSH keys: '; read ssh_comment
ssh-keygen -t ed25519 -C "$ssh_comment"

mkdir -p $HOME/.config/nvim
mkdir $HOME/developer

cat $HOME/.ssh/id_ed25519.pub
echo 'Copy new SSH key to GitHub.'
echo -n 'Are you done?[y/N] '; read answer
until [ "$answer" == "y" ]; do
    echo -n 'Are you done?[y/N] '; read answer
done

read -r -p 'Clone dotfiles now? [Y/n]' answer
if [ "$answer" != 'Y' ]; then
    exit 0
fi

echo 'Cloning dotfiles repository.'
echo 'Remember to write "yes" instead of pressing enter for "fingerprint".'
git clone git@github.com:marinacompsci/dotfiles.git $HOME/developer/dotfiles

rm -rf $HOME/.bash* 
rm -rf $HOME/.tmux* 
rm -rf $HOME/.vimrc
rm -rf $HOME/.vim 
rm -f $HOME/.hunspell_en_US 
rm -f $HOME/.config/nvim/init.lua
rm -f $HOME/.config/kitty/kitty.conf 
rm -f $HOME/.config/i3/config

echo 'Run symlinks creation script.'
SYMLINK_SCRIPT="$HOME/developer/dotfiles/scripts/bash/setup.sh"
BASHENV_PATH="$HOME/developer/dotfiles/bash/.bashenv"
"$SYMLINK_SCRIPT" "$BASHENV_PATH" 'linux-desktop'

echo 'Install VM tools to help adjust the resolution.'
sudo apt install open-vm-tools open-vm-tools-desktop
