#!/usr/bin/env bash
set -euo pipefail

BREWFILE="$(cd "$(dirname "$0")" && pwd)/Brewfile"

# Check Homebrew is installed
if ! command -v brew &>/dev/null; then
  echo "Error: Homebrew is not installed."
  echo "Install it first: https://brew.sh"
  exit 1
fi

# Check Brewfile exists
if [ ! -f "$BREWFILE" ]; then
  echo "Error: Brewfile not found at $BREWFILE"
  exit 1
fi

echo "Installing packages from Brewfile..."
brew bundle --file="$BREWFILE" --no-upgrade

# Install tmuxinator gem using the Homebrew-managed Ruby
echo "Installing tmuxinator gem..."
GEM="$(brew --prefix ruby)/bin/gem"
if "$GEM" list tmuxinator -i &>/dev/null; then
  echo "  tmuxinator already installed, skipping."
else
  "$GEM" install tmuxinator
fi

echo "Done."
