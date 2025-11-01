# Windows

- import [`00-setup.reg`](00-setup.reg) file, then **REBOOT** the PC
- import [`10-prefs.reg`](10-prefs.reg) file
- "run" [`20-software.winget`](20-software.winget) to install commonly used software

## Auto-configuration

- auto-configuration is **experimental**:

  ```ps1
  iex "& { $(iwr https://raw.githubusercontent.com/dlordi/config/refs/heads/main/windows/autoconf.ps1) }"
  ```
