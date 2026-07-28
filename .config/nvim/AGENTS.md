# AGENTS.md

## Project Overview

A personal Neovim configuration written entirely in Lua. It uses
[lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager and the
[catppuccin](https://github.com/catppuccin/nvim) colorscheme. The config is
organized in a modular structure: core options and the lazy bootstrap live under
`lua/config/`, and each plugin is configured in its own file under
`lua/plugins/` (with LSP-related plugins under `lua/plugins/lsp/`).

## Directory Structure

```
.config/nvim/
├── init.lua                     # Entry point; requires config.opt then config.lazy
├── lazy-lock.json               # lazy.nvim pinned plugin versions (auto-generated, do not edit)
├── lua/
│   ├── config/
│   │   ├── opt.lua              # Vim options (numbers, tabs, search, appearance) + mapleader notes
│   │   └── lazy.lua             # Bootstrap lazy.nvim, set leaders, import specs, apply colorscheme
│   └── plugins/
│       ├── alpha.lua            # alpha-nvim dashboard greeter
│       ├── barbar.lua           # barbar.nvim buffer/tabline
│       ├── which-key.lua        # which-key.nvim keybinding popup (no custom config)
│       ├── nvim-tree.lua        # nvim-tree.lua file explorer
│       ├── codecompanion.lua    # codecompanion.nvim AI assistant (copilot adapter)
│       ├── linting.lua          # nvim-lint linters by filetype
│       ├── preview.lua          # plantuml.nvim PlantUML preview
│       ├── avante.lua-bkp       # avante.nvim BACKUP (no .lua ext -> NOT auto-imported, dead config)
│       ├── treesitter.lua       # nvim-treesitter parsers/highlighting
│       ├── copilot.lua          # Empty spec (copilot.vim line commented out)
│       ├── lualine.lua          # lualine.nvim statusline
│       ├── telescope.lua        # telescope.nvim fuzzy finder + keymaps
│       ├── dressing.lua         # dressing.nvim UI dressing for vim.ui.select/input
│       ├── formatting.lua       # conform.nvim formatters by filetype
│       └── lsp/
│           ├── nvim-cmp.lua     # nvim-cmp completion engine + sources
│           ├── lspconfig.lua    # nvim-lspconfig server config + LSP keymaps
│           └── mason.lua        # mason.nvim + installer for LSP servers and tools
```

Notes:
- `plugins/` is auto-imported via `{ import = "plugins" }` in `lazy.lua`.
- `plugins/lsp/` is auto-imported via `{ import = "plugins.lsp" }` in `lazy.lua`.
- `config/` holds the lazy bootstrap plus vim options; it is not auto-imported —
  it is required explicitly from `init.lua`.

## How the Config Loads

1. `init.lua` runs `require("config.opt")` then `require("config.lazy")`.
2. `config/opt.lua` sets vim options (`number`, `relativenumber`, `tabstop=4`,
   `shiftwidth=4`, `expandtab`, `textwidth=80`, `colorcolumn="80"`,
   `ignorecase`/`smartcase`, `cursorline`, `termguicolors`, `background=dark`,
   `signcolumn=yes`, `encoding=utf-8`). The netrw-disable lines are commented
   out.
3. `config/lazy.lua` bootstraps lazy.nvim (cloning `folke/lazy.nvim` to
   `stdpath("data")/lazy/lazy.nvim` if missing), sets `mapleader = " "` and
   `maplocalleader = "\\"`, then calls `lazy.setup` with:
   - an inline `indent-blankline.nvim` spec (`main = "ibl"`, empty `opts`),
   - `{ import = "plugins" }`,
   - `{ import = "plugins.lsp" }`,
   - an inline `catppuccin/nvim` spec (`priority = 1000`),
   - `install = { colorscheme = { "habamax" } }` (used during install),
   - `checker = { enabled = true }` (auto update checking),
   - `git = { timeout = 200 }`.
4. After lazy loads, `vim.cmd.colorscheme("catppuccin")` applies the colorscheme.

## Plugins Inventory

Grouped by category. Canonical pinned list comes from `lazy-lock.json`.

### LSP / Completion
| Plugin | Config file | Purpose |
|---|---|---|
| `neovim/nvim-lspconfig` | `lua/plugins/lsp/lspconfig.lua` | LSP server configuration + LSP keymaps (LspAttach autocmd) |
| `hrsh7th/nvim-cmp` | `lua/plugins/lsp/nvim-cmp.lua` | Completion engine; sources nvim_lsp, luasnip, buffer, path |
| `hrsh7th/cmp-buffer` | (cmp dep) | Buffer-word completion source |
| `hrsh7th/cmp-path` | (cmp dep) | File-path completion source |
| `hrsh7th/cmp-nvim-lsp` | (lspconfig dep) | LSP completion source / default capabilities |
| `saadparwaiz1/cmp_luasnip` | (cmp dep) | LuaSnip completion source |
| `L3MON4D3/LuaSnip` | (cmp dep) | Snippet engine; built with `make install_jsregexp`, pinned `v2.*` |
| `rafamadriz/friendly-snippets` | (cmp dep) | Prebuilt VSCode-style snippets |
| `onsails/lspkind-nvim` | (cmp dep) | Pictogram symbols in cmp menu |
| `williamboman/mason.nvim` | `lua/plugins/lsp/mason.lua` | Package manager for LSP servers/tools |
| `williamboman/mason-lspconfig.nvim` | (mason dep) | Bridges mason <-> lspconfig |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | (mason dep) | Auto-installs configured tools |
| `antosha417/nvim-lsp-file-operations` | (lspconfig dep) | LSP-aware file operations |
| `folke/lazydev.nvim` | (lspconfig dep, `ft = "lua"`) | Lua dev types (loads `vim.uv` library) |

### Fuzzy Finder
| Plugin | Config file | Purpose |
|---|---|---|
| `nvim-telescope/telescope.nvim` | `lua/plugins/telescope.lua` | Fuzzy finder UI + pickers + keymaps |
| `nvim-telescope/telescope-fzf-native.nvim` | (telescope dep) | C fzf sorter (build `make`, cond `executable("make")`) |
| `nvim-telescope/telescope-ui-select.nvim` | (telescope dep) | `vim.ui.select` backend via telescope |
| `nvim-lua/plenary.nvim` | (telescope dep) | Lua utility library required by telescope |
| `BurntSushi/ripgrep` | (telescope dep, cond `executable("rg")`) | ripgrep for live_grep |

### UI / Visual
| Plugin | Config file | Purpose |
|---|---|---|
| `catppuccin/nvim` (name `catppuccin`) | inline in `lua/config/lazy.lua` | Colorscheme (`priority = 1000`) |
| `nvim-lualine/lualine.nvim` | `lua/plugins/lualine.lua` | Statusline (configured theme `gruvbox`) |
| `goolord/alpha-nvim` | `lua/plugins/alpha.lua` | Dashboard greeter with custom ASCII header |
| `romgrk/barbar.nvim` | `lua/plugins/barbar.lua` | Bufferline/tabline |
| `folke/which-key.nvim` | `lua/plugins/which-key.lua` | Keybinding popup (no custom config) |
| `stevearc/dressing.nvim` | `lua/plugins/dressing.lua` | Dresses `vim.ui.select`/`input` (`event = "VeryLazy"`) |
| `lukas-reineke/indent-blankline.nvim` | inline in `lua/config/lazy.lua` | Indent guides (`main = "ibl"`) |
| `nvim-tree/nvim-web-devicons` | (dep of barbar/nvim-tree) | Filetype icons |

### File Explorer
| Plugin | Config file | Purpose |
|---|---|---|
| `nvim-tree/nvim-tree.lua` | `lua/plugins/nvim-tree.lua` | File explorer; `<leader>e` toggle, hijacks netrw |

### Editor Enhancements
| Plugin | Config file | Purpose |
|---|---|---|
| `lewis6991/gitsigns.nvim` | (barbar dep) | Git signs in gutter (loaded as a barbar dependency) |

### AI / Copilot
| Plugin | Config file | Purpose |
|---|---|---|
| `olimorris/codecompanion.nvim` | `lua/plugins/codecompanion.lua` | AI chat/inline/cmd assistant (copilot adapter, `gpt-4.1`, pinned `v17.33.0`) |
| `github/copilot.vim` | (codecompanion dep) | Copilot provider for codecompanion |

### Formatting / Linting
| Plugin | Config file | Purpose |
|---|---|---|
| `stevearc/conform.nvim` | `lua/plugins/formatting.lua` | Formatter runner; format on save with lsp fallback |
| `mfussenegger/nvim-lint` | `lua/plugins/linting.lua` | Linter runner by filetype |

### Syntax
| Plugin | Config file | Purpose |
|---|---|---|
| `nvim-treesitter/nvim-treesitter` | `lua/plugins/treesitter.lua` | Treesitter parsers + highlight/indent |
| `goropikari/plantuml.nvim` | `lua/plugins/preview.lua` | PlantUML preview |
| `aklt/plantuml-syntax` | (preview dep) | PlantUML syntax support |
| `goropikari/LibDeflate.nvim` | (preview dep) | Compression lib for plantuml.nvim |

## Keybindings & Leader Keys

- `mapleader = " "` (Space) — set in `lua/config/lazy.lua` before lazy setup.
- `maplocalleader = "\\"` — set in `lua/config/lazy.lua` before lazy setup.

### Telescope (`lua/plugins/telescope.lua`)
| Key | Action | Description |
|---|---|---|
| `<leader>ff` | `find_files` (hidden, no_ignore) | Find files |
| `<leader>fc` | `find_files` in `stdpath("config")` | Find config files |
| `<leader>fg` | `live_grep` (`--hidden`) | Live grep |
| `<leader>fB` | `buffers` (sort_lastused) | Buffers |
| `<leader>fr` | `oldfiles` | Recent files |
| `<leader>fk` | `keymaps` | Keymaps |
| `<C-k>` (insert) | `move_selection_previous` | Telescope prev |
| `<C-j>` (insert) | `move_selection_next` | Telescope next |
| `<CR>` (insert/normal) | deferred `select_default` | Open after tree settles |

### nvim-tree (`lua/plugins/nvim-tree.lua`)
| Key | Action | Description |
|---|---|---|
| `<leader>e` | `NvimTreeToggle` | Toggle File Explorer |

### Linting (`lua/plugins/linting.lua`)
| Key | Action | Description |
|---|---|---|
| `<leader>l` | `lint.try_lint()` | Run Linting |

### LSP keymaps (`lua/plugins/lsp/lspconfig.lua`, set on `LspAttach`)
| Key | Action | Description |
|---|---|---|
| `gr` | `Telescope lsp_references` | Show References |
| `gd` | `Telescope lsp_definitions` | Show Definition |
| `gt` | `Telescope lsp_type_definitions` | Show Type Definition |
| `gi` | `Telescope lsp_implementations` | Show Implementation |
| `K` | `vim.lsp.buf.hover` | Show documentation for symbol under cursor |
| `<leader>d` | `Telescope diagnostics bufnr=0` | Show Buffer Diagnostics |
| `]d` | `vim.diagnostic.goto_next` | Go to Next Diagnostic |
| `[d` | `vim.diagnostic.goto_prev` | Go to Previous Diagnostic |
| `<leader>rn` | `vim.lsp.buf.rename` | Rename Symbol |
| `<leader>ca` | `vim.lsp.buf.code_action` | Code Action |
| `gD` | `vim.lsp.buf.declaration` | Go to Declaration |
| `<leader>rs` | `:LspRestart` | Restart LSP Server |

### Completion (`lua/plugins/lsp/nvim-cmp.lua`)
| Key | Action |
|---|---|
| `<C-j>` | select next item |
| `<C-k>` | select previous item |
| `<C-S-j>` | scroll docs down (4) |
| `<C-S-k>` | scroll docs up (-4) |
| `<C-Space>` | trigger completion |
| `<CR>` | confirm (Replace, select = true) |
| `<C-e>` | abort |

No keybindings are defined in: `alpha.lua`, `barbar.lua`, `which-key.lua`,
`copilot.lua`, `dressing.lua`, `lualine.lua`, `preview.lua`, `treesitter.lua`,
`formatting.lua`, `mason.lua`.

## LSP / Completion Setup

- **`mason.nvim`** (`lua/plugins/lsp/mason.lua`): UI with rounded border and
  custom icons (`✓` / `➜` / `✗`).
- **`mason-lspconfig`** `ensure_installed` servers:
  `lua_ls`, `html`, `cssls`, `jsonls`, `pyright`, `clangd`, `bashls`, `gopls`,
  `dockerls`, `yamlls`.
- **`mason-tool-installer`** `ensure_installed` tools:
  `prettier`, `stylua`, `eslint_d`, `clang-format`, `shellcheck`, `gofumpt`.
- **`nvim-lspconfig`** (`lua/plugins/lsp/lspconfig.lua`): sets up capabilities
  from `cmp_nvim_lsp.default_capabilities()`. Uses `mason_lspconfig` handlers —
  a generic handler sets up each server with capabilities, plus a dedicated
  `lua_ls` handler that sets `Lua.diagnostics.globals = { "vim" }` and
  `Lua.completion.callSnippet = "Replace"`. Diagnostic signs are configured with
  custom icons for ERROR/WARN/HINT/INFO.
- **`nvim-cmp`** (`lua/plugins/lsp/nvim-cmp.lua`): loads on `InsertEnter`.
  Snippet expansion via LuaSnip; `friendly-snippets` lazy-loaded. Completion
  sources (in order): `nvim_lsp`, `luasnip`, `buffer`, `path`. Formatting via
  `lspkind` (`symbol_text`, maxwidth 50, ellipsis `...`). `completeopt` is
  `menu,menuone,preview,noselect`.
- **Formatters** (`conform.nvim` in `lua/plugins/formatting.lua`): `lua`→stylua,
  `javascript`/`typescript`/`html`/`css`/`json`/`markdown`→prettier,
  `c`/`cpp`→clang_format. `format_on_save` with `lsp_fallback = true`,
  `async = false`, `timeout_ms = 1000`.
- **Linters** (`nvim-lint` in `lua/plugins/linting.lua`): `python`→flake8,
  `javascript`/`typescript`→eslint, `html`→htmlhint, `css`→stylelint. The
  `lua`→luacheck and `c`/`cpp`→cppcheck entries are commented out. Linting runs
  on `BufWritePost`, `BufEnter`, and `InsertLeave` autocmds.

## Notable Details / Quirks

- **`avante.lua-bkp` is dead config.** It lacks a `.lua` extension, so lazy.nvim
  does NOT auto-import it from `lua/plugins/`. It contains an old
  `yetone/avante.nvim` spec (provider `copilot`) and is inactive.
- **netrw disabling is commented out** in `lua/config/opt.lua`
  (`g.loaded_netrw` / `g.loaded_netrwPlugin`). Instead `nvim-tree` uses
  `hijack_netrw = true` (with `disable_netrw` commented out inside nvim-tree's
  own config).
- **`copilot.lua` is effectively empty.** The plugin string
  `"github/copilot.vim"` is commented out, so the file returns an empty table.
  `copilot.vim` is actually loaded as a dependency of `codecompanion.nvim`.
- **lualine theme mismatch.** `lualine.lua` configures `theme = 'gruvbox'`
  while the global colorscheme is `catppuccin` — the statusline theme does not
  match the colorscheme.
- **codecompanion `strategies` placement.** In `codecompanion.lua` the
  `strategies` table sits at the top level of the lazy spec, outside `opts`
  (which is `{}`). lazy.nvim does not treat `strategies` as a known spec field,
  so it is not forwarded to `codecompanion.setup`; the strategies likely have no
  effect as written.
- **`codecompanion.nvim` is version-pinned** to `"17.33.0"` in its spec.
- **Telescope `BurntSushi/ripgrep` dependency.** The spec lists the actual
  ripgrep repository (`BurntSushi/ripgrep`) as a lazy dependency guarded by
  `cond = executable("rg")`. It appears in `lazy-lock.json` as `"ripgrep"`. The
  `sharkdp/fd` dependency in the same spec is guarded by `cond =
  executable("fd")` and is **not** present in `lazy-lock.json` (likely because
  `fd` was not installed at lock time).
- **`lazy-lock.json` is auto-generated.** It pins branch + commit for every
  installed plugin; do not hand-edit it.

## Working on This Project

- Plugin specs use the lazy.nvim spec format (table fields: `dir`/`url`, `opts`,
  `config`, `keys`, `event`, `cmd`, `dependencies`, `ft`, `lazy`, `build`,
  `init`, `version`, `cond`, `priority`, `main`, `name`, etc.).
- New plugins go in `lua/plugins/*.lua` (or `lua/plugins/lsp/*.lua` for LSP
  ones); each file returns a spec table and is auto-imported. Inline specs can
  also be added directly in `lua/config/lazy.lua`.
- To verify changes:
  - Run `nvim` to load the config.
  - `:Lazy` for plugin manager health / status.
  - `:checkhealth` for diagnostics.
  - `:LspInfo` (and `:LspRestart`) for LSP server state.
  - `:Mason` for installed servers/tools.
- There is **no test suite, linter, or typechecker configured** for this config
  itself (note: `luacheck` is commented out in `linting.lua`).
- `lazy-lock.json` pins versions — do not hand-edit it.
- If available, `luacheck` can lint the Lua files manually, or
  `nvim --headless` can load the config to catch startup errors.

## Workflow for Applying Changes and Fixes

When the user asks for changes or fixes to the plugin configuration,
**always** follow this issue-by-issue approval flow:

1. **Go through issues one at a time.** Do not batch or apply multiple
   changes without presenting each individually.
2. **For each issue, present:**
   - The issue title, affected file(s) and line number(s), and severity.
   - A brief description of the problem and why it matters.
   - The current code (relevant snippet).
   - The proposed fix (the exact code change or action).
   - What the fix does (the effect it will have).
3. **Ask for approval** before applying each fix. Use the `question` tool
   to offer at least "Apply the fix (Recommended)" and "Skip this issue"
   options. When there are multiple valid approaches, present them as
   separate options.
4. **Apply the fix only after the user approves.** If the user skips,
   move on to the next issue without changes.
5. **After all issues are processed**, update `PLUGIN_ISSUES.md` with a
   status table showing which issues were fixed and which were skipped.
6. **Do not commit** unless the user explicitly asks.

This flow ensures the user stays in control of every change and
understands what each fix does before it is applied.
