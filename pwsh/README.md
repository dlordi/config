# pwsh / PowerShell Core

- configuration file path is stored in the `$PROFILE` environment variable

  - to display it, run this command from the command prompt `pwsh.exe -Command "echo $PROFILE"`
  - it should be `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`

- create a symlink for the configuration file

  ```bat
  mklink "%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1" "%PATH_TO_THIS_REPO%\pwsh\Microsoft.PowerShell_profile.ps1"
  ```
