# dotfiles

Personal configuration files for Neovim, Vim, tmux, Spacemacs, and zsh.

## Files

| File / Directory | Symlink target | Purpose |
|------------------|---------------|---------|
| `nvim/` | `~/.config/nvim/` | Neovim config — LazyVim, obsidian.nvim |
| `_vimrc` | `~/.vimrc` | Vim config — vim-plug, gruvbox, fzf, LSP |
| `_tmux.conf` | `~/.tmux.conf` | tmux config — C-a prefix, Catppuccin Mocha |
| `_spacemacs` | `~/.spacemacs` | Spacemacs config — Evil mode, Clojure, org-mode |
| `_zshrc` | `~/.zshrc` | zsh config — oh-my-zsh, NVM, Homebrew PATH |

## Setup

```sh
ln -s ~/Projects/dotfiles/nvim ~/.config/nvim
ln -s ~/Projects/dotfiles/_vimrc ~/.vimrc
ln -s ~/Projects/dotfiles/_tmux.conf ~/.tmux.conf
ln -s ~/Projects/dotfiles/_spacemacs ~/.spacemacs
ln -s ~/Projects/dotfiles/_zshrc ~/.zshrc
```

If `~/.config/nvim` already exists, remove or back it up before symlinking.
Open Neovim once — lazy.nvim bootstraps itself and installs all plugins automatically.

If oh-my-zsh is not installed, the shell will print a reminder and abort.
Install it manually first:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Open Vim once — vim-plug and all plugins install automatically.

## Neovim

The `nvim/` directory is a [LazyVim](https://lazyvim.github.io/) starter with custom plugins layered on top.
Symlink it to `~/.config/nvim` (see Setup above) and open Neovim — lazy.nvim will install everything on first launch.

### Plugins

| Plugin | Purpose |
|--------|---------|
| [LazyVim](https://github.com/LazyVim/LazyVim) | Neovim config framework — LSP, treesitter, telescope, and more |
| [obsidian.nvim](https://github.com/epwalsh/obsidian.nvim) | Obsidian vault integration for Neovim |

### obsidian.nvim

Configured in `nvim/lua/plugins/obsidian.lua`. The vault is located at:

```
~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Marco
```

The plugin loads automatically when a markdown file inside the vault is opened.

**Commands:**

| Command | Action |
|---------|--------|
| `:ObsidianNew [TITLE]` | Create a new note |
| `:ObsidianQuickSwitch` | Fuzzy-search notes by name |
| `:ObsidianSearch [QUERY]` | Full-text search across the vault |
| `:ObsidianToday` | Open or create today's daily note |
| `:ObsidianYesterday` / `:ObsidianTomorrow` | Open daily notes for adjacent days |
| `:ObsidianFollowLink` | Follow link under cursor |
| `:ObsidianBacklinks` | List all notes linking to the current one |
| `:ObsidianTags [TAG]` | Browse all notes with a given tag |
| `:ObsidianTemplate` | Insert a template into the current note |
| `:ObsidianLink` | Link selected text to an existing note |
| `:ObsidianRename [NEWNAME]` | Rename note and update all backlinks |
| `:ObsidianPasteImg` | Paste clipboard image into note |
| `:ObsidianOpen` | Open current note in the Obsidian app |

**Key bindings (active inside vault markdown files):**

| Key | Action |
|-----|--------|
| `gf` | Follow markdown/wiki link under cursor |
| `<CR>` | Smart action: follow link or toggle checkbox |
| `<leader>ch` | Toggle checkbox state |

**Requirements:** `ripgrep` must be on `$PATH` (included in `brew/Brewfile`).
macOS only: install `pngpaste` (`brew install pngpaste`) to enable `:ObsidianPasteImg`.

## Homebrew packages

`brew/Brewfile` contains the curated list of explicitly installed packages.
Edit it by hand to add or remove packages — do not generate it with `brew bundle dump`.

Install all missing packages on a new system:

```sh
bash brew/install.sh
```

Already-installed packages are skipped silently. Existing package versions are
not upgraded — run `brew upgrade` separately if needed.

The install script also installs the `tmuxinator` Ruby gem via the
Homebrew-managed Ruby automatically.

## Shell tools

### lazygit

[lazygit](https://github.com/jesseduffield/lazygit) is a terminal UI for git. Installed via Homebrew and integrated into Neovim via `nvim/lua/plugins/lazygit.lua`.

| How | Command |
|-----|---------|
| Terminal | `lazygit` |
| Neovim | `<leader>gg` |

### delta

[delta](https://github.com/dandavison/delta) is a syntax-highlighted pager for `git diff`, `git log`, and `git show`. Active via `GIT_PAGER` in `_zshrc` — no extra config needed to get started.

To customize further, add a `[delta]` section to `~/.gitconfig`.

### eza

[eza](https://github.com/eza-community/eza) is a modern `ls` replacement with colors, icons, and git status.

| Alias | Command | Description |
|-------|---------|-------------|
| `ls` | `eza --icons` | Default listing with file-type icons |
| `ll` | `eza -la --icons --git` | Long listing with hidden files and git status |
| `lt` | `eza --tree --icons` | Recursive tree view |

### zoxide

[zoxide](https://github.com/ajeetdsouza/zoxide) is a smarter `cd` that learns your most-visited directories. Replaces autojump.

| Command | Action |
|---------|--------|
| `z <partial>` | Jump to the most frecent matching directory |
| `zi` | Interactive selection with fzf |
| `z -` | Go to the previous directory |

## Mole

[Mole](https://github.com/tw93/mole) is a macOS system health tool for cleaning, optimizing, and monitoring your Mac. The CLI command is `mo`.

| Command | Action |
|---------|--------|
| `mo` | Main menu (interactive) |
| `mo clean` | Free up disk space (caches, logs, temp files) |
| `mo uninstall` | Remove apps completely with leftover cleanup |
| `mo optimize` | Check and maintain system health |
| `mo analyze` | Explore disk usage |
| `mo status` | Monitor system health |
| `mo purge` | Remove old project build artifacts |
| `mo installer` | Find and remove installer files |
| `mo touchid` | Configure Touch ID for sudo |

Most commands accept `--dry-run` to preview changes before applying them.

## Apfel

[Apfel](https://github.com/apfelai/apfel) runs Apple Intelligence from the command line. Requires macOS with Apple Intelligence enabled.

| Command | Action |
|---------|--------|
| `apfel "<prompt>"` | Send a single prompt |
| `apfel --stream "<prompt>"` | Stream a single response |
| `apfel --chat` | Interactive conversation |
| `apfel -f <file> "<prompt>"` | Attach file content to prompt |
| `apfel -o json "<prompt>"` | Output as JSON |
| `apfel --serve` | Start OpenAI-compatible HTTP server (port 11434) |

**Examples:**

```sh
apfel "What is the capital of Austria?"
apfel -f code.swift "Explain this code"
apfel -s "You are a pirate" --chat
cat README.md | apfel "Summarize this"
apfel --serve --port 3000 --cors
```

## tmuxinator

[tmuxinator](https://github.com/tmuxinator/tmuxinator) manages named tmux
session layouts defined as YAML files in `~/.config/tmuxinator/`.

| Command | Action |
|---------|--------|
| `mux list` / `muxl` | List saved projects |
| `mux open <name>` / `muxo <name>` | Create or edit a project |
| `mux start <name>` / `muxs <name>` | Start a session |
| `mux stop <name>` | Stop a session |
| `mux new <name>` | Create a new project |
| `mux delete <name>` | Delete a project |

Project files live in `~/.config/tmuxinator/<name>.yml`. To track them in this
repo, symlink individual project files:

```sh
ln -s ~/Projects/dotfiles/tmuxinator/myproject.yml ~/.config/tmuxinator/myproject.yml
```

## Usage

```sh
vim file.txt        # open a file
vim .               # open current directory in NERDTree
vim /path/to/dir    # open a specific directory
```

When opening a directory, NERDTree launches automatically.

**Inside the NERDTree panel:**

| Key | Action |
|-----|--------|
| `Enter` / `o` | Open file or expand directory |
| `t` | Open in a new tab |
| `s` | Open in a vertical split |
| `i` | Open in a horizontal split |
| `go` / `gs` / `gi` | Preview (open without moving cursor to file) |
| `p` | Jump to parent directory |
| `P` | Jump to root |
| `u` | Move tree root one level up |
| `C` | Set selected directory as new root |
| `R` | Refresh the tree |
| `m` | Open file/directory menu (add, rename, delete, copy…) |
| `I` | Toggle hidden files |
| `q` | Close NERDTree |

**From anywhere in Vim:**

| Key | Action |
|-----|--------|
| `<Space>e` | Toggle NERDTree |
| `<Space>f` | Reveal current file in the tree |

## Buffers vs tabs

In Vim, open files are **buffers** — the preferred way to work with multiple
files. Tabs ("tab pages") exist but each one is a full window layout, not a
single file like in most editors.

**Buffers** (recommended for switching between files):

| Key | Action |
|-----|--------|
| `<C-n>` | Next buffer |
| `<C-p>` | Previous buffer |
| `<Space>b` | Pick buffer from fuzzy list (fzf) |
| `<Space>bd` | Delete (close) current buffer |
| `:ls` | List all open buffers |

**Tabs** (for separate window layouts):

| Key | Action |
|-----|--------|
| `t` | Open file in new tab (from NERDTree) |
| `gt` | Next tab |
| `gT` | Previous tab |
| `{n}gt` | Go to tab number `n` |
| `:tabnew` | Open a new empty tab |
| `:tabclose` | Close current tab |

## Key bindings (Vim)

| Key | Action |
|-----|--------|
| `<Space>p` | Fuzzy file finder (fzf) |
| `<Space>b` | Buffer switcher |
| `<Space>r` | Ripgrep search |
| `<Space>e` | Toggle NERDTree |
| `<Space>gs` | Git status (fugitive) |
| `<C-hjkl>` | Navigate splits |
| `gd` / `K` | LSP go-to-definition / hover |
| `<Space>sv` | Re-source vimrc |
