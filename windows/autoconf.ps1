#Requires -RunAsAdministrator
# TOOD: does the above statement/directive is really required?

# this directory will contain unzipped repos downloaded in the next steps...
$dest_dir = "$env:USERPROFILE\Desktop" # TODO: use "$env:TEMP"

Write-Host "downloading zipped config repo..."
$tmp_zip = New-TemporaryFile | Rename-Item -NewName { $_ -replace 'tmp$', 'zip' } -PassThru
Invoke-WebRequest -OutFile $tmp_zip https://github.com/dlordi/config/archive/master.zip
Write-Host "unzipping config repo to $dest_dir\config-main..."
Expand-Archive -Force -LiteralPath $tmp_zip -DestinationPath $dest_dir
Remove-Item -Force $tmp_zip

# TODO: verify Win11Debloat works properly when elevated as an user different than "Administrator"
Write-Host "downloading zipped Raphire-Win11Debloat repo..."
$tmp_zip = New-TemporaryFile | Rename-Item -NewName { $_ -replace 'tmp$', 'zip' } -PassThru
Invoke-WebRequest -OutFile $tmp_zip https://github.com/dlordi/Raphire-Win11Debloat/archive/master.zip
Write-Host "unzipping Raphire-Win11Debloat repo to $dest_dir\Raphire-Win11Debloat-master..."
Expand-Archive -Force -LiteralPath $tmp_zip -DestinationPath $dest_dir
Remove-Item -Force $tmp_zip

Copy-Item "$dest_dir\config-main\windows\Raphire-Win11Debloat\SavedSettings.txt" "$dest_dir\Raphire-Win11Debloat-master\SavedSettings"
Copy-Item "$dest_dir\config-main\windows\Raphire-Win11Debloat\CustomAppsList.txt" "$dest_dir\Raphire-Win11Debloat-master\CustomAppsList"
# TODO: always save log file on user Desktop in order to check its content
& { Start-Process powershell -Wait -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$dest_dir\Raphire-Win11Debloat-master\Win11Debloat.ps1`" -RunSavedSettings -RemoveAppsCustom -LogPath `"$dest_dir`" -Silent" -Verb RunAs }
Remove-Item -Force -Recurse $dest_dir\Raphire-Win11Debloat-master

# Remove-Item -Force -Recurse $dest_dir\config-main

# TODO: warn user to check debloat log file on the desktop and/or to delete it

# TODO: prompt user to press "R" to immediatly reboot the PC or press any other key to just quit...
Write-Host -NoNewLine 'Press any key to continue...'
Read-Host | Out-Null
