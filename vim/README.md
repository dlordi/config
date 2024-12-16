# vim

- create a symlink for the configuration file and subdirectories

  - on Windows, the configuration directory is `%USERPROFILE%\.vim` and the main configuration file is `%USERPROFILE%\.vim\vimrc`

    ```bat
    if not exist "%USERPROFILE%\.vim" mkdir "%USERPROFILE%\.vim"
    mklink "%USERPROFILE%\.vim\vimrc" "%PATH_TO_THIS_REPO%\vim\vimrc"
    mklink /D "%USERPROFILE%\.vim\colors" "%PATH_TO_THIS_REPO%\vim\colors"
    ```

  - on Linux/MacOS, the configuration directory is `$HOME/.vim` and the main configuration file is `$HOME/.vim/vimrc`
    ```sh
    mkdir -p "$HOME/.vim"
    ln -s "$PATH_TO_THIS_REPO/vim/vimrc" "$HOME/.vim/vimrc"
    ln -s "$PATH_TO_THIS_REPO/vim/colors" "$HOME/.vim/colors"
    ```

- [monokai colorscheme](./colors/monokai.vim) has been downloaded from [this repo](https://github.com/ku1ik/vim-monokai/)
