return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                filesystem = {
                    follow_current_file = {
                        enabled = true,
                    },
                    hijack_netrw_behavior = "open_current",
                    filtered_items = {
                        visible = true, -- Affiche les fichiers cachés par défaut
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        hide_by_name = {
                            ".git",
                            "node_modules"
                        },
                    }
                }
            })
            vim.keymap.set("n", "<leader>e", ":Neotree toggle position=left<CR>", { desc = "Explorer: Toggle NeoTree" })
        end
    },
    {
        "goolord/alpha-nvim",
        config = function()
            require("alpha").setup(require("alpha.themes.dashboard").config)
        end,
    }
}
