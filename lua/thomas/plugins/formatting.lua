return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                css = { "prettier" },
                html = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                lua = { "stylua" },
            },
            -- Formatage automatique à la sauvegarde
            format_on_save = {
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            },
        })
        
        -- Keymap simple
        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            conform.format({ lsp_fallback = true, async = false, timeout_ms = 1000 })
        end, { desc = "Format file or range (Prettier)" })
    end,
}

