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

-- Copilot

-- Allow all filetypes to use copilot
vim.g.copilot_filetypes = {
	["*"] = true,
}

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp", { clear = true }),
	callback = function(args)
		-- 2
		vim.api.nvim_create_autocmd("BufWritePre", {
			-- 3
			buffer = args.buf,
			callback = function()
				-- 4 + 5
				vim.lsp.buf.format({ async = false, id = args.data.client_id })
			end,
		})
	end,
})

-- Colorscheme

local status, _ = pcall(vim.cmd, "colorscheme nightfly")
if not status then
	print("Colorscheme not found !!!")
	return
end
