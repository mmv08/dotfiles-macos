#!/usr/bin/env bash
set -euo pipefail

brew bundle --file ./dotfiles-meta/Brewfile

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Zsh plugins
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat

defaults write com.apple.dock show-recents -bool false;
defaults write com.apple.dock persistent-apps -array; 
