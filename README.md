# dotfiles

Personal configuration files for Vim, tmux, Spacemacs, and zsh.

## Files

| File | Symlink target | Purpose |
|------|---------------|---------|
| `_vimrc` | `~/.vimrc` | Vim config — vim-plug, gruvbox, fzf, LSP |
| `_tmux.conf` | `~/.tmux.conf` | tmux config — C-a prefix, Catppuccin Mocha |
| `_spacemacs` | `~/.spacemacs` | Spacemacs config — Evil mode, Clojure, org-mode |
| `_zshrc` | `~/.zshrc` | zsh config — oh-my-zsh, NVM, Homebrew PATH |

## Setup

```sh
ln -s ~/Projects/dotfiles/_vimrc ~/.vimrc
ln -s ~/Projects/dotfiles/_tmux.conf ~/.tmux.conf
ln -s ~/Projects/dotfiles/_spacemacs ~/.spacemacs
ln -s ~/Projects/dotfiles/_zshrc ~/.zshrc
```

If oh-my-zsh is not installed, the shell will print a reminder and abort.
Install it manually first:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Open Vim once — vim-plug and all plugins install automatically.

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
