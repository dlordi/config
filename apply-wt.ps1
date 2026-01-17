param (
    [Parameter()][ValidateNotNullOrEmpty()][string]$standard_wt_path = $(throw 'standard_wt_path is mandatory, please provide a value.')
)

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
        }
        else {
            Add-Member -InputObject $TargetObject -Name $name -Value $value -MemberType NoteProperty
        }
    }
}

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
    Set-MemberRecursively -TargetObject $wt_settings -Values ("{`"defaultProfile`": `"$($cmder_profile.guid)`"}" | ConvertFrom-Json)

    # save settings
    $wt_settings = $wt_settings | ConvertTo-Json -Depth 100 | Format-Json -Indentation 2 -AsArray
    $wt_settings += '' # empty line appended just to avoid improper mixing of EOL
    $wt_settings -Join $eol | Set-Content -NoNewline $wt_settings_path
}