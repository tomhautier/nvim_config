return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/nvim-cmp",
            "pmizio/typescript-tools.nvim", -- Excellent pour React
        },
        config = function()
            require("mason").setup()
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            
            -- Définir les handlers AVANT setup ou DANS setup, mais éviter l'itération manuelle + handlers
            -- qui crée des doublons et des appels redondants.
            
            -- 1. S'assurer que 'stylua' n'est PAS dans Mason-LSPConfig (car ce n'est pas un LSP)
            -- mais plutôt géré par Mason directement ou conform.nvim
            
            mason_lspconfig.setup({
                ensure_installed = {
                    "eslint",      -- Linter/Fixer
                    "jsonls",      -- JSON
                    "cssls",       -- CSS
                    "html",        -- HTML
                    -- Pas de tsserver/ts_ls ici car typescript-tools
                },
                automatic_installation = true,
                handlers = {
                    function(server_name)
                        -- Ignorer tsserver car géré par typescript-tools
                        if server_name == "tsserver" or server_name == "ts_ls" then
                            return
                        end
                        
                        -- Ignorer stylua car ce n'est pas un serveur LSP
                        if server_name == "stylua" then
                            return
                        end
                        
                        -- Configuration standard pour les autres
                        -- Note: le warning sur require('lspconfig') est inoffensif pour l'instant,
                        -- mais l'erreur "config 'stylua' not found" vient du fait qu'on essaie de setup stylua comme un LSP.
                        if lspconfig[server_name] then
                             lspconfig[server_name].setup({ capabilities = capabilities })
                        end
                    end,
                }
            })

            -- TypeScript Tools
            require("typescript-tools").setup({
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false 
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
                settings = {
                    jsx_close_tag = { enable = true, filetypes = { "javascriptreact", "typescriptreact" } },
                    expose_as_code_action = "all",
                }
            })
            
            -- Keymaps LSP
             vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set("n", "gd", function() vim.cmd('tab split'); vim.schedule(vim.lsp.buf.definition) end, opts)
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
                    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
                    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
                    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
                    vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
                    vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
                    vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
                    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
                end,
            })
        end
    }
}
