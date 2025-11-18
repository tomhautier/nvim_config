local lsp_config = require('lspconfig')
local lsp_defaults = lsp_config.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- Helper function to create LSP keymaps that only trigger if a client is attached.
local function lsp_keymap(mode, key, action, desc)
  vim.keymap.set(mode, key, function()
    if #vim.lsp.get_clients({ buffer = 0 }) > 0 then
      action()
    else
      vim.notify("LSP not attached to this buffer.", vim.log.levels.WARN)
    end
  end, { desc = "LSP: " .. desc })
end

-- Global LSP Keymaps
lsp_keymap("n", "gd", function() vim.cmd('tab split'); vim.schedule(vim.lsp.buf.definition) end, "Go to definition in new tab")
lsp_keymap("n", "gD", require('telescope.builtin').lsp_references, "Show references (via Telescope)")
lsp_keymap("n", "K", vim.lsp.buf.hover, "Hover documentation")
lsp_keymap("n", "<leader>vws", vim.lsp.buf.workspace_symbol, "Workspace symbols")
lsp_keymap("n", "<leader>vd", vim.diagnostic.open_float, "Show line diagnostics")
lsp_keymap("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
lsp_keymap("n", "[d", vim.diagnostic.goto_next, "Go to next diagnostic")
lsp_keymap("n", "]d", vim.diagnostic.goto_prev, "Go to previous diagnostic")
lsp_keymap("n", "<leader>vca", vim.lsp.buf.code_action, "Code actions")
lsp_keymap("n", "<leader>vrr", vim.lsp.buf.references, "Show references")
lsp_keymap("n", "<leader>vrn", vim.lsp.buf.rename, "Rename symbol")
lsp_keymap("i", "<C-h>", vim.lsp.buf.signature_help, "Signature help")
lsp_keymap({ 'n' }, '<leader>ca', vim.lsp.buf.code_action, "Code actions (alternative)")


local on_attach = function(client, bufnr)
  -- Keymaps are now global.
  -- This function is kept for any future client-specific settings.
end

require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({
        on_attach = on_attach,
        capabilities = require('cmp_nvim_lsp').default_capabilities()
      })
    end
  }
})

require('typescript-tools').setup({
  on_attach = on_attach,
  settings = {
    -- ...
  },
  tsserver_path = vim.fn.expand('~/.nvm/versions/node/v20.15.1/bin/tsserver'),
}) 
