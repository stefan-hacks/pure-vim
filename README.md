<div align="center">

# pure-vim

**A single `vimrc`. Zero plugins. Maximum capability.**

Built for Vim 9.1+ on any Linux system — just drop it in and start editing.

</div>

---

## What is this?

`pure-vim` is a carefully crafted, self-contained Vim configuration designed for infrastructure engineers, developers, and anyone who needs a powerful editing environment on machines where they can't (or won't) install plugins.

Everything you need — a modern color scheme, smart search, file exploration, custom commenting, infrastructure syntax support, and more — lives in **one file**.

No plugin manager. No external dependencies. No internet required.

---

## Features

### 🎨 Built-in Catppuccin Theme

Both **Mocha** (dark) and **Latte** (light) palettes are included as pure Vim script — no color files to download. Toggle anytime with `<Space>t`.

- Full syntax highlighting for all standard groups
- Custom infra tweaks (YAML/JSON keys colored as functions)
- Terminal ANSI color mapping for consistent 256-color fallback

### 🔍 Smart Search

- `hlsearch` auto-clears when you move the cursor away from a match
- Press `<Esc><Esc>` for instant manual clear
- Search commands (`n`, `N`, `*`, `#`, `/`, `?`) tracked intelligently

### 📝 Soft Wrapping (Display-Only)

Lines wrap visually without inserting actual newlines — perfect for reading logs and prose without corrupting files.

- `wrap` + `linebreak` + `breakindent`
- `textwidth=0` enforced across all filetypes (ftplugins can't override it)
- Toggle wrapping on/off with `<Space>z`

### 🗂️ Infrastructure Syntax Support

Automatic filetype detection for 20+ formats sysadmins and DevOps engineers use daily:

| Category | Filetypes |
|---|---|
| Config | `nix`, `flake.lock`, `hcl`, `terraform`, `nomad`, `toml` |
| Containers | `dockerfile`, `Containerfile` |
| CI/CD | `groovy` (Jenkinsfile) |
| Automation | `yaml.ansible`, `puppet`, `ruby` (Vagrantfile) |
| System | `systemd`, `networkd`, `nftables`, `sudoers` |
| Web/Proxy | `nginx`, `sshconfig`, `sshdconfig` |
| Templates | `jinja` (`.j2` with underlying filetype detection) |
| Env files | `.env`, `.env.*` |

Plus inline fallback syntax highlighting for **Nix** and **Ansible Jinja2** expressions when Vim's runtime files are absent.

### 💬 Custom Commenting System

Full-featured commenting without any plugin:

| Mapping | Action |
|---|---|
| `gcc` | Toggle line comment (accepts count: `3gcc`) |
| `gc{motion}` | Toggle line comments over motion (`gcap`, `gcip`) |
| `gc` | Toggle line comments in visual mode |
| `gbc` | Toggle block comment (accepts count: `3gbc`) |
| `gb{motion}` | Toggle block comments over motion (`gbap`, `gb}`) |
| `gb` | Toggle block comments in visual mode |

Block comment markers defined for: `c`, `cpp`, `java`, `go`, `rust`, `javascript`, `typescript`, `css`, `php`, `sql`, `nix`, `terraform`, `hcl`, `groovy`, `puppet`, `html`, `xml`, `markdown`, `lua`, `jinja`, `haskell`.

Line comment strings auto-configured for all infrastructure filetypes.

### 📂 Netrw File Explorer

- `<Space>e` opens `Lexplore` (left sidebar tree)
- Banner disabled, tree list style, 25% window width
- Pure Vim — no external file manager needed

### 📊 Mode-Colored Statusline

A custom statusline that changes color based on your current mode:

- **Blue** — Normal
- **Green** — Insert
- **Purple** — Visual
- **Red** — Replace
- **Peach** — Command-line

Updates instantly via the `ModeChanged` autocommand.

### 🖥️ Kitty Terminal Optimization

First-class support for the Kitty terminal:

- Truecolor (`t_8f` / `t_8b`)
- Undercurl for spell/diagnostic underlines (`t_Cs` / `t_Ce` / `t_8u`)
- Cursor shape changes: bar (insert), block (normal), underline (replace)
- Clean alternate screen entry/exit (no keyboard protocol residue)

Gracefully degrades on other terminals.

### 💾 Persistent State

- **Undo** history saved to `~/.vim/undo`
- **Swap** files in `~/.vim/swap`
- **Backup** files in `~/.vim/backup`
- Cursor position restored when reopening files
- Trailing whitespace trimmed on save (except markdown/diff)

### ⚡ Modern Vim Defaults

- `termguicolors` when available
- `smoothscroll` (if supported)
- `clipboard=unnamedplus` (if compiled with `+clipboard`)
- `history=1000`
- Fast timeout settings (`timeoutlen=600`, `ttimeoutlen=20`)

---

## Installation

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/stefan-hacks/pure-vim/main/vimrc -o ~/.vimrc
```

Or clone and symlink:

```bash
git clone https://github.com/stefan-hacks/pure-vim.git ~/Projects/pure-vim
ln -sf ~/Projects/pure-vim/vimrc ~/.vimrc
```

### First Run

Vim will automatically create the required directories on first launch:

```
~/.vim/undo
~/.vim/swap
~/.vim/backup
```

---

## Requirements

- **Vim 9.1** or newer
- Any Linux terminal ( Kitty recommended for full feature set)
- Zero plugins. Zero dependencies.

---

## Key Mappings

| Key | Action |
|---|---|
| `<Space>` | Leader key |
| `<Space>t` | Toggle Catppuccin Mocha ↔ Latte |
| `<Space>z` | Toggle soft wrap |
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>e` | Open file explorer (netrw) |
| `<Space>\|` | Vertical split |
| `<Space>-` | Horizontal split |
| `<Space>b` | Buffer list → switch |
| `<Space>f` | Find file |
| `<Space>h/j/k/l` | Navigate windows |
| `Y` | Yank to end of line |
| `J` / `K` | Move selected lines down/up (visual) |
| `<` / `>` | Indent and reselect (visual) |
| `j` / `k` | Wrap-aware movement ( respects `wrap` ) |
| `0` / `$` | Wrap-aware line boundaries |
| `<Esc><Esc>` | Clear search highlight |
| `w!!` | Write with sudo (`:w !sudo tee %`) |

---

## Architecture

```
┌─────────────────────────────────────┐
│  Terminal Layer (kitty-optimized)   │
├─────────────────────────────────────┤
│  UI & Theme (Catppuccin Mocha/Latte)│
├─────────────────────────────────────┤
│  Core Editing (search, indent, etc) │
├─────────────────────────────────────┤
│  Infrastructure Syntax & Filetypes  │
├─────────────────────────────────────┤
│  Custom Commenting Engine             │
├─────────────────────────────────────┤
│  Statusline & Netrw Integration     │
├─────────────────────────────────────┤
│  Persistence (undo, swap, backup)   │
└─────────────────────────────────────┘
```

All contained in a single `vimrc` file. No external colors/ directory, no plugin manager, no package manager dependency.

---

## Philosophy

> *"I want to SSH into any Linux box, scp a single file, and have my full editing environment immediately. No compiling plugins, no cloning repos, no dependency hell."*

`pure-vim` is designed for:
- Production servers where you can't install arbitrary software
- Container environments with minimal base images
- CI/CD runners that need quick editor setup
- Personal dotfiles you want to keep trivially portable

---

## Contributing

This configuration is intentionally **additive-only**. Features are never removed — they are enhanced or extended. If you have an idea for a new zero-plugin enhancement, open an issue or PR.

---

<div align="center">

Made with discipline and no plugins.

</div>
