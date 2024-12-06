#!/bin/bash

LOG_FILE="script.log"

log() {
    local message="$1"
    local timestamp
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "$timestamp - $message" | tee -a "$LOG_FILE"
}

log "Script started."

cd "/c/path_programs" || { log "Failed to change directory to /c/path_programs"; exit 1; }
log "Changed directory to /c/path_programs."

source "go_to_today_is.sh" || { log "Failed to source go_to_today_is.sh"; exit 1; }
log "Successfully sourced go_to_today_is.sh."

TODAY=$(date +"%A, %B %d, %Y")
log "Fetched today's date: $TODAY."

echo "$TODAY" > index.html || { log "Failed to write today's date to index.html"; exit 1; }
log "Successfully wrote today's date to index.html."

git add . || { log "Failed to add files to Git"; exit 1; }
log "Added files to Git."

git commit -m "Update HTML with today's date: $TODAY" || { log "Git commit failed"; exit 1; }
log "Git commit successful with message: 'Update HTML with today's date: $TODAY'."

git push origin master || { log "Git push failed"; exit 1; }
log "Successfully pushed changes to Git."

log "Script completed."
