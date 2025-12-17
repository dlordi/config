# zed

- create a symlink for the configuration file

  - on Windows, the configuration directory is `%APPDATA%\Zed`

    ```bat
    mklink /D "%APPDATA%\Zed\snippets" "%PATH_TO_THIS_REPO%\zed\snippets"
    mklink "%APPDATA%\Zed\settings.json" "%PATH_TO_THIS_REPO%\zed\settings.json"
    mklink "%APPDATA%\Zed\keymap.json" "%PATH_TO_THIS_REPO%\zed\keymap.json"
    ```
