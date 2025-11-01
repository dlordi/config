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

& { Start-Process powershell -Wait -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$dest_dir\Raphire-Win11Debloat-master\Win11Debloat.ps1`" -RunSavedSettings -RemoveAppsCustom -LogPath `"$dest_dir`" -Silent" -Verb RunAs }

# rm -Recurse $dest_dir\config-main
rm -Recurse $dest_dir\Raphire-Win11Debloat-master

Write-Host -NoNewLine 'Press any key to continue...'
Read-Host | Out-Null
