-- require("monet").setup {
--        transparent_background = false,
--        semantic_tokens = true,
--        dark_mode = false,
--        highlight_overrides= {},
--        color_overrides = {},
--        styles = {},
--    }
require("colorizer").setup()
function InitMonetColorScheme()
    require("monet").setup {
        transparent_background = false,
        semantic_tokens = true,
        dark_mode = false,
        highlight_overrides= {},
        color_overrides = {},
        styles = {},
    }
end

require('kanagawa').setup({
    transparent = true
})

function ColorMyPencils(color)
    vim.cmd("colorscheme kanagawa-dragon")
   -- vim.cmd("colorscheme neopywal")
    --vim.cmd("colorscheme monpropretheme")
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none"})
end

--InitMonetColorScheme();
ColorMyPencils();
