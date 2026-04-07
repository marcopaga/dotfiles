# Neovim config

Built on [LazyVim](https://lazyvim.github.io/) — a batteries-included Neovim config framework.

## Structure

```
nvim/
├── init.lua                  # entry point, loads lua/config/lazy.lua
├── lazyvim.json              # LazyVim extras (edit to enable extras)
├── lazy-lock.json            # pinned plugin versions
└── lua/
    ├── config/
    │   ├── lazy.lua          # lazy.nvim bootstrap + plugin spec
    │   ├── options.lua       # custom vim options
    │   ├── keymaps.lua       # custom key mappings
    │   └── autocmds.lua      # custom autocommands
    └── plugins/
        ├── obsidian.lua      # obsidian.nvim — Obsidian vault integration
        └── example.lua       # disabled reference spec (not loaded)
```

## Setup

Symlink this directory to `~/.config/nvim`:

```sh
ln -s ~/Projects/dotfiles/nvim ~/.config/nvim
```

Open Neovim — lazy.nvim bootstraps itself and installs all plugins on first launch.

## Plugins

### obsidian.nvim

Provides deep Obsidian vault integration. See the [root README](../README.md#obsidiannvim) for the full
command and key binding reference.

- Config: `lua/plugins/obsidian.lua`
- Vault: `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Marco`
- Loads lazily for any `*.md` file; activates fully when inside the vault

### LazyVim extras

Enable extras by editing `lazyvim.json` or running `:LazyExtras` inside Neovim.
See the [LazyVim extras catalogue](https://www.lazyvim.org/extras) for the full list.
