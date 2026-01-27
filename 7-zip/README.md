# 7-zip

- import registry settings from [config.reg](config.reg) file
  - sample code to automatically apply settings

  ```bat
  @REM 7-zip
  echo|set /p _="%TIME%   - 7-zip... "
  reg import "%PATH_TO_THIS_REPO%\7-zip\config.reg" 2>NUL
  echo done
  ```

  - **NOT ALL DESIRED SETTINGS** can be applied
    - file associations must be set manually
