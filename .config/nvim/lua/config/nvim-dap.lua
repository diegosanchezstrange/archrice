local status, dap = pcall(require, "dap")
if not status then
	return
end

local status, nvim_dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if not status then
	return
end

-- local status, dapui = pcall(require, "dapui")
-- if not status then
-- 	return
-- end

nvim_dap_virtual_text.setup()

dap.adapters.lldb = {
	type = "executable",
	command = "/opt/homebrew/opt/llvm/bin/lldb-vscode",
	name = "lldb",
}

dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
		runInTerminal = false,
	},
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "🟦", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })

-- vim.keymap.set("n", "<leader>dh", function()
-- 	require("dap").toggle_breakpoint()
-- end)
-- vim.keymap.set("n", "<leader>dH", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
-- vim.keymap.set({ "n", "t" }, "<A-k>", function()
-- 	require("dap").step_out()
-- end)
-- vim.keymap.set({ "n", "t" }, "<A-l>", function()
-- 	require("dap").step_into()
-- end)
-- vim.keymap.set({ "n", "t" }, "<A-j>", function()
-- 	require("dap").step_over()
-- end)
-- vim.keymap.set({ "n", "t" }, "<A-h>", function()
-- 	require("dap").continue()
-- end)
-- vim.keymap.set("n", "<leader>dn", function()
-- 	require("dap").run_to_cursor()
-- end)
-- vim.keymap.set("n", "<leader>dc", function()
-- 	require("dap").terminate()
-- end)
-- vim.keymap.set("n", "<leader>dR", function()
-- 	require("dap").clear_breakpoints()
-- end)
-- vim.keymap.set("n", "<leader>de", function()
-- 	require("dap").set_exception_breakpoints({ "all" })
-- end)
-- vim.keymap.set("n", "<leader>da", function()
-- 	require("debugHelper").attach()
-- end)
-- vim.keymap.set("n", "<leader>dA", function()
-- 	require("debugHelper").attachToRemote()
-- end)
-- vim.keymap.set("n", "<leader>di", function()
-- 	require("dap.ui.widgets").hover()
-- end)
-- vim.keymap.set("n", "<leader>d?", function()
-- 	local widgets = require("dap.ui.widgets")
-- 	widgets.centered_float(widgets.scopes)
-- end)
-- vim.keymap.set("n", "<leader>dk", ':lua require"dap".up()<CR>zz')
-- vim.keymap.set("n", "<leader>dj", ':lua require"dap".down()<CR>zz')
-- vim.keymap.set("n", "<leader>dr", ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
-- vim.keymap.set("n", "<leader>du", ':lua require"dapui".toggle()<CR>')
