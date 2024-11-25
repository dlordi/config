# bash

- aliases

  ```sh
  ln -s $HOME/config/bash/bash_aliases $HOME/.bash_aliases
  echo "" >>~/.bashrc
  echo "if [ -e ~/.bash_aliases ]; then source ~/.bash_aliases; fi" >>~/.bashrc
  ```
