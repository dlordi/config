# yazi

- https://yazi-rs.github.io/docs/configuration/overview
  - https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/yazi.toml
  - https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/keymap.toml
  - https://github.com/sxyazi/yazi/blob/shipped/yazi-config/preset/theme.toml

- create a symlink for the configuration file

  - on Windows, the configuration directory is `%APPDATA%\yazi`

    ```bat
    mkdir "%APPDATA%\yazi"
    mklink /D "%APPDATA%\yazi\config" "%USERPROFILE%\Desktop\config\yazi"
    ```

  - on Linux/MacOS, the configuration directory is `$HOME/.config/yazi`
    ```sh
    ln -s $HOME/config/yazi $HOME/.config/yazi
    ```

