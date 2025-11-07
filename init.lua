-- Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 0

-- Tab navigation with wrap-around
vim.keymap.set("n", "<leader>]", function()
    local tabs = vim.api.nvim_list_tabpages()
    local current = vim.api.nvim_tabpage_get_number(0)
    local next_idx = current == #tabs and 1 or current + 1
    vim.api.nvim_set_current_tabpage(tabs[next_idx])
end, { desc = "Next Tab (Wrap)" })

vim.keymap.set("n", "<leader>[", function()
    local tabs = vim.api.nvim_list_tabpages()
    local current = vim.api.nvim_tabpage_get_number(0)
    local prev_idx = current == 1 and #tabs or current - 1
    vim.api.nvim_set_current_tabpage(tabs[prev_idx])
end, { desc = "Previous Tab (Wrap)" })

-- Lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath
        }
    )
end
vim.opt.rtp:prepend(lazypath)

-- === PLUGIN SETUP ===
require("lazy").setup(
    {
        -- File browser
        {
            "stevearc/oil.nvim",
            config = function()
                require("oil").setup()
            end,
            keys = {{"-", "<Cmd>Oil<CR>", desc = "File Browser"}}
        },
        -- Statusline
        {
            "nvim-lualine/lualine.nvim",
            event = "VeryLazy",
            config = function()
                local lualine = require("lualine")
                lualine.setup({
                    options = {
                        theme = "onedark"
                    },
                    sections = {
                        lualine_a = { "mode" },
                        lualine_b = { "branch", "diff" },
                        lualine_c = {
                            {
                                "filename",
                                file_status = true,
                                newfile_status = true,
                                path = 1,
                                symbols = {
                                    modified = "[+]",
                                    readonly = "[-]",
                                    unnamed = "[No Name]",
                                    newfile = "[New]"
                                }
                            }
                        },
                        lualine_x = {
                            "encoding",
                            "fileformat",
                            "filetype"
                        }
                    }
                })
            end
        },
        -- Theme
        {
            "savq/melange-nvim"
        },
        -- === COMPLETION: nvim-cmp ===
        {
            "hrsh7th/nvim-cmp",
            event = "InsertEnter",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path"
            },
            config = function()
                local cmp = require("cmp")

                cmp.setup(
                    {
                        sources = {
                            {name = "nvim_lsp"},
                            {name = "buffer"},
                            {name = "path"}
                        },
                        window = {
                            completion = cmp.config.window.bordered(),
                            documentation = cmp.config.window.bordered(
                                {
                                    winhighlight = "Normal:Normal,FloatBorder:CmpDocumentationBorder,CursorLine:CmpDocumentationCursorLine,Search:None",
                                    border = "rounded",
                                    max_width = 80,
                                    max_height = 20
                                }
                            )
                        },
                        mapping = cmp.mapping.preset.insert(
                            {
                                ["<C-Space>"] = cmp.mapping.complete(),
                                ["<CR>"] = cmp.mapping.confirm({select = false}),
                                ["<Tab>"] = cmp.mapping(
                                    function(fallback)
                                        if cmp.visible() then
                                            cmp.select_next_item()
                                        else
                                            fallback()
                                        end
                                    end,
                                    {"i", "s"}
                                ),
                                ["<S-Tab>"] = cmp.mapping(
                                    function(fallback)
                                        if cmp.visible() then
                                            cmp.select_prev_item()
                                        else
                                            fallback()
                                        end
                                    end,
                                    {"i", "s"}
                                )
                            }
                        ),
                        formatting = {
                            format = function(entry, item)
                                item.menu =
                                    ({
                                    nvim_lsp = "[LSP]",
                                    buffer = "[Buf]",
                                    path = "[Path]"
                                })[entry.source.name]
                                return item
                            end
                        }
                    }
                )
            end
        },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            event = "BufReadPre",
            config = function()
                require("nvim-treesitter.configs").setup(
                    {
                        ensure_installed = {"python", "lua", "bash"}, -- add more later
                        highlight = {enable = true},
                        indent = {enable = true},
                        incremental_selection = {
                            enable = true,
                            keymaps = {
                                init_selection = "gr", -- start growing
                                node_incremental = "gr",
                                scope_incremental = "gr",
                                node_decremental = "gR"
                            }
                        }
                    }
                )
            end
        },
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = { "nvim-lua/plenary.nvim" },
            event = "VeryLazy",
            keys = {
                { "<leader>p", "<cmd>Telescope live_grep<cr>", desc = "Buffer Search" },
                { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Files Search" }
            },
            config = function()
                local telescope = require("telescope")
                local actions = require("telescope.actions")
                telescope.setup({
                    defaults = {
                        layout_strategy = "vertical",
                        layout_config = { height = 0.8, width = 0.8 },
                        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                        sorting_strategy = "ascending",
                        preview = { hide_on_startup = true },
                    },
                    mappings = {
                        i = {
                            ["<CR>"] = actions.select_tab,
                        },
                        n = {
                            ["<CR>"] = actions.select_tab,
                        },
                    },
                    pickers = {
                        find_files = {},
                        live_grep = {
                            mappings = {
                                i = { ["<CR>"] = actions.select_default },
                                n = { ["<CR>"] = actions.select_default },
                            },
                        },
                    },
                })
            end
        },
        {
            "linux-cultist/venv-selector.nvim",
            dependencies = {
                "neovim/nvim-lspconfig",
                {
                    "nvim-telescope/telescope.nvim", dependencies = {"nvim-lua/plenary.nvim"},
                },
            },
            ft = "python",
            opts = {}
        },
        {
            "sphamba/smear-cursor.nvim",
            opts = {},
        }
    }
)

-- === LSP CONFIG (NeoVim 0.11 Style) ===
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Define basedpyright config using vim.lsp.config
vim.lsp.config(
    "ty",
    {
        cmd = {"ty", "server"},
        filetypes = {"python"},
        root_markers = {"pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".venv"},
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    extraPaths = {
                        vim.fn.expand("%:p:h") .. "/.venv/lib/python*/site-packages"
                    }
                }
            }
        },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            local map = function(mode, lhs, rhs)
                vim.keymap.set(mode, lhs, rhs, {buffer = bufnr, silent = true})
            end
            map("n", "gd", vim.lsp.buf.definition)
            map("n", "K", vim.lsp.buf.hover)
            map("n", "<leader>r", vim.lsp.buf.rename)
        end
    }
)

-- Enable the LSP
vim.lsp.enable({"ty"})

vim.api.nvim_set_hl(0, "CmpDocumentationBorder", {fg = "#555555", bg = "none"})
vim.api.nvim_set_hl(0, "CmpDocumentationCursorLine", {bg = "#2a2a2a"})
vim.api.nvim_set_hl(0, "IblIndent", {fg = "#3e4451", nocombine = true}) -- very dim gray
vim.g.skip_ts_context_commentstring_module = true -- if you use comment plugins

-- Auto-fix + format with ruff on save
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.py",
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)

        -- Step 1: ruff check --fix (removes unused, sorts imports)
        local fix_cmd = { "ruff", "check", "--fix", "--stdin-filename", filename, "-" }
        local input = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
        
        local fix_result = vim.system(fix_cmd, { stdin = input, text = true }):wait()
        if fix_result.code == 0 and fix_result.stdout then
            local fixed_lines = vim.split(fix_result.stdout, "\n")
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, fixed_lines)
        end

        -- Step 2: ruff format (black-style formatting)
        local format_cmd = { "ruff", "format", "--stdin-filename", filename, "-" }
        local current_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local format_input = table.concat(current_lines, "\n")

        local format_result = vim.system(format_cmd, { stdin = format_input, text = true }):wait()
        if format_result.code == 0 and format_result.stdout then
            local formatted_lines = vim.split(format_result.stdout, "\n")
            -- Remove trailing newline if ruff adds it
            if #formatted_lines > 0 and formatted_lines[#formatted_lines] == "" then
                table.remove(formatted_lines)
            end
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted_lines)
        end
    end,
})

vim.diagnostic.config({
  virtual_lines = {
    current_line = true
  }
})

vim.cmd.colorscheme 'melange'
