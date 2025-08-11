-- Configuration pour ESLint et Prettier
local lint = require("lint")
local conform = require("conform")

-- Configuration de nvim-lint pour ESLint
-- Utilise eslint_d qui lit automatiquement les configs locales (.eslintrc, etc.)
lint.linters_by_ft = {
	javascript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescript = { "eslint_d" },
	typescriptreact = { "eslint_d" },
	vue = { "eslint_d" },
	svelte = { "eslint_d" },
}

-- Configuration des diagnostics pour une meilleure visibilité
vim.diagnostic.config({
	virtual_text = {
		prefix = "●", -- Peut être '●', '▎', 'x', '■', etc.
		source = "always", -- Affiche la source (eslint, etc.)
	},
	float = {
		source = "always", -- Affiche la source dans la popup
		border = "rounded",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- Configuration de conform.nvim pour Prettier ET ESLint fix
conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		-- Pour JavaScript/TypeScript : seulement Prettier (ESLint fix sera manuel)
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		vue = { "prettier" },
		svelte = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
	},

	-- Configuration des formateurs
	formatters = {
		-- Suppression de la config eslint_d qui causait le problème JSON
		-- Prettier avec config locale
		prettier = {
			args = function(self, ctx)
				local args = { "--stdin-filepath", "$FILENAME" }

				-- Chercher un fichier de config Prettier dans le projet
				local prettier_config_files = {
					".prettierrc",
					".prettierrc.json",
					".prettierrc.js",
					".prettierrc.mjs",
					".prettierrc.cjs",
					"prettier.config.js",
					"prettier.config.mjs",
					"prettier.config.cjs",
				}

				for _, config_file in ipairs(prettier_config_files) do
					if vim.fn.findfile(config_file, ".;") ~= "" then
						table.insert(args, "--config")
						table.insert(args, vim.fn.findfile(config_file, ".;"))
						break
					end
				end

				return args
			end,
		},
	},
	format_on_save = function(bufnr)
		-- Applique seulement Prettier automatiquement
		return {
			timeout_ms = 500,
			lsp_fallback = true,
			formatters = { "prettier" },
		}
	end,
})

-- Configuration personnalisée pour eslint_d linting
-- Arguments simplifiés qui fonctionnent avec eslint_d
lint.linters.eslint_d.args = {
	"--format",
	"json",
	"--stdin",
	"--stdin-filename",
	function()
		return vim.api.nvim_buf_get_name(0)
	end,
}

-- Fonction pour lancer le linting manuellement
local function lint_file()
	lint.try_lint()
end

-- Fonction pour formater manuellement
local function format_file()
	conform.format({ async = true, lsp_fallback = true })
end

-- Fonction pour afficher tous les diagnostics
local function show_diagnostics()
	vim.diagnostic.setloclist()
end

-- Auto-commandes pour le linting
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
	end,
})

-- Affichage automatique des diagnostics au hover
vim.api.nvim_create_autocmd("CursorHold", {
	group = lint_augroup,
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})

-- Fonction simple et sûre pour ESLint fix
local function safe_eslint_fix()
	local filename = vim.api.nvim_buf_get_name(0)

	-- Vérifier que c'est un fichier JS/TS
	if
		not (filename:match("%.js$") or filename:match("%.jsx$") or filename:match("%.ts$") or filename:match("%.tsx$"))
	then
		print("Not a JS/TS file")
		conform.format({ async = true, lsp_fallback = true })
		return
	end

	print("Running ESLint fix...")

	-- Sauvegarder d'abord
	vim.cmd("write")

	-- Utiliser jobstart pour une exécution propre
	vim.fn.jobstart({ "npx", "eslint", "--fix", filename }, {
		on_exit = function(job_id, exit_code, event_type)
			vim.schedule(function()
				print("ESLint finished with code: " .. exit_code)
				-- Recharger le fichier
				vim.cmd("edit!")
				-- Puis formatter avec Prettier
				conform.format({ async = true, lsp_fallback = true })
			end)
		end,
		on_stdout = function(job_id, data, event_type)
			-- Ne rien faire avec stdout pour éviter les problèmes
		end,
		on_stderr = function(job_id, data, event_type)
			if data and #data > 0 then
				vim.schedule(function()
					print("ESLint output: " .. table.concat(data, "\n"))
				end)
			end
		end,
	})
end

-- Keymaps
vim.keymap.set("n", "<leader>l", lint_file, { desc = "Lint file" })
vim.keymap.set("n", "<leader>f", format_file, { desc = "Format file" })
vim.keymap.set("n", "<leader>lf", safe_eslint_fix, { desc = "ESLint fix + format", silent = false })
vim.keymap.set("v", "<leader>f", function()
	conform.format({ async = true, lsp_fallback = true })
end, { desc = "Format selection" })

-- Commande alternative pour ESLint fix
vim.api.nvim_create_user_command("ESLintFix", safe_eslint_fix, {
	desc = "Run ESLint --fix and format",
})

-- Test du keymap (pour debug)
vim.keymap.set("n", "<leader>test", function()
	print("Keymap test works!")
end, { desc = "Test keymap" })

-- Fonction de test simple pour ESLint fix seulement
local function simple_eslint_fix()
	local filename = vim.api.nvim_buf_get_name(0)
	print("Simple ESLint fix for: " .. filename)

	-- Sauvegarde d'abord
	vim.cmd("write")

	-- Commande simple
	local cmd = "npx eslint --fix " .. vim.fn.shellescape(filename)
	print("Command: " .. cmd)

	local result = vim.fn.system(cmd)
	print("Result: " .. (result or "no output"))
	print("Exit code: " .. vim.v.shell_error)

	-- Recharge
	vim.cmd("checktime")
end

-- Keymap pour le test simple
vim.keymap.set("n", "<leader>ef", simple_eslint_fix, { desc = "Simple ESLint fix test" })

-- Keymaps pour les diagnostics
vim.keymap.set("n", "<leader>ed", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>q", show_diagnostics, { desc = "Show all diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

-- Commande pour désactiver le formatage automatique si besoin
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- Désactiver globalement
		vim.b.disable_autoformat = true
	else
		-- Désactiver pour ce buffer
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

-- Keymap alternatif
vim.keymap.set("n", "<leader>fix", simple_eslint_fix, { desc = "Alternative ESLint fix" })
