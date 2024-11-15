# neovim

- create a symlink for the configuration directory

  - on Windows, the configuration directory is `%LOCALAPPDATA%\nvim`

    ```bat
    mklink /D "%LOCALAPPDATA%\nvim" "%USERPROFILE%\Desktop\config\neovim"
    ```

  - on Linux/MacOS, the configuration directory is `$HOME/.config/nvim`
    ```sh
    ln -s $HOME/config/neovim $HOME/.config/nvim
    ```

- on Windows and on Alpine Linux, the easiest way to use `treesitter` plugin is to install the zig compiler

- `telescope` plugin works betters when `ripgrep` and `fd` utilities are installed!
  - on Windows, use following commands to install
    ```bat
    winget install --source winget --interactive --exact --id BurntSushi.ripgrep.MSVC
    winget install --source winget --interactive --exact --id sharkdp.fd
    ```
  - on Alpine Linux, use following commands to install
    ```bat
    doas apk add ripgrep
    doas apk add fd
    ```
