vim.g.mapleader = " "

local keymap = vim.keymap

-- Remove search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- X doesnt copy to clipboard
keymap.set("n", "x", '"_x')


-- Tab control
keymap.set("n", "<leader>to", ":tabnew<CR>")
keymap.set("n", "<leader>tx", ":tabclose<CR>")
keymap.set("n", "<leader>tp", ":tabp<CR>")
keymap.set("n", "<leader>tn", ":tabn<CR>")


-- Plugins
-----------------------------------
-- Vim Maximizer
keymap.set("n", "<leader>mm", ":MaximizerToggle<CR>")

-- Nvim Tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Telescope
-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
