#Requires -Version 5.0

$PATH_TO_THIS_REPO = $PSScriptRoot

function mklink {
	param (
		$link,
		$target
	)

	# New-Item -Path "..." -ItemType SymbolicLink -Value "..." # requires admin privileges
	cmd /c mklink "$link" "$target" >$null
}

function mklinkd {
	param (
		$link,
		$target
	)

	# New-Item -Path "..." -ItemType SymbolicLink -Value "..." # requires admin privileges
	cmd /c mklink /D "$link" "$target" >$null
}

# alacritty
function Invoke-alacritty {
	Write-Host -NoNewline "$(Get-Date -Format "HH:mm:ss")   - alacritty... "
	if (Test-Path "$env:APPDATA\alacritty") { Remove-Item -LiteralPath "$env:APPDATA\alacritty" -Force -Recurse }
	mklinkd "$env:APPDATA\alacritty" "$PATH_TO_THIS_REPO\alacritty"
	Write-Host "done"
}

# autohotkey: compile my-autohotkeys.ahk to executable into the startup folder
function Invoke-autohotkey {
	Write-Host -NoNewline "$(Get-Date -Format "HH:mm:ss")   - autohotkey... "
	if (Test-Path "$env:LOCALAPPDATA\Programs\AutoHotkey\Compiler\Ahk2Exe.exe") {
		Write-Host -NoNewline 'compiling my-autohotkeys (if prompted, choose to UNLOAD)... '
		Stop-Process -Name 'my-autohotkeys' -Force -ErrorAction SilentlyContinue
		# TODO: find a way to automatically reload recompiled my-autohotkeys.exe, then restore the "/silent" option
		Start-Process -NoNewWindow -Wait -FilePath "$env:LOCALAPPDATA\Programs\AutoHotkey\Compiler\Ahk2Exe.exe" -ArgumentList `
			"/in `"$env:PATH_TO_THIS_REPO\autohotkey\my-autohotkeys.ahk`"", `
			"/out `"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\my-autohotkeys.exe`"", `
			"/base `"$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe`"", `
			'/silent'
		# cmd /c "$env:LOCALAPPDATA\Programs\AutoHotkey\Compiler\Ahk2Exe.exe" `
		# 	/in "$env:PATH_TO_THIS_REPO\autohotkey\my-autohotkeys.ahk" `
		# 	/out "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\my-autohotkeys.exe" `
		# 	/base "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe"
		# TODO: remove following command when reloading recompiled my-autohotkeys.exe will work...
		Start-Process -NoNewWindow -FilePath "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\my-autohotkeys.exe"
	}
	Write-Host "done"
}

# capsicain
function Invoke-capsicain {
	Write-Host -NoNewline "$(Get-Date -Format "HH:mm:ss")   - capsicain... "
	if (Test-Path "C:\bin\capsicain\capsicain.ini") { Remove-Item "C:\bin\capsicain\capsicain.ini" -Force }
	if (Test-Path "C:\bin\capsicain") {
		mklink "C:\bin\capsicain\capsicain.ini" "$PATH_TO_THIS_REPO\capsicain\capsicain.ini"
	}
	Write-Host "done"
}

# Write-Output "$(Get-Date -Format "HH:mm:ss") applying default configurations..."

Invoke-alacritty
Invoke-autohotkey
Invoke-capsicain

# Write-Output "$(Get-Date -Format "HH:mm:ss") configurations successfully applied"
