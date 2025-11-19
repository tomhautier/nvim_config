return {
    "jedrzejboczar/possession.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("possession").setup({
            autosave = {
                current = true,  -- Sauvegarde auto la session courante
            },
            commands = {
                save = "PossessionSave",
                load = "PossessionLoad",
                delete = "PossessionDelete",
                list = "PossessionList",
            },
        })

        -- Intégration Telescope pour lister les sessions
        local telescope = require("telescope")
        telescope.load_extension("possession")

        -- Raccourcis
        local map = vim.keymap.set
        map("n", "<leader>Sl", function() telescope.extensions.possession.list() end, { desc = "Sessions: List (Telescope)" })
        map("n", "<leader>Sn", function() 
            local session_name = vim.fn.input("Session name: ")
            if session_name ~= "" then
                vim.cmd("PossessionSave " .. session_name)
            end
        end, { desc = "Sessions: New/Save" })
        map("n", "<leader>Sd", ":PossessionDelete ", { desc = "Sessions: Delete" })
        map("n", "<leader>Sc", ":PossessionClose<CR>", { desc = "Sessions: Close current" })
    end,
}
