@echo off

winget install --source winget --exact --id DominikReichl.KeePass
winget install --source winget --exact --id Mozilla.Firefox.it
winget install --source winget --exact --id MartinBresson.Executor --include-unknown
winget install --source winget --exact --id fjsoft.MyPhoneExplorer

@REM references:
@REM - https://github.com/microsoft/winget-cli/discussions/3462
@REM - https://gitforwindows.org/silent-or-unattended-installation.html
winget install --accept-source-agreements --accept-package-agreements --source winget --exact --id Git.Git --custom "/VERYSILENT /NORESTART /NOCANCEL /LOADINF=git_install_options.ini"

@REM references:
@REM - https://www.autohotkey.com/docs/v2/Program.htm#install
@REM - https://www.autohotkey.com/docs/v2/Scripts.htm#ahk2exe-run
winget install --source winget --exact --id AutoHotkey.AutoHotkey --custom "/silent"
@REM custom installation of the ahk2exe compiler (based on default installation script, changed to make it more silent)
"%LOCALAPPDATA%\Programs\AutoHotkey\v2\AutoHotkey64.exe" install-ahk2exe.ahk
