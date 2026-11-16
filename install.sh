#!/usr/bin/env bash
# install.sh — Install pure-vim configuration and optional tooling
# Usage: ./install.sh [--tools]
# Pass --tools to also install language tooling via system package manager.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VIM_DIR="${HOME}/.vim"

# ---------- Package manager detection ----------

detect_pm() {
  if command -v nix >/dev/null 2>&1; then
    echo 'nix'
  elif command -v pacman >/dev/null 2>&1; then
    echo 'pacman'
  elif command -v apt-get >/dev/null 2>&1; then
    echo 'apt'
  elif command -v dnf >/dev/null 2>&1; then
    echo 'dnf'
  elif command -v yum >/dev/null 2>&1; then
    echo 'yum'
  elif command -v zypper >/dev/null 2>&1; then
    echo 'zypper'
  elif command -v apk >/dev/null 2>&1; then
    echo 'apk'
  elif command -v brew >/dev/null 2>&1; then
    echo 'brew'
  else
    echo 'unknown'
  fi
}

PM="$(detect_pm)"

# ---------- Tool package names by distro ----------

declare -A PKGS
case "$PM" in
  nix)
    PKGS[fzf]='fzf'
    PKGS[bat]='bat'
    PKGS[rg]='ripgrep'
    PKGS[fd]='fd'
    PKGS[delta]='delta'
    PKGS[ctags]='universal-ctags'
    PKGS[shellcheck]='shellcheck'
    PKGS[shfmt]='shfmt'
    PKGS[nixfmt]='nixfmt-rfc-style'
    PKGS[alejandra]='alejandra'
    PKGS[yamllint]='yamllint'
    PKGS[ansible-lint]='ansible-lint'
    PKGS[taplo]='taplo'
    PKGS[ruff]='ruff'
    PKGS[black]='black'
    PKGS[go]='go'
    PKGS[golangci-lint]='golangci-lint'
    PKGS[rustfmt]='rustfmt'
    PKGS[clang-format]='clang-tools'
    PKGS[cmake]='cmake'
    PKGS[nodejs]='nodejs'
    PKGS[eslint]='eslint'
    PKGS[prettier]='prettier'
    PKGS[stylua]='stylua'
    PKGS[lua-ls]='lua-language-server'
    PKGS[jq]='jq'
    PKGS[nixd]='nixd'
    ;;
  pacman)
    PKGS[fzf]='fzf'
    PKGS[bat]='bat'
    PKGS[rg]='ripgrep'
    PKGS[fd]='fd'
    PKGS[delta]='delta'
    PKGS[ctags]='ctags'
    PKGS[shellcheck]='shellcheck'
    PKGS[shfmt]='shfmt'
    PKGS[yamllint]='yamllint'
    PKGS[taplo]='taplo'
    PKGS[go]='go'
    PKGS[clang-format]='clang'
    PKGS[cmake]='cmake'
    PKGS[nodejs]='nodejs'
    PKGS[prettier]='prettier'
    PKGS[jq]='jq'
    ;;
  apt)
    PKGS[fzf]='fzf'
    PKGS[bat]='bat'          
    PKGS[rg]='ripgrep'
    PKGS[fd]='fd-find'
    PKGS[delta]='delta'
    PKGS[ctags]='universal-ctags'
    PKGS[shellcheck]='shellcheck'
    PKGS[yamllint]='yamllint'
    PKGS[go]='golang-go'
    PKGS[clang-format]='clang-format'
    PKGS[cmake]='cmake'
    PKGS[nodejs]='nodejs'
    PKGS[jq]='jq'
    ;;
  dnf|yum)
    PKGS[fzf]='fzf'
    PKGS[bat]='bat'
    PKGS[rg]='ripgrep'
    PKGS[fd]='fd-find'
    PKGS[delta]='delta'
    PKGS[ctags]='ctags'
    PKGS[shellcheck]='ShellCheck'
    PKGS[shfmt]='shfmt'
    PKGS[yamllint]='yamllint'
    PKGS[go]='golang'
    PKGS[clang-format]='clang-tools-extra'
    PKGS[cmake]='cmake'
    PKGS[nodejs]='nodejs'
    PKGS[jq]='jq'
    ;;
  zypper)
    PKGS[fzf]='fzf'
    PKGS[bat]='bat'
    PKGS[rg]='ripgrep'
    PKGS[fd]='fd'
    PKGS[delta]='delta'
    PKGS[ctags]='ctags'
    PKGS[shellcheck]='shellcheck'
    PKGS[yamllint]='yamllint'
    PKGS[go]='go'
    PKGS[clang-format]='clang'
    PKGS[cmake]='cmake'
    PKGS[nodejs]='nodejs'
    PKGS[jq]='jq'
    ;;
  apk)
    PKGS[fzf]='fzf'
    PKGS[bat]='bat'
    PKGS[rg]='ripgrep'
    PKGS[fd]='fd'
    PKGS[delta]='delta'
    PKGS[ctags]='ctags'
    PKGS[shellcheck]='shellcheck'
    PKGS[yamllint]='yamllint'
    PKGS[go]='go'
    PKGS[clang-format]='clang-extra-tools'
    PKGS[cmake]='cmake'
    PKGS[nodejs]='nodejs'
    PKGS[jq]='jq'
    ;;
  brew)
    PKGS[fzf]='fzf'
    PKGS[bat]='bat'
    PKGS[rg]='ripgrep'
    PKGS[fd]='fd'
    PKGS[delta]='delta'
    PKGS[ctags]='universal-ctags'
    PKGS[shellcheck]='shellcheck'
    PKGS[shfmt]='shfmt'
    PKGS[yamllint]='yamllint'
    PKGS[taplo]='taplo'
    PKGS[ruff]='ruff'
    PKGS[black]='black'
    PKGS[go]='go'
    PKGS[golangci-lint]='golangci-lint'
    PKGS[rustfmt]='rustfmt'
    PKGS[clang-format]='llvm'
    PKGS[cmake]='cmake'
    PKGS[nodejs]='node'
    PKGS[prettier]='prettier'
    PKGS[stylua]='stylua'
    PKGS[jq]='jq'
    ;;
  *)
    echo "[pure-vim] Unknown package manager. Tool installation skipped."
    ;;
esac

# ---------- Install functions ----------

install_tools() {
  if [ "$PM" = 'unknown' ]; then
    echo "[pure-vim] Cannot detect package manager. Install these tools manually:"
    echo "  fzf, bat, ripgrep, fd, delta, shellcheck, shfmt"
    echo "  yamllint, taplo, ruff, black, go, rustfmt, clang-format"
    echo "  nodejs, prettier, stylua, jq"
    return
  fi

  echo "[pure-vim] Detected package manager: $PM"

  local to_install=()
  for key in "${!PKGS[@]}"; do
    local pkg="${PKGS[$key]}"
    local bin="$key"
    case "$key" in
      rg) bin='rg' ;;
      fd) bin='fd' ;;
      ctags) bin='ctags' ;;
      rustfmt) bin='rustfmt' ;;
      clang-format) bin='clang-format' ;;
      lua-ls) bin='lua-language-server' ;;
    esac

    if ! command -v "$bin" >/dev/null 2>&1; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -eq 0 ]; then
    echo "[pure-vim] All requested tools already installed."
    return
  fi

  echo "[pure-vim] Installing: ${to_install[*]}"

  case "$PM" in
    nix)
      if command -v nix-env >/dev/null 2>&1; then
        for pkg in "${to_install[@]}"; do
          nix-env -iA "nixpkgs.${pkg}" || echo "[pure-vim] Failed to install ${pkg}"
        done
      else
        echo "[pure-vim] nix-env not available. Tools not installed."
      fi
      ;;
    pacman)
      sudo pacman -S --needed --noconfirm "${to_install[@]}"
      ;;
    apt)
      sudo apt-get update
      sudo apt-get install -y "${to_install[@]}"
      ;;
    dnf)
      sudo dnf install -y "${to_install[@]}"
      ;;
    yum)
      sudo yum install -y "${to_install[@]}"
      ;;
    zypper)
      sudo zypper install -y "${to_install[@]}"
      ;;
    apk)
      sudo apk add "${to_install[@]}"
      ;;
    brew)
      brew install "${to_install[@]}"
      ;;
  esac
}

# ---------- Main ----------

echo "[pure-vim] Installing from ${REPO_DIR} ..."

# Backup existing ~/.vim/vimrc if present and not already a symlink
if [[ -f "${VIM_DIR}/vimrc" && ! -L "${VIM_DIR}/vimrc" ]]; then
    mv "${VIM_DIR}/vimrc" "${VIM_DIR}/vimrc.bak.$(date +%s)"
    echo "[pure-vim] Backed up existing ~/.vim/vimrc"
fi

# Create ~/.vim/ if needed
mkdir -p "${VIM_DIR}"

# Symlink vimrc
ln -sf "${REPO_DIR}/vimrc" "${VIM_DIR}/vimrc"

# Symlink core/ and ftplugin/ directories
if [[ -d "${REPO_DIR}/core" ]]; then
    ln -sfn "${REPO_DIR}/core" "${VIM_DIR}/core"
    echo "[pure-vim] Linked core/ modules"
fi

if [[ -d "${REPO_DIR}/ftplugin" ]]; then
    ln -sfn "${REPO_DIR}/ftplugin" "${VIM_DIR}/ftplugin"
    echo "[pure-vim] Linked ftplugin/ modules"
fi

# Ensure persistent directories exist
mkdir -p "${HOME}/.vim/undo" "${HOME}/.vim/swap" "${HOME}/.vim/backup"

# Install tools if --tools flag passed
if [[ "${1:-}" == '--tools' ]]; then
  install_tools
else
  echo "[pure-vim] Run with --tools to install language tooling (fzf, bat, ripgrep, linters, formatters)"
fi

echo "[pure-vim] Installation complete. Start Vim to use the configuration."
echo "[pure-vim] Run: vim"
