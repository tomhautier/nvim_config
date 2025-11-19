return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "mxsdev/nvim-dap-vscode-js", -- Support Node/Chrome
        "microsoft/vscode-js-debug", -- L'adapteur VSCode
        "nvim-neotest/nvim-nio"
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("dap-vscode-js").setup({
            -- Chemin vers vscode-js-debug (à installer via mason ou manuellement)
            -- Note: Mason l'installe dans un path spécifique, on essaie de le détecter
            debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter",
            adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        })

        for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
            dap.configurations[language] = {
                {
                    type = "pwa-node",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    cwd = "${workspaceFolder}",
                },
                {
                    type = "pwa-node",
                    request = "attach",
                    name = "Attach",
                    processId = require'dap.utils'.pick_process,
                    cwd = "${workspaceFolder}",
                }
            }
        end
        
        dapui.setup()
        
        -- Ouvrir l'UI automatiquement quand on debug
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Continue" })
    end
}

