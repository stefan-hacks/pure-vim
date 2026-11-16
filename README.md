<div align="center">

# pure-vim

**A single `vimrc`. Optional modules. Zero plugins. Maximum capability.**

Built for Vim 9.1+ on any Linux system — just drop it in and start editing.

</div>

---

## Installation

Choose the method that fits your workflow.

### Quick Try — No Install (Nix)

```bash
# Launch Vim with pure-vim config directly from GitHub
nix run github:stefan-hacks/pure-vim

# Or clone first, then run locally
nix run . -- somefile.py
```

This downloads the flake, opens Vim with the config, and discards everything on exit. Perfect for testing.

---

### Full Install (with modules)

```bash
git clone https://github.com/stefan-hacks/pure-vim.git ~/Projects/pure-vim
cd ~/Projects/pure-vim
./install.sh
```

This symlinks the repo into `~/.vim/` so `core/` and `ftplugin/` are discovered.

### Minimal Install (vimrc only)

```bash
curl -fsSL https://raw.githubusercontent.com/stefan-hacks/pure-vim/main/vimrc -o ~/.vimrc
```

### Home Manager (Declarative)

```nix
# In your home-manager configuration
{ inputs, ... }: {
  imports = [ inputs.pure-vim.homeManagerModules.default ];

  programs.pure-vim = {
    enable = true;
    enableLanguageTools = true;  # Installs fzf, bat, ripgrep, linters, formatters
  };
}
```

Then add the input to your flake:

```nix
# flake.nix inputs
pure-vim.url = "github:stefan-hacks/pure-vim";
```

### NixOS / Nix Profile (Imperative)

```bash
# Install into your profile
nix profile install github:stefan-hacks/pure-vim

# Or build the package
nix build github:stefan-hacks/pure-vim
```

### Development Shell

```bash
# Enter a shell with all tools (vim, fzf, bat, ripgrep, linters, formatters)
nix develop github:stefan-hacks/pure-vim
```

---

## What is this?

`pure-vim` is a carefully crafted, self-contained Vim configuration designed for infrastructure engineers, developers, and anyone who needs a powerful editing environment on machines where they can't (or won't) install plugins.

The core lives in **one file** (`vimrc`). Optional modules (`core/`, `ftplugin/`) extend it with fuzzy finding, language-specific tooling, and more — but the base config works perfectly standalone.

No plugin manager. No `colors/` directory. No internet required.

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

### 🔎 Fuzzy Finding (Optional — requires `fzf` + `bat`)

If `fzf` is installed, floating popup windows give you IDE-grade file/buffer/search navigation:

| Mapping | Action |
|---|---|
| `<Space>F` | Fuzzy file finder with `bat` syntax preview |
| `<Space>s` | Live ripgrep with `bat` line preview |
| `<Space>S` | Ripgrep word under cursor |
| `<Space>b` | Fuzzy buffer switcher |
| `<Space>c` | Fuzzy command palette |
| `<Space>H` | Fuzzy help tag finder |

If `fzf` is missing, the base `vimrc` still works — no errors.

### 🧩 Language Modules (ftplugin/)

Auto-loaded modules for 14+ languages. Each provides:

- **Indentation** (tabs/spaces, width)
- **Lint** (`<Space>m` → populate quickfix)
- **Format** (`<Space>=` → format entire buffer)
- **Run** (`<Space>r` → run in bottom terminal)
- **Completion** (native `omnifunc` or `syntaxcomplete#Complete`)
- **Include-search** (`[i`, `]i`, `<C-w>i`)

| Language | Lint | Format | Run | Debug |
|---|---|---|---|---|
| **bash/sh** | shellcheck | shfmt | — | — |
| **nix** | statix / nix-instantiate | alejandra / nixfmt / nixpkgs-fmt | — | — |
| **yaml** | yamllint | yamlfmt / prettier | — | — |
| **ansible** | ansible-lint | yamlfmt / prettier | ansible-playbook | — |
| **toml** | taplo | taplo | — | — |
| **python** | ruff / flake8 | black / autopep8 | python3 | — |
| **go** | staticcheck / golint | gofmt / goimports | go run/test | — |
| **rust** | cargo clippy / rustc | rustfmt | cargo run/test | — |
| **c** | gcc / clang | clang-format | `./%:r` | Termdebug |
| **cpp** | g++ / clang++ | clang-format | `./%:r` | Termdebug |
| **javascript** | eslint / jshint | prettier | node | — |
| **typescript** | tsc | prettier | ts-node | — |
| **lua** | luac | stylua | lua / luajit | — |
| **json** | jq | jq / python json.tool | — | — |
| **markdown** | — | prettier / mdformat | browser preview | — |

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

## Requirements

- **Vim 9.1** or newer
- Any Linux terminal (Kitty recommended for full feature set)
- Zero plugins. Zero dependencies for the base config.
- **Optional:** `fzf` + `bat` for fuzzy finding; `rg` for ripgrep search
- **Optional:** per-language tools (see Language Modules table above)

### Full Tooling (Nix)

If you use the Home Manager module or `nix develop`, the following tools are included:

| Category | Tools |
|---|---|
| Fuzzy finding | `fzf`, `bat`, `bat-extras`, `ripgrep`, `fd` |
| Diff / tags | `delta`, `universal-ctags` |
| Shell | `shellcheck`, `shfmt` |
| Nix | `nixfmt-rfc-style`, `alejandra`, `nixpkgs-fmt`, `statix`, `nixd` |
| YAML / Ansible | `yamllint`, `ansible-lint` |
| TOML | `taplo` |
| Python | `ruff`, `black`, `pyright` |
| Go | `go`, `gopls`, `golangci-lint` |
| Rust | `rustc`, `cargo`, `rustfmt`, `clippy` |
| C / C++ | `clang-tools`, `cmake` |
| JS / TS | `nodejs`, `eslint`, `prettier` |
| Lua | `stylua`, `lua-language-server` |
| JSON | `jq` |

---

## Directory Structure

```
~/.vim/
├── vimrc              # Main config (single file, works alone)
├── core/
│   └── fzf.vim        # Floating popup fzf + bat (optional)
└── ftplugin/
    ├── sh.vim         # Bash/Shell
    ├── nix.vim        # Nix
    ├── yaml.vim       # YAML
    ├── yaml.ansible.vim # Ansible
    ├── toml.vim       # TOML
    ├── dosini.vim     # INI
    ├── python.vim     # Python
    ├── go.vim         # Go
    ├── rust.vim        # Rust
    ├── c.vim          # C
    ├── cpp.vim        # C++
    ├── javascript.vim # JavaScript
    ├── typescript.vim # TypeScript
    ├── lua.vim        # Lua
    ├── json.vim       # JSON
    └── markdown.vim   # Markdown
```

---

## Key Mappings

### Global

| Key | Action |
|---|---|
| `<Space>` | Leader key |
| `<Space>t` | Toggle Catppuccin Mocha ↔ Latte |
| `<Space>z` | Toggle soft wrap |
| `<Space>w` | Save file |
| `<Space>q` | Quit |
| `<Space>e` | Open file explorer (netrw) |
| `<Space>\` | Vertical split |
| `<Space>-` | Horizontal split |
| `<Space>h/j/k/l` | Navigate windows |
| `Y` | Yank to end of line |
| `J` / `K` | Move selected lines down/up (visual) |
| `<` / `>` | Indent and reselect (visual) |
| `j` / `k` | Wrap-aware movement (respects `wrap`) |
| `0` / `$` | Wrap-aware line boundaries |
| `<Esc><Esc>` | Clear search highlight |
| `w!!` | Write with sudo (`:w !sudo tee %`) |

### Fuzzy Finding (requires `fzf`)

| Key | Action |
|---|---|
| `<Space>F` | Fuzzy find files |
| `<Space>s` | Live grep search |
| `<Space>S` | Grep word under cursor |
| `<Space>b` | Fuzzy switch buffers |
| `<Space>c` | Fuzzy command palette |
| `<Space>H` | Fuzzy help tags |

### Language-Specific (buffer-local)

| Key | Action |
|---|---|
| `<Space>m` | Lint current file (quickfix) |
| `<Space>=` | Format current file |
| `<Space>r` | Run current file in bottom terminal |
| `<Space>i` | Organize imports (Go: goimports) |
| `<Space>t` | Run tests (Go, Rust) |
| `<Space>db` | Launch Termdebug (C/C++) |

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
│  Optional: Fuzzy Finding (fzf)        │
├─────────────────────────────────────┤
│  Optional: Language Modules (ftplugin)│
├─────────────────────────────────────┤
│  Statusline & Netrw Integration     │
├─────────────────────────────────────┤
│  Persistence (undo, swap, backup)     │
└─────────────────────────────────────┘
```

The core is a single `vimrc`. Optional modules (`core/`, `ftplugin/`) auto-load if present.

---

## Philosophy

> *"I want to SSH into any Linux box, scp a single file, and have my full editing environment immediately. No compiling plugins, no cloning repos, no dependency hell."*

`pure-vim` is designed for:
- Production servers where you can't install arbitrary software
- Container environments with minimal base images
- CI/CD runners that need quick editor setup
- Personal dotfiles you want to keep trivially portable
- But also **daily development** when you add optional modules for fuzzing, linting, and formatting

---

## Contributing

This configuration is intentionally **additive-only**. Features are never removed — they are enhanced or extended. If you have an idea for a new zero-plugin enhancement, open an issue or PR.

---

<div align="center">

Made with discipline and no plugins.

</div>
