return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                -- A list of parser names, or "all"
                ensure_installed = { "javascript", "typescript", "tsx", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "html", "css", "json" },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                auto_install = true,

                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true
                },
            })
        end
    },
    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
    }
}

