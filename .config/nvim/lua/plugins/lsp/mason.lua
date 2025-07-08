return
{
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        require("mason").setup({
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "html",
                "cssls",
                "jsonls",
                "pyright",
                "clangd",
                "bashls",
                "gopls",
                "dockerls",
                "yamlls",
            },
        })

        require("mason-tool-installer").setup({
            ensure_installed = {
                "prettier",
                "stylua",
                "eslint_d",
                "clang-format",
                "shellcheck",
                "gofumpt",
            },
        })
    end,
}
