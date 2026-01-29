param (
	[Parameter()][ValidateNotNullOrEmpty()][string]$standard_cmder_path = $(throw 'standard_cmder_path is mandatory, please provide a value.'),
	[Parameter()][ValidateNotNullOrEmpty()][string]$config_repo_path = $(throw 'config_repo_path is mandatory, please provide a value.')
)

# prepare config_repo_path to be used in cmd file
$config_repo_path = $config_repo_path.TrimStart('"')
$config_repo_path = $config_repo_path.TrimEnd('"')
$config_repo_path = $config_repo_path.TrimEnd('\')
if ($config_repo_path.StartsWith($env:USERPROFILE)) {
	$config_repo_path = $config_repo_path.Replace($env:USERPROFILE, '%USERPROFILE%')
}

$user_aliases_path = "$env:CMDER_ROOT\config\user_aliases.cmd"
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
