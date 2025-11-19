return {
    "axelvc/template-string.nvim",
    event = "InsertEnter",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "python" },
    config = function()
        require("template-string").setup({
            filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "python" },
            jsx_brackets = true, -- must add brackets to JSX attributes
            remove_template_string = true, -- remove backticks when there are no template strings
            restore_quotes = {
                -- quotes used when "remove_template_string" is enabled
                normal = [[']],
                jsx = [["]],
            },
        })
    end,
}

