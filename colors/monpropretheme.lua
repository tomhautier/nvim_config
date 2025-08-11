-- monpropretheme.lua

-- D'abord, on réinitialise les styles par défaut
vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.g.colors_name = 'monpropretheme'

-- Définir une palette de couleurs
local palette = {
  background = '#1e1e2e',
  foreground = '#cdd6f4',
  comment    = '#6c7086',
  keyword    = '#cba6f7',
  string     = '#a6e3a1',
  -- Ajoutez d'autres couleurs ici
}

-- Appliquer les couleurs aux groupes de coloration syntaxique
vim.api.nvim_set_hl(0, 'Normal', { fg = palette.foreground, bg = palette.background })
vim.api.nvim_set_hl(0, 'Comment', { fg = palette.comment, italic = true })
vim.api.nvim_set_hl(0, 'Keyword', { fg = palette.keyword })
vim.api.nvim_set_hl(0, 'String', { fg = palette.string })
-- ... et ainsi de suite pour tous les autres groupes que vous voulez personnaliser
