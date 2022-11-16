-- Makes sure Packer is installed and if it isn't it installes it
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

-- Automatically reloads the packages if the file is changed
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerInstall
  augroup end
]])

-- Try to import packer
-- If it fails return nothing
-- else continue 
local status, packer = pcall(require, "packer")
if not status then
    return
end

return packer.startup(function(use)

    use("wbthomason/packer.nvim")

    -- Lua functions for other plugins
    use("nvim-lua/plenary.nvim")

    -- Colorscheme
    use("bluz71/vim-nightfly-guicolors")

    -- Tmux and split windows
    -- use("christoomey/vim-tmux-navigator")

    -- Maximizes and resteres split windows
    use("szw/vim-maximizer")

    -- Surround text
    use("tpope/vim-surround")

    -- Replace something with copied text
    use("vim-scripts/ReplaceWithRegister")

    -- Comment with gc
    use
    { 
        "numToStr/Comment.nvim",
        config = [[require('config.comments')]]    }

	use 
    {
  		'nvim-lualine/lualine.nvim',
        config = [[require('config.lualine')]],
  		requires = 
        { 
            'kyazdani42/nvim-web-devicons', 
            opt = true 
        }
	}

    use('nvim-tree/nvim-web-devicons')

    -- Nvim tree
    use 
    {
        'nvim-tree/nvim-tree.lua',
        requires = 
        {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        config = [[require('config.tree')]],
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    -- Startin Dashboard
	use 
    { 
        "glepnir/dashboard-nvim", 
        event = "VimEnter",
        cond = firenvim_not_active,
        config = [[require('config.dashboard')]]
    }

    -- fuzzy finding w/ telescope
    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim", 
        config = [[require('config.telescope')]],
        branch = "0.1.x" }) -- fuzzy finder

    if packer_bootstrap then
        require("packer").sync()
    end
end)
