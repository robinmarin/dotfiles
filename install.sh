#!/usr/bin/env bash
#
# install.sh — Deploy dotfiles from this repo into the correct locations
# on a machine (fresh setup, or after editing configs elsewhere).
#
# Usage: ./install.sh
#
# Existing files at the destination are backed up with a .bak.<timestamp>
# suffix before being overwritten, so nothing is silently lost.

set -euo pipefail

# Resolve the directory this script lives in, so it works regardless of
# where you call it from.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

# List of "source (relative to repo) -> destination (absolute)" pairs.
# Add new dotfiles here as you start tracking them.
FILES=(
  ".zshrc:$HOME/.zshrc"
  ".tmux.conf:$HOME/.tmux.conf"
  "alacritty/alacritty.toml:$HOME/.config/alacritty/alacritty.toml"
  "alacritty/catppuccin-mocha.toml:$HOME/.config/alacritty/catppuccin-mocha.toml"
)

echo "Installing dotfiles from: $DOTFILES_DIR"
echo

for entry in "${FILES[@]}"; do
  src="${entry%%:*}"
  dest="${entry#*:}"
  src_path="$DOTFILES_DIR/$src"

  if [[ ! -f "$src_path" ]]; then
    echo "  [skip] $src not found in repo, skipping"
    continue
  fi

  # Make sure the destination directory exists (e.g. ~/.config/alacritty)
  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"

  # Back up an existing file rather than clobbering it silently
  if [[ -e "$dest" ]]; then
    cp "$dest" "${dest}.bak.${TIMESTAMP}"
    echo "  [backup] $dest -> ${dest}.bak.${TIMESTAMP}"
  fi

  cp "$src_path" "$dest"
  echo "  [installed] $src -> $dest"
done

echo
echo "Done. Restart your shell or run 'source ~/.zshrc' to pick up changes."
echo "Reload tmux with 'tmux source-file ~/.tmux.conf'."
