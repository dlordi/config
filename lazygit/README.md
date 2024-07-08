# lazygit

- lazygit configuration docs: https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md

- create a symlink for the configuration file

  - on Windows, the configuration file is `%APPDATA%\lazygit\config.yml`
    ```bat
    if not exist "%APPDATA%\lazygit" md "%APPDATA%\lazygit"
    mklink "%APPDATA%\lazygit\config.yml" "%USERPROFILE%\Desktop\config\lazygit\config.yml"
    ```
