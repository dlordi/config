# bash

- aliases

  ```sh
  ln -s $PATH_TO_THIS_REPO/bash/bash_aliases $HOME/.bash_aliases
  echo "" >>~/.bashrc
  echo "if [ -e ~/.bash_aliases ]; then source ~/.bash_aliases; fi" >>~/.bashrc
  ```

- config

  ```sh
  ln -s $PATH_TO_THIS_REPO/bash/bash_config $HOME/.bash_config
  echo "" >>~/.bash_profile
  echo "if [ -e ~/.bash_config ]; then source ~/.bash_config; fi" >>~/.bash_profile
  ```
