return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"github/copilot.vim",
		},
		opts = {
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
	},
}
