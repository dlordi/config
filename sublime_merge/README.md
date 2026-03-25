# Sublime Merge

- create a symlink for the configuration directory

  - configuration directory changes depending on the setup method, commonly is `%APPDATA%\Sublime Merge\Packages\User`

    ```bat
    mklink /D "%APPDATA%\Sublime Merge\Packages\User" "%PATH_TO_THIS_REPO%\sublime_merge"
    ```
