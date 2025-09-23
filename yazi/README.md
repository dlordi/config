# yazi

- https://yazi-rs.github.io/docs/configuration/overview
  - https://github.com/sxyazi/yazi/tree/shipped/yazi-config/preset

- create a symlink for the configuration file

  - on Windows, the configuration directory is `%APPDATA%\yazi`

    ```bat
    mkdir "%APPDATA%\yazi"
    mklink /D "%APPDATA%\yazi\config" "%PATH_TO_THIS_REPO%\yazi"
    ```

  - on Linux/MacOS, the configuration directory is `$HOME/.config/yazi`
    ```sh
    ln -s $PATH_TO_THIS_REPO/yazi $HOME/.config/yazi
    ```
