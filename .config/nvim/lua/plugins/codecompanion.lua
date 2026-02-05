return {
	{
		"olimorris/codecompanion.nvim",
		opts = {},
		version = "17.33.0",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"github/copilot.vim",
		},
		strategies = {
			chat = {
				adapter = "copilot",
				model = "gpt-4.1",
			},
			inline = {
				adapter = "copilot",
				model = "gpt-4.1",
			},
			cmd = {
				adapter = "copilot",
				model = "gpt-4.1",
			},
		},
	},
}
