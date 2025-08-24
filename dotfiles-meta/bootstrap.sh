#!/usr/bin/env bash
set -euo pipefail

brew bundle --file ./dotfiles-meta/Brewfile

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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

# Configure macOS Dock (only on initial setup)
if [ ! -f "$HOME/.dotfiles-dock-configured" ]; then
  defaults write com.apple.dock show-recents -bool false
  defaults write com.apple.dock persistent-apps -array
  touch "$HOME/.dotfiles-dock-configured"
fi 
