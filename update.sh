#!/bin/bash

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$REPO_DIR/script.log"

log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S.%3N") - $1" | tee -a "$LOG_FILE"
}

log "Script started."

cd "$REPO_DIR" || { log "ERROR: Cannot cd to $REPO_DIR"; exit 1; }

git rebase --abort 2>/dev/null || true
git restore . 2>/dev/null || true
git clean -fd 2>/dev/null || true

git pull --rebase origin master || { log "ERROR: git pull failed."; exit 1; }

TODAY=$(date +"%Y-%m-%d %H:%M:%S.%3N")
echo "$TODAY" > index.html || { log "ERROR: Failed to write index.html."; exit 1; }
log "Wrote date to index.html: $TODAY"

sleep 20

git add index.html || { log "ERROR: git add failed."; exit 1; }
git commit -m "Update HTML with today's date: $TODAY" || { log "ERROR: git commit failed."; exit 1; }
git push origin master || { log "ERROR: git push failed."; exit 1; }

log "Done."
