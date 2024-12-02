# helix

- [keymap](https://docs.helix-editor.com/keymap.html)

- create a symlink for the configuration directory

  - on Windows, the configuration directory is `%APPDATA%\helix`

    ```bat
    mklink /D "%APPDATA%\helix" "%PATH_TO_THIS_REPO%\config\helix"
    ```

  - on Linux/MacOS, the configuration directory is `$HOME/.config/helix`
    ```sh
    ln -s $PATH_TO_THIS_REPO/config/helix $HOME/.config/helix
    ```

### add python support

- requirements
  - `nodejs` (via `npm`)
  - `python`!!

```bat
npm install --location=global pyright
:: py -m pip install -U ruff-lsp
```
