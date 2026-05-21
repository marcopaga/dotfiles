#!/usr/bin/env bash
# tmpo-status.sh — show current tmpo time tracking status
# Output example: " dotfiles 1h 23m"  (or empty if not tracking)
# Queries ~/.tmpo/tmpo.db directly to avoid parsing ANSI output from `tmpo status`.

DB="$HOME/.tmpo/tmpo.db"

# Bail silently if sqlite3 is unavailable
command -v sqlite3 >/dev/null 2>&1 || exit 0

# Query for the running entry (end_time IS NULL, most recent start).
# We skip the [ -f ] guard — it fails when the directory has restrictive
# permissions even though the file exists and sqlite3 can open it fine.
read -r project start_time <<< "$(sqlite3 "$DB" \
  "SELECT project_name, start_time FROM time_entries WHERE end_time IS NULL ORDER BY start_time DESC LIMIT 1;" \
  2>/dev/null)"

# Nothing tracking — exit silently so the widget disappears
[ -z "$project" ] && exit 0

# Compute elapsed seconds.
# start_time is stored as UTC by tmpo (Go's time.Now().UTC()).
# SQLite may return it as "2026-05-21 10:30:00", "2026-05-21T10:30:00Z",
# or "2026-05-21T10:30:00+00:00". Normalize to "YYYY-MM-DD HH:MM:SS".
start_normalized="${start_time/T/ }"          # T separator → space
start_normalized="${start_normalized%%.*}"    # strip sub-second ".NNN"
start_normalized="${start_normalized%Z}"      # strip trailing Z
start_normalized="${start_normalized%+00:00}" # strip +00:00 timezone
start_normalized="${start_normalized%-00:00}" # strip -00:00 timezone

now_epoch=$(date -u +%s)
start_epoch=$(date -u -j -f "%Y-%m-%d %H:%M:%S" "$start_normalized" +%s 2>/dev/null)

if [ -z "$start_epoch" ]; then
  # Fallback: try without time component (shouldn't happen, but be safe)
  exit 0
fi

elapsed=$(( now_epoch - start_epoch ))
[ "$elapsed" -lt 0 ] && elapsed=0

hours=$(( elapsed / 3600 ))
minutes=$(( (elapsed % 3600) / 60 ))

if [ "$hours" -gt 0 ]; then
  duration="${hours}h ${minutes}m"
else
  duration="${minutes}m"
fi

printf " %s %s" "$project" "$duration"
