@echo off

winget install --source winget --exact --id DominikReichl.KeePass
winget install --source winget --exact --id Mozilla.Firefox.it
winget install --source winget --exact --id MartinBresson.Executor --include-unknown
winget install --source winget --exact --id fjsoft.MyPhoneExplorer

@REM references:
@REM - https://github.com/microsoft/winget-cli/discussions/3462
@REM - https://gitforwindows.org/silent-or-unattended-installation.html
winget install --accept-source-agreements --accept-package-agreements --source winget --exact --id Git.Git --custom "/VERYSILENT /NORESTART /NOCANCEL /LOADINF=git_install_options.ini"
