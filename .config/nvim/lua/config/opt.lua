local opt = vim.opt
local g = vim.g

-- Numbers
opt.number = true
opt.relativenumber = true

-- Tabs and indents
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Max lenght
opt.textwidth = 80
opt.colorcolumn = "80"

-- For search
opt.ignorecase = true
opt.smartcase = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.encoding = "utf-8"

-- Plugin options

-- nvim-tree
-- g.loaded_netrw = 1
-- g.loaded_netrwPlugin = 1
