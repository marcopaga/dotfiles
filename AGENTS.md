# AGENTS.md — Dotfiles Repository

This repository contains personal configuration files (dotfiles) for Neovim,
Vim (fallback), tmux, zsh, and related tooling. There is no build system, test
suite, or package manager. Changes are applied by symlinking files into `$HOME`.

---

## Repository Layout

```
_vimrc                          → ~/.vimrc
_tmux.conf                      → ~/.tmux.conf
_zshrc                          → ~/.zshrc
nvim/                           → ~/.config/nvim (LazyVim)
brew/Brewfile                  curated Homebrew package list
brew/install.sh                installs missing packages from Brewfile + tmuxinator gem
tmuxinator/dotfiles.yml        tmuxinator session: shell (left) + opencode (right)
tmux/plugins/catppuccin-tmux/  tmux theme (tracked, pinned to v2.1.3)
tmux/plugins/tmux-battery/     battery widget for tmux
tmux/plugins/tmux-cpu/         CPU widget for tmux
tmux/scripts/net-traffic.sh    network up/down speed script
```

Symlinks are created manually (see `README.md`):

```sh
ln -s ~/Projects/dotfiles/_vimrc ~/.vimrc
ln -s ~/Projects/dotfiles/_tmux.conf ~/.tmux.conf
ln -s ~/Projects/dotfiles/_zshrc ~/.zshrc
ln -s ~/Projects/dotfiles/nvim ~/.config/nvim
```

Vim plugins are managed by **vim-plug** and live in `~/.vim/plugged/` (not
tracked by this repo). vim-plug auto-bootstraps itself on first Vim launch.

tmux plugins live in `tmux/plugins/` and are tracked in this repo (shallow
clones). To update them, re-clone with a newer tag and commit the result.

---

## Build / Lint / Test Commands

There is **no automated build, lint, or test pipeline** in this repository.

| Task | Command |
|------|---------|
| Install / update Neovim plugins | `:Lazy sync` inside Neovim |
| Install / update Vim plugins | `:PlugInstall` / `:PlugUpdate` inside Vim |
| Validate vimrc (core settings) | `vim -c "source _vimrc" -c "qa"` |
| Re-source vimrc without restarting | `<leader>sv` inside Vim (or `:source $MYVIMRC`) |
| Reload tmux config (live) | `tmux source-file ~/.tmux.conf` |
| Update vim-plug itself | `:PlugUpgrade` inside Vim |
| Reload zshrc (live) | `source ~/.zshrc` |
| Install missing Homebrew packages | `bash brew/install.sh` |
| Create / edit a tmuxinator project | `tmuxinator open <name>` |
| Start a tmuxinator session | `tmuxinator start <name>` |

There are no unit tests to run. Validation is done by sourcing the config
files directly in the target application.

---

## Neovim (primary editor)

Neovim configuration lives in `nvim/` and is symlinked to `~/.config/nvim`.
It is a LazyVim-based setup with custom plugins under `lua/plugins/`.

| Task | Command |
|------|---------|
| Install / update plugins | `:Lazy sync` |
| Install Tree-sitter parsers | `:TSInstall <lang>` |
| Re-source config | `:source` or restart Neovim |

Plugin files follow the LazyVim spec convention (`return { ... }`).
Each file in `lua/plugins/` is auto-loaded by `lazy.nvim`.

---

## Vim Plugin Manager

Plugins are managed with **vim-plug** and live in `~/.vim/plugged/` (not
tracked by this repo). vim-plug auto-installs itself on first launch via a
`curl` bootstrap in `_vimrc`.

Current plugins declared in `_vimrc`:

| Plugin | Purpose |
|--------|---------|
| `junegunn/fzf` + `junegunn/fzf.vim` | Fuzzy file/buffer/grep search |
| `preservim/nerdtree` | File tree sidebar |
| `tpope/vim-fugitive` | Git integration |
| `morhetz/gruvbox` | Color scheme |
| `prabirshrestha/vim-lsp` | LSP client |
| `mattn/vim-lsp-settings` | Auto-installs language servers |
| `prabirshrestha/asyncomplete.vim` | Async completion popup |
| `prabirshrestha/asyncomplete-lsp.vim` | LSP completion source |

To add a plugin: add a `Plug '...'` line in the `call plug#begin()` block in
`_vimrc`, then run `:PlugInstall`.

---

## Code Style Guidelines

### General Principles

- Keep config files minimal and readable.
- Prefer comments over clever, unexplained settings.
- One logical group of settings per section; separate sections with a blank
  line and a comment header.
- Remove settings that are no longer relevant rather than leaving them
  commented out indefinitely (exception: intentionally disabled options
  should carry an explanatory comment).

---

### Vim / Vimrc (`_vimrc`)

- **Indentation:** 2 spaces (`shiftwidth=2`, `tabstop=2`, `softtabstop=2`).
  `expandtab` is on — never use hard tabs.
- **Leader key:** `<Space>` (`let mapleader=" "`).
- **Keymaps:** Use `:nmap` / `:vmap` / `:imap` with explicit mode. Prefer
  `<C-x>` notation for control keys.
- **Numbering:** Always use `:nmap` style (with colon) for consistency with
  the existing file, not the bare `nmap` form.
- **Options:** Group related `set` calls together (search options, display
  options, editing options, etc.).
- **Color scheme:** gruvbox dark (`background=dark`, `colorscheme gruvbox`).
- **No backup / swapfiles:** `nobackup` and `noswapfile` are intentional —
  do not re-enable them.
- **Number format:** `set nrformats=` (treat all numbers as decimal) — keep
  this in place.

---

### tmux (`_tmux.conf`)

- **Prefix:** `C-a` (screen-style). Do not change this.
- **Pane/window indexing:** 1-based (`base-index 1`, `pane-base-index 1`).
- **Comments:** Begin section comments with `# ===` headers for visual grouping.
- **Keybinds:** Use `bind` (not `bind-key`) for brevity, except where
  `bind-key` is already used for clarity with complex commands.
- **Repeatable binds:** Mark resize binds with `-r`; mark navigation binds
  without `-r`.
- **Theme:** Catppuccin Mocha, loaded from `tmux/plugins/catppuccin-tmux/`.
  Do not hardcode colors; use `#{@thm_*}` variables from the catppuccin palette.
- **Status bar:** Widgets are assembled via `status-right` using catppuccin
  module format (`#{E:@catppuccin_status_*}`). The network script is called
  inline via `#(tmux/scripts/net-traffic.sh)`. Do not hardcode system info.
- **`reattach-to-user-namespace`:** Not needed on macOS 13+ / tmux 3.2+.
  Do not re-add it.

---

## zsh / zshrc (`_zshrc`)

- **oh-my-zsh check:** The file checks for `~/.oh-my-zsh` at the top and
  prints an install reminder (then `return 1`) if it is missing. This block
  must stay at the top of the file, before `export ZSH=...`. Install manually
  via the official installer: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- **Section headers:** Use `# === Section Name ===` to delimit logical groups
  (bootstrap, PATH, NVM, aliases, tool-specific blocks, etc.).
- **PATH ordering:** Declare all `PATH` exports together in one block after
  `source $ZSH/oh-my-zsh.sh`. Order: Homebrew → Rancher Desktop → asdf
  shims → local bin → tool-specific (opencode, etc.). More-specific paths
  should be prepended (`$PATH` at the end of the value), not appended.
- **NVM:** Loaded once via the Homebrew-managed path
  (`/opt/homebrew/opt/nvm/nvm.sh`). Do not duplicate the init block. The
  `load-nvmrc` hook (auto-switches node version on `cd`) follows immediately
  after the NVM init.
- **oh-my-zsh plugins:** Declared in the single `plugins=(...)` line.
  Add plugins sparingly — each one increases shell startup time. Document
  non-obvious plugins with a comment.
- **Tool-managed blocks:** Blocks inserted by external tools (Rancher Desktop,
  AsyncAPI CLI, etc.) may be kept as-is. Do not reformat or merge them.
- **Aliases:** Group shell aliases together under `# === aliases ===` rather
  than scattering them throughout the file.
- **No `>> file` redirects inside the rc:** PATH or config lines must never
  append to the file on disk (i.e., never use `>> ~/.zshrc` inside `_zshrc`).

---

### Brewfile (`brew/Brewfile`)

- **Curated only:** This file is maintained by hand. Never overwrite it with
  `brew bundle dump` — that would include transitive dependencies and pollute
  the list. Only add entries for packages you explicitly want on any new system.
- **Format:** Use standard Brewfile syntax: `brew`, `cask`, `tap`, `mas`.
  Group entries under `# === Section ===` comments.
- **No upgrades on install:** `brew/install.sh` passes `--no-upgrade` to
  `brew bundle`. Upgrading existing packages is a separate, intentional step
  (`brew upgrade`). This keeps the install script safe to re-run at any time.
- **tmuxinator:** Installed as a Ruby gem via the Homebrew-managed Ruby
  (`brew install ruby` + `gem install tmuxinator`). The install script handles
  this automatically after `brew bundle`. Do not add tmuxinator to the Brewfile
  directly — it is not a Homebrew formula.
- **Script is run from repo root:** Always invoke as `bash brew/install.sh`.
  Do not `cd brew/` first — the script resolves the Brewfile path relative to
  its own location.

---

## Naming Conventions

- Config files use a leading underscore prefix (`_vimrc`, `_tmux.conf`) so
  they are distinguishable from their symlink targets and sort together.
- New config files added to the repo should follow the same `_<name>` pattern.
- Do not commit Vim plugins to this repo; declare them in `_vimrc` via vim-plug.
- tmux plugins in `tmux/plugins/` are shallow clones tracked by this repo.
  Update them by re-cloning at a newer tag and committing.

---

## Editing This Repository

- **Sandbox boundary:** All changes must stay within this repository
  (`~/Projects/dotfiles/`). Never create, modify, or delete files outside
  the repo tree. Symlink targets in `$HOME` are managed by the user, not
  by the agent.
- **Never commit** editor swap files, `.DS_Store`, or other OS artifacts.
  The `.gitignore` currently only excludes `.netrwhist`; add new patterns as
  needed.
- When adding a new dotfile, update `README.md` with the corresponding
  `ln -s` command.
- Prefer atomic commits: one logical change per commit (e.g., "add
  vim-surround plugin" or "remap tmux split keys").
