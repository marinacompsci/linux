#!/usr/bin/env bash

echo 'Run me on a TMUX split window and not i3.'
echo 'Install NPM packages.'
curl -fsSL https://get.pnpm.io/install.sh | sh -
pnpm i -g bash-language-server
pnpm i -g pyright
pnpm i -g vscode-langservers-extracted

echo 'Install Go language server.'
go install golang.org/x/tools/gopls@latest
