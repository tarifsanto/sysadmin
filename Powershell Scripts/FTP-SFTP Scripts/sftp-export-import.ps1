# ******************************************************
# This Powershell Script upload files (specified datatypes) from a local PC directory to a remote SFTP directory and after successfull upload it copies the files to a backup folder and then deletes the files from local directory
# Likewise it download certain files (specified file types) from FTP to a local PC directory as well to a backup folder and after successfull download it deletes the files from the FTP directory
# The script uses WinSCP Powershell Module. So it is required to install it first with the following command: Install-Module -Name WinSCP

# +++ Tarif R. Santo +++
# +++ 21.09.2023 +++
# ******************************************************

# Load the WinSCP module
Import-Module -Name WinSCP

# Specify SFTP server credentials
$sftpServer = "Specify Server Hostname Here"
$sftpUsername = "SFTP Username"
$sftpPassword = "SFTP Password"

# Specifiy Directories
$FTPExportDirectory = "FTP-Export-Directory/"
$LocalImportDirectory = "Local-Import-Directory\"
$LocalExportDirectory = "Local-Export-Directory\"
$RemoteImportDirectory = "FTP-Import-Directory/"
$BackupOrderFile="Backup-Directory-for-downloaded-Files/"
$BackupDataFile="Backup-Directory-for-uploaded-Files/"
$logFilePath = "Path-for-Log-Files\SFTPScriptLog.txt" 

# Specify Datatype / Data Extension Filter
$FileType4Download = "*.ord"
$FileType2Upload = "*.dat"

# Logging Function
function Log-Event {
    param (
        [string]$message
    )
    $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') $message`n"  # Add `n for newline
    $logEntry | Out-File -FilePath $logFilePath -Append
}

# Get The HostKeyFingerprint
function Get-SshFingerprint {
    param( [string]$ssh_server )
  
    # Load WinSCP .NET assembly
    Add-Type -Path "${env:ProgramFiles(x86)}\WinSCP\WinSCPnet.dll"
  
    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = $ssh_server
        UserName = ""
    }
  
    # Scan for the host key
    $session = New-Object WinSCP.Session
    try
    {
        $fingerprint = $session.ScanFingerprint($sessionOptions, "SHA-256")
    }
    finally
    {
        $session.Dispose()
    }
  
    # And output the host key to the pipeline
    Write-Output $fingerprint
  }


# Function to download files from SFTP directory to local directory
function DownloadFiles4mSFTP {
    param (
        [string]$RemoteExportPath,
        [string]$LocalImportPath
    )
    # Get the HostKeyFingerprint
    # $sshHostKeyFingerprint = Get-WinSCPHostKeyFingerprint -SessionOption $sessionOptions -Algorithm SHA-256
    $sshHostKeyFingerprint = Get-SshFingerprint $sftpServer

    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = $sftpServer
        UserName = $sftpUsername
        Password = $sftpPassword
        SshHostKeyFingerprint = $sshHostKeyFingerprint
    }

    $session = New-Object WinSCP.Session

    try {
        # Connect to the SFTP server
        $session.Open($sessionOptions)

        # Log event
        Log-Event "SFTP Session initialization running"
        
        # List remote files
        $remoteFiles = $session.ListDirectory($RemoteExportPath)

        # Log event
        Log-Event "Directory listing running"
        
        foreach ($remoteFile in $remoteFiles.Files) {
            if ($remoteFile.IsDirectory) {
                continue
            }
            
            $remoteFileName = $remoteFile.Name
            $localFilePath = Join-Path -Path $LocalImportPath -ChildPath $remoteFileName
            
            # Download the files
            if ($remoteFileName -like $FileType4Download) {
                $session.GetFiles($remoteFile.FullName, $localFilePath).Check()
                Log-Event "Files are downloading from FTP Server to Local Folder"
            }
        }
    } finally {
        # Backup the order files to local backup folder
        Copy-Item -Path "$LocalImportPath\*.ord" -Destination $BackupOrderFile -Force
        Log-Event "Backup of order files is completed"
        # Delete all the files from the server
        $session.RemoveFiles(($RemoteExportPath + $FileType4Download)).Check()
        Log-Event ".ord files from FTP Server are deleted"
        # Disconnect and dispose of the session
        $session.Dispose()
    }
}

# Function to upload the local files to SFTP
function UploadFilesToFTP {
    param (
        [string]$localExportPath,
        [string]$remoteImportPath
    )
    
    # Get the HostKeyFingerprint
    $sshHostKeyFingerprint = Get-SshFingerprint $sftpServer

    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = $sftpServer
        UserName = $sftpUsername
        Password = $sftpPassword
        SshHostKeyFingerprint = $sshHostKeyFingerprint
    }

    $session = New-Object WinSCP.Session
    
    try {
        # Connect to the SFTP server
        $session.Open($sessionOptions)

        # Get a list of desired files in the local directory
        $LocalExportFiles = Get-ChildItem -Path $localExportPath -Filter $FileType2Upload
        
        # For debug:
        #Write-Host $LocalExportFiles
        #write-host $remoteImportPath

        # Set the transferoptions
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

        # Upload the files one by one to the remote SFTP directory
        foreach ($dataFile in $LocalExportFiles) {
            $transferResult = $session.PutFiles($dataFile.FullName, $remoteImportPath, $False, $transferOptions)
            $transferResult.Check()
            }
        Log-Event "Files uploading to FTP Server is done!"

    } finally {
        # Copy the .dat files to backup folder before deleting
        Copy-Item -Path "$localExportPath\*.dat" -Destination $BackupDataFile -Force
        Log-Event ".dat files are copied to backup folder"
        # Delete all the .dat files from the local directory
        Remove-Item -Path "$localExportPath\*.dat" -Force
        # Disconnect and dispose of the session
        Log-Event "only .dat files are deleted from the local folder"
        $session.Dispose()
    }
}

# Run the function for: Download files from SFTP
DownloadFiles4mSFTP -RemoteExportPath $FTPExportDirectory -LocalImportPath $LocalImportDirectory

# Run the function for: Upload files to SFTP
UploadFilesToFTP -localExportPath $LocalExportDirectory -remoteImportPath $RemoteImportDirectory
