; adapted from default "%LOCALAPPDATA%\Programs\AutoHotkey\UX\install-ahk2exe.ahk"
; references:
;   - https://www.autohotkey.com/docs/v2/Variables.htm#OSVersion
;   - https://www.autohotkey.com/docs/v2/Scripts.htm#ahk2exe-run

; Run this script download and install Ahk2Exe into A_ScriptDir '\..\Compiler'.
#requires AutoHotkey v2.0

#include "%A_AppData%\..\Local\Programs\AutoHotkey\UX\install.ahk"
#include "%A_AppData%\..\Local\Programs\AutoHotkey\UX\inc\GetGitHubReleaseAssetURL.ahk"

#SingleInstance Force
InstallAhk2Exe

InstallAhk2Exe() {
    inst := Installation()
    inst.ResolveInstallDir()  ; This sets inst.InstallDir and inst.UserInstall

    finalPath := inst.InstallDir '\Compiler\Ahk2Exe.exe'
    if FileExist(finalPath) {
        ExitApp
    }

    tempDir := A_ScriptDir '\.staging' ; Avoid A_Temp for security reasons
    DirCreate tempDir
    SetWorkingDir tempDir

    ; TrayTip "Downloading Ahk2Exe", "AutoHotkey"
    url := GetGitHubReleaseAssetURL('AutoHotkey/Ahk2Exe')
    Download url, 'Ahk2Exe.zip'

    ; TrayTip "Installing Ahk2Exe", "AutoHotkey"
    DirCopy 'Ahk2Exe.zip', 'Compiler', true
    FileDelete 'Ahk2Exe.zip'

    inst.AddCompiler(tempDir '\Compiler')
    inst.Apply()

    ; Working dir may have been changed
    DirDelete tempDir '\Compiler', true
    DirDelete tempDir

    ; TrayTip "Ahk2Exe has been installed", "AutoHotkey"
}
