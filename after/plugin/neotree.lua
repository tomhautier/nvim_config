require'neo-tree'.setup {
    open_on_setup = true,
    close_if_last_window = true,
    open_files_in_new_tab = true,
      popup_border_style = "single",
      enable_git_status = true,
      enable_modified_markers = true,
      enable_diagnostics = true,
      sort_case_insensitive = true,
      default_component_configs = {
        indent = {
          with_markers = true,
          with_expanders = true,
        },
        modified = {
          symbol = " ",
          highlight = "NeoTreeModified",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          folder_empty_open = "",
        },
        git_status = {
          symbols = {
            -- Change type
            added = "",
            deleted = "",
            modified = "",
            renamed = "",
            -- Status type
            untracked = "",
            ignored = "",
            unstaged = "",
            staged = "",
            conflict = "",
          },
        },
      },
      window = {
        position = "left",
        width = 35,
        mappings = { -- Add this mappings table
          ["<CR>"] = "open_tabnew", -- Map Enter key to open in a new tab always
          ["<S-CR>"] = "open_tabnew", -- Optional: Map Shift+Enter as well
          ["<C-t>"] = "open_tabnew", -- Optional: Keep Ctrl+t consistent if you use it
        }
      },
      filesystem = {
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
          },
          never_show = {
            ".DS_Store",
            "thumbs.db",
      œ    },
        },
      },
      source_selector = {
        winbar = true,
        sources = {
          { source = "filesystem", display_name = "   Files " },
          { source = "buffers", display_name = "   Bufs " },
          { source = "git_status", display_name = "   Git " },
        },
      },
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function(args)
            if args.position == "left" or args.position == "right" then
              vim.cmd("wincmd =")
            end
          end,0
        },
      },
}

vim.keymap.set('n', '<leader>e', function()
  vim.cmd('Neotree toggle left')
end, { desc = 'Toggle Neotree left window' })

-- Keymap to reveal current file in Neotree
vim.keymap.set('n', '<leader>tf', function()
  vim.cmd('Neotree reveal')
end, { desc = 'Reveal current file in Neotree' })

-- Auto reveal Neotree when switching buffers
vim.api.nvim_set_hl(0, "NeoTreeBufName", { bg = "#444444", bold = true })

-- Automatically reveal current file in Neo-tree when buffer changes (ensure this is present)
local group = vim.api.nvim_create_augroup("NeoTreeFollowBuffer", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  pattern = "*", -- Run for all buffers
  callback = function()
    -- Safely attempt to load the neo-tree filesystem module
    local success, fs_module = pcall(require, "neo-tree.sources.filesystem")

    -- Proceed only if require succeeded and returned the module table
    if success and fs_module then
      -- Check if the is_visible function exists on the module and if it returns true
      if fs_module.is_visible and fs_module.is_visible() then
        -- Check if the buffer entered is not the Neo-tree window itself
        if vim.bo.filetype ~= "neo-tree" then
          -- Use 'silent' to avoid messages and prevent Neotree from stealing focus
          -- Use pcall again for safety during Neovim closing or edge cases
          pcall(vim.cmd, "silent Neotree reveal")
        end
      end
    end
  end,
})

-- Auto-open Neotree on new tabs
vim.api.nvim_create_autocmd("TabNew", {
  group = group,
  callback = function()
    -- Small delay to ensure tab is fully created
    vim.defer_fn(function()
      pcall(vim.cmd, "silent Neotree show left")
    end, 10)
  end,
})