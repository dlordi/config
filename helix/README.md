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

# compile, install and run helix from sources

```bat
cd "%USERPROFILE%\Desktop"
if not exist helix git clone git@github.com:helix-editor/helix.git

:: make a small change to the helix-term\src\main.rs (function main_impl) just to be sure things works as expected!
cd "%USERPROFILE%\Desktop\helix" && cargo install --path helix-term --locked

:: executable will be installed in "%USERPROFILE%\.cargo\bin\hx.exe"
where hx.exe
hx --help
hx --version
```

## uninstall

```bat
del "%USERPROFILE%\.cargo\bin\hx.exe"
```
