# helix

- [keymap](https://docs.helix-editor.com/keymap.html)

- create a symlink for the configuration directory

  - on Windows, the configuration directory is `%APPDATA%\helix`
    ```bat
    mklink /D "%APPDATA%\helix" "%USERPROFILE%\Desktop\config\helix"
    ```

  - on Linux/MacOS, the configuration directory is `$HOME/.config/helix`
    ```sh
    ln -s $HOME/config/helix $HOME/.config
    ```

### add python support

- requirements
  - `nodejs` (via `npm`)
  - `python`!!

```bat
npm install --location=global pyright
:: py -m pip install -U ruff-lsp
```
