$url = "https://dl.google.com/android/repository/commandlinetools-win-11479570_latest.zip"
$zipPath = "$env:TEMP\cmdline-tools.zip"
Write-Host "Downloading command line tools..."
curl.exe -L $url -o $zipPath

$sdkPath = "$env:LOCALAPPDATA\Android\Sdk"
$destPath = "$sdkPath\cmdline-tools\latest"

if (!(Test-Path $destPath)) {
    New-Item -ItemType Directory -Force -Path $destPath | Out-Null
}

Write-Host "Extracting tools..."
$extractPath = "$env:TEMP\cmdline-tools-extracted"
if (Test-Path $extractPath) {
    Remove-Item -Recurse -Force $extractPath
}
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

Write-Host "Copying to SDK path..."
Copy-Item -Path "$extractPath\cmdline-tools\*" -Destination $destPath -Recurse -Force

Write-Host "Accepting licenses..."
Start-Process -NoNewWindow -FilePath "cmd.exe" -ArgumentList "/c echo y | flutter doctor --android-licenses" -Wait

Write-Host "Done!"
