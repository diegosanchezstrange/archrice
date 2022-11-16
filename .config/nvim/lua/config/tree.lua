local status, tree = pcall(require, "nvim-tree")
if not status then
    return
end

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

tree.setup({

    renderer = 
    {
        icons = 
        {
          glyphs = 
          {
            folder = 
            {
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
