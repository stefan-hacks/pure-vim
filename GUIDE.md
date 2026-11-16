# pure-vim — Complete User Guide

This guide documents **every** feature in the `pure-vim` configuration, how it works, and how to use it. It is designed to stay in sync with the `vimrc` as the project grows.

---

## Table of Contents

1. [Installation & Requirements](#installation--requirements)
2. [Terminal Layer](#terminal-layer)
3. [Leader Key & Philosophy](#leader-key--philosophy)
4. [Core Settings](#core-settings)
5. [User Interface](#user-interface)
6. [Soft Wrapping System](#soft-wrapping-system)
7. [Catppuccin Theme Engine](#catppuccin-theme-engine)
8. [Search System](#search-system)
9. [Indentation Engine](#indentation-engine)
10. [Infrastructure Syntax Detection](#infrastructure-syntax-detection)
11. [Inline Syntax Fallbacks](#inline-syntax-fallbacks)
12. [Commenting Engine](#commenting-engine)
13. [File Persistence](#file-persistence)
14. [Window & Buffer Management](#window--buffer-management)
15. [Netrw File Explorer](#netrw-file-explorer)
16. [Mode-Colored Statusline](#mode-colored-statusline)
17. [Exit Behavior](#exit-behavior)
18. [Modular Architecture](#modular-architecture)
19. [Fuzzy Finding (fzf)](#fuzzy-finding-fzf)
20. [Language Modules (ftplugin)](#language-modules-ftplugin)

---

## Installation & Requirements

**Requirements:** Vim 9.1+ on any Linux system. No plugins. No internet.

**Install:**

```bash
curl -fsSL https://raw.githubusercontent.com/stefan-hacks/pure-vim/main/vimrc -o ~/.vimrc
```

On first launch, Vim silently creates:
- `~/.vim/undo` — persistent undo history
- `~/.vim/swap` — swap files
- `~/.vim/backup` — backup files

---

## Terminal Layer

The vimrc detects Kitty (`&term ==# 'xterm-kitty'`) and applies terminal-specific sequences. On non-Kitty terminals these are simply skipped.

| Setting | Purpose |
|---|---|
| `t_TI = ""` | Disables kitty keyboard protocol (prevents Esc weirdness) |
| `t_TE = ""` | Disables keyboard protocol cleanup |
| `t_ti / t_te` | Clean alternate screen enter/exit (`\e[?1049h/l`) |
| `t_8f / t_8b` | Truecolor RGB foreground/background sequences |
| `t_Cs / t_Ce` | Undercurl on/off (`\e[4:3m` / `\e[4:0m`) |
| `t_8u` | Undercurl color (`\e[58:2:%lu:%lu:%lum`) |
| `t_SI` | Insert mode cursor: bar (`\e[6 q`) |
| `t_EI` | Normal mode cursor: block (`\e[2 q`) |
| `t_SR` | Replace mode cursor: underline (`\e[4 q`) |

**What this means for you:**
- Colors look correct in truecolor terminals.
- Undercurls appear for spell errors if you enable spell checking.
- Cursor shape changes based on mode.
- Vim exits cleanly without leaving keyboard protocol residue.

---

## Leader Key & Philosophy

```vim
let mapleader = " "
```

The **spacebar** is the leader key. All custom commands are namespaced behind it so they don't collide with native Vim bindings.

The philosophy: leader mappings are for **actions** you perform repeatedly (save, quit, explore, toggle). Complex editing operations (commenting, search clearing) get their own top-level mappings because you use them hundreds of times per session.

---

## Core Settings

| Setting | Value | Why |
|---|---|---|
| `nocompatible` | — | Breaks compatibility with ancient vi limitations |
| `encoding` | `utf-8` | Unicode everywhere |
| `hidden` | — | Allows switching buffers without saving first |
| `autoread` | — | Auto-reloads files changed outside Vim |
| `updatetime` | `250` | Faster CursorHold events (affects auto-no-hlsearch) |
| `timeoutlen` | `600` | Time to complete a mapped sequence |
| `ttimeoutlen` | `20` | Time to complete a keycode sequence |
| `backspace` | `indent,eol,start` | Normal backspace behavior |
| `mouse` | `a` | Mouse in all modes |
| `history` | `1000` | Large command/search history |
| `belloff` | `all` | Never beep |
| `clipboard` | `unnamedplus` | Yank to system clipboard (if `+clipboard` is compiled) |

---

## User Interface

| Setting | Purpose |
|---|---|
| `number relativenumber` | Absolute + relative line numbers |
| `cursorline` | Highlight current line |
| `cursorlineopt=number,screenline` | Highlight number column + screen line only |
| `scrolloff=8` | Keep 8 lines visible above/below cursor |
| `sidescrolloff=8` | Keep 8 columns visible left/right |
| `signcolumn=yes` | Always reserve gutter space |
| `laststatus=2` | Always show statusline |
| `noshowmode` | Don't show `-- INSERT --` (statusline handles it) |
| `showcmd` | Show partial commands in bottom-right |
| `wildmenu` | Command-line completion menu |
| `wildmode=longest:full,full` | Complete longest match, then cycle |
| `wildoptions=pum` | Popup menu for wildmenu (Vim 9+ feature) |
| `splitbelow splitright` | Splits open below and to the right |
| `synmaxcol=500` | Stop syntax highlighting after 500 columns (perf) |
| `list` | Show invisible characters |
| `listchars` | Tab: `» `, Trail: `·`, Nbsp: `␣` |
| `fillchars` | Vertical split: `│`, Fold: `─`, EOB: space |

---

## Soft Wrapping System

**Default:** Soft wrapping is ON. Lines wrap visually without inserting newline characters.

```vim
set wrap
set linebreak
set breakindent
set display+=lastline
set textwidth=0 wrapmargin=0
set formatoptions-=t
set nojoinspaces
silent! set smoothscroll
```

An `augroup SoftWrap` enforces `wrap linebreak textwidth=0 wrapmargin=0 formatoptions-=t` on **every** `FileType` event. Many ftplugins (like `gitcommit`) force `textwidth` — this overrides them.

| Mapping | Action |
|---|---|
| `<Space>z` | Toggle `wrap` on/off |
| `j` / `k` | Wrap-aware: move by screen line unless given a count |
| `0` / `$` | Wrap-aware: go to start/end of screen line when `wrap` is on |

**Why soft wrap?** You can read long lines (logs, JSON, prose) without corrupting the underlying file with inserted hard returns.

---

## Catppuccin Theme Engine

The theme is built entirely in Vim script. No `colors/` directory. No external files.

### How it works

A dictionary `s:palettes` holds two complete color maps:
- `mocha` — dark theme (default)
- `latte` — light theme

The `s:H(group, fg, bg, [attr])` helper resolves palette names to hex codes and sets `guifg`/`guibg`/`gui`/`cterm`. This is how every highlight group is applied.

### Terminal ANSI colors

`g:terminal_ansi_colors` maps the 16 ANSI slots to Catppuccin colors so terminal windows inside Vim (`:terminal`) match the theme.

### What gets colored

- **Editor chrome:** Normal, CursorLine, LineNr, SignColumn, Visual, Search, MatchParen, Folded, Pmenu, TabLine, etc.
- **Syntax:** All 30+ standard highlight groups (Comment, String, Function, Keyword, Type, etc.)
- **Infra tweaks:** YAML block keys, JSON keys → colored as `Function` (blue) for readability
- **Statusline segments:** Mode-colored segments (`StlNormal`, `StlInsert`, etc.)
- **Diff:** DiffAdd, DiffDelete, DiffChange, DiffText with custom subtle backgrounds
- **Spell:** Undercurl with language-specific colors (red/yellow/blue/green)

### Usage

| Mapping | Action |
|---|---|
| `<Space>t` | Toggle Mocha ↔ Latte |

---

## Search System

### Settings

```vim
set incsearch    " Show matches as you type
set hlsearch     " Highlight all matches
set ignorecase   " Case-insensitive search
set smartcase    " Case-sensitive if query contains uppercase
```

### Manual clear

| Mapping | Action |
|---|---|
| `<Esc><Esc>` | Clear `hlsearch` highlights immediately |

### Auto-clear

A state machine tracks whether the last movement was a search command:
- `n`, `N`, `*`, `#`, `g*`, `g#`, `/`, `?` set `s:from_search = 1`
- `CursorMoved` checks: if `v:hlsearch` is active and the movement was NOT a search command, it fires `:nohlsearch`
- `InsertEnter` also clears highlights

**Result:** Highlights disappear automatically when you start editing or navigate away from search results. They reappear when you press `n`/`N` again.

---

## Indentation Engine

### Defaults

```vim
set expandtab        " Spaces, not tabs
set tabstop=4        " Tab displays as 4 columns
set shiftwidth=4     " >/< shift by 4
set softtabstop=4    " Tab key inserts 4 spaces
set smartindent      " Auto-indent new lines
set autoindent       " Copy indent from previous line
```

### Filetype-specific overrides

| Filetypes | Settings |
|---|---|
| `nix`, `yaml`, `json`, `hcl`, `terraform`, `jinja`, `html`, `css`, `javascript`, `lua` | `ts=2 sw=2 sts=2` |
| `yaml` | `indentkeys-=0#` (don't re-indent on `#`) |
| `make`, `go` | `noexpandtab` (real tabs required) |

---

## Infrastructure Syntax Detection

The `InfraFiletypes` autocmd group sets filetypes for files Vim doesn't know about by default.

### Nix ecosystem
- `*.nix` → `nix`
- `flake.lock` → `json`

### HashiCorp stack
- `*.tf`, `*.tfvars` → `terraform` (falls back to `hcl` if `syntax/terraform.vim` missing)
- `*.hcl`, `*.nomad` → `hcl`

### Containers
- `Dockerfile*`, `*.dockerfile`, `Containerfile*` → `dockerfile`

### CI/CD & Automation
- `Jenkinsfile*` → `groovy`
- `Vagrantfile` → `ruby`
- `*.pp` → `puppet`

### systemd
- `*.service`, `*.timer`, `*.socket`, `*.mount`, `*.automount`, `*.swap`, `*.path`, `*.slice`, `*.scope`, `*.target` → `systemd`
- `*/systemd/network/*.network`, `*.netdev`, `*.link` → `systemd`
- `*/containers/systemd/*` (Podman quadlets) → `systemd`

### Ansible
- `*/playbooks/*.yml`, `*/roles/*/tasks/*.yml`, `*/roles/*/handlers/*.yml`, `*/group_vars/*`, `*/host_vars/*`, `playbook*.yml`, `site.yml` → `yaml.ansible`

### Services
- `*/nginx/*.conf`, `*/nginx/conf.d/*`, `*/nginx/sites-*/*` → `nginx`
- `*/sudoers.d/*` → `sudoers`
- `*/ssh/ssh_config.d/*`, `*/.ssh/config.d/*` → `sshconfig`
- `*/ssh/sshd_config.d/*` → `sshdconfig`
- `*.nft`, `nftables.conf` → `nftables`

### Environment files
- `.env`, `.env.*`, `*.env` → `sh`

### Jinja templates
- `*.j2` → Strips `.j2`, detects filetype from underlying name (e.g., `nginx.conf.j2` → `nginx`), then re-runs filetype detection

---

## Inline Syntax Fallbacks

When Vim's runtime doesn't include syntax files (common on minimal servers), these functions provide basic highlighting:

### Nix (`s:NixSyntax()`)

Covers: keywords (`let`, `in`, `if`, `then`, `else`, `rec`, `with`, `inherit`, `assert`, `or`, `import`), booleans, builtins, numbers, attribute names, paths, URIs, operators (`++`, `//`, `->`, `&&`, `||`, `!=`, `==`), escapes, string interpolation (`${...}`), double-quoted strings, and indented strings (`''...''`).

### Ansible Jinja (`s:AnsibleSyntax()`)

Adds inline Jinja markers inside `yaml.ansible` buffers:
- `{{ ... }}` → `PreProc`
- `{% ... %}` → `Statement`
- `{# ... #}` → `Comment`

These run as `Syntax` autocmds so they apply even when the base YAML syntax is already loaded.

---

## Commenting Engine

The most complex subsystem in pure-vim. It provides `tpope/vim-commentary` parity without any plugin.

### How it works

1. **Comment strings** — The `commentstring` option tells Vim how to comment one line. An autocmd sets it for all infrastructure filetypes to `# %s` (or `// %s` for groovy, `{# %s #}` for jinja).

2. **Block markers** — A dictionary `s:block` maps filetypes to `[opener, closer]` pairs. Example: `nix` → `/*`, `*/`; `html` → `<!--`, `-->`; `lua` → `--[[`, `]]`.

3. **Toggle logic** — Both `s:ToggleLines()` and `s:ToggleBlock()` are idempotent:
   - If ALL selected lines are already commented → uncomment them
   - Otherwise → comment them
   - Both preserve indentation and window view

### Line comments (`gcc` family)

| Mapping | Action |
|---|---|
| `gcc` | Toggle comment on current line (accepts count: `5gcc`) |
| `gc{motion}` | Toggle line comments over motion (e.g., `gcap`, `gcip`, `gc5j`) |
| `gc` | Toggle line comments on visual selection |

### Block comments (`gbc` family)

| Mapping | Action |
|---|---|
| `gbc` | Toggle block comment on current line (accepts count: `3gbc` wraps 3 lines in one block) |
| `gb{motion}` | Toggle block comment over motion (e.g., `gbap`, `gb}`) |
| `gb` | Toggle block comment on visual selection |

**Block fallback:** If a filetype has no block markers defined (e.g., `sh`, `python`), `gbc`/`gb` fall back to line comments automatically.

### Block markers table

| Filetype(s) | Opener | Closer |
|---|---|---|
| c, cpp, java, go, rust, javascript, typescript, css, scss, php, sql, nix, terraform, hcl, groovy, puppet | `/*` | `*/` |
| html, xml, markdown | `<!--` | `-->` |
| lua | `--[[` | `]]` |
| jinja | `{#` | `#}` |
| haskell | `{-` | `-}` |

---

## File Persistence

### Undo / Swap / Backup

```vim
set undofile
set undodir=~/.vim/undo//
set directory=~/.vim/swap//
set backupdir=~/.vim/backup//
```

The double-slash (`//`) in paths tells Vim to store files using their full path as filename, preventing collisions between files with the same name in different directories.

### Restore cursor position

When reopening a file, Vim jumps to the last known cursor position (`'"` mark) if it's within the file bounds.

### Trim trailing whitespace

On `BufWritePre`, all trailing whitespace is stripped — except for `markdown` and `diff` files where trailing spaces are meaningful.

---

## Window & Buffer Management

| Mapping | Action |
|---|---|
| `<Space>w` | Save file (`:w`) |
| `<Space>q` | Quit (`:q`) |
| `<Space>\` | Vertical split (`:vsplit`) |
| `<Space>-` | Horizontal split (`:split`) |
| `<Space>b` | List buffers, prompt to switch (`:ls` → `:b`) |
| `<Space>f` | Find file (`:find *`) |
| `<Space>h/j/k/l` | Move to window left/down/up/right |

### Visual mode helpers

| Mapping | Action |
|---|---|
| `J` / `K` | Move selected lines down/up, preserving selection and re-indenting |
| `<` / `>` | Indent/outdent, then reselect the same lines |

### Convenience commands

| Command | Action |
|---|---|
| `:W` | Alias for `:w` (common typo) |
| `:Q` | Alias for `:q` (common typo) |
| `:w!!` | Write with sudo (`:w !sudo tee % >/dev/null`) |

---

## Netrw File Explorer

Netrw is Vim's built-in file explorer. It is configured as a sidebar tree:

```vim
let g:netrw_banner = 0        " Hide the help banner
let g:netrw_liststyle = 3     " Tree view
let g:netrw_winsize = 25      " 25% of window width
```

| Mapping | Action |
|---|---|
| `<Space>e` | Open `Lexplore` (left sidebar file tree) |

**Netrw basics:**
- `Enter` — Open file or directory
- `t` — Open in new tab
- `v` — Open in vertical split
- `i` — Cycle list styles
- `s` — Cycle sort order
- `d` — Make directory
- `%` — Create new file
- `D` — Delete file/directory
- `R` — Rename
- `q` — Close netrw window

---

## Mode-Colored Statusline

The statusline is built from scratch and changes color based on the current mode.

### Structure

```
┌────────┬──────────────────────────────┬──────────────────────────────┬────────┐
│  MODE  │ filename [modified][readonly]│     filetype │ encoding     │ pos    │
│ color  │                              │         │ format         │        │
└────────┴──────────────────────────────┴──────────────────────────────┴────────┘
```

### Mode colors

| Mode | Color | Highlight Group |
|---|---|---|
| Normal | Blue | `StlNormal` |
| Insert | Green | `StlInsert` |
| Visual / V-Line / V-Block | Purple | `StlVisual` |
| Replace | Red | `StlReplace` |
| Command | Peach | `StlCommand` |
| Terminal | Green | `StlInsert` |
| Select | Purple | `StlVisual` |

### How it updates

The `ModeChanged` autocommand triggers `redrawstatus` every time the mode changes, so the color switches instantly.

---

## Exit Behavior

When Vim exits, it resets the terminal cursor shape to the default (blinking block) by writing `\e[0 q` to `/dev/tty`:

```vim
autocmd VimLeave * silent! call writefile(["\e[0 q"], '/dev/tty', 'b')
```

This prevents the terminal from leaving the cursor as a bar or underline after Vim closes.

---

## Modular Architecture

`pure-vim` supports optional modules that auto-load if present. The core `vimrc` is self-contained and works standalone.

### Directory layout

```
~/.vim/
├── vimrc              # Core config (mandatory)
├── core/              # Optional feature modules
│   └── fzf.vim        # Floating popup fzf + bat
└── ftplugin/          # Language-specific modules
    ├── sh.vim
    ├── python.vim
    └── ...
```

### How modules load

At the end of `vimrc`, a loader:

1. Sets `g:pure_vim_root` to the repo directory
2. Appends the repo path to `runtimepath` so `ftplugin/` is discovered natively
3. Sources any files in `core/` that exist (`fzf.vim`, `git.vim`, `format.vim`)

All loads are guarded with `filereadable()` — missing files produce no errors.

### `b:undo_ftplugin` convention

Every `ftplugin/*.vim` defines `b:undo_ftplugin` so Vim can cleanly revert settings when switching buffers.

---

## Fuzzy Finding (fzf)

The `core/fzf.vim` module provides floating popup fzf integration using Vim 8.1+ `popup_create()` and `term_start()`.

### Requirements

- `fzf` binary on `$PATH`
- `bat` binary for syntax-highlighted previews (optional but recommended)
- `rg` (ripgrep) for live grep (optional)

### Features

| Function | Leader Key | Description |
|---|---|---|
| `s:FzfFiles()` | `<Space>F` | Fuzzy file finder with bat preview |
| `s:FzfRipgrep()` | `<Space>s` | Live grep with bat line preview |
| `s:FzfRipgrep(word)` | `<Space>S` | Grep word under cursor |
| `s:FzfBuffers()` | `<Space>b` | Fuzzy buffer switcher |
| `s:FzfCommands()` | `<Space>c` | Fuzzy `:command` palette |
| `s:FzfHelptags()` | `<Space>h` | Fuzzy help tag finder |

### How it works

`FzfPopup(cmd, sink)` creates a centered popup (80% width × 75% height), starts `fzf` inside a hidden terminal buffer attached to the popup, and calls the `sink` callback with the selected line when the process exits.

If `fzf` or `rg` are missing, commands echo a message instead of failing.

---

## Language Modules (ftplugin)

Each `ftplugin/{lang}.vim` is loaded automatically by Vim when opening a file of that type. Modules use `setlocal`, `nnoremap <buffer>`, and define `b:undo_ftplugin`.

### Predictive input strategy (zero-plugin)

1. **`omnifunc`** — Vim's built-in language-aware completion (`<C-x><C-o>`)
2. **`syntaxcomplete#Complete`** — syntax-driven completion for languages without native omnifunc
3. **Keyword completion** — `<C-n>` / `<C-p>` from current buffer and includes
4. **Tags** — `ctags -R`, navigate with `<C-]>` and `<C-t>`
5. **Include-search** — `[i`, `]i`, `<C-w>i` after setting `include` and `includeexpr`

### Common buffer-local mappings

| Mapping | Action |
|---|---|
| `<Space>m` | Lint (`makeprg` → quickfix) |
| `<Space>=` | Format (`formatprg`) |
| `<Space>r` | Run in bottom terminal |
| `<Space>i` | Organize imports (Go) |
| `<Space>t` | Run tests (Go, Rust) |
| `<Space>db` | Launch Termdebug (C, C++) |

### Language-specific details

**bash/sh**
- Lint: `shellcheck` (gcc format)
- Format: `shfmt -i 4 -ci`

**nix**
- Lint: `statix check` → fallback `nix-instantiate --parse`
- Format: `alejandra` → `nixfmt` → `nixpkgs-fmt`

**yaml / yaml.ansible**
- Lint: `yamllint` / `ansible-lint`
- Format: `yamlfmt` / `prettier`

**python**
- Lint: `ruff check` → `flake8`
- Format: `black` → `autopep8`
- `omnifunc=python3complete#Complete`

**go**
- Lint: `staticcheck` → `golint`
- Format: `gofmt` → `goimports`
- Uses real tabs (`noexpandtab`)

**rust**
- Lint: `cargo clippy` → `rustc`
- Format: `rustfmt`

**c / cpp**
- Lint/Compile: `clang`/`gcc`, `clang++`/`g++`
- Format: `clang-format`
- Debug: native `Termdebug`

**javascript / typescript**
- Lint: `eslint` / `tsc --noEmit`
- Format: `prettier`

**lua**
- Lint: `luac -p`
- Format: `stylua`

**json**
- Validate: `jq .`
- Format: `jq` → `python3 -m json.tool`

**markdown**
- Format: `prettier --parser markdown` → `mdformat`
- Preserves trailing whitespace (used for line breaks)

---

*This guide is maintained alongside the `vimrc`. When features are added, this document is updated to reflect them.*
