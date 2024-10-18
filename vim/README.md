# vim

- create a symlink for the configuration file

  - on Windows, the configuration file is `%USERPROFILE%\_vimrc`

    ```bat
    mklink "%USERPROFILE%\_vimrc" "%USERPROFILE%\Desktop\config\vim\.vimrc"
    ```

  - on Linux/MacOS, the configuration file is `$HOME/.vimrc`
    ```bat
    ln -s "$HOME/Desktop/config/vim/.vimrc" "$HOME/.vimrc"
    ```
