@echo off

@rem NOTE: PATH_TO_THIS_REPO ends with a back-slash (ie: directory separator)!
set PATH_TO_THIS_REPO=%~dp0

@rem alacritty
if exist "%APPDATA%\alacritty" rd "%APPDATA%\alacritty"
mklink /D "%APPDATA%\alacritty" "%PATH_TO_THIS_REPO%\alacritty"

@rem capsicain
if exist C:\bin\capsicain\capsicain.ini del C:\bin\capsicain\capsicain.ini
mklink C:\bin\capsicain\capsicain.ini "%PATH_TO_THIS_REPO%\capsicain\capsicain.ini"

@rem helix
if exist "%APPDATA%\helix" rd "%APPDATA%\helix"
mklink /D "%APPDATA%\helix" "%PATH_TO_THIS_REPO%\helix"

@rem lazygit
if not exist "%APPDATA%\lazygit" md "%APPDATA%\lazygit"
if exist "%APPDATA%\lazygit\config.yml" del "%APPDATA%\lazygit\config.yml"
mklink "%APPDATA%\lazygit\config.yml" "%PATH_TO_THIS_REPO%\lazygit\config.yml"

@rem vim
if exist "%USERPROFILE%\.vim\vimrc" del "%USERPROFILE%\.vim\vimrc"
if exist "%USERPROFILE%\.vim\colors" rd "%USERPROFILE%\.vim\colors"
if not exist "%USERPROFILE%\.vim" mkdir "%USERPROFILE%\.vim"
mklink "%USERPROFILE%\.vim\vimrc" "%PATH_TO_THIS_REPO%\vim\vimrc"
mklink /D "%USERPROFILE%\.vim\colors" "%PATH_TO_THIS_REPO%\vim\colors"

@rem yazi
if not exist "%APPDATA%\yazi" mkdir "%APPDATA%\yazi"
if exist "%APPDATA%\yazi\config" rd "%APPDATA%\yazi\config"
mklink /D "%APPDATA%\yazi\config" "%PATH_TO_THIS_REPO%\yazi"

@rem wezterm
if exist "%USERPROFILE%\.config\wezterm\wezterm.lua" del "%USERPROFILE%\.config\wezterm\wezterm.lua"
if not exist "%USERPROFILE%\.config\wezterm" md "%USERPROFILE%\.config\wezterm"
mklink "%USERPROFILE%\.config\wezterm\wezterm.lua" "%PATH_TO_THIS_REPO%\wezterm\wezterm.lua"
