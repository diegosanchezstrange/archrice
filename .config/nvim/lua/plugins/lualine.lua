return
{
    "nvim-lualine/lualine.nvim" ,
    config = function(_, opts)
        require('lualine').setup
        {
            options = 
            {
                theme = 'gruvbox'
            }
        }
    end,
}
