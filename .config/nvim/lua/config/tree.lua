local status, tree = pcall(require, "nvim-tree")
if not status then
	return
end

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1
vim.g.nvim_tree_respect_buf_cwd = 1

vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

tree.setup({

	renderer = {
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "",
					arrow_open = "",
				},
			},
		},
	},
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
})

-- local function open_nvim_tree()
--
--   -- open the tree
--   require("nvim-tree.api").tree.open()
-- end

local function open_nvim_tree(data)
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1

	if not directory then
		return
	end

	-- change to the directory
	vim.cmd.cd(data.file)

	-- open the tree
	require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
