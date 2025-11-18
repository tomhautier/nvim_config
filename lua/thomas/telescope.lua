local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope: Find files' })

vim.keymap.set('n', '<leader>gh', builtin.git_files, { desc = 'Telescope: Find Git files' })

vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ")});
end, { desc = 'Telescope: Grep string (prompt)' })

vim.keymap.set('n', '<leader>gr', builtin.live_grep, { desc = 'Telescope: Live grep' })

vim.keymap.set('n', '<leader>en', function() 
    require('telescope.builtin').find_files { 
        cwd = vim.fn.stdpath("config")
    }
end, { desc = 'Telescope: Find files in Neovim config' })

vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope: Search help tags' });
vim.keymap.set('n', '<leader>bn', function() vim.cmd('bnext') end, { desc = 'Buffer: Next buffer' })
vim.keymap.set('n', '<leader>bv', function() vim.cmd('bprev') end, { desc = 'Buffer: Previous buffer' })
vim.keymap.set('n', '<leader>o', function() require("telescope.builtin").buffers() end, { desc = 'Telescope: Show buffers' })
vim.keymap.set('n', '<leader>ss', function() require('telescope.builtin').git_status() end, { desc = 'Telescope: Git status' })
vim.keymap.set('n', '<leader>sw', function()
    builtin.live_grep({ default_text = vim.fn.expand('<cword>') })
end, { desc = 'Telescope: Search word under cursor' })

-- Add this keymap for finding file usages
vim.keymap.set('n', '<leader>su', function() -- fu = find usage
  -- Get the filename *without* the extension (root name)
  -- This is often how files are referenced in imports/requires
  local filename_root = vim.fn.expand('%:t:r')
  if filename_root == '' then
    print("Error: Could not determine filename for current buffer.")
    return
  end

  -- Use live_grep, pre-filling the search prompt with the filename root
  builtin.live_grep({
    prompt_title = "Find Usages of '" .. vim.fn.expand('%:t') .. "'", -- Show full filename in title
    default_text = filename_root,
  })
end, { desc = 'Telescope: Find usages of current file (filename root)' })

-- Live grep the word under cursor
vim.keymap.set('n', '<leader>gw', function()
    local word = vim.fn.expand('<cword>')
    if word == '' then
        print("No word under cursor")
        return
    end
    
    builtin.live_grep({
        prompt_title = "Live Grep: '" .. word .. "'",
        default_text = word,
    })
end, { desc = 'Telescope: Live grep word under cursor' })

require("telescope").load_extension("ui-select")

-- Function to show categorized keymaps
local function show_keymaps()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  local modes = {'n', 'v', 'i', 'x', 'o', 't'} -- Modes to check for mappings
  local categories = {} -- Table to hold maps grouped by category
  local display_list = {} -- Final list for Telescope

  -- Iterate through specified modes
  for _, mode in ipairs(modes) do
    local maps = vim.api.nvim_get_keymap(mode)
    -- Iterate through maps found for the current mode
    for _, map in ipairs(maps) do
      -- We only care about user-defined maps that have a description
      if map.desc and map.desc ~= "" and map.lhs ~= '<Plug>' then
        local category = "General"
        local description = map.desc

        -- Try to parse "Category: Description" format
        local parts = vim.split(map.desc, ":", {plain = true, trimempty = true, max = 2}) -- Split into max 2 parts
        if #parts > 1 then
           category = vim.trim(parts[1])
           description = vim.trim(parts[2])
        end

        -- Initialize category table if it doesn't exist
        if not categories[category] then
          categories[category] = {}
        end

        -- Format the display string: [mode] lhs -> description
        -- Pad lhs for alignment
        local display_string = string.format("[%s] %-20s -> %s", map.mode, map.lhs, description)
        -- Store the display string and the original map info
        table.insert(categories[category], { display = display_string, value = map })
      end
    end
  end

  -- Get category names and sort them alphabetically
  local sorted_category_names = {}
  for name, _ in pairs(categories) do
    table.insert(sorted_category_names, name)
  end
  table.sort(sorted_category_names)

  -- Build the final list for Telescope, grouped and sorted
  for _, category_name in ipairs(sorted_category_names) do
    -- Add category header (make it unselectable)
    table.insert(display_list, { display = string.format("--- %s ---", category_name), unreachable = true })

    -- Sort maps within the category by lhs
    local maps_in_category = categories[category_name]
    table.sort(maps_in_category, function(a,b) return a.value.lhs < b.value.lhs end)

    -- Add maps for this category
    for _, item in ipairs(maps_in_category) do
      table.insert(display_list, item)
    end
    -- Add a blank line for separation
    table.insert(display_list, { display = "", unreachable = true })
  end


  -- Create and open the Telescope picker
  pickers.new({}, {
    prompt_title = "Keymaps Help",
    finder = finders.new_table {
      results = display_list,
      entry_maker = function(entry)
        return {
          value = entry.value, -- Store original map info
          display = entry.display,
          ordinal = entry.display, -- Use display string for searching/sorting
          unreachable = entry.unreachable or false -- Mark headers/spacers
        }
      end
    },
    -- No explicit sorter specified - let Telescope use its default
    -- sorter = conf.empty_sorter({}), -- REMOVED THIS LINE

    attach_mappings = function(prompt_bufnr, map_func)
        -- Keep default Telescope actions (like Enter, Ctrl-X, etc.)
        -- Override Enter slightly to handle unreachable items
        actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            if selection and not selection.unreachable then
                -- Optional: Print full details of the selected map on Enter
                actions.close(prompt_bufnr)
                print("Selected Keymap Details:")
                print(vim.inspect(selection.value))
            elseif selection and selection.unreachable then
               -- Do nothing if a header/spacer is selected
            else
                actions.close(prompt_bufnr) -- Close if no selection
            end
        end)
        return true -- Indicates mappings are attached
    end,
  }):find()
end

-- Set the keymap to trigger the help window
vim.keymap.set('n', '<leader>help', show_keymaps, { noremap = true, silent = true, desc = 'Help: Show custom keymaps' })

-- Custom find_files that opens selection in vertical split (on the right)
vim.keymap.set('n', '<leader>fvs', function()
    local action_state = require('telescope.actions.state')
    local actions = require('telescope.actions')
    
    require('telescope.builtin').find_files({
        attach_mappings = function(prompt_bufnr, map)
            -- Override the default select action
            actions.select_default:replace(function()
                -- Store current buffer and window
                local current_buf = vim.api.nvim_get_current_buf()
                local current_win = vim.api.nvim_get_current_win()
                
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                
                -- Create vertical split
                vim.cmd('vsplit ' .. selection[1])
                -- Move new window to the far right
                vim.cmd('wincmd L')
            end)
            return true
        end,
    })
end, { desc = 'Telescope: Find files (vertical split)' })

require('telescope').setup{
  defaults = {
    preview = {
        width = 0.8,
        height = 0.9,
    },
    mappings = {
      i = {
        ["<cr>"] = require('telescope.actions').select_default,
        ["<C-s>"] = require('telescope.actions').select_horizontal,
        ["<C-v>"] = require('telescope.actions').select_vertical,
        ["<C-t>"] = require('telescope.actions').select_tab,
        ["<C-u>"] = require('telescope.actions').preview_scrolling_up,
        ["<C-d>"] = require('telescope.actions').preview_scrolling_down,
      },
      n = {
        ["<cr>"] = require('telescope.actions').select_default,
        ["<C-s>"] = require('telescope.actions').select_horizontal,
        ["<C-v>"] = require('telescope.actions').select_vertical,
        ["<C-t>"] = require('telescope.actions').select_tab,
        ["<C-u>"] = require('telescope.actions').preview_scrolling_up,
        ["<C-d>"] = require('telescope.actions').preview_scrolling_down,
      },
    },
  },
  pickers = {
    live_grep = {
      additional_args = { "--fixed-strings" }
    }
  }
}
