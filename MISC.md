# misc

## Cmder

- main config file: `%CMDER_ROOT%\config\user_aliases.cmd`

  - aliases (**manually replace %MY_CONFIG_REPO% with actual directory path**):
    ```cmd
    gync=git commit -am "mod" && git pull && git push
    gss=git status
    gaa= git add -A .
    gcm=git commit -am $*
    dt=%HOMEDRIVE% && cd "%USERPROFILE%\Desktop"
    ll=ls -last $*
    ydl=yt-dlp.exe -f - --config-locations "%MY_CONFIG_REPO%\yt-dlp\yt-dlp.conf" $*
    ymp3=yt-dlp.exe --config-locations "%MY_CONFIG_REPO%\yt-dlp\yt-dlp.conf" --extract-audio --audio-format mp3 $*
    ```

## Executor

- main config file: `%APPDATA%\Executor\executor.ini`

## Windows Terminal

- main config file: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`

- useful options:

  ```json
  {
    "launchMode": "maximized",
    "copyOnSelect": true,
    "multiLinePasteWarning": false,
    "trimPaste": false,
    "profiles": {
      "defaults": {
        "closeOnExit": "always",
        "padding": "0",
        "font": {
          "face": "JetBrainsMonoNL Nerd Font",
          "size": 10.0,
          "weight": "medium"
        }
      }
    }
  }
  ```

## Linux/MacOS shell

- partial search in command history

  - add following lines to `$HOME/.inputrc`

    ```sh
    # apply default shortcuts
    $include /etc/inputrc

    "\e[A":history-search-backward
    "\e[B":history-search-forward
    ```

- disable terminal bell

  - add following lines to `$HOME/.inputrc`

    ```sh
    set bell-style none
    ```

- shell aliases

  - `bash`: add aliases to `$HOME/.bashrc`
