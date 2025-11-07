[![Version 1.0](https://img.shields.io/badge/Version-1.0-blue.svg?style=flat-square)](https://github.com/yourusername/your-repo)

README is written by Grok.

# Neovim Config (Lua-based)

A modern, minimal Neovim configuration using `lazy.nvim`, Treesitter, LSP, and Python-focused tooling.

## Features
- **Plugin Manager**: `lazy.nvim` with automatic bootstrap
- **File Explorer**: `oil.nvim` (`-`)
- **Statusline**: `lualine.nvim` with Git & file info
- **Completion**: `nvim-cmp` + LSP, buffer, path
- **Syntax**: `nvim-treesitter` with Python, Lua, Bash
- **Fuzzy Finder**: `telescope.nvim` (vertical layout)
- **Python**: `venv-selector.nvim`, `ty` (basedpyright) LSP
- **Auto-fix & Format**: `ruff check --fix` + `ruff format` on save
- **Theme**: `melange-nvim`

## Prerequisites
- Neovim ≥ 0.11
- `git`, `ruff`, `ty` (basedpyright), Python venv

## Installation
```bash
git clone https://github.com/yourusername/your-repo.git ~/.config/nvim
nvim
