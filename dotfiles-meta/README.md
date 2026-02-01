# dotfiles macOS (personal)

Minimal notes for me.

---

## Bootstrap on a fresh macOS

```bash
# prerequisites
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# clone bare repo
git clone --bare https://github.com/mmv08/dotfiles-macos $HOME/.dotfiles
alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot checkout
dot config --local status.showUntrackedFiles no

# install packages & extras
bash dotfiles-meta/bootstrap.sh

dot remote set-url origin git@github.com:mmv08/dotfiles-macos.git
```

---

## Daily use

```bash
# track changes
 dot add <file> && dot commit -m "msg" && dot push

# pull on other machine
 dot pull

# update brewfile
 brew bundle dump --file dotfiles-meta/Brewfile --force
```

---

## Layout reference

```
$HOME
├── dotfiles-meta/        # files that live outside ~, symlinked by install.sh
└── dotfiles     # .gitconfig, .zshrc, etc.
```

---

## Amethyst layouts

- Source: `dotfiles-meta/amethyst/Layouts/`
- Install: `bash dotfiles-meta/scripts/install_amethyst_layouts.sh`
- Destination: `~/Library/Application Support/Amethyst/Layouts`
- Idempotent: safe to run multiple times; removes stale symlinks for deleted layouts

---

## Architecture reminder

- **Bare repo**: `~/.dotfiles` is a _bare_ Git repo; `$HOME` acts as the work‑tree.
- **Alias**: `alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'` for all Git ops.
- **Meta dir**: `dotfiles-meta/` stores anything that doesn’t belong directly in `$HOME` plus helper scripts.
- **Brewfile**: `dotfiles-meta/Brewfile` is the single source of truth for CLI tools, GUI apps and fonts.
- **Provisioning**: `dotfiles-meta/install.sh` symlinks/copies external configs and installs plugins/toolchains.

---

That’s it.
