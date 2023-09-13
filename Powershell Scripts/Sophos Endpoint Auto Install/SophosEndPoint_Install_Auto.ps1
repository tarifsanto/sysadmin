# ****** Sophos Endpoint Automatic Installation Script *******
# Date: 21.03.2022 | Tarif Santo

# CHANGE HERE
$DestinationFolder = "C:\temp\"
$SophosInstalled = Test-Path -Path "C:\Program Files\Sophos"
$InstallerSource = "https://CHANGE_HERE\SophosSetup.zip"
$DestinationFile = "$DestinationFolder\SophosSetup.zip"
$CustomerToken = "WRITE TOKEN ID HERE"
$EpiServer = "API SERVER ADDRESS HERE"

# Check whether Sophos is already installed or not. If not then begin instllation
If ($SophosInstalled){
Write-Host "Sophos is already installed. "
Sleep 3
Exit
} Else {
Write-Host "Beginning the installation"

# Checkt whether temp directory exists or not. If not create it
If (Test-Path -Path $DestinationFolder -PathType Container){
Write-Host "$DestinationFolder folder already exists" -ForegroundColor Red
} Else {
New-Item -Path $DestinationFolder -ItemType directory
}
# SilentContinue will make the download faster by removing verbose
$ProgressPreference = 'SilentlyContinue'
# Download the file
Invoke-WebRequest -Uri "$InstallerSource" -OutFile "$DestinationFile"
# Extract the file
Expand-Archive -LiteralPath "$DestinationFolder\SophosSetup.zip" -DestinationPath "$DestinationFolder\"

}
# Start the silent installation
Start-Process -FilePath "$DestinationFolder\SophosSetup.exe" -ArgumentList "--customertoken=$CustomerToken --epinstallerserver=$EpiServer --products=""all"" --quiet"