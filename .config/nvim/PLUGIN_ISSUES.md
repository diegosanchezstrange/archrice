# PLUGIN_ISSUES.md

A review of the Neovim plugin configuration for outdated, broken, or
deprecated settings.

## Status After Review Session

| # | Issue | Status |
|---|-------|--------|
| 1 | codecompanion `strategies` outside `opts` | **Fixed** |
| 2 | mason-lspconfig `handlers` deprecated | **Fixed** |
| 3 | ripgrep/fd CLI binaries as plugin deps | **Fixed** |
| 4 | Telescope extensions never loaded | **Fixed** |
| 5 | treesitter `autoinstall` misspelled | **Fixed** |
| 6 | deprecated `goto_next`/`goto_prev` | **Fixed** |
| 7 | eslint vs eslint_d linter mismatch | **Fixed** |
| 8 | lualine gruvbox vs catppuccin theme | Skipped (user choice) |
| 9 | oldfiles cwd points to obscure dir | **Fixed** |
| 10 | `lsp_fallback` deprecated | **Fixed** |
| 11 | which-key missing `opts` | **Fixed** |
| 12 | codecompanion version pin vs lock | **Fixed** (pin removed) |
| 13 | dead `copilot.lua` file | Skipped (user choice) |
| 14 | dead `avante.lua-bkp` file | Skipped (user choice) |
| 15 | undocumented `signs.active` field | **Fixed** |
| 16 | config funcs ignore `opts` | **Fixed** (lualine, nvim-tree; telescope kept as custom config) |
| 17 | stylistic typos | **Fixed** (typos only; commented-out code left as-is) |

## Summary

17 issues found across the configuration. Severity breakdown:

| Severity | Count |
|----------|-------|
| Critical | 2     |
| High     | 5     |
| Medium   | 5     |
| Low      | 5     |

The two **Critical** issues cause core functionality to have no effect:
codecompanion's adapter/model configuration is silently ignored, and the
LSP server setup relies on a deprecated/removed `handlers` API that may
prevent any language server from being configured. The **High** issues
include CLI binaries mistakenly listed as Neovim plugin dependencies,
missing telescope extension loading, a misspelled treesitter option, and
deprecated diagnostic APIs. **Medium** and **Low** issues cover theme
mismatches, dead files, typos, and patterns that defeat lazy.nvim's
`opts` merging.

## Issues

---

### 1. codecompanion `strategies` placed outside `opts` — adapter/model config has no effect

- **File:** `lua/plugins/codecompanion.lua:4,10-23`
- **Severity:** Critical
- **Description:** The `strategies` table (lines 10–23) sits at the top
  level of the lazy spec, outside the `opts` table (which is `{}` on line
  4). lazy.nvim only forwards known spec fields (`opts`, `config`, `keys`,
  `event`, etc.) to the plugin's `setup()` function. `strategies` is not a
  recognized lazy spec field, so it is silently dropped.
  `codecompanion.setup({})` is called with an empty table, meaning the
  `copilot` adapter and `gpt-4.1` model selection for chat/inline/cmd
  strategies are never applied. Codecompanion falls back to its defaults
  (which may not be copilot/gpt-4.1).
- **Solution:** Move the `strategies` table inside `opts`:
  ```lua
  return {
      {
          "olimorris/codecompanion.nvim",
          opts = {
              strategies = {
                  chat = { adapter = "copilot", model = "gpt-4.1" },
                  inline = { adapter = "copilot", model = "gpt-4.1" },
                  cmd = { adapter = "copilot", model = "gpt-4.1" },
              },
          },
          version = "17.33.0",
          dependencies = { "nvim-lua/plenary.nvim", "github/copilot.vim" },
      },
  }
  ```

---

### 2. `mason-lspconfig` `handlers` API deprecated/removed — LSP servers may not be configured

- **File:** `lua/plugins/lsp/lspconfig.lua:95-118` (and `lua/plugins/lsp/mason.lua:20-33`)
- **Severity:** Critical
- **Description:** The config relies on `mason_lspconfig.setup({ handlers =
  { ... } })` to automatically configure each LSP server via a generic
  handler (lines 96–101) and a dedicated `lua_ls` handler (lines 102–116).
  The `handlers` option was **removed in mason-lspconfig v2.0.0** (late
  2024). If the locked version is v2.0.0+, the handlers never run, which
  means `lspconfig.<server>.setup()` is never called for any server — no
  language servers will attach to buffers. Even if the currently locked
  commit still supports handlers, the next `:Lazy update` will break LSP
  entirely.

  Additionally, `mason-lspconfig.setup()` is called **twice**: once in
  `mason.lua:20` (with `ensure_installed`) and again in
  `lspconfig.lua:95` (with `handlers`). The second call may override or
  conflict with the first.
- **Solution:** Remove the `handlers`-based setup. Instead, explicitly
  configure each server with `lspconfig`. Use `mason-lspconfig` only for
  `ensure_installed` and `automatic_installation`. For example:
  ```lua
  -- In lspconfig.lua config function:
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local servers = { "html", "cssls", "jsonls", "pyright", "clangd",
      "bashls", "gopls", "dockerls", "yamlls" }
  for _, server in ipairs(servers) do
      lspconfig[server].setup({ capabilities = capabilities })
  end
  lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = { Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
      } },
  })
  ```
  Then remove the `handlers` block and the second `mason_lspconfig.setup()`
  call from `lspconfig.lua`. Keep only the `ensure_installed` setup in
  `mason.lua`.

---

### 3. CLI binaries (`ripgrep`, `fd`) listed as lazy.nvim plugin dependencies

- **File:** `lua/plugins/telescope.lua:12-23`
- **Severity:** High
- **Description:** The spec lists `"BurntSushi/ripgrep"` (lines 12–17) and
  `"sharkdp/fd"` (lines 18–23) as lazy dependencies, guarded by
  `cond = executable("rg")` / `cond = executable("fd")`. These are **CLI
  binaries written in Rust**, not Neovim plugins. lazy.nvim will clone
  them into `lazy/` but cannot load them as plugins — they have no Lua
  entry point. The `cond` guards are self-defeating: if `rg`/`fd` are
  already installed system-wide, lazy clones the repos anyway (confirmed:
  `"ripgrep"` appears in `lazy-lock.json:35`). If they are not installed,
  the `cond` prevents cloning — but cloning wouldn't help since there's no
  `build` step to compile the Rust binaries.
- **Solution:** Remove both `"BurntSushi/ripgrep"` and `"sharkdp/fd"`
  entries entirely. Telescope uses the system-installed `rg` and `fd`
  binaries automatically. Ensure `ripgrep` and `fd` are installed via the
  system package manager (e.g., `pacman -S ripgrep fd`).

---

### 4. Telescope extensions configured but never loaded

- **File:** `lua/plugins/telescope.lua:77-115`
- **Severity:** High
- **Description:** The `telescope.setup()` call configures two extensions
  in the `extensions` table: `fzf` (lines 105–110) and `ui-select`
  (lines 111–113). However, `require("telescope").load_extension("fzf")`
  and `require("telescope").load_extension("ui-select")` are **never
  called** after setup. Telescope does not auto-load extensions — they
  must be explicitly loaded. As a result:
  - The `fzf` native sorter is not activated; telescope falls back to the
    slower default sorter.
  - The `ui-select` extension is not activated; `vim.ui.select` is not
    replaced by telescope (dressing.nvim covers this instead, so the
    impact is minor for ui-select, but fzf performance is lost).
- **Solution:** Add after `require("telescope").setup({...})`:
  ```lua
  pcall(require("telescope").load_extension, "fzf")
  pcall(require("telescope").load_extension, "ui-select")
  ```
  (Use `pcall` to avoid errors if an extension's binary is missing.)

---

### 5. `nvim-treesitter` `autoinstall` misspelled — auto-install of parsers does not work

- **File:** `lua/plugins/treesitter.lua:9`
- **Severity:** High
- **Description:** The config uses `autoinstall = true` (no underscore).
  The correct option name is `auto_install` (with underscore). Because the
  key is misspelled, nvim-treesitter silently ignores it and does not
  auto-install parsers when encountering a buffer with an uninstalled
  parser. Only the parsers listed in `ensure_installed` (line 6) will be
  installed on setup.
- **Solution:** Change `autoinstall = true` to `auto_install = true`.

  **Additional note (needs verification):** The config uses the legacy
  `require("nvim-treesitter.configs").setup({...})` module-based API with
  `ensure_installed` / `highlight` / `indent`. The lock file shows
  `nvim-treesitter` on the `master` branch (lazy-lock.json:30), where this
  API still works. However, the `main` branch of nvim-treesitter is a
  rewrite that removes the module system entirely. If the plugin ever
  migrates to `main`, this config will break. Consider pinning to the
  `master` branch explicitly (`branch = "master"`) for stability.

---

### 6. `vim.diagnostic.goto_next` / `goto_prev` deprecated in Neovim 0.11+

- **File:** `lua/plugins/lsp/lspconfig.lua:50,53`
- **Severity:** High
- **Description:** The keymaps `]d` (line 50) and `[d` (line 53) use
  `vim.diagnostic.goto_next` and `vim.diagnostic.goto_prev`. These
  functions were **deprecated in Neovim 0.11** in favor of
  `vim.diagnostic.jump()`. They still work (as deprecated aliases) but
  will emit deprecation warnings and may be removed in a future Neovim
  release.
- **Solution:** Replace with the new API:
  ```lua
  keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
  keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
  ```

---

### 7. Linter name mismatch: `eslint` used in nvim-lint but `eslint_d` installed by mason

- **File:** `lua/plugins/linting.lua:11-12` (and `lua/plugins/lsp/mason.lua:39`)
- **Severity:** High
- **Description:** `linting.lua` configures `javascript = { "eslint" }` and
  `typescript = { "eslint" }` (lines 11–12). nvim-lint's `eslint` linter
  expects the `eslint` binary to be on `$PATH`. However, `mason.lua:39`
  installs `eslint_d` (the daemon version), not `eslint`. Unless `eslint`
  is independently installed on the system, linting for JavaScript and
  TypeScript will fail silently because nvim-lint cannot find the `eslint`
  executable.
- **Solution:** Either:
  - Change `linting.lua` to use `{ "eslint_d" }` (matching what mason
    installs), **or**
  - Add `"eslint"` to `mason-tool-installer`'s `ensure_installed` in
    `mason.lua` (in addition to or instead of `eslint_d`).

---

### 8. lualine theme `'gruvbox'` does not match the `catppuccin` colorscheme

- **File:** `lua/plugins/lualine.lua:9`
- **Severity:** Medium
- **Description:** The statusline is configured with `theme = 'gruvbox'`
  while the global colorscheme (set in `lua/config/lazy.lua:52`) is
  `catppuccin`. This causes a visual mismatch — the statusline uses
  gruvbox colors (warm browns/oranges) while the rest of the UI uses
  catppuccin (cool pastels). lualine supports catppuccin natively via the
  `catppuccin` theme name.
- **Solution:** Change `theme = 'gruvbox'` to `theme = 'catppuccin'` (or
  `theme = 'auto'` to automatically match the active colorscheme).

---

### 9. Telescope `<leader>fr` oldfiles `cwd` points to an obscure directory

- **File:** `lua/plugins/telescope.lua:60`
- **Severity:** Medium
- **Description:** The `<leader>fr` keymap (lines 58–63) calls
  `telescope.builtin.oldfiles()` with `cwd = vim.fn.stdpath("data") ..
  "/site"`, which resolves to `~/.local/share/nvim/site`. When `cwd` is
  passed to `oldfiles`, telescope filters the recent-files list to only
  files within that directory. The `site` directory is typically empty or
  contains very few files, so this picker likely shows no useful results.
  The user almost certainly intended to see recent files across all
  projects.
- **Solution:** Remove the `cwd` filter to show all recent files:
  ```lua
  require("telescope.builtin").oldfiles({ prompt_title = "Recent files" })
  ```
  Or use `cwd = vim.fn.getcwd()` to scope to the current working directory.

---

### 10. conform.nvim `lsp_fallback` deprecated in favor of `lsp_format` (needs verification)

- **File:** `lua/plugins/formatting.lua:21`
- **Severity:** Medium
- **Description:** The `format_on_save` config uses `lsp_fallback = true`
  (line 21). In newer versions of conform.nvim, this option was renamed to
  `lsp_format`, which accepts `"never"`, `"fallback"`, `"prefer"`, or
  `"last"`. The old `lsp_fallback = true` is equivalent to
  `lsp_format = "fallback"` and may still work as a backward-compatible
  alias, but it is deprecated and may be removed in a future version.
- **Solution:** Replace with `lsp_format = "fallback"` to use the current
  API. (Verify against the conform.nvim version currently locked.)

---

### 11. which-key.nvim has no `opts` or `config` — `setup()` may not be called (needs verification)

- **File:** `lua/plugins/which-key.lua:1-4`
- **Severity:** Medium
- **Description:** The spec is just `{ "folke/which-key.nvim" }` with no
  `opts` and no `config`. lazy.nvim only auto-calls `setup()` when an
  `opts` field is present. Without `opts` or a `config` function,
  `require("which-key").setup()` is never called. which-key v3 (the
  `main` branch rewrite, which is what the lock shows) requires explicit
  setup. The plugin may partially work (it hooks into key mappings on
  load) but full functionality (custom icons, layout, etc.) requires
  `setup()`. (Needs verification against the locked version.)
- **Solution:** Add `opts = {}` to trigger lazy's auto-setup:
  ```lua
  return { "folke/which-key.nvim", opts = {} }
  ```

---

### 12. codecompanion `version = "17.33.0"` contradicted by lock file showing `branch: "main"`

- **File:** `lua/plugins/codecompanion.lua:5` (and `lazy-lock.json:11`)
- **Severity:** Medium
- **Description:** The spec pins `version = "17.33.0"` (line 5), which
  should restrict lazy.nvim to the `v17.33.0` tag. However,
  `lazy-lock.json:11` shows `"branch": "main"` with commit
  `e7762c68...`. This suggests the version pin is either not being applied
  or was added after the lock was generated. If the locked commit is
  ahead of the `v17.33.0` tag, the user is running a newer version than
  intended. If the pin format doesn't match codecompanion's tagging
  convention (e.g., tags are `v17.33.0` vs `17.33.0`), lazy may silently
  fall back to `main`.
- **Solution:** Run `:Lazy restore codecompanion.nvim` to re-sync to the
  pinned version. If the tag uses a `v` prefix, lazy.nvim should handle it
  automatically, but verify with `:Lazy log codecompanion.nvim` that the
  correct tag is checked out. Consider whether pinning to a specific
  version is desirable — codecompanion releases frequently and the pin
  may be stale.

---

### 13. `copilot.lua` is a dead file — empty spec with plugin commented out

- **File:** `lua/plugins/copilot.lua:1-3`
- **Severity:** Low
- **Description:** The file returns an empty table `{}` because
  `"github/copilot.vim"` is commented out on line 2. `copilot.vim` is
  actually loaded as a dependency of `codecompanion.nvim`
  (`codecompanion.lua:8`). This file is auto-imported by lazy but does
  nothing — it's dead clutter.
- **Solution:** Delete `lua/plugins/copilot.lua` since `copilot.vim` is
  already provided as a dependency of codecompanion.

---

### 14. `avante.lua-bkp` is a dead backup file

- **File:** `lua/plugins/avante.lua-bkp` (entire file, 51 lines)
- **Severity:** Low
- **Description:** This is a backup of an old `avante.nvim` spec. It lacks
  a `.lua` extension, so lazy.nvim does NOT auto-import it from
  `lua/plugins/`. It has no effect on the config but clutters the plugins
  directory and may cause confusion.
- **Solution:** Delete the file or move it outside `lua/plugins/` (e.g.,
  to a `backup/` directory) if you want to keep it for reference.

---

### 15. `vim.diagnostic.config` `signs.active` is not a documented field (needs verification)

- **File:** `lua/plugins/lsp/lspconfig.lua:72`
- **Severity:** Low
- **Description:** The diagnostic config includes `signs = { active = true,
  text = { ... } }` (line 72). The `active` key is not part of the
  documented `vim.diagnostic.config` `signs` table schema (which accepts
  `text`, `linehl`, `numhl`, and `priority`). It is likely silently
  ignored. The `text` table on its own is sufficient to configure
  diagnostic signs.
- **Solution:** Remove `active = true` from the `signs` table. The `text`
  table alone correctly configures the sign icons.

---

### 16. Multiple `config` functions ignore the `opts` parameter — defeats lazy.nvim opts merging

- **Files:**
  - `lua/plugins/lualine.lua:4` — `config = function(_, opts)` but calls `lualine.setup` with an inline table
  - `lua/plugins/nvim-tree.lua:26` — `config = function(_, opts)` but calls `nvim-tree.setup` with an inline table
  - `lua/plugins/telescope.lua:26` — `config = function()` (doesn't even accept `opts`)
- **Severity:** Low
- **Description:** These config functions receive `opts` from lazy.nvim but
  discard it, passing their own hardcoded table to `setup()` instead. This
  means any `opts` set elsewhere (e.g., by extending the spec) would be
  ignored. While there are currently no `opts` defined for these plugins
  in their specs, this pattern prevents future use of lazy's `opts`
  merging and is inconsistent with plugins that do use `opts` (like
  `indent-blankline` and `catppuccin` in `lazy.lua`).
- **Solution:** Either move the inline config tables into the spec's
  `opts` field (letting lazy merge and forward them), or pass `opts`
  through with `vim.tbl_deep_extend("force", default_opts, opts or {})`.
  For example in `nvim-tree.lua`:
  ```lua
  opts = { hijack_netrw = true, view = { width = 30, side = "left" },
      renderer = { group_empty = true }, filters = { dotfiles = false } },
  ```
  and use the default `config = function(_, opts) require("nvim-tree").setup(opts) end`.

---

### 17. Stylistic issues: typos, commented-out code, trailing spaces

- **Files:** Multiple
- **Severity:** Low
- **Description:** Various minor cosmetic issues found across the config:

  | File | Line | Issue |
  |------|------|-------|
  | `lua/config/opt.lua` | 14 | Comment typo: "Max lenght" → "Max length" |
  | `lua/config/lazy.lua` | 51 | Comment typo: "loaded_" → "loaded" |
  | `lua/plugins/lsp/nvim-cmp.lua` | 17 | Comment typo: "Load friendly friendly-snippets" → duplicated "friendly" |
  | `lua/plugins/lsp/lspconfig.lua` | 79 | Comment typo: "UNder line" → "Underline" |
  | `lua/plugins/lsp/lspconfig.lua` | 65 | `":LspRestart<cr>"` uses lowercase `<cr>` (works but inconsistent with `<CR>` used elsewhere) |
  | `lua/plugins/lsp/lspconfig.lua` | 80-91 | Large block of commented-out `linehl`/`numhl` diagnostic config |
  | `lua/plugins/linting.lua` | 9,15-16 | Commented-out `luacheck` and `cppcheck` linter entries |
  | `lua/plugins/nvim-tree.lua` | 7,29 | Commented-out `cmd` and `disable_netrw` lines |
  | `lua/plugins/alpha.lua` | 10-11,21-22 | Extra blank lines in header/footer arrays |
  | `lua/plugins/which-key.lua` | 1 | Trailing space after `return` |
  | `lua/plugins/lualine.lua` | 3,7 | Trailing spaces after string and `options =` |

- **Solution:** Clean up typos and remove commented-out dead code if no
  longer needed. These are cosmetic and do not affect functionality.
