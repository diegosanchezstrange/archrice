local opt = vim.opt

-- Numbers
opt.number = true
opt.relativenumber = true


-- Tabs and indents
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- No wrap lines
opt.wrap = false

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

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
-- opt.clipboard:append("unnamedplus")

opt.iskeyword:append("-")

opt.encoding = "utf-8"

-- Colorscheme

local status, _ = pcall(vim.cmd, "colorscheme nightfly")
if not status then
    print("Colorscheme not found !!!")
    return
end
