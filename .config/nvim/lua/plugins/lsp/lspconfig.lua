return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
			callback = function(args)
				local opts = { buffer = args.buf, silent = true }

				opts.desc = "Show References"
				keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)

				opts.desc = "Show Definition"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)

				opts.desc = "Show Type Definition"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)

				opts.desc = "Show Implementation"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)

				opts.desc = "Show documentation for symbol under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Show Buffer Diagnostics"
				keymap.set("n", "<leader>d", "<cmd>Telescope diagnostics bufnr=0<cr>", opts)

				opts.desc = "Go to Next Diagnostic"
				keymap.set("n", "]d", function()
					vim.diagnostic.jump({ count = 1 })
				end, opts)

				opts.desc = "Go to Previous Diagnostic"
				keymap.set("n", "[d", function()
					vim.diagnostic.jump({ count = -1 })
				end, opts)

				opts.desc = "Rename Symbol"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Code Action"
				keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Go to Definition"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Restart LSP Server"
				keymap.set("n", "<leader>rs", ":LspRestart<cr>", opts)
			end,
		})
		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
				-- Underline with squiggly line
				-- linehl = {
				-- 	[vim.diagnostic.severity.ERROR] = "DiagnosticUnderlineError",
				-- 	[vim.diagnostic.severity.WARN] = "DiagnosticUnderlineWarn",
				-- 	[vim.diagnostic.severity.HINT] = "DiagnosticUnderlineHint",
				-- 	[vim.diagnostic.severity.INFO] = "DiagnosticUnderlineInfo",
				-- },
				-- numhl = {
				-- 	[vim.diagnostic.severity.ERROR] = "DiagnosticError",
				-- 	[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
				-- 	[vim.diagnostic.severity.HINT] = "DiagnosticHint",
				-- 	[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
				-- },
			},
		})

		local servers = {
			"html",
			"cssls",
			"jsonls",
			"pyright",
			"clangd",
			"bashls",
			"gopls",
			"dockerls",
			"yamlls",
		}

		for _, server in ipairs(servers) do
			vim.lsp.config(server, { capabilities = capabilities })
			vim.lsp.enable(server)
		end

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")
	end,
}
