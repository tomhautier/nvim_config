local lsp_zero = require('lsp-zero')
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

lsp_zero.on_attach(function(client, bufnr)
    local opts_with_desc = function(desc)
        return { buffer = bufnr, remap = false, desc = 'LSP: ' .. desc }
    end

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts_with_desc('Go to definition'))
  vim.keymap.set("n", "tgd", function() vim.cmd('tab split'); vim.lsp.buf.definition() end)
  vim.keymap.set("n", "tgi", function() vim.cmd('tab split'); vim.lsp.buf.references() end)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts_with_desc('Hover documentation'))
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts_with_desc('Workspace symbols'))
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts_with_desc('Show line diagnostics'))
  vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts_with_desc('Go to implementation'))
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts_with_desc('Go to next diagnostic'))
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts_with_desc('Go to previous diagnostic'))
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts_with_desc('Code actions'))
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts_with_desc('Show references'))
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts_with_desc('Rename symbol'))
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts_with_desc('Signature help'))
  vim.keymap.set({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'LSP: Code actions (alternative)' })
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the list of servers with the ones you want installed
  ensure_installed = {'lua_ls', 'ts_ls', 'rust_analyzer'},
  handlers = {
    lsp_zero.default_setup,
    -- Example of custom setup for a specific server if needed
    -- lua_ls = function()
    --   local lua_opts = lsp_zero.nvim_lua_ls()
    --   require('lspconfig').lua_ls.setup(lua_opts)
    -- end,
  }
})

cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({select = true}),
    ['<Tab>'] = cmp_action.tab_complete(),
    ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
  }
})
