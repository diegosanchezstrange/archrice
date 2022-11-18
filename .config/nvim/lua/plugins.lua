-- Makes sure Packer is installed and if it isn't it installes it
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer()

-- Automatically reloads the packages if the file is changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Try to import packer
-- If it fails return nothing
-- else continue
local status, packer = pcall(require, "packer")
if not status then
	return
end

return packer.startup(function(use)
	use("wbthomason/packer.nvim")

	-- Lua functions for other plugins
	use("nvim-lua/plenary.nvim")

	-- Colorscheme
	use("bluz71/vim-nightfly-guicolors")

	-- Tmux and split windows
	-- use("christoomey/vim-tmux-navigator")

	-- Maximizes and resteres split windows
	use("szw/vim-maximizer")

	-- Surround text
	use("tpope/vim-surround")

	-- Replace something with copied text
	use("vim-scripts/ReplaceWithRegister")

	-- Comment with gc
	use({
		"numToStr/Comment.nvim",
		config = [[require('config.comments')]],
	})

	use({
		"nvim-lualine/lualine.nvim",
		config = [[require('config.lualine')]],
		requires = {
			"kyazdani42/nvim-web-devicons",
			opt = true,
		},
	})

	use("nvim-tree/nvim-web-devicons")

	-- Nvim tree
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		config = [[require('config.tree')]],
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})

	-- Startin Dashboard
	use({
		"glepnir/dashboard-nvim",
		event = "VimEnter",
		cond = firenvim_not_active,
		config = [[require('config.dashboard')]],
	})

	-- fuzzy finding w/ telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", config = [[require('config.telescope')]], branch = "0.1.x" }) -- fuzzy finder

	-- autocompletion
	use({ "hrsh7th/nvim-cmp", config = [[require('config.nvim-cmp')]] }) -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system paths

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig
	use({ "williamboman/mason.nvim", config = [[require('config.lsp.mason')]] }) -- in charge of managing lsp servers, linters & formatters

	-- configuring lsp servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion
	use({ "glepnir/lspsaga.nvim", branch = "main", config = [[require('config.lsp.lspsaga')]] }) -- enhanced lsp uis
	use({ "neovim/nvim-lspconfig", config = [[require('config.lsp.lspconfig')]] }) -- easily configure language servers

	-- formatting & linting
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls
	use({ "jose-elias-alvarez/null-ls.nvim", config = [[require('config.lsp.null-ls')]] }) -- configure formatters & linters

	-- treesitter configuration
	use({
		"nvim-treesitter/nvim-treesitter",
		config = [[require('config.treesitter')]],
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- auto closing
	use({ "windwp/nvim-autopairs", config = [[require('config.autopairs')]] })
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- git integration
	use({ "lewis6991/gitsigns.nvim", config = [[require('config.gitsigns')]] }) -- show line modifications on left hand side

	if packer_bootstrap then
		require("packer").sync()
	end
end)
