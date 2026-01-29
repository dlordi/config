param (
	[Parameter()][ValidateNotNullOrEmpty()][string]$standard_gitconfig_path = $(throw 'standard_gitconfig_path is mandatory, please provide a value.')
)

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
