@echo off

setlocal enabledelayedexpansion

@REM NOTE: PATH_TO_THIS_REPO ends with a backslash (the directory separator)!
set "PATH_TO_THIS_REPO=%~dp0"

call :set_HH_MM_SS
echo %HH%:%MM%:%SS% applying default configurations...

if "%1"=="" (
	@REM call :alacritty
	@REM call :autohotkey
	@REM call :capsicain
	powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -File "%PATH_TO_THIS_REPO%\apply.ps1"
	call :cmder
	call :helix
	call :git
	call :lazygit
	call :neovim
	call :ruff
	call :sublime_merge
	call :tabby
	call :vim
	call :vscodium
	call :yazi
	call :waveterm
	call :wezterm
	call :windows
	call :winmerge
	call :wt
	call :zed
) else (
	call :%1
)

call :set_HH_MM_SS
echo %HH%:%MM%:%SS% configurations successfully applied

goto :EOF


@REM @REM alacritty
@REM :alacritty
@REM call :set_HH_MM_SS
@REM echo|set /p _="%HH%:%MM%:%SS%   - alacritty... "
@REM if exist "%APPDATA%\alacritty" rd "%APPDATA%\alacritty"
@REM mklink /D "%APPDATA%\alacritty" "%PATH_TO_THIS_REPO%\alacritty" >NUL
@REM echo done
@REM goto :EOF

@REM @REM autohotkey: compile my-autohotkeys.ahk to executable into the startup folder
@REM :autohotkey
@REM call :set_HH_MM_SS
@REM echo|set /p _="%HH%:%MM%:%SS%   - autohotkey... "
@REM if exist "%LOCALAPPDATA%\Programs\AutoHotkey\Compiler\Ahk2Exe.exe" (
@REM 	echo|set /p _="compiling my-autohotkeys (if prompted, choose to UNLOAD)... "
@REM 	@REM TODO: find a way to automatically reload recompiled my-autohotkeys.exe, then restore the "/silent" option
@REM 	"%LOCALAPPDATA%\Programs\AutoHotkey\Compiler\Ahk2Exe.exe" ^
@REM 		/in "%PATH_TO_THIS_REPO%\autohotkey\my-autohotkeys.ahk" ^
@REM 		/out "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\my-autohotkeys.exe" ^
@REM 		/base "%LOCALAPPDATA%\Programs\AutoHotkey\v2\AutoHotkey64.exe"
@REM 	@REM TODO: remove following command when reloading recompiled my-autohotkeys.exe will work...
@REM 	start "" "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\my-autohotkeys.exe"
@REM )
@REM echo done
@REM goto :EOF

@REM @REM capsicain
@REM :capsicain
@REM call :set_HH_MM_SS
@REM echo|set /p _="%HH%:%MM%:%SS%   - capsicain... "
@REM if exist C:\bin\capsicain\capsicain.ini del C:\bin\capsicain\capsicain.ini
@REM if exist C:\bin\capsicain mklink C:\bin\capsicain\capsicain.ini "%PATH_TO_THIS_REPO%\capsicain\capsicain.ini" >NUL
@REM echo done
@REM goto :EOF

@REM cmder
:cmder
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - cmder... "
powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -File "%PATH_TO_THIS_REPO%\apply-cmder.ps1" "%PATH_TO_THIS_REPO%\cmder" "%PATH_TO_THIS_REPO%"
echo done
goto :EOF

@REM helix
:helix
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - helix... "
if exist "%APPDATA%\helix" rd "%APPDATA%\helix"
mklink /D "%APPDATA%\helix" "%PATH_TO_THIS_REPO%\helix" >NUL
echo done
goto :EOF

@REM git
:git
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - git... "
powershell -ExecutionPolicy Bypass -NoLogo -NoProfile -File "%PATH_TO_THIS_REPO%\apply-git.ps1" "%PATH_TO_THIS_REPO%\git\gitconfig"
if not exist "%USERPROFILE%\.config\git" mkdir "%USERPROFILE%\.config\git"
if exist "%USERPROFILE%\.config\git\git-prompt.sh" del "%USERPROFILE%\.config\git\git-prompt.sh"
mklink "%USERPROFILE%\.config\git\git-prompt.sh" "%PATH_TO_THIS_REPO%\git\git-prompt.sh" >NUL
echo done
goto :EOF

@REM lazygit
:lazygit
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - lazygit... "
if not exist "%APPDATA%\lazygit" mkdir "%APPDATA%\lazygit"
if exist "%APPDATA%\lazygit\config.yml" del "%APPDATA%\lazygit\config.yml"
mklink "%APPDATA%\lazygit\config.yml" "%PATH_TO_THIS_REPO%\lazygit\config.yml" >NUL
echo done
goto :EOF

@REM neovim
:neovim
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - neovim... "
if exist "%LOCALAPPDATA%\nvim" rd "%LOCALAPPDATA%\nvim"
mklink /D "%LOCALAPPDATA%\nvim" "%PATH_TO_THIS_REPO%\neovim" >NUL
echo done
goto :EOF

@REM ruff
:ruff
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - ruff... "
if not exist "%USERPROFILE%\.config" mkdir "%USERPROFILE%\.config"
if exist "%USERPROFILE%\.config\ruff.toml" del "%USERPROFILE%\.config\ruff.toml"
mklink "%USERPROFILE%\.config\ruff.toml" "%PATH_TO_THIS_REPO%\ruff\ruff.toml" >NUL
echo done
goto :EOF

@REM sublime merge
:sublime_merge
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - sublime merge... "
set "WINGET_ID=SublimeHQ.SublimeMerge_Microsoft.Winget.Source_8wekyb3d8bbwe"
set "PARENTS=%APPDATA%\Sublime Merge\Packages;%LOCALAPPDATA%\Microsoft\WinGet\Packages\%WINGET_ID%\Data\Packages"
for %%P in ("%PARENTS:;=" "%") do (
    set "CURRENT_PARENT=%%~P"
    if not exist "!CURRENT_PARENT!" mkdir "!CURRENT_PARENT!"
    if exist "!CURRENT_PARENT!\User" rd /s /q "!CURRENT_PARENT!\User"
    mklink /D "!CURRENT_PARENT!\User" "%PATH_TO_THIS_REPO%\sublime_merge" >NUL
)
echo done
goto :EOF

@REM tabby
:tabby
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - tabby... "
if exist "%APPDATA%\tabby\config.yaml" del "%APPDATA%\tabby\config.yaml"
mklink "%APPDATA%\tabby\config.yaml" "%PATH_TO_THIS_REPO%\tabby\config.yaml" >NUL
echo done
goto :EOF

@REM vim
:vim
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - vim... "
if exist "%USERPROFILE%\.vim\vimrc" del "%USERPROFILE%\.vim\vimrc"
if exist "%USERPROFILE%\.vim\colors" rd "%USERPROFILE%\.vim\colors"
if not exist "%USERPROFILE%\.vim" mkdir "%USERPROFILE%\.vim"
mklink "%USERPROFILE%\.vim\vimrc" "%PATH_TO_THIS_REPO%\vim\vimrc" >NUL
mklink /D "%USERPROFILE%\.vim\colors" "%PATH_TO_THIS_REPO%\vim\colors" >NUL
if not exist "%USERPROFILE%\.vim\pack\tpope\start" mkdir "%USERPROFILE%\.vim\pack\tpope\start"
if not exist "%USERPROFILE%\.vim\pack\tpope\start\vim-fugitive" git -C "%USERPROFILE%\.vim\pack\tpope\start" clone https://github.com/tpope/vim-fugitive >NUL
git -C "%USERPROFILE%\.vim\pack\tpope\start\vim-fugitive" pull >NUL
echo done
goto :EOF

@REM vscodium
:vscodium
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - vscodium... "
if exist "%APPDATA%\VSCodium\User\settings.json" del "%APPDATA%\VSCodium\User\settings.json"
if exist "%APPDATA%\VSCodium\User\keybindings.json" del "%APPDATA%\VSCodium\User\keybindings.json"
if not exist "%APPDATA%\VSCodium\User" mkdir "%APPDATA%\VSCodium\User
mklink "%APPDATA%\VSCodium\User\settings.json" "%PATH_TO_THIS_REPO%\vscodium\settings.json" >NUL
mklink "%APPDATA%\VSCodium\User\keybindings.json" "%PATH_TO_THIS_REPO%\vscodium\keybindings.json" >NUL
echo done
goto :EOF

@REM yazi
:yazi
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - yazi... "
if not exist "%APPDATA%\yazi" mkdir "%APPDATA%\yazi"
if exist "%APPDATA%\yazi\config" rd "%APPDATA%\yazi\config"
mklink /D "%APPDATA%\yazi\config" "%PATH_TO_THIS_REPO%\yazi" >NUL
echo done
goto :EOF

@REM waveterm
:waveterm
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - wave terminal... "
if not exist "%USERPROFILE%\.config\waveterm" mkdir "%USERPROFILE%\.config\waveterm"
if exist "%USERPROFILE%\.config\waveterm\settings.json" del "%USERPROFILE%\.config\waveterm\settings.json"
mklink "%USERPROFILE%\.config\waveterm\settings.json" "%PATH_TO_THIS_REPO%\waveterm\settings.json" >NUL
echo done
goto :EOF

@REM wezterm
:wezterm
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - wezterm... "
if not exist "%USERPROFILE%\.config\wezterm" mkdir "%USERPROFILE%\.config\wezterm"
if exist "%USERPROFILE%\.config\wezterm\wezterm.lua" del "%USERPROFILE%\.config\wezterm\wezterm.lua"
mklink "%USERPROFILE%\.config\wezterm\wezterm.lua" "%PATH_TO_THIS_REPO%\wezterm\wezterm.lua" >NUL
echo done
goto :EOF

@REM windows
:windows
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - windows... "
reg import "%PATH_TO_THIS_REPO%\windows\10-prefs.reg" 2>NUL
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
echo done
goto :EOF

@REM winmerge
:winmerge
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - winmerge... "
reg import "%PATH_TO_THIS_REPO%\winmerge\settings.reg" 2>NUL
echo done
goto :EOF

@REM wt (windows terminal)
:wt
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - wt (Windows Terminal)... "
powershell -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -File "%PATH_TO_THIS_REPO%\apply-wt.ps1" "%PATH_TO_THIS_REPO%\wt"
echo done
goto :EOF

@REM zed
:zed
call :set_HH_MM_SS
echo|set /p _="%HH%:%MM%:%SS%   - zed... "
if exist "%APPDATA%\Zed\snippets" rd "%APPDATA%\Zed\snippets"
if exist "%APPDATA%\Zed\settings.json" del "%APPDATA%\Zed\settings.json"
if exist "%APPDATA%\Zed\keymap.json" del "%APPDATA%\Zed\keymap.json"
if not exist "%APPDATA%\Zed" mkdir "%APPDATA%\Zed"
mklink /D "%APPDATA%\Zed\snippets" "%PATH_TO_THIS_REPO%\zed\snippets" >NUL
mklink "%APPDATA%\Zed\settings.json" "%PATH_TO_THIS_REPO%\zed\settings.json" >NUL
mklink "%APPDATA%\Zed\keymap.json" "%PATH_TO_THIS_REPO%\zed\keymap.json" >NUL
echo done
goto :EOF

:set_HH_MM_SS
set HH=%TIME:~0,2%
if "%HH:~0,1%" == " " set HH=0%HH:~1,1%
set MM=%TIME:~3,2%
set SS=%TIME:~6,2%
goto :EOF
