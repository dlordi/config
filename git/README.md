# git

- create a symlink for the configuration file

  - on Windows, the configuration file is `%USERPROFILE%\.gitconfig`

    ```bat
    mklink /D "%USERPROFILE%\.gitconfig" "%PATH_TO_THIS_REPO%\git\gitconfig"
    ```

  - on Linux/MacOS, the configuration file is `$HOME/.gitconfig`

    ```sh
    ln -s $PATH_TO_THIS_REPO/git/gitconfig $HOME/.gitconfig
    ```
