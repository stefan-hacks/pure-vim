# pure-vim — Cheat Sheet

Quick reference for every feature in pure-vim. For details, see [`GUIDE.md`](./GUIDE.md).

---

## General

| Mapping | Action |
|---|---|
| `\u003cSpace\u003e` | Leader key |
| `\u003cSpace\u003ew` | Save file |
| `\u003cSpace\u003eq` | Quit |
| `:W` | Alias `:w` |
| `:Q` | Alias `:q` |
| `:w!!` | Save with sudo |

---

## Search

| Mapping | Action |
|---|---|
| `/` / `?` | Search forward/backward |
| `n` / `N` | Next/previous match |
| `*` / `#` | Search word under cursor (fwd/bwd) |
| `g*` / `g#` | Partial word search (fwd/bwd) |
| `\u003cEsc\u003e\u003cEsc\u003e` | Clear search highlights |

---

## Theme

| Mapping | Action |
|---|---|
| `\u003cSpace\u003et` | Toggle Catppuccin Mocha ↔ Latte |

---

## Text Wrapping

| Mapping | Action |
|---|---|
| `\u003cSpace\u003ez` | Toggle soft wrap |
| `j` / `k` | Screen-line movement (when wrap is on, no count) |
| `0` / `$` | Screen-line start/end (when wrap is on) |

---

## Windows & Buffers

| Mapping | Action |
|---|---|
| `\u003cSpace\u003e\\` | Vertical split |
| `\u003cSpace\u003e-` | Horizontal split |
| `\u003cSpace\u003eh/j/k/l` | Focus window left/down/up/right |
| `\u003cSpace\u003eb` | List buffers → switch |
| `\u003cSpace\u003ef` | Find file (`:find *`) |

---

## Commenting

### Line Comments

| Mapping | Action |
|---|---|
| `gcc` | Toggle line comment |
| `5gcc` | Toggle 5 lines |
| `gc{motion}` | Toggle over motion (`gcap`, `gcip`, `gc5j`) |
| `gc` | Toggle visual selection |

### Block Comments

| Mapping | Action |
|---|---|
| `gbc` | Toggle block comment on line(s) |
| `3gbc` | Wrap 3 lines in one block |
| `gb{motion}` | Toggle block over motion (`gbap`, `gb}`) |
| `gb` | Toggle block on visual selection |

**Block markers:** `/* */` (nix, tf, hcl, c, go, rust, js, ts, css, php, sql, groovy, puppet), `\u003c!-- --\u003e` (html, xml, md), `--[[ ]]` (lua), `{# #}` (jinja), `{- -}` (haskell). Falls back to line comments if none defined.

---

## Visual Mode

| Mapping | Action |
|---|---|
| `J` / `K` | Move selected lines down/up |
| `\u003c` / `\u003e` | Indent/outdent and reselect |
| `gc` | Line-comment selection |
| `gb` | Block-comment selection |

---

## File Explorer (Netrw)

| Mapping | Action |
|---|---|
| `\u003cSpace\u003ee` | Open left sidebar tree |

**Inside netrw:**
| Key | Action |
|---|---|
| `Enter` | Open file/dir |
| `t` | Open in tab |
| `v` | Open in vertical split |
| `i` | Cycle list style |
| `s` | Cycle sort |
| `d` | New directory |
| `%` | New file |
| `D` | Delete |
| `R` | Rename |
| `q` | Close |

---

## Statusline Colors

The statusline changes color by mode:

| Mode | Color |
|---|---|
| Normal | Blue |
| Insert | Green |
| Visual | Purple |
| Replace | Red |
| Command | Peach |
| Terminal | Green |

---

## Supported Filetypes

Auto-detected infrastructure filetypes:

- `nix`, `json` (flake.lock)
- `terraform` / `hcl`, `nomad`
- `dockerfile`, `Containerfile`
- `groovy` (Jenkinsfile), `ruby` (Vagrantfile), `puppet`
- `systemd` (units, network, quadlets)
- `yaml.ansible` (playbooks, roles, vars)
- `nginx`, `sudoers`
- `sshconfig`, `sshdconfig`
- `nftables`
- `sh` (.env files)
- `jinja` (`.j2` with underlying detection)

---

## Indentation by Filetype

| Filetypes | Tabs |
|---|---|
| nix, yaml, json, hcl, tf, jinja, html, css, js, lua | 2 spaces |
| make, go | Real tabs |
| Everything else | 4 spaces |

---

*This cheat sheet is maintained alongside the `vimrc`. When features are added, this document is updated to reflect them.*
