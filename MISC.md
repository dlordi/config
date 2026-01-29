# misc

## Executor

- main config file: `%APPDATA%\Executor\executor.ini`

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
