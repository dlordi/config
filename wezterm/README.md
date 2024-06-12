# wezterm

- create a symlink for the configuration file

  - on Windows, the configuration file is `%USERPROFILE%\.config\wezterm\wezterm.lua`
    ```bat
    if not exist "%USERPROFILE%\.config\wezterm" md "%USERPROFILE%\.config\wezterm"
    mklink "%USERPROFILE%\.config\wezterm\wezterm.lua" "%USERPROFILE%\Desktop\config\wezterm\wezterm.lua"
    ```
