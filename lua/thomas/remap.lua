vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = 'File: Open file explorer' })

-- Close current window
vim.keymap.set("n", "<leader>q", vim.cmd.q, { desc = 'Window: Close current' })
-- Save current buffer
vim.keymap.set("n", "<leader>W", vim.cmd.w, { desc = 'Buffer: Save current' })

vim.keymap.set('n', '<leader>w', '<C-w>w', { desc = "Window: Cycle next", noremap = true, silent = true })

function OpenAndCloseTerminal(command)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.1),
    style = 'minimal',
    border = 'single'
  })
  
  vim.fn.termopen(command, {
    on_exit = function()
      vim.api.nvim_win_close(win, true)
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  })
  
  vim.cmd('startinsert')
end

-- file browser

vim.keymap.set("n", "<space>fb", function()
	require("telescope").extensions.file_browser.file_browser()
end, { desc = 'Telescope: File browser' })

-- Function to open Telescope picker for IDE/Project selection
local function select_ide_project()
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local finders = require('telescope.finders')
  local pickers = require('telescope.pickers')
  local conf = require('telescope.config').values
  local build_dir_to_open = "/home/bandini/WebstormProjects/OfflineCamera/android/app/build/outputs/apk/debug"

  local current_working_dir = vim.fn.getcwd()
  
  -- Get all open buffers that are files
  local open_files = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
          local bufname = vim.api.nvim_buf_get_name(buf)
          if bufname and bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
              table.insert(open_files, bufname)
          end
      end
  end
  
  -- Define the 4 choices
  local choices = {
    { 
      display = "WebStorm - Current Directory", 
      dir = "/home/bandini/Téléchargements/WebStorm-2025.1.3/WebStorm-251.26927.40/bin", 
      cmd = "./webstorm " .. vim.fn.shellescape(current_working_dir)
    },
    { 
      display = "WebStorm - Current Directory With Nvim Tabs", 
       dir = "/home/bandini/Téléchargements/WebStorm-2025.1.3/WebStorm-251.26927.40/bin",
            cmd = "./webstorm " .. vim.fn.shellescape(current_working_dir) .. " " .. table.concat(vim.tbl_map(vim.fn.shellescape, open_files), " ")
    },
    { 
      display = "Cursor - Current Directory", 
      dir = current_working_dir, 
      cmd = "/home/bandini/Téléchargements/Cursor-0.49.6-x86_64.AppImage . --no-sandbox" 
    },
    { 
      display = "File Manager - OfflineCamera Build Directory", 
      dir = "/", 
      cmd = "xdg-open " .. vim.fn.shellescape(build_dir_to_open) 
    }
  }

  pickers.new({}, {
    prompt_title = "Select IDE/Project",
    finder = finders.new_table {
      results = choices,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.display,
          ordinal = entry.display,
        }
      end,
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection and selection.value then
          local choice_data = selection.value
          local command = choice_data.cmd
          local full_shell_command

          -- Check if the command is xdg-open, if so, run it directly with nohup
          if command:match("^xdg%-open") then
            full_shell_command = "nohup " .. command .. " >/dev/null 2>&1 &"
          else
            -- Otherwise, construct the cd && command structure with nohup
            local target_dir = vim.fn.expand(choice_data.dir)
            full_shell_command = "cd " .. vim.fn.shellescape(target_dir) .. " && nohup " .. command .. " >/dev/null 2>&1 &"
          end

          -- Execute the command using vim.fn.system to truly detach it
          vim.fn.system(full_shell_command)
          vim.notify("Launched: " .. choice_data.display, vim.log.levels.INFO)
        end
      end)
      return true
    end,
  }):find()
end

-- Set the new keymap
vim.keymap.set("n", "<leader>ide", select_ide_project, { desc = "System: Select IDE/Project to launch" })

-- Merge current tab with the next tab
vim.keymap.set("n", "<leader>tm", function()
    -- Store current tab number
    local current_tab = vim.fn.tabpagenr()
    
    -- Check if there's a next tab
    if current_tab < vim.fn.tabpagenr('$') then
        -- Store current buffer
        local current_buf = vim.api.nvim_get_current_buf()
        
        -- Save all windows from the next tab
        vim.cmd('tabnext')
        local windows = vim.api.nvim_tabpage_list_wins(0)
        local buffers = {}
        
        -- Store buffer numbers for each window
        for _, win in ipairs(windows) do
            table.insert(buffers, vim.api.nvim_win_get_buf(win))
        end
        
        -- Move back to original tab
        vim.cmd('tabprevious')
        
        -- Create a vertical split first
        vim.cmd('vsplit')
        -- Move to the right window
        vim.cmd('wincmd l')
        
        -- Set the first buffer from the next tab
        if #buffers > 0 then
            vim.api.nvim_win_set_buf(0, buffers[1])
        end
        
        -- Create additional vertical splits for any remaining buffers
        for i = 2, #buffers do
            vim.cmd('vsplit')
            vim.api.nvim_win_set_buf(0, buffers[i])
        end
        
        -- Move back to the leftmost window and set original buffer
        vim.cmd('wincmd h')
        vim.api.nvim_win_set_buf(0, current_buf)
        
        -- Close the next tab
        vim.cmd('tabclose ' .. (current_tab + 1))
    else
        vim.notify("No next tab to merge", vim.log.levels.WARN)
    end
end, { desc = 'Tab: Merge with next tab' })

-- Add these lines to lua/thomas/remap.lua if you want custom tab switching keys

vim.keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Tab: Next tab" })
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Tab: Previous tab" })

-- Launch new terminal with Neovim on current file
vim.keymap.set("n", "<S-t>", function()
  local current_working_dir = vim.fn.getcwd()
  local current_file = vim.api.nvim_buf_get_name(0)
  
  -- Build the command
  local nvim_command
  if current_file and current_file ~= "" and vim.fn.filereadable(current_file) == 1 then
    nvim_command = "nvim " .. vim.fn.shellescape(current_file)
  else
    nvim_command = "nvim"
  end
  
  -- Launch xterm with nvim
  local xterm_cmd = {"xterm", "-e", "bash", "-c", "cd " .. vim.fn.shellescape(current_working_dir) .. " && " .. nvim_command}
  
  local job_id = vim.fn.jobstart(xterm_cmd, {
    detach = true
  })
  
  if current_file and current_file ~= "" then
    vim.notify("Launched xterm with nvim on " .. vim.fn.fnamemodify(current_file, ":t"), vim.log.levels.INFO)
  else
    vim.notify("Launched xterm with nvim", vim.log.levels.INFO)
  end
end, { desc = "Terminal: Launch xterm with Neovim on current file" })
