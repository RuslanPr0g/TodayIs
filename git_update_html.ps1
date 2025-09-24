$LOG_FILE = "script.log"

function Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
    "$timestamp - $message" | Tee-Object -FilePath $LOG_FILE -Append
}

Log "Script execution started."

# Change directory
Set-Location "C:\path_programs" -ErrorAction Stop
Log "Successfully changed directory to C:\path_programs."

# Source script (PowerShell equivalent of `source`)
. ".\go_to_today_is.ps1" -ErrorAction Stop
Log "Successfully sourced go_to_today_is.ps1."

# Get today's date
$TODAY = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
Log "Fetched today's date: $TODAY."

# Git operations
git rebase --abort
git restore .
git clean -f

# Git pull with rebase
try {
    git pull --rebase origin master
} catch {
    Log "ERROR: Git pull failed."
    exit 1
}
Log "Successfully pulled changes from Git repository."

# Write today's date to index_windows.html
$TODAY | Out-File -FilePath "index_windows.html" -Force
Log "Successfully wrote today's date to index_windows.html."

# Wait for 20 seconds
Log "Waiting for 20 seconds before proceeding with git add."
Start-Sleep -Seconds 20

# Git add, commit, and push
try {
    git add .
    Log "Successfully staged changes for Git commit."

    git commit -m "Update HTML with today's date: $TODAY"
    Log "Git commit successful with message: 'Update HTML with today's date: $TODAY'."

    git push origin master
    Log "Successfully pushed changes to Git repository."
} catch {
    Log "ERROR: Git operation failed."
    exit 1
}

Log "Script execution completed."
