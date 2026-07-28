return 
{
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle File Explorer" },
    },
    init = function()
        local arg = vim.fn.argv()[1]

        if arg and vim.fn.isdirectory(arg) == 1 then
            vim.api.nvim_create_autocmd("VimEnter", {
              callback = function()
                require("lazy").load({ plugins = { "nvim-tree.lua" } })
                vim.cmd.cd(arg)
                vim.schedule(function()
                  require("nvim-tree.api").tree.open()
                end)
              end,
            })
        end
    end,
    opts = {
        hijack_netrw = true,
        view = {
            width = 30,
            side = "left",
        },
        renderer = {
            group_empty = true,
        },
        filters = {
            dotfiles = false,
        },
    },
}
