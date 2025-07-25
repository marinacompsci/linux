#!/usr/bin/env bash

set -e

echo 'Install packages.'
sudo apt install -y i3 --no-install-recommends
sudo apt install -y kitty
sudo apt install -y git
sudo apt install -y tmux
sudo apt install -y neovim
sudo apt install -y curl
sudo apt install -y zoxide
sudo apt install -y hunspell
sudo apt install -y htop

echo 'Set kitty as default terminal.'
echo 1 | sudo update-alternatives --config x-terminal-emulator

# Vim-plug(vim/nvim plugin manager)
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Install Node Version Manager, Node(NPM included) and LSP's
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
echo 'Assert that $PATH contains .nvm/../bin'
echo $PATH
read -r -p 'Continue? [Y/n]'; answer
if [ "$answer" != 'Y' ]; then
    exit 1
fi
#export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install latest
npm i -g bash-language-server
npm i -g pyright
npm i -g typescript-language-server typescript
npm i -g vscode-langservers-extracted


# Install Go
curl https://go.dev/dl/go1.24.5.linux-arm64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.5.linux-arm64.tar.gz
echo 'Assert that $PATH contains /usr/local/go/bin'
echo $PATH
read -r -p 'Continue? [Y/n]'; answer
if [ "$answer" != 'Y' ]; then
    exit 1
fi
go install golang.org/x/tools/gopls@latest

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

git clone git@github.com:marinacompsci/dotfiles.git $HOME/developer/dotfiles

rm -rf $HOME/.bash* $HOME/.tmux* $HOME/.vimrc
rm -rf $HOME/.hunspell_en_US $HOME/.vim $HOME/.config/nvim/init.lua
rm -rf $HOME/.config/kitty/kitty.conf $HOME/.config/i3/config

echo 'Run symlinks creation script.'
BASHENV_PATH=$(find -name '.bashenv')
SYMLINK_SCRIPT="$HOME/developer/dotfiles/scripts/bash/setup.sh"
"$SYMLINK_SCRIPT" "$BASHENV_PATH" 'linux-desktop'

echo 'Install VM tools to help adjust the resolution.'
sudo apt install open-vm-tools open-vm-tools-desktop
