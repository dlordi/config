# helix

- [keymap](https://docs.helix-editor.com/keymap.html)

- create a symlink for the configuration directory
  - on Windows, the configuration directory is `%APPDATA%\helix`
    ```bat
    mklink /D "%APPDATA%\helix" "%USERPROFILE%\Desktop\config\helix"
    ```

### add python support

- requirements
  - `nodejs` (via `npm`)
  - `python`!!

```bat
npm install --location=global pyright
:: py -m pip install -U ruff-lsp
```
