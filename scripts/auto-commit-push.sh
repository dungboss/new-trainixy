#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

INTERVAL="${AUTO_GIT_INTERVAL:-2}"
DEBOUNCE="${AUTO_GIT_DEBOUNCE:-15}"
MESSAGE_PREFIX="${AUTO_GIT_MESSAGE_PREFIX:-auto}"
REMOTE="${AUTO_GIT_REMOTE:-origin}"

last_snapshot=""
last_change_time=0

echo "Auto git watcher is running in: $ROOT_DIR"
echo "Interval: ${INTERVAL}s | Debounce: ${DEBOUNCE}s | Remote: ${REMOTE}"
echo "Press Ctrl+C to stop."

while true; do
  snapshot="$(git status --porcelain)"
  now="$(date +%s)"

  if [[ -n "$snapshot" ]]; then
    if [[ "$snapshot" != "$last_snapshot" ]]; then
      last_snapshot="$snapshot"
      last_change_time="$now"
      echo "Detected changes at $(date '+%Y-%m-%d %H:%M:%S'). Waiting for edits to settle..."
    elif (( now - last_change_time >= DEBOUNCE )); then
      commit_message="${MESSAGE_PREFIX}: sync $(date '+%Y-%m-%d %H:%M:%S')"

      git add -A

      if git diff --cached --quiet; then
        last_snapshot=""
        last_change_time=0
        sleep "$INTERVAL"
        continue
      fi

      echo "Committing: $commit_message"
      git commit -m "$commit_message"
      echo "Pushing to ${REMOTE}..."
      git push "$REMOTE" HEAD
      echo "Done at $(date '+%Y-%m-%d %H:%M:%S')."

      last_snapshot=""
      last_change_time=0
    fi
  else
    last_snapshot=""
    last_change_time=0
  fi

  sleep "$INTERVAL"
done
