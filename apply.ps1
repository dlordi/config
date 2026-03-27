<#
@powershell -Command "Start-Process powershell -ArgumentList '-NoProfile -NoLogo -ExecutionPolicy Bypass -File \"%~dp0apply.ps1\" %*' -Verb RunAs" || pause
@powershell -NoProfile -NoLogo -ExecutionPolicy Bypass -File "%~dp0apply.ps1" %* || pause
#>

#Requires -Version 5.0

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error 'Administrative privileges required. Please run as Administrator.'
    exit 1
    # Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Wait -Verb RunAs
    # exit
}

$PATH_TO_THIS_REPO = "$PSScriptRoot"

function Get-Timestamp { return (Get-Date -Format 'HH:mm:ss') }

function Invoke-Symlink {
    param(
        [Parameter(Mandatory = $true)] [string]$target,
        [Parameter(Mandatory = $true)] [string]$symlink
    )

    try {
        if (Test-Path $symlink) { Remove-Item -Path $symlink -Recurse -Force -ErrorAction Stop }

        # $flag = if (Test-Path $target -PathType Container) { '/D' } else { '' }
        # cmd /c mklink $flag "$symlink" "$target" >$null

        New-Item -ItemType SymbolicLink -Path $symlink -Target $target -Force -ErrorAction Stop | Out-Null
    } catch {
        Write-Host "ERRORE: unable to create symlink $symlink" # -ForegroundColor Red
    }
}

function Invoke-Shortcut {
    param(
        [Parameter(Mandatory = $true)] [string]$target,
        [Parameter(Mandatory = $true)] [string]$lnkfile
    )

    $wshShell = New-Object -COMObject WScript.Shell
    $shortcut = $wshShell.CreateShortcut($lnkfile)
    $shortcut.TargetPath = $target
    $shortcut.Save()
}

# https://stackoverflow.com/questions/56322993/proper-formating-of-json-using-powershell/56324247#56324247
function Format-Json {
    <#
    .SYNOPSIS
        Prettifies JSON output.
    .DESCRIPTION
        Reformats a JSON string so the output looks better than what ConvertTo-Json outputs.
    .PARAMETER Json
        Required: [string] The JSON text to prettify.
    .PARAMETER Minify
        Optional: Returns the json string compressed.
    .PARAMETER Indentation
        Optional: The number of spaces (1..1024) to use for indentation. Defaults to 4.
    .PARAMETER AsArray
        Optional: If set, the output will be in the form of a string array, otherwise a single string is output.
    .EXAMPLE
        $json | ConvertTo-Json  | Format-Json -Indentation 2
    #>
    [CmdletBinding(DefaultParameterSetName = 'Prettify')]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$Json,

        [Parameter(ParameterSetName = 'Minify')]
        [switch]$Minify,

        [Parameter(ParameterSetName = 'Prettify')]
        [ValidateRange(1, 1024)]
        [int]$Indentation = 4,

        [Parameter(ParameterSetName = 'Prettify')]
        [switch]$AsArray
    )

    if ($PSCmdlet.ParameterSetName -eq 'Minify') {
        return ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100 -Compress
    }

    # If the input JSON text has been created with ConvertTo-Json -Compress
    # then we first need to reconvert it without compression
    if ($Json -notmatch '\r?\n') {
        $Json = ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100
    }

    $indent = 0
    $regexUnlessQuoted = '(?=([^"]*"[^"]*")*[^"]*$)'

    $result = $Json -split '\r?\n' | ForEach-Object {
        # If the line contains a ] or } character, 
        # we need to decrement the indentation level, unless:
        #   - it is inside quotes, AND
        #   - it does not contain a [ or {
        if (($_ -match "[}\]]$regexUnlessQuoted") -and ($_ -notmatch "[\{\[]$regexUnlessQuoted")) {
            $indent = [Math]::Max($indent - $Indentation, 0)
        }

        # Replace all colon-space combinations by ": " unless it is inside quotes.
        $line = (' ' * $indent) + ($_.TrimStart() -replace ":\s+$regexUnlessQuoted", ': ')

        # If the line contains a [ or { character, 
        # we need to increment the indentation level, unless:
        #   - it is inside quotes, AND
        #   - it does not contain a ] or }
        if (($_ -match "[\{\[]$regexUnlessQuoted") -and ($_ -notmatch "[}\]]$regexUnlessQuoted")) {
            $indent += $Indentation
        }

        $line
    }

    if ($AsArray) { return $result }
    return $result -Join [Environment]::NewLine
}

function Set-MemberRecursively {
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [object]$TargetObject,

        [Parameter(Mandatory = $true)]
        [object]$Values
    )

    $Values.PSObject.Properties | ForEach-Object {
        $type = $_.TypeNameOfValue
        $name = $_.Name
        $value = $_.Value
        if (Get-Member -InputObject $TargetObject -Name $name) {
            switch ($type) {
                "System.String" {
                    $TargetObject.PSObject.Properties[$name].Value = $value
                }
                "System.Boolean" {
                    $TargetObject.PSObject.Properties[$name].Value = $value
                }
                "System.Int32" {
                    $TargetObject.PSObject.Properties[$name].Value = $value
                }
                "System.Management.Automation.PSCustomObject" {
                    Set-MemberRecursively `
                        -TargetObject $TargetObject.PSObject.Properties[$name].Value `
                        -Values $value
                }
                default {
                    Write-Error "cannot set `"$name`": unknown type `"$type`""
                }
            }
        } else {
            Add-Member -InputObject $TargetObject -Name $name -Value $value -MemberType NoteProperty
        }
    }
}

function Invoke-alacritty {
    Write-Host -NoNewline "$(Get-Timestamp)   - alacritty... "

    Invoke-Symlink -target "$PATH_TO_THIS_REPO\alacritty" -symlink "$env:APPDATA\alacritty"

    Write-Host 'done'
}

function Invoke-autohotkey {
    Write-Host -NoNewline "$(Get-Timestamp)   - autohotkey... "

    if (Test-Path "$env:LOCALAPPDATA\Programs\AutoHotkey\Compiler\Ahk2Exe.exe") {
        $my_autohotkeys = 'my-autohotkeys'
        Write-Host -NoNewline "compiling $my_autohotkeys (if prompted, choose to UNLOAD)... "
        Stop-Process -Name $my_autohotkeys -Force -ErrorAction SilentlyContinue
        Start-Process -NoNewWindow -Wait -FilePath "$env:LOCALAPPDATA\Programs\AutoHotkey\Compiler\Ahk2Exe.exe" -ArgumentList `
            "/in `"$env:PATH_TO_THIS_REPO\autohotkey\$my_autohotkeys.ahk`"", `
            "/out `"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\$my_autohotkeys.exe`"", `
            "/base `"$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe`"", `
            '/silent'
        # cmd /c "$env:LOCALAPPDATA\Programs\AutoHotkey\Compiler\Ahk2Exe.exe" `
        # 	/in "$env:PATH_TO_THIS_REPO\autohotkey\my-autohotkeys.ahk" `
        # 	/out "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\my-autohotkeys.exe" `
        # 	/base "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe" `
        # 	/silent
        # TODO: remove following command when reloading recompiled my-autohotkeys.exe will work...
        Start-Process -NoNewWindow -FilePath "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\$my_autohotkeys.exe"
    }

    Write-Host 'done'
}

function Invoke-capsicain {
    $home_dir = 'C:\bin\capsicain'
    if (-not (Test-Path $home_dir)) { return }

    Write-Host -NoNewline "$(Get-Timestamp)   - capsicain... "

    Invoke-Symlink -target "$PATH_TO_THIS_REPO\capsicain\capsicain.ini" -symlink "$home_dir\capsicain.ini"

    Write-Host 'done'
}

function Invoke-cmder {
    $home_dir = "$env:CMDER_ROOT"
    if ([string]::IsNullOrEmpty($home_dir)) { return }
    if (-not (Test-Path $home_dir)) { return }

    Write-Host -NoNewline "$(Get-Timestamp)   - cmder... "

    $standard_cmder_path = "$PATH_TO_THIS_REPO\cmder"
    $config_repo_path = "$PATH_TO_THIS_REPO"

    # prepare config_repo_path to be used in cmd file
    $config_repo_path = $config_repo_path.TrimStart('"')
    $config_repo_path = $config_repo_path.TrimEnd('"')
    $config_repo_path = $config_repo_path.TrimEnd('\')
    if ($config_repo_path.StartsWith($env:USERPROFILE)) {
        $config_repo_path = $config_repo_path.Replace($env:USERPROFILE, '%USERPROFILE%')
    }

    $user_aliases_path = "$home_dir\config\user_aliases.cmd"
    $custom_user_aliases_path = "$standard_cmder_path\user_aliases.cmd"

    $begin_marker = ';= rem begin custom aliases (THIS SECTION IS AUTO GENERATED: ANY CHANGE TO IT COULD BE LOST)'
    $end_marker = ';= rem end custom aliases'

    $utf8 = New-Object System.Text.UTF8Encoding $false

    $lines = @()
    $flag_keep_line = $true
    foreach ($line in [System.IO.File]::ReadLines($user_aliases_path, $utf8)) {
        if ($line -eq $begin_marker) {
            $flag_keep_line = $false
            continue
        }
        if ($line -eq $end_marker) {
            $flag_keep_line = $true
            continue
        }
        if ($flag_keep_line) {
            $lines += $line
        }
    }

    $lines += $begin_marker
    foreach ($line in [System.IO.File]::ReadLines($custom_user_aliases_path, $utf8)) {
        if ($line.StartsWith(';= rem')) {
            continue
        }
        $lines += $line.Replace('%MY_CONFIG_REPO%', $config_repo_path)
    }
    $lines += $end_marker
    [System.IO.File]::WriteAllLines($user_aliases_path, $lines, $utf8)

    Write-Host 'done'
}

function Invoke-helix {
    Write-Host -NoNewline "$(Get-Timestamp)   - helix... "

    Invoke-Symlink -target "$PATH_TO_THIS_REPO\helix" -symlink "$env:APPDATA\helix"

    Write-Host 'done'
}

function Invoke-git {
    Write-Host -NoNewline "$(Get-Timestamp)   - git... "

    $standard_gitconfig_path = "$PATH_TO_THIS_REPO\git\gitconfig"

    $git_user_name = ''
    $git_user_email = ''

    $gitconfig_path = "$env:USERPROFILE\.gitconfig"
    if (Test-Path -PathType Leaf $gitconfig_path) {
        # ini parsing is heavly based on https://stackoverflow.com/questions/417798/ini-file-parsing-in-powershell
        $gitconfig = @{}
        switch -regex -file $gitconfig_path {
            '^\[(.+)\]$' {
                $section = $matches[1].Trim()
                $gitconfig[$section] = @{}
            }
            '^\s*([^#].+?)\s*=\s*(.*)' {
                $name, $value = $matches[1..2]
                if (!($name.StartsWith('#'))) {
                    $gitconfig[$section][$name] = $value.Trim()
                }
            }
        }
        if ($gitconfig.ContainsKey('user')) {
            if ($gitconfig['user'].ContainsKey('name')) {
                $git_user_name = $gitconfig['user']['name']
            }
            if ($gitconfig['user'].ContainsKey('email')) {
                $git_user_email = $gitconfig['user']['email']
            }
        }
    }
    $indent = '             '
    $flag_add_new_line = $true
    while (-not $git_user_name) {
        if ($flag_add_new_line) {
            Write-Output ''
            $flag_add_new_line = $false
        }
        $git_user_name = Read-Host "$($indent)enter user name"
        if (-not $git_user_name) {
            Write-Output "$($indent)invalid name, try again!"
        }
    }
    while (-not $git_user_email.Contains('@')) {
        if ($flag_add_new_line) {
            Write-Output ''
            $flag_add_new_line = $false
        }
        $git_user_email = Read-Host "$($indent)enter user email"
        if (-not $git_user_email.Contains('@')) {
            Write-Output "$($indent)invalid email, try again!"
        }
    }

    $utf8 = New-Object System.Text.UTF8Encoding $false
    [System.IO.File]::WriteAllText($gitconfig_path, @"
# THIS FILE IS AUTO GENERATED: ANY CHANGE TO IT COULD BE LOST

[user]
	name = $git_user_name
	email = $git_user_email

# BEGIN standard git config
$([System.IO.File]::ReadAllText($standard_gitconfig_path))
# END standard git config
"@, $utf8)

    $home_dir = "$env:USERPROFILE\.config\git"
    if (-not (Test-Path $home_dir)) { New-Item -ItemType Directory -Path $home_dir -Force | Out-Null }
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\git\git-prompt.sh" -symlink "$home_dir\git-prompt.sh"

    Write-Host 'done'
}

function Invoke-lazygit {
    Write-Host -NoNewline "$(Get-Timestamp)   - lazygit... "

    $home_dir = "$env:APPDATA\lazygit"
    if (-not (Test-Path $home_dir)) { New-Item -ItemType Directory -Path $home_dir -Force | Out-Null }
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\lazygit\config.yml" -symlink "$home_dir\config.yml"

    Write-Host 'done'
}

function Invoke-neovim {
    Write-Host -NoNewline "$(Get-Timestamp)   - neovim... "

    Invoke-Symlink -target "$PATH_TO_THIS_REPO\neovim" -symlink "$env:LOCALAPPDATA\nvim"

    Write-Host 'done'
}

function Invoke-ruff {
    Write-Host -NoNewline "$(Get-Timestamp)   - ruff... "

    $home_dir = "$env:USERPROFILE\.config"
    if (-not (Test-Path $home_dir)) { New-Item -ItemType Directory -Path $home_dir -Force | Out-Null }
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\ruff\ruff.toml" -symlink "$home_dir\ruff.toml"

    Write-Host 'done'
}

function Invoke-sublime_merge {
    Write-Host -NoNewline "$(Get-Timestamp)   - sublime merge... "

    $WINGET_ID = 'SublimeHQ.SublimeMerge_Microsoft.Winget.Source_8wekyb3d8bbwe'
    $parents = @(
        "$env:APPDATA\Sublime Merge\Packages",
        "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\$WINGET_ID\Data\Packages"
    )
    foreach ($parent in $parents) {
        if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        Invoke-Symlink -target "$PATH_TO_THIS_REPO\sublime_merge" -symlink "$parent\User"
    }

    Write-Host 'done'
}

function Invoke-tabby {
    Write-Host -NoNewline "$(Get-Timestamp)   - tabby... "

    Invoke-Symlink -target "$PATH_TO_THIS_REPO\tabby\config.yaml" -symlink "$env:APPDATA\tabby\config.yaml"

    Write-Host 'done'
}

function Invoke-vim {
    Write-Host -NoNewline "$(Get-Timestamp)   - vim... "

    $home_dir = "$env:USERPROFILE\.vim"
    if (-not (Test-Path $home_dir)) { New-Item -ItemType Directory -Path $home_dir -Force | Out-Null }
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\vim\vimrc" -symlink "$home_dir\vimrc"
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\vim\colors" -symlink "$home_dir\colors"
    if (-not (Test-Path "$home_dir\pack\tpope\start")) {
        New-Item -ItemType Directory -Path "$home_dir\pack\tpope\start" -Force | Out-Null
    }
    Write-Host -NoNewline 'install/update fugitive plugin... '
    if (-not (Test-Path "$home_dir\pack\tpope\start\vim-fugitive")) {
        git -C "$home_dir\pack\tpope\start" clone https://github.com/tpope/vim-fugitive >$null
    }
    git -C "$home_dir\pack\tpope\start\vim-fugitive" pull >$null

    Write-Host 'done'
}

function Invoke-vscodium {
    Write-Host -NoNewline "$(Get-Timestamp)   - vscodium... "

    $home_dir = "$env:APPDATA\VSCodium\User"
    if (-not (Test-Path $home_dir)) { New-Item -ItemType Directory -Path $home_dir -Force | Out-Null }
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\vscodium\settings.json" -symlink "$home_dir\settings.json"
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\vscodium\keybindings.json" -symlink "$home_dir\keybindings.json"

    Write-Host 'done'
}

function Invoke-yazi {
    Write-Host -NoNewline "$(Get-Timestamp)   - yazi... "

    $home_dir = "$env:APPDATA\yazi"
    if (-not (Test-Path $home_dir)) { New-Item -ItemType Directory -Path $home_dir -Force | Out-Null }
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\yazi" -symlink "$home_dir\config"

    Write-Host 'done'
}

function Invoke-waveterm {
    Write-Host -NoNewline "$(Get-Timestamp)   - waveterm... "

    $home_dir = "$env:APPDATA\.config\waveterm"
    if (-not (Test-Path $home_dir)) { New-Item -ItemType Directory -Path $home_dir -Force | Out-Null }
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\waveterm\settings.json" -symlink "$home_dir\settings.json"

    Write-Host 'done'
}

function Invoke-wezterm {
    Write-Host -NoNewline "$(Get-Timestamp)   - wezterm... "

    $home_dir = "$env:APPDATA\.config\wezterm"
    if (-not (Test-Path $home_dir)) { New-Item -ItemType Directory -Path $home_dir -Force | Out-Null }
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\wezterm\wezterm.lua" -symlink "$home_dir\wezterm.lua"

    Write-Host 'done'
}

function Invoke-windows {
    Write-Host -NoNewline "$(Get-Timestamp)   - windows... "

    reg import "$PATH_TO_THIS_REPO\windows\10-prefs.reg" 2>$null
    RUNDLL32.EXE "user32.dll,UpdatePerUserSystemParameters"

    Write-Host 'done'
}

function Invoke-winmerge {
    Write-Host -NoNewline "$(Get-Timestamp)   - winmerge... "

    reg import "$PATH_TO_THIS_REPO\winmerge\settings.reg" 2>$null

    Write-Host 'done'
}

function Invoke-wt {
    Write-Host -NoNewline "$(Get-Timestamp)   - wt (Windows Terminal)... "

    $standard_wt_path = "$PATH_TO_THIS_REPO\wt"
    $cmder_profile = Get-Content "$standard_wt_path\cmder_profile.json" | ConvertFrom-Json
    $wt_custom_settings = Get-Content "$standard_wt_path\custom_settings.json" | ConvertFrom-Json

    $wt_settings_path = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    if (Test-Path -PathType Leaf $wt_settings_path) {
        # detect EOL
        $eol = if ((Get-Content $wt_settings_path -Raw) -match '\r\n$') { "`r`n" } else { "`n" }

        # load existings settings
        $wt_settings = Get-Content $wt_settings_path | ConvertFrom-Json

        # apply customizations
        Set-MemberRecursively -TargetObject $wt_settings -Values $wt_custom_settings

        # add the cmder profile and make it the default one
        if (Test-Path -Type Leaf ([environment]::ExpandEnvironmentVariables($cmder_profile.icon))) {
            $add_cmder_profile = $true
            foreach ($wt_profile in $wt_settings.profiles.list) {
                if ($wt_profile.guid -eq $cmder_profile.guid) {
                    $add_cmder_profile = $false
                    Set-MemberRecursively -TargetObject $wt_profile -Values $cmder_profile
                    break
                }
            }
            if ($add_cmder_profile) {
                $wt_settings.profiles.list += $cmder_profile
            }
            Set-MemberRecursively `
                -TargetObject $wt_settings `
                -Values ("{`"defaultProfile`": `"$($cmder_profile.guid)`"}" | ConvertFrom-Json)
        }

        # save settings
        $wt_settings = $wt_settings | ConvertTo-Json -Depth 100 | Format-Json -Indentation 2 -AsArray
        $wt_settings += '' # empty line appended just to avoid improper mixing of EOL
        $wt_settings -Join $eol | Set-Content -NoNewline $wt_settings_path
    }

    Write-Host 'done'
}

function Invoke-zed {
    Write-Host -NoNewline "$(Get-Timestamp)   - zed... "

    $home_dir = "$env:APPDATA\Zed"
    if (-not (Test-Path $home_dir)) { New-Item -ItemType Directory -Path $home_dir -Force | Out-Null }
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\zed\snippets" -symlink "$home_dir\snippets"
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\zed\settings.json" -symlink "$home_dir\settings.json"
    Invoke-Symlink -target "$PATH_TO_THIS_REPO\zed\keymap.json" -symlink "$home_dir\keymap.json"

    Write-Host 'done'
}

# entry point
$arg = $args[0]
Write-Host "$(Get-Timestamp) applying default configurations..."

if ([string]::IsNullOrEmpty($arg)) {
    Invoke-windows

    Invoke-alacritty
    Invoke-autohotkey
    Invoke-capsicain
    Invoke-cmder
    Invoke-helix
    Invoke-git
    Invoke-lazygit
    Invoke-neovim
    Invoke-ruff
    Invoke-sublime_merge
    Invoke-tabby
    Invoke-vim
    Invoke-vscodium
    Invoke-yazi
    Invoke-waveterm
    Invoke-wezterm
    Invoke-winmerge
    Invoke-wt
    Invoke-zed
} else {
    $func = "Invoke-$arg"
    if (Get-Command $func -ErrorAction SilentlyContinue) {
        & $func
    } else {
        Write-Warning "configuration '$arg' not found."
    }
}

Write-Host "$(Get-Timestamp) configurations successfully applied"
