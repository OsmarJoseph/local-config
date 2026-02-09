# AGENTS.md

## Project Overview

Personal dotfiles repository for a macOS development environment. Managed with
**GNU Stow** (symlink farm manager). No build system, test framework, or CI
pipeline. The owner primarily works with TypeScript/React and uses a
terminal-centric workflow (Neovim + tmux + Ghostty).

## Repository Structure

```
dotfiles/
  stow                   # Lists stow-managed directories
  aerospace/             # AeroSpace tiling window manager (TOML)
  alacritty/             # Alacritty terminal emulator (TOML)
  bash/                  # Shell config: .zshrc, .bash_aliases, scripts/
  gh/                    # GitHub CLI config (YAML)
  ghostty/               # Ghostty terminal emulator config
  karabiner/             # Karabiner-Elements keyboard remapping (JSON)
  nvim/                  # Neovim configuration (Lua, lazy.nvim)
  tmux/                  # tmux config
```

Each top-level directory mirrors `$HOME` with a `.config/` prefix. Running
`stow <dir>` from the repo root creates symlinks (e.g., `stow nvim` links
`~/.config/nvim`).

**Stow-managed directories:** aerospace, ghostty, gh, karabiner, nvim, tmux

## Commands

### Deploying Configuration

```bash
# Deploy a single config (from repo root)
stow <directory>        # e.g. stow nvim

# Remove a stowed config
stow -D <directory>     # e.g. stow -D nvim

# Re-stow (remove then re-link)
stow -R <directory>
```

### Neovim

```bash
# Open Neovim (aliased)
n                       # alias for nvim

# Reload config from within Neovim
:source ~/.config/nvim/init.lua    # or <leader><CR>

# Sync plugins (lazy.nvim)
:Lazy sync

# Format Lua files with StyLua
stylua <file>.lua

# Format TS/JS files with Prettier
:FormatWithPrettier     # from within Neovim

# Sort imports in TS/JS
:Sort                   # from within Neovim

# Type-check TypeScript projects (configured in Neovim)
# makeprg is set to: NODE_OPTIONS="--max_old_space_size=4096" yarn tsc
:make
```

### tmux

```bash
# Reload tmux config
tmux source-file ~/.config/tmux/tmux.conf   # or prefix + r

# Install tmux plugins (TPM)
# prefix + I (capital i)
```

### Shell

```bash
# After editing .zshrc or .bash_aliases
source ~/.zshrc
```

## There Are No Tests

This is a configuration-only repository. There are no test files, test
frameworks, or test commands.

## Code Style Guidelines

### Lua (Neovim Config)

- **Formatter:** StyLua (`.stylua.toml` at `nvim/.config/nvim/`)
- **Indent:** 2 spaces (no tabs)
- **Module structure:** All Lua modules live under `lua/josean/`
  - `core/` -- options, keymaps, colorscheme
  - `plugins/` -- one file per plugin
  - `plugins/lsp/` -- LSP-specific configs
- **Imports:** Use `require("josean.<module>")` with dot notation for paths
- **Safe imports for plugins:** Use `pcall(require, "module")` with early return
  on failure (see `telescope.lua` for the pattern)
- **Local aliases:** Assign commonly-used globals to locals at top of file:
  ```lua
  local opt = vim.opt
  local keymap = vim.keymap
  ```
- **Comments:** Use `--` for single-line; section headers use `-----` dividers
- **Keymap style:** `keymap.set(mode, lhs, rhs, opts)` -- always provide
  descriptive comments on the same line or above
- **String quotes:** Double quotes for strings
- **Trailing commas:** Used in tables
- **Plugin declarations (lazy.nvim):** In `plugins-setup.lua`, each plugin is
  either a string (`"author/plugin"`) or a table with config options
- **Return values:** Plugin config files that expose values use
  `return { key = value }` at end of file
- **Type annotations:** Use `---@type`, `---@param`, `---@return` LuaDoc
  annotations where appropriate

### Shell (Zsh/Bash)

- **Shell:** Zsh with oh-my-zsh, Powerlevel10k, vi mode
- **Aliases:** Defined in `.bash_aliases`, sourced by `.zshrc`
- **Scripts:** Stored in `bash/scripts/`, added to `$PATH` via `~/scripts`
- **Quoting:** Use double quotes for variable expansion, single quotes for
  literal strings
- **Functions:** Use `function_name() { ... }` syntax

### TOML (Aerospace, Alacritty)

- Standard TOML formatting
- Grouped by sections with blank lines between groups

### JSON (Karabiner)

- Machine-generated; do not hand-edit the main `karabiner.json`
- Custom modifications go in `assets/complex_modifications/`

### General Conventions

- **Indentation:** 2 spaces universally (Lua, shell, TOML, JSON)
- **Line width:** No hard wrap; editor has `wrap = false`
- **Colorscheme:** tokyonight-night (used across Neovim, tmux, fzf, Ghostty)
- **Naming:** snake_case for Lua variables and functions; kebab-case for
  shell script filenames
- **Error handling (Lua):** Use `pcall` for plugin requires that may fail;
  return early rather than nesting in conditionals
- **No secrets in repo:** Secrets are sourced from `~/secrets.sh` (not tracked)

## Editor Settings (for reference)

These are the Neovim settings that reflect the owner's coding preferences
(configured in `nvim/.config/nvim/lua/josean/core/options.lua`):

- Tab width: 2, expand tabs to spaces
- Relative line numbers with absolute number on cursor line
- Smart case search (case-insensitive unless uppercase is used)
- System clipboard integration (`unnamedplus`)
- No swap/backup files; persistent undo enabled
- Spell checking: en_us + pt (Portuguese)
- Split: new vertical splits go right, horizontal splits go below

## Key Tools in the Environment

| Tool              | Purpose                              |
|-------------------|--------------------------------------|
| GNU Stow          | Symlink management for dotfiles      |
| Neovim (lazy.nvim)| Editor with ~40 plugins              |
| tmux (TPM)        | Terminal multiplexer                  |
| Ghostty           | Primary terminal emulator            |
| AeroSpace         | Tiling window manager (macOS)        |
| fzf + fd + rg     | Fuzzy finding and search             |
| StyLua            | Lua formatter                        |
| Prettier          | TS/JS/Markdown formatter             |
| Mason (Neovim)    | LSP/linter/formatter installer       |
| typescript-tools  | TS language server (Neovim plugin)   |
| Karabiner-Elements| Keyboard remapping                   |
