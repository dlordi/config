#!/usr/bin/env bash

echo "`date +%H:%M:%S` applying default configurations..."

# PATH_TO_THIS_REPO does not end with a slash (the directory separator)!
PATH_TO_THIS_REPO=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# alacritty
echo -n "`date +%H:%M:%S`   - alacritty... "
[ -e $HOME/.config/alacritty ] && rm -rf $HOME/.config/alacritty
mkdir -p $HOME/.config
ln -sf $PATH_TO_THIS_REPO/alacritty $HOME/.config/alacritty
echo "done"

# git
echo -n "`date +%H:%M:%S`   - git... "
$PATH_TO_THIS_REPO/apply-git.py "$PATH_TO_THIS_REPO/git/gitconfig"
echo "done"

# neovim
echo -n "`date +%H:%M:%S`   - neovim... "
[ -e $HOME/.config/nvim ] && rm -rf $HOME/.config/nvim
mkdir -p $HOME/.config
ln -sf $PATH_TO_THIS_REPO/neovim $HOME/.config/nvim
echo "done"

# vim
echo -n "`date +%H:%M:%S`   - vim... "
mkdir -p "$HOME/.vim"
ln -sf "$PATH_TO_THIS_REPO/vim/vimrc" "$HOME/.vim/vimrc"
[ -e $HOME/.vim/colors ] && rm -rf $HOME/.vim/colors
ln -sf "$PATH_TO_THIS_REPO/vim/colors" "$HOME/.vim/colors"
mkdir -p ~/.vim/pack/tpope/start
[ ! -d ~/.vim/pack/tpope/start/vim-fugitive ] && git -C ~/.vim/pack/tpope/start clone https://github.com/tpope/vim-fugitive
git -C ~/.vim/pack/tpope/start/vim-fugitive pull >/dev/null
echo "done"

# yazi
echo -n "`date +%H:%M:%S`   - yazi... "
[ -e $HOME/.config/yazi ] && rm -rf $HOME/.config/yazi
mkdir -p $HOME/.config
ln -sf $PATH_TO_THIS_REPO/yazi $HOME/.config/yazi
echo "done"

echo "`date +%H:%M:%S` configuration applied successfully!"
