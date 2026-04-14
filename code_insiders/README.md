# Visual Studio Code Insiders

- create a symlink for the configuration files

  - on Windows, the configuration files are in `%APPDATA%\Code - Insiders\User`

    ```bat
    mklink "%APPDATA%\Code - Insiders\User\settings.json" "%PATH_TO_THIS_REPO%\code-insiders\settings.json"
    ```
