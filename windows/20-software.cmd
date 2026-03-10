@echo off

echo installing/updating KeePass...
call :winget DominikReichl.KeePass

echo installing/updating Firefox and Firefox Developer Edition...
@REM references:
@REM - https://firefox-source-docs.mozilla.org/browser/installer/windows/installer/FullConfig.html
call :winget Mozilla.Firefox.it --custom "/S /INI=%~dp0\firefox_install_options.ini"
call :winget Mozilla.Firefox.DeveloperEdition --custom "/S /InstallDirectoryPath=%LOCALAPPDATA%\Firefox Developer Edition /INI=%~dp0\firefox_install_options.ini"

echo installing/updating Executor...
call :winget MartinBresson.Executor --include-unknown

echo installing/updating MyPhoneExplorer...
call :winget fjsoft.MyPhoneExplorer

echo installing/updating git...
@REM references:
@REM - https://github.com/microsoft/winget-cli/discussions/3462
@REM - https://gitforwindows.org/silent-or-unattended-installation.html
call :winget Git.Git --custom "/VERYSILENT /NORESTART /NOCANCEL /LOADINF=%~dp0\git_install_options.ini"

echo installing/updating AutoHotkey...
@REM references:
@REM - https://www.autohotkey.com/docs/v2/Program.htm#install
@REM - https://www.autohotkey.com/docs/v2/Scripts.htm#ahk2exe-run
call :winget AutoHotkey.AutoHotkey --custom "/silent"
@REM custom installation of the ahk2exe compiler (based on default installation script, changed to make it more silent)
"%LOCALAPPDATA%\Programs\AutoHotkey\v2\AutoHotkey64.exe" "%~dp0\install-ahk2exe.ahk"

echo installing/updating iTunes
@REM references:
@REM - https://silentinstallhq.com/apple-itunes-silent-install-how-to-guide/
call :winget Apple.iTunes --custom "/qn ALLUSERS=1 DESKTOP_SHORTCUTS=0 REBOOT=ReallySuppress"

goto :EOF

:winget
winget install --accept-package-agreements --accept-source-agreements --source winget --silent --exact --id %*
goto :EOF
