# android-cli

- https://developer.android.com/tools/agents/android-cli

- create a symlink for the configuration file
  - on Windows, the configuration file is `%USERPROFILE%\.androidrc`

    ```bat
    mklink "%USERPROFILE%\.androidrc" "%PATH_TO_THIS_REPO%\android-cli\androidrc.txt"
    ```

  - on Linux/MacOS, the configuration file is `$HOME/.androidrc`

    ```sh
    ln -s "$PATH_TO_THIS_REPO/android-cli/androidrc.txt" "$HOME/.androidrc"
    ```
