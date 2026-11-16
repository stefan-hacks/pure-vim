#!/usr/bin/env bash
# install.sh — Install pure-vim modular configuration
# Usage: ./install.sh
# This symlinks the repo into ~/.vim/ so core/ and ftplugin/ are discovered.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VIM_DIR="${HOME}/.vim"

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

echo "[pure-vim] Installation complete. Start Vim to use the configuration."
echo "[pure-vim] Run: vim"
