# Windows

- import [`00-setup.reg`](00-setup.reg) file, then **REBOOT** the PC
- import [`10-prefs.reg`](10-prefs.reg) file
- "run" [`20-software.winget`](20-software.winget) to install commonly used software

## Auto-configuration

- auto-configuration is **experimental**:

  ```ps1
  iex "& { $(iwr https://raw.githubusercontent.com/dlordi/config/refs/heads/main/windows/autoconf.ps1) }"
  ```

  - to debug/test

    - start a local web server on a separate terminal

      ```bat
      py -m http.server 8123
      ```

    - run a slightly different command

      ```ps1
      iex "& { $(iwr http://localhost:8123/autoconf.ps1) }"
      ```
