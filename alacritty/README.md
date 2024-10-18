# alacritty

- alacritty configuration docs: https://alacritty.org/config-alacritty.html

- create a symlink for the configuration file

  - on Windows, the configuration file is `%APPDATA%\alacritty\alacritty.toml`

    ```bat
    if not exist "%APPDATA%\alacritty" md "%APPDATA%\alacritty"
    mklink "%APPDATA%\alacritty\alacritty.toml" "%USERPROFILE%\Desktop\config\alacritty\alacritty.toml"
    ```
