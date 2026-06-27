#!/bin/bash
# Watches index.html and auto-commits + pushes to GitHub on every change.
# Run once in the background: bash ~/focus-plan/watch.sh &

REPO_DIR="$HOME/focus-plan"
WATCH_FILE="$REPO_DIR/index.html"
INTERVAL=5

echo "Watching $WATCH_FILE for changes (every ${INTERVAL}s)..."
last_hash=$(md5 -q "$WATCH_FILE" 2>/dev/null)

while true; do
  sleep "$INTERVAL"
  current_hash=$(md5 -q "$WATCH_FILE" 2>/dev/null)
  if [ "$current_hash" != "$last_hash" ]; then
    echo "[$(date '+%H:%M:%S')] Change detected — pushing..."
    cd "$REPO_DIR" || exit 1
    git add index.html
    git commit -m "Update focus plan [$(date '+%Y-%m-%d %H:%M')]"
    git push
    last_hash="$current_hash"
    echo "[$(date '+%H:%M:%S')] Done."
  fi
done
