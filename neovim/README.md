# neovim

- create a symlink for the configuration directory

  - on Windows, the configuration directory is `%LOCALAPPDATA%\nvim`

    ```bat
    mklink /D "%LOCALAPPDATA%\nvim" "%PATH_TO_THIS_REPO%\neovim"
    ```

  - on Linux/MacOS, the configuration directory is `$HOME/.config/nvim`
    ```sh
    ln -s $PATH_TO_THIS_REPO/neovim $HOME/.config/nvim
    ```

- the easiest way to use `treesitter` plugin is to install the zig compiler

  - on Windows, use following commands to install
    ```bat
    winget install --source winget --interactive --exact --id zig.zig
    winget install --source winget --interactive --exact --id zigtools.zls
    ```

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
  - on Arck Linux, use following commands to install
    ```bat
    sudo yay -Syu ripgrep fd
    ```

## Resources

- https://neovim.io/doc/user/options.html
- https://neovim.io/doc/user/editorconfig.html
