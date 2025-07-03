#!/bin/bash

MAIN_PATH="$HOME/Desktop/Projects/TodayIs"

LOG_FILE="$MAIN_PATH/script.log"

log() {
    local message="$1"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S.%3N")
    echo "$timestamp - $message" | tee -a "$LOG_FILE"
}

log "Script execution started."

TARGET_DIR="$MAIN_PATH"

cd "$TARGET_DIR" || { log "ERROR: Failed to change directory to $TARGET_DIR."; exit 1; }
log "Successfully changed directory to $TARGET_DIR."

TODAY=$(date +"%Y-%m-%d %H:%M:%S.%3N")
log "Fetched today's date: $TODAY."

git rebase --abort

git restore .

git clean -f

git pull --rebase origin master || { log "ERROR: Git pull failed."; exit 1; }

echo "$TODAY" > index.html || { log "ERROR: Failed to write today's date to index.html."; exit 1; }
log "Successfully wrote today's date to index.html."

log "Waiting for 20 seconds before proceeding with git add."
sleep 20

git add . || { log "ERROR: Failed to add files to Git."; exit 1; }
log "Successfully staged changes for Git commit."

git commit -m "Update HTML with today's date: $TODAY" || { log "ERROR: Git commit failed."; exit 1; }
log "Git commit successful."

git push origin master || { log "ERROR: Git push failed."; exit 1; }
log "Successfully pushed changes to Git repository."

log "Script execution completed."
