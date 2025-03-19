# Setting Up SQL Server PowerShell Module
# Ensure you have the SQL Server PowerShell module installed
# Run the following command as an administrator:

Install-Module -Name SqlServer

# Creating a SQL Database Backup Script with Error Handling and Logging
# Replace the placeholders below with your actual SQL Server details:
# - ServerInstance: Your SQL Server instance name (e.g., "MY-SERVER\SQL2019")
# - Database: The name of the database you want to back up (e.g., "SalesDB")
# - BackupFile: The path where you want to save backups (e.g., "D:\SQLBackups\SalesDB_")
# - Username & Password: Your SQL Server credentials (if using SQL authentication)

$logFile = "C:\Backup\BackupLog.txt"

function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -Append -FilePath $logFile
}

Try {
    Write-Output "Starting SQL database backup..."
    Write-Log "Starting SQL database backup."
    Backup-SqlDatabase -ServerInstance "localhost\Instance" `
        -Database "DatabaseName" `
        -BackupFile ("C:\Backup\DatabaseName_" + (Get-Date -Format "yyyyMMdd_HHmmss") + ".bak") `
        -Username "YourUsername" `
        -Password "YourPassword"
    Write-Output "Database backup completed successfully."
    Write-Log "Database backup completed successfully."
}
Catch {
    $errorMsg = "Failed to backup the database: $_"
    Write-Error $errorMsg
    Write-Log $errorMsg
    Exit 1
}

# Automating Backup Cleanup with Error Handling and Logging
# Delete backups older than 30 days
# Update the path below to match your backup folder (e.g., "D:\SQLBackups")

Try {
    Write-Output "Starting backup cleanup..."
    Write-Log "Starting backup cleanup..."
    $olderThan = (Get-Date).AddDays(-30)
    Get-ChildItem "C:\Backup" | Where-Object { $_.LastWriteTime -lt $olderThan } | Remove-Item -Force
    Write-Output "Old backups deleted successfully."
    Write-Log "Old backups deleted successfully."
}
Catch {
    $errorMsg = "Failed to clean up old backups: $_"
    Write-Error $errorMsg
    Write-Log $errorMsg
    Exit 1
}

# Scheduling Tasks with PowerShell
# Create automated tasks for backup and cleanup

# Backup Task (Runs Daily at 3:00 AM)
<#
$trigger = New-ScheduledTaskTrigger -At "03:00" -Daily
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File 'C:\Backup\SQLBackupScript.ps1'"
Register-ScheduledTask -TaskName "SQLBackupTask" -Trigger $trigger -Action $action
Write-Log "Scheduled SQL backup task created to run daily at 3:00 AM."
#>

# Testing and Monitoring Scheduled Tasks
# To test the tasks manually:
# Start-ScheduledTask -TaskName "SQLBackupTask"

# Check the result of the last run:
# Get-ScheduledTaskInfo -TaskName "SQLBackupTask"

# Look at the LastTaskResult field.
# A value of 0 means the task succeeded, while any other value indicates an error.

