# Run all update scripts
Write-Host "Running folder updates..."
.\runscripts\folderupdates.ps1

Write-Host "
Running file edits..."
.\runscripts\fileedits.ps1

Write-Host "
Running Flutter build runner..."
flutter pub run build_runner build --delete-conflicting-outputs

Write-Host "
All updates completed."
