neovim

- create a symlink for the configuration directory
  - on Windows, the configuration directory is `%LOCALAPPDATA%\nvim`
    ```bat
    mklink /D "%LOCALAPPDATA%\nvim" "%USERPROFILE%\Desktop\config\neovim"
    ```
