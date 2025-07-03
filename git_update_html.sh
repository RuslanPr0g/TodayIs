#!/bin/bash

LOG_FILE="script.log"

log() {
    local message="$1"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S.%3N")
    echo "$timestamp - $message" | tee -a "$LOG_FILE"
}

log "Script execution started."

cd "/c/path_programs" || { log "ERROR: Failed to change directory to /c/path_programs."; exit 1; }
log "Successfully changed directory to /c/path_programs."

source "go_to_today_is.sh" || { log "ERROR: Failed to source go_to_today_is.sh."; exit 1; }
log "Successfully sourced go_to_today_is.sh."

TODAY=$(date +"%Y-%m-%d %H:%M:%S.%3N")
log "Fetched today's date: $TODAY."

echo "$TODAY" > index.html || { log "ERROR: Failed to write today's date to index.html."; exit 1; }
log "Successfully wrote today's date to index.html."

log "Waiting for 20 seconds before proceeding with git add."
sleep 20

git restore .

git clean -f

git pull --rebase origin master || { log "ERROR: Git pull failed."; exit 1; }

git add . || { log "ERROR: Failed to add files to Git."; exit 1; }
log "Successfully staged changes for Git commit."

git commit -m "Update HTML with today's date: $TODAY" || { log "ERROR: Git commit failed."; exit 1; }
log "Git commit successful with message: 'Update HTML with today's date: $TODAY'."

git push origin master || { log "ERROR: Git push failed."; exit 1; }
log "Successfully pushed changes to Git repository."

log "Script execution completed."
