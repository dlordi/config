@echo off

echo installing/updating KeePass...
winget install --source winget --exact --id DominikReichl.KeePass

echo installing/updating Firefox and Firefox Developer Edition...
@REM references:
@REM - https://firefox-source-docs.mozilla.org/browser/installer/windows/installer/FullConfig.html
winget install --source winget --exact --id Mozilla.Firefox.it --custom "/S /INI=%~dp0\firefox_install_options.ini"
winget install --source winget --exact --id Mozilla.Firefox.DeveloperEdition --custom "/S /InstallDirectoryPath=%LOCALAPPDATA%\Firefox Developer Edition /INI=%~dp0\firefox_install_options.ini"

echo installing/updating Executor...
winget install --source winget --exact --id MartinBresson.Executor --include-unknown

echo installing/updating MyPhoneExplorer...
winget install --source winget --exact --id fjsoft.MyPhoneExplorer

echo installing/updating git...
@REM references:
@REM - https://github.com/microsoft/winget-cli/discussions/3462
@REM - https://gitforwindows.org/silent-or-unattended-installation.html
winget install --accept-source-agreements --accept-package-agreements --source winget --exact --id Git.Git --custom "/VERYSILENT /NORESTART /NOCANCEL /LOADINF=%~dp0\git_install_options.ini"

echo installing/updating AutoHotkey...
@REM references:
@REM - https://www.autohotkey.com/docs/v2/Program.htm#install
@REM - https://www.autohotkey.com/docs/v2/Scripts.htm#ahk2exe-run
winget install --source winget --exact --id AutoHotkey.AutoHotkey --custom "/silent"
@REM custom installation of the ahk2exe compiler (based on default installation script, changed to make it more silent)
"%LOCALAPPDATA%\Programs\AutoHotkey\v2\AutoHotkey64.exe" "%~dp0\install-ahk2exe.ahk"
