# vim

- create a symlink for the configuration file and subdirectories

  - on Windows, the configuration file is `%USERPROFILE%\_vimrc` and the main directory is `%USERPROFILE%\.vim`

    ```bat
    mklink "%USERPROFILE%\_vimrc" "%PATH_TO_THIS_REPO%\config\vim\vimrc"
    if not exist "%USERPROFILE%\.vim" mkdir "%USERPROFILE%\.vim"
    mklink /D "%USERPROFILE%\.vim\colors" "%PATH_TO_THIS_REPO%\config\vim\colors"
    ```

  - on Linux/MacOS, the configuration file is `$HOME/.vimrc` and the main directory is `$HOME/.vim`
    ```bat
    ln -s "$PATH_TO_THIS_REPO/config/vim/vimrc" "$HOME/.vimrc"
    mkdir -p "$HOME/.vim"
    ln -s "$PATH_TO_THIS_REPO/config/vim/colors" "$HOME/.vim/colors"
    ```

- [monokai colorscheme](./colors/monokai.vim) has been downloaded from [this repo](https://github.com/ku1ik/vim-monokai/)
