#!/usr/bin/env bash
set -euo pipefail

brew bundle --file ./dotfiles-meta/Brewfile

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  # The tracked .zshrc is checked out before bootstrap; keep it as the source of truth.
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# Install rustup
if ! command -v rustup &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# Install uv
if ! command -v uv &> /dev/null; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Zsh plugins
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-bat" ]; then
  git clone https://github.com/fdellwing/zsh-bat.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-bat"
fi

# Amethyst custom layouts
bash ./dotfiles-meta/scripts/install_amethyst_layouts.sh

# Configure macOS Dock (only on initial setup)
if [ ! -f "$HOME/.dotfiles-dock-configured" ]; then
  defaults write com.apple.dock show-recents -bool false
  defaults write com.apple.dock persistent-apps -array
  touch "$HOME/.dotfiles-dock-configured"
fi 

# Disable Siri and Text Input Menu (safe to re run since I always want them off)
defaults write com.apple.TextInputMenu visible -bool false
defaults write com.apple.Siri StatusMenuVisible -bool false

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show Finder path and status bars
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Sort files by name by default in Finder icon view
finder_plist="$HOME/Library/Preferences/com.apple.finder.plist"
/usr/libexec/PlistBuddy \
  -c "Set :StandardViewSettings:IconViewSettings:arrangeBy name" \
  "$finder_plist"

# Save screenshots to a dedicated folder
screenshots_dir="$HOME/Pictures/Screenshots"
mkdir -p "$screenshots_dir"
defaults write com.apple.screencapture location -string "$screenshots_dir"

# Keep Spaces in a stable order for predictable window management
defaults write com.apple.dock mru-spaces -bool false

# Automatically hide the Dock
defaults write com.apple.dock autohide -bool true

# Disable all hot corners
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0

# Clear modifiers (optional but nice to keep clean)
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-modifier -int 0

# Restart affected UI services
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true
