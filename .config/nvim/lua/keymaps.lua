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


-- Vim Maximizer
keymap.set("n", "<leader>mm", ":MaximizerToggle<CR>")
