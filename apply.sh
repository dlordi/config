#!/usr/bin/env bash

# PATH_TO_THIS_REPO does not end with a slash (the directory separator)!
PATH_TO_THIS_REPO=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# alacritty
[ -e $HOME/.config/alacritty ] && rm -rf $HOME/.config/alacritty
ln -sf $PATH_TO_THIS_REPO/alacritty $HOME/.config/alacritty

# neovim
[ -e $HOME/.config/nvim ] && rm -rf $HOME/.config/nvim
ln -sf $PATH_TO_THIS_REPO/neovim $HOME/.config/nvim

# vim
mkdir -p "$HOME/.vim"
ln -sf "$PATH_TO_THIS_REPO/vim/vimrc" "$HOME/.vim/vimrc"
[ -e $HOME/.vim/colors ] && rm -rf $HOME/.vim/colors
ln -sf "$PATH_TO_THIS_REPO/vim/colors" "$HOME/.vim/colors"
mkdir -p ~/.vim/pack/tpope/start
[ ! -d ~/.vim/pack/tpope/start/vim-fugitive ] && git -C ~/.vim/pack/tpope/start clone https://github.com/tpope/vim-fugitive
git -C ~/.vim/pack/tpope/start/vim-fugitive pull >/dev/null

# yazi
[ -e $HOME/.config/yazi ] && rm -rf $HOME/.config/yazi
ln -sf $PATH_TO_THIS_REPO/yazi $HOME/.config/yazi

echo configuration applied successfully!
