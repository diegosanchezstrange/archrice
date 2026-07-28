return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = { "c", "cpp", "lua", "python", "rust", "javascript", "typescript" },
			highlight = { enable = true },
			indent = { enable = true },
			auto_install = true,
		})
	end,
}
