@echo off

@REM NOTE: PATH_TO_THIS_REPO ends with a backslash (the directory separator)!
set PATH_TO_THIS_REPO=%~dp0

@REM alacritty
if exist "%APPDATA%\alacritty" rd "%APPDATA%\alacritty"
mklink /D "%APPDATA%\alacritty" "%PATH_TO_THIS_REPO%\alacritty"

@REM autohotkey: compile my-autohotkeys.ahk to executable into the startup folder
if exist "%LOCALAPPDATA%\Programs\AutoHotkey\Compiler\Ahk2Exe.exe" (
	"%LOCALAPPDATA%\Programs\AutoHotkey\Compiler\Ahk2Exe.exe" /silent ^
		/in "%PATH_TO_THIS_REPO%\autohotkey\my-autohotkeys.ahk" ^
		/out "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\my-autohotkeys.exe" ^
		/base "%LOCALAPPDATA%\Programs\AutoHotkey\v2\AutoHotkey64.exe"
)

@REM capsicain
if exist C:\bin\capsicain\capsicain.ini del C:\bin\capsicain\capsicain.ini
if exist C:\bin\capsicain mklink C:\bin\capsicain\capsicain.ini "%PATH_TO_THIS_REPO%\capsicain\capsicain.ini"

@REM helix
if exist "%APPDATA%\helix" rd "%APPDATA%\helix"
mklink /D "%APPDATA%\helix" "%PATH_TO_THIS_REPO%\helix"

@REM git
powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -File "%PATH_TO_THIS_REPO%\apply-git.ps1" "%PATH_TO_THIS_REPO%\git\gitconfig"
if not exist "%USERPROFILE%\.config\git" mkdir "%USERPROFILE%\.config\git"
if exist "%USERPROFILE%\.config\git\git-prompt.sh" del "%USERPROFILE%\.config\git\git-prompt.sh"
mklink "%USERPROFILE%\.config\git\git-prompt.sh" "%PATH_TO_THIS_REPO%\git\git-prompt.sh"

@REM lazygit
if not exist "%APPDATA%\lazygit" mkdir "%APPDATA%\lazygit"
if exist "%APPDATA%\lazygit\config.yml" del "%APPDATA%\lazygit\config.yml"
mklink "%APPDATA%\lazygit\config.yml" "%PATH_TO_THIS_REPO%\lazygit\config.yml"

@REM neovim
if exist "%LOCALAPPDATA%\nvim" rd "%LOCALAPPDATA%\nvim"
mklink /D "%LOCALAPPDATA%\nvim" "%PATH_TO_THIS_REPO%\neovim"

@REM ruff
if not exist "%USERPROFILE%\.config" mkdir "%USERPROFILE%\.config"
if exist "%USERPROFILE%\.config\ruff.toml" del "%USERPROFILE%\.config\ruff.toml"
mklink "%USERPROFILE%\.config\ruff.toml" "%PATH_TO_THIS_REPO%\ruff\ruff.toml"

@REM vim
if exist "%USERPROFILE%\.vim\vimrc" del "%USERPROFILE%\.vim\vimrc"
if exist "%USERPROFILE%\.vim\colors" rd "%USERPROFILE%\.vim\colors"
if not exist "%USERPROFILE%\.vim" mkdir "%USERPROFILE%\.vim"
mklink "%USERPROFILE%\.vim\vimrc" "%PATH_TO_THIS_REPO%\vim\vimrc"
mklink /D "%USERPROFILE%\.vim\colors" "%PATH_TO_THIS_REPO%\vim\colors"
if not exist "%USERPROFILE%\.vim\pack\tpope\start" mkdir "%USERPROFILE%\.vim\pack\tpope\start"
if not exist "%USERPROFILE%\.vim\pack\tpope\start\vim-fugitive" git -C "%USERPROFILE%\.vim\pack\tpope\start" clone https://github.com/tpope/vim-fugitive
git -C "%USERPROFILE%\.vim\pack\tpope\start\vim-fugitive" pull

@REM vscodium
if exist "%APPDATA%\VSCodium\User\settings.json" del "%APPDATA%\VSCodium\User\settings.json"
if exist "%APPDATA%\VSCodium\User\keybindings.json" del "%APPDATA%\VSCodium\User\keybindings.json"
if not exist "%APPDATA%\VSCodium\User" mkdir "%APPDATA%\VSCodium\User
mklink "%APPDATA%\VSCodium\User\settings.json" "%PATH_TO_THIS_REPO%\vscodium\settings.json"
mklink "%APPDATA%\VSCodium\User\keybindings.json" "%PATH_TO_THIS_REPO%\vscodium\keybindings.json"

@REM yazi
if not exist "%APPDATA%\yazi" mkdir "%APPDATA%\yazi"
if exist "%APPDATA%\yazi\config" rd "%APPDATA%\yazi\config"
mklink /D "%APPDATA%\yazi\config" "%PATH_TO_THIS_REPO%\yazi"

@REM wezterm
if exist "%USERPROFILE%\.config\wezterm\wezterm.lua" del "%USERPROFILE%\.config\wezterm\wezterm.lua"
if not exist "%USERPROFILE%\.config\wezterm" mkdir "%USERPROFILE%\.config\wezterm"
mklink "%USERPROFILE%\.config\wezterm\wezterm.lua" "%PATH_TO_THIS_REPO%\wezterm\wezterm.lua"

@REM wt (windows terminal)
powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -File "%PATH_TO_THIS_REPO%\apply-wt.ps1" "%PATH_TO_THIS_REPO%\wt"

@REM zed
if exist "%APPDATA%\Zed\snippets" rd "%APPDATA%\Zed\snippets"
if exist "%APPDATA%\Zed\settings.json" del "%APPDATA%\Zed\settings.json"
if exist "%APPDATA%\Zed\keymap.json" del "%APPDATA%\Zed\keymap.json"
if not exist "%APPDATA%\Zed" mkdir "%APPDATA%\Zed"
mklink /D "%APPDATA%\Zed\snippets" "%PATH_TO_THIS_REPO%\zed\snippets"
mklink "%APPDATA%\Zed\settings.json" "%PATH_TO_THIS_REPO%\zed\settings.json"
mklink "%APPDATA%\Zed\keymap.json" "%PATH_TO_THIS_REPO%\zed\keymap.json"
