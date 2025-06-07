#!/usr/bin/env bash
set -euo pipefail

# Install dependencies for macOS
xcode-select --install

# Install Homebrew 
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

[[ -d $ZSH_CUSTOM/themes/powerlevel10k ]] || \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k   

# 2. Rust toolchain
command -v rustup >/dev/null || \
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh    
# 3. NVM & Node
if [[ ! -d $HOME/.nvm ]]; then
  brew install nvm                                                 
  mkdir -p ~/.nvm
fi