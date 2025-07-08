return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				-- lua = { "luacheck" },
				python = { "flake8" },
				javascript = { "eslint" },
				typescript = { "eslint" },
				html = { "htmlhint" },
				css = { "stylelint" },
				-- c = { "cppcheck" },
				-- cpp = { "cppcheck" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("linting", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
			vim.keymap.set("n", "<leader>l", function()
				require("lint").try_lint()
			end, { desc = "Run Linting" })
		end,
	},
}
