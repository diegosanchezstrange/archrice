return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{
			"BurntSushi/ripgrep",
			cond = function()
				return vim.fn.executable("rg") == 1
			end,
		},
		{
			"sharkdp/fd",
			cond = function()
				return vim.fn.executable("fd") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		-- Keymaps
		vim.keymap.set("n", "<leader>ff", function()
			require("telescope.builtin").find_files({
				hidden = true,
				no_ignore = true,
			})
		end, { desc = "Find files" })

		vim.keymap.set("n", "<leader>fc", function()
			require("telescope.builtin").find_files({
				prompt_title = "Config files",
				cwd = vim.fn.stdpath("config"),
				hidden = true,
			})
		end, { desc = "Find config files" })

		vim.keymap.set("n", "<leader>fg", function()
			require("telescope.builtin").live_grep({
				additional_args = function(opts)
					return { "--hidden" }
				end,
			})
		end, { desc = "Live grep" })

		vim.keymap.set("n", "<leader>fB", function()
			require("telescope.builtin").buffers({
				sort_lastused = true,
			})
		end, { desc = "Buffers" })

		-- Keymaps for recent files
		vim.keymap.set("n", "<leader>fr", function()
			require("telescope.builtin").oldfiles({
				cwd = vim.fn.stdpath("data") .. "/site",
				prompt_title = "Recent files",
			})
		end, { desc = "Recent files" })

		vim.keymap.set("n", "<leader>fk", function()
			require("telescope.builtin").keymaps()
		end, { desc = "Keymaps" })

		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { ".git/", "node_modules/", "%.lock" },
				mappings = {
					i = {
						["<C-k>"] = require("telescope.actions").move_selection_previous,
						["<C-j>"] = require("telescope.actions").move_selection_next,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
					theme = "ivy",
				},
				buffers = {
					theme = "ivy",
				},
				oldfiles = {
					theme = "ivy",
				},
				diagnostics = {
					theme = "ivy",
				},
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
				},
				["ui-select"] = {
					require("telescope.themes").get_ivy(),
				},
			},
		})
	end,
}
