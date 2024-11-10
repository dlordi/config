# alacritty

- alacritty configuration docs: https://alacritty.org/config-alacritty.html

- create a symlink for the configuration directory

  - on Windows, the configuration directory is `%APPDATA%\alacritty`

    ```bat
    mklink /D "%APPDATA%\alacritty" "%USERPROFILE%\Desktop\config\alacritty"
    ```

  - on Linux/MacOS, the configuration directory is `$HOME/.config/alacritty`

    ```sh
    ln -s $HOME/config/alacritty $HOME/.config/alacritty
    ```
