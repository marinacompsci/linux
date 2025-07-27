#!/usr/bin/env bash

set -e

PKGS_DIR="$HOME/developer/pkgs"
DOTFILES_DIR="$HOME/developer/dotfiles"


echo 'Install packages with apt.'
sudo apt install -y i3 --no-install-recommends
sudo apt install -y kitty
sudo apt install -y git
sudo apt install -y tmux
sudo apt install -y curl
sudo apt install -y zoxide
sudo apt install -y hunspell
sudo apt install -y htop
sudo apt install -y sqlite3

echo 'Set kitty as default terminal.'
echo 1 | sudo update-alternatives --config x-terminal-emulator

# Create directory for custom builds due to Debian being always a step behind
mkdir -p "$PKGS_DIR"
if ! [ -d "$PKGS_DIR" ]; then
    echo '[ERROR] Directory $HOME/developer/pkgs not created.'
    exit 1
fi

mkdir "$DOTFILES_DIR"
if ! [ -d "$DOTFILES_DIR" ]; then
    echo '[ERROR] Directory $HOME/developer/dotfiles not created.'
    exit 1
fi

# Install Neovim
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.3/nvim-linux-arm64.appimage
chmod u+x nvim-linux-arm64.appimage
mv nvim-linux-arm64.appimage "$PKGS_DIR"
sudo ln -s ${PKGS_DIR}/nvim-linux-arm64.appimage /usr/local/bin/nvim

# Vim-plug(vim/nvim plugin manager)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'


# Install Node Version Manager, Node(NPM included) and LSP's
# Setting PROFILE to /dev/null ensures that it does not modify our bash files
PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'

echo 'Install Golang, check if the version installed is the latest.'
curl -LO https://go.dev/dl/go1.24.5.linux-arm64.tar.gz
mv go1.24.5.linux-arm64.tar.gz "$PKGS_DIR"

sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.24.5.linux-arm64.tar.gz

echo 'Generate SSH keys.'
read -r -p 'Insert comment for SSH keys: ' ssh_comment
ssh-keygen -t ed25519 -C "$ssh_comment"

mkdir -p $HOME/.config/nvim
if ! [ -d "$HOME/.config/nvim" ]; then
    echo '[ERROR] $HOME/.config/nvim not created.'
    exit 1
fi

cat $HOME/.ssh/id_ed25519.pub
echo 'Copy new SSH key to GitHub.'
read -r -p 'Are you done? [y/N] ' answer
until [ "$answer" == "y" ]; do
    echo -n 'Are you done? [y/N] '; read answer
done

read -r -p 'Clone dotfiles now? [Y/n]' answer
if [ "$answer" == 'Y' ]; then
    echo 'Cloning dotfiles repository.'
    echo 'Remember to write "yes" instead of pressing enter for "fingerprint".'
    git clone git@github.com:marinacompsci/dotfiles.git "$DOTFILES_DIR"
    rm -rf $HOME/.bash* 
    rm -rf $HOME/.tmux* 
    rm -rf $HOME/.vimrc
    rm -rf $HOME/.vim 
    rm -f $HOME/.hunspell_en_US 
    rm -f $HOME/.config/nvim/init.lua
    rm -f $HOME/.config/kitty/kitty.conf 
    rm -f $HOME/.config/i3/config

    echo 'Run symlinks creation script.'
    local symlink_script=${DOTFILES_DIR}/scripts/bash/setup.sh
    local bashenv_path=${DOTFILES_DIR}/bash/.bashenv
    "$symlink_script" "$bashenv_path" 'linux-desktop'
fi

echo 'Install VM tools to help adjust the resolution.'
sudo apt install open-vm-tools open-vm-tools-desktop

echo "Set DNS server to Google\'s."
sudo echo 'nameserver 8.8.8.8' > /etc/resolv.conf
