#!/usr/bin/env bash

echo 'Install NPM packages.'
nvm install latest
npm i -g bash-language-server
npm i -g pyright
npm i -g typescript-language-server typescript
npm i -g vscode-langservers-extracted

echo 'Install Go language server.'
go install golang.org/x/tools/gopls@latest
