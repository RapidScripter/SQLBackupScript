# SQL Server Backup and Cleanup Script

## Description

This PowerShell script automates the process of backing up a SQL Server database and cleaning up old backups. It includes robust error handling, logging, and scheduling capabilities to ensure reliable and efficient database management. The script is designed to simplify administrative tasks, reduce manual effort, and provide a clear audit trail through detailed logs.

## Parameters

- **ServerInstance**: The name of your SQL Server instance (e.g., `localhost\Instance`).
- **Database**: The name of the database to back up (e.g., `SalesDB`).
- **BackupFile**: The path where backups will be saved (e.g., `C:\Backup\DatabaseName_`).
- **Username & Password**: SQL Server credentials (if using SQL authentication).

## Prerequisites

1. **PowerShell**: Ensure you are using PowerShell 5.1 or later.
2. **SQL Server PowerShell Module**: Install the `SqlServer` module using:
   ```powershell
   Install-Module -Name SqlServer -Force -Scope CurrentUser
3. **Permissions**: Ensure the script is run with sufficient permissions to access the SQL Server instance and the backup directory.

## Installation and Usage

1. Download or Clone the Script
   ```bash
   git clone https://github.com/RapidScripter/SQLBackupScript.git

2. Update Configuration
- Open the script in a text editor.
- Replace the placeholders (`ServerInstance`, `Database`, `BackupFile`, `Username`, and `Password`) with your SQL Server details.

3. Run the Script
- Open PowerShell with Administrator privileges.
- Navigate to the script directory and execute:
   ```powershell
   .\SQLBackupScript.ps1

4. Output
- The script generates a backup file in the specified directory (e.g., `C:\Backup\DatabaseName_20231001_030000.bak`).
- Logs are saved to `C:\Backup\BackupLog.txt`.

## Script Details

1. Database Backup
- Connects to the specified SQL Server instance.
- Creates a full backup of the database.
- Logs the backup process and handles errors gracefully.

2. Backup Cleanup
- Deletes backups older than 30 days from the specified backup directory.
- Logs the cleanup process and handles errors.

3. Logging
- All actions and errors are logged to `C:\Backup\BackupLog.txt` with timestamps for easy tracking.

## Scheduling the Script

To automate the backup and cleanup process, you can schedule the script to run daily using Windows Task Scheduler:

1. Create a Scheduled Task:
   ```powershell
   $trigger = New-ScheduledTaskTrigger -At "03:00" -Daily
   $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File 'C:\Backup\SQLBackupScript.ps1'"
   Register-ScheduledTask -TaskName "SQLBackupTask" -Trigger $trigger -Action $action

2. Test the Task:
- Manually start the task:
   ```powershell
   Start-ScheduledTask -TaskName "SQLBackupTask"

- Check the task status:
   ```powershell
   Get-ScheduledTaskInfo -TaskName "SQLBackupTask"

- A `LastTaskResult` value of `0` indicates success.

## Example Log Output

2023-10-01 03:00:01 - Starting SQL database backup.
2023-10-01 03:00:15 - Database backup completed successfully.
2023-10-01 03:00:16 - Starting backup cleanup...
2023-10-01 03:00:17 - Old backups deleted successfully.
