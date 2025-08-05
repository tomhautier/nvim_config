--[[ local lsp_zero = require('lsp-zero')
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

 lsp_zero.on_attach(function(client, bufnr)
    local opts_with_desc = function(desc)
        return { buffer = bufnr, remap = false, desc = 'LSP: ' .. desc }
    end

  
end) 

vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { desc = 'Go to definition'})
  vim.keymap.set("n", "tgd", function() vim.cmd('tab split'); vim.lsp.buf.definition() end)
  vim.keymap.set("n", "tgi", function() vim.cmd('tab split'); vim.lsp.buf.references() end)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, { desc = 'LSP: Hover documentation' })
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, { desc = 'LSP: Workspace symbols' })
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, { desc = 'LSP: Show line diagnostics' })
  vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, { desc = 'LSP: Go to implementation' })
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, { desc = 'LSP: Go to next diagnostic' })
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, { desc = 'LSP: Go to previous diagnostic' })
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, { desc = 'LSP: Code actions' })
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, { desc = 'LSP: Show references' })
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, { desc = 'LSP: Rename symbol' })
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, { desc = 'LSP: Signature help' })
  vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: Code actions (alternative)' })

vim.lsp.config('*', {
  root_markers = { '.git' },
})

-- Set configuration for typescript language server
vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
})

-- Enable Typescript Language Server
vim.lsp.enable('ts_ls')--]]