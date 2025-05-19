@echo off

set PATH_TO_THIS_REPO=%~dp0

@rem alacritty
if exist "%APPDATA%\alacritty" rd "%APPDATA%\alacritty"
mklink /D "%APPDATA%\alacritty" "%PATH_TO_THIS_REPO%\alacritty"

@rem vim
if exist "%USERPROFILE%\.vim\vimrc" del "%USERPROFILE%\.vim\vimrc"
if exist "%USERPROFILE%\.vim\colors" rd "%USERPROFILE%\.vim\colors"
if not exist "%USERPROFILE%\.vim" mkdir "%USERPROFILE%\.vim"
mklink "%USERPROFILE%\.vim\vimrc" "%PATH_TO_THIS_REPO%\vim\vimrc"
mklink /D "%USERPROFILE%\.vim\colors" "%PATH_TO_THIS_REPO%\vim\colors"

@rem wezterm
if exist "%USERPROFILE%\.config\wezterm\wezterm.lua" del "%USERPROFILE%\.config\wezterm\wezterm.lua"
if not exist "%USERPROFILE%\.config\wezterm" md "%USERPROFILE%\.config\wezterm"
mklink "%USERPROFILE%\.config\wezterm\wezterm.lua" "%PATH_TO_THIS_REPO%\wezterm\wezterm.lua"
