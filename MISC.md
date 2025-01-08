# misc

## Cmder

- main config file: `%CMDER_ROOT%\config\user_aliases.cmd`

  - aliases to add (**manually replace %MY_CONFIG_REPO% with actual directory path**):
    ```cmd
    ll=ls -last $*
    gaa=git add -A .
    gcm=git commit -m $*
    gss=git status
    gync=git add -A . && git commit -m "mod" && git pull && git push
    ydl=yt-dlp.exe -f - --config-locations "%MY_CONFIG_REPO%\yt-dlp\yt-dlp.conf" $*
    ymp3=yt-dlp.exe --config-locations "%MY_CONFIG_REPO%\yt-dlp\yt-dlp.conf" --extract-audio --audio-format mp3 $*
    dt=cd /D "%USERPROFILE%\Desktop"
    cdd=cd /D $*
    cdh=cd /D "%USERPROFILE%"
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
        "colorScheme": "CGA",
        "padding": "0",
        "font": {
          "face": "JetBrainsMonoNL NFM",
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

  - add/uncomment the following line in `/etc/inputrc`

    ```sh
    set bell-style none
    ```

- misc bash options to add to `$HOME/.bashrc`

  - `shopt -s histappend`: append commands to history

- start `tmux` automatically (line to add to `$HOME/.bashrc`)

  - also add ` && [ -z "$SSH_CONNECTION" ]` to prevent tmux from starting upon ssh

  - `if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then exec tmux; fi`
