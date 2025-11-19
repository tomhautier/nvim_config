return {
    "rmagatti/goto-preview",
    event = "BufEnter",
    config = function()
        require('goto-preview').setup {
            width = 120, -- Width of the floating window
            height = 15, -- Height of the floating window
            border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}, -- Border characters of the floating window
            default_mappings = true, -- Bind default mappings
            debug = false, -- Print debug information
            opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
            resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
            post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran when a preview window is opened.
            post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran when a preview window is closed.
            references = { -- Configure the telescope UI for references
                telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
            },
            -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
            focus_on_open = true, -- Focus the floating window when opening it.
            dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
            force_close = true, -- The close the current floating window when opening a new one.
            bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
            stack_floating_preview_windows = true, -- Whether to nest floating windows
            preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
        }
        
        -- Keymaps personnalisés si tu ne veux pas les défauts (gpd, gpi, gpr, gP)
        -- gpd: goto preview definition
        -- gpi: goto preview implementation
        -- gpr: goto preview references
        vim.keymap.set("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {desc = "Preview definition"})
        vim.keymap.set("n", "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", {desc = "Preview type definition"})
        vim.keymap.set("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", {desc = "Preview implementation"})
        vim.keymap.set("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", {desc = "Preview references"})
        vim.keymap.set("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", {desc = "Close preview windows"})
    end
}

