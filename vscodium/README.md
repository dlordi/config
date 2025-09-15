# vscodium

- create a symlink for the configuration file

  - on Windows, the configuration files are `%APPDATA%\VSCodium\User\settings.json` and `%APPDATA%\VSCodium\User\keybindings.json`

    ```bat
    mklink "%APPDATA%\VSCodium\User\settings.json" "%PATH_TO_THIS_REPO%\vscodium\settings.json"
    mklink "%APPDATA%\VSCodium\User\keybindings.json" "%PATH_TO_THIS_REPO%\vscodium\keybindings.json"
    ```
