#!/usr/bin/env bash
# tmpo-status.sh — show current tmpo time tracking status
# Output example: " dotfiles 1h 23m"  (or empty if not tracking)
# Uses `tmpo status` CLI output instead of querying the database directly.

# Bail silently if tmpo is not installed
command -v tmpo >/dev/null 2>&1 || exit 0

# Capture tmpo status output, stripping ANSI escape codes.
# tmpo status prints lines like:
#   ⏱️  Currently tracking: ProjectName
#       Duration: 1h 23m 45s
raw=$(tmpo status 2>/dev/null)
[ -z "$raw" ] && exit 0

# Strip ANSI escape sequences
plain=$(printf '%s' "$raw" | sed 's/\x1b\[[0-9;]*m//g')

# Extract project name from "Currently tracking: <project>"
project=$(printf '%s' "$plain" | sed -n 's/.*Currently tracking: *//p')
[ -z "$project" ] && exit 0

# Extract duration from "Duration: <duration>"
# tmpo formats as e.g. "1d 2h 3m 4s", "1h 23m 45s", "5m 12s", "30s"
duration=$(printf '%s' "$plain" | sed -n 's/.*Duration: *//p')
[ -z "$duration" ] && exit 0

# Trim seconds for a compact tmux status-bar display:
#   "1d 2h 3m 4s" → "1d 2h 3m"
#   "1h 23m 45s"  → "1h 23m"
#   "5m 12s"      → "5m"
#   "30s"         → "0m"  (less than a minute)
if printf '%s' "$duration" | grep -qE '[dhm]'; then
  duration=$(printf '%s' "$duration" | sed 's/ *[0-9]*s$//')
else
  duration="0m"
fi

printf " %s %s" "$project" "$duration"
