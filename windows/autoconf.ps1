#Requires -RunAsAdministrator

# this directory will contain unzipped repos downloaded in the next steps...
$dest_dir = "$env:USERPROFILE\Desktop" # TODO: use "$env:TEMP"

Write-Host "downloading zipped config repo..."
$tmp_zip = New-TemporaryFile | ren -NewName { $_ -replace 'tmp$', 'zip' } -PassThru
iwr -OutFile $tmp_zip https://github.com/dlordi/config/archive/master.zip
Write-Host "unzipping config repo to $dest_dir\config-main..."
Expand-Archive -Force -LiteralPath $tmp_zip -DestinationPath $dest_dir
rm $tmp_zip

Write-Host "downloading zipped Raphire-Win11Debloat repo..."
$tmp_zip = New-TemporaryFile | ren -NewName { $_ -replace 'tmp$', 'zip' } -PassThru
iwr -OutFile $tmp_zip https://github.com/dlordi/Raphire-Win11Debloat/archive/master.zip
Write-Host "unzipping Raphire-Win11Debloat repo to $dest_dir\Raphire-Win11Debloat-master..."
Expand-Archive -Force -LiteralPath $tmp_zip -DestinationPath $dest_dir
rm $tmp_zip

Copy-Item "$dest_dir\config-main\windows\Raphire-Win11Debloat\SavedSettings.txt" "$dest_dir\Raphire-Win11Debloat-master\SavedSettings"
Copy-Item "$dest_dir\config-main\windows\Raphire-Win11Debloat\CustomAppsList.txt" "$dest_dir\Raphire-Win11Debloat-master\CustomAppsList"
Set-ExecutionPolicy Unrestricted -Scope Process
& "$dest_dir\Raphire-Win11Debloat-master\Win11Debloat.ps1" -RunSavedSettings -RemoveAppsCustom -LogPath $PSScriptRoot

# $PSScriptRoot
# & { Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command "type $dest_dir\config-main\windows\README.md; Read-Host | Out-Null"' }
# & { Start-Process powershell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File $dest_dir\config-main\windows\...' -Verb RunAs }

# rm -Recurse $dest_dir\config-main
rm -Recurse $dest_dir\Raphire-Win11Debloat-main

Write-Host -NoNewLine 'Press any key to continue...'
Read-Host | Out-Null
