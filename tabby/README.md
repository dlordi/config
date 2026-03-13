# Tabby

- create a symlink for the configuration file
  - on Windows, the configuration file is `%APPDATA%\tabby\config.yaml`

    ```bat
    mklink "%APPDATA%\tabby\config.yaml" "%PATH_TO_THIS_REPO%\tabby\config.yaml"
    ```
