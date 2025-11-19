return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { 
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require('telescope.builtin')

            telescope.setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                    file_browser = {
                        theme = "ivy",
                        hijack_netrw = true,
                        hidden = true,
                    },
                },
                defaults = {
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                    },
                    preview = {
                        width = 0.8,
                        height = 0.9,
                    },
                    -- C'est ici qu'on définit les dossiers à ignorer
                    file_ignore_patterns = { 
                        "node_modules", 
                        ".git", 
                        "build", 
                        "dist", 
                        "coverage",
                        ".next" 
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        no_ignore = false,
                    },
                },
            })

            telescope.load_extension("ui-select")
            telescope.load_extension("file_browser")

            -- Basic Telescope Keymaps
            vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope: Find files' })
            vim.keymap.set('n', '<leader>gh', builtin.git_files, { desc = 'Telescope: Find Git files' })
            vim.keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ")});
            end, { desc = 'Telescope: Grep string (prompt)' })
            vim.keymap.set('n', '<leader>gr', builtin.live_grep, { desc = 'Telescope: Live grep' })
            vim.keymap.set("n", "<space>fb", function()
                telescope.extensions.file_browser.file_browser()
            end, { desc = "Telescope: File browser" })

            -- Restored Keymaps from previous configuration
            vim.keymap.set('n', '<leader>en', function() 
                require('telescope.builtin').find_files { 
                    cwd = vim.fn.stdpath("config")
                }
            end, { desc = 'Telescope: Find files in Neovim config' })
            
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope: Search help tags' })
            vim.keymap.set('n', '<leader>o', function() builtin.buffers() end, { desc = 'Telescope: Show buffers' })
            vim.keymap.set('n', '<leader>ss', function() builtin.git_status() end, { desc = 'Telescope: Git status' })
            vim.keymap.set('n', '<leader>sw', function()
                builtin.live_grep({ default_text = vim.fn.expand('<cword>') })
            end, { desc = 'Telescope: Search word under cursor' })

            -- Find Usages (su)
            vim.keymap.set('n', '<leader>su', function() 
              local filename_root = vim.fn.expand('%:t:r')
              if filename_root == '' then
                print("Error: Could not determine filename for current buffer.")
                return
              end
              builtin.live_grep({
                prompt_title = "Find Usages of '" .. vim.fn.expand('%:t') .. "'", 
                default_text = filename_root,
              })
            end, { desc = 'Telescope: Find usages of current file (filename root)' })

            -- Grep word under cursor (gw)
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
            
            -- Custom Keymap Help (<leader>help)
            local function show_keymaps()
                local pickers = require('telescope.pickers')
                local finders = require('telescope.finders')
                local conf = require('telescope.config').values
                local actions = require('telescope.actions')
                local action_state = require('telescope.actions.state')
              
                local modes = {'n', 'v', 'i', 'x', 'o', 't'}
                local categories = {}
                local display_list = {}
              
                for _, mode in ipairs(modes) do
                  local maps = vim.api.nvim_get_keymap(mode)
                  for _, map in ipairs(maps) do
                    if map.desc and map.desc ~= "" and map.lhs ~= '<Plug>' then
                      local category = "General"
                      local description = map.desc
                      local parts = vim.split(map.desc, ":", {plain = true, trimempty = true, max = 2})
                      if #parts > 1 then
                         category = vim.trim(parts[1])
                         description = vim.trim(parts[2])
                      end
                      if not categories[category] then categories[category] = {} end
                      local display_string = string.format("[%s] %-20s -> %s", map.mode, map.lhs, description)
                      table.insert(categories[category], { display = display_string, value = map })
                    end
                  end
                end
              
                local sorted_category_names = {}
                for name, _ in pairs(categories) do table.insert(sorted_category_names, name) end
                table.sort(sorted_category_names)
              
                for _, category_name in ipairs(sorted_category_names) do
                  table.insert(display_list, { display = string.format("--- %s ---", category_name), unreachable = true })
                  local maps_in_category = categories[category_name]
                  table.sort(maps_in_category, function(a,b) return a.value.lhs < b.value.lhs end)
                  for _, item in ipairs(maps_in_category) do table.insert(display_list, item) end
                  table.insert(display_list, { display = "", unreachable = true })
                end
              
                pickers.new({}, {
                  prompt_title = "Keymaps Help",
                  finder = finders.new_table {
                    results = display_list,
                    entry_maker = function(entry)
                      return {
                        value = entry.value,
                        display = entry.display,
                        ordinal = entry.display,
                        unreachable = entry.unreachable or false
                      }
                    end
                  },
                  attach_mappings = function(prompt_bufnr, map_func)
                      actions.select_default:replace(function()
                          local selection = action_state.get_selected_entry()
                          if selection and not selection.unreachable then
                              actions.close(prompt_bufnr)
                              print("Selected Keymap Details:")
                              print(vim.inspect(selection.value))
                          elseif selection and selection.unreachable then
                          else
                              actions.close(prompt_bufnr)
                          end
                      end)
                      return true
                  end,
                }):find()
            end
            
            vim.keymap.set('n', '<leader>help', show_keymaps, { noremap = true, silent = true, desc = 'Help: Show custom keymaps' })
        end
    }
}
