# ruff

- create a symlink for the configuration file

  - on Windows, the configuration file is `%USERPROFILE%\.config\ruff.toml`

    ```bat
    mklink "%USERPROFILE%\.config\ruff.toml" "%USERPROFILE%\Desktop\config\ruff\ruff.toml"
    ```

  - on Linux/MacOS, the configuration file is `$HOME/.config/ruff.toml`

    ```sh
    ln -s "$HOME/Desktop/config/ruff/ruff.toml" "$HOME/config/ruff.toml"
    ```
