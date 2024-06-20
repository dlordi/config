# vscodium

- create a symlink for the configuration file
  - on Windows, the configuration file is `%APPDATA%\VSCodium\User\settings.json`
    ```bat
    mklink "%APPDATA%\VSCodium\User\settings.json" "%USERPROFILE%\Desktop\config\vscodium\settings.json"
    ```
