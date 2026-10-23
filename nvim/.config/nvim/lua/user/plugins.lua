local obsidian_vault = vim.fn.expand("~/Documents/Obsidian-noter")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",     -- GitHub siger: Brug main for Nvim 0.12+ [cite: 105, 143, 146]
    lazy = false,        -- GitHub siger: Pluginnet understøtter IKKE lazy-loading [cite: 168]
    build = ":TSUpdate", -- GitHub anbefaler at automatisere opdatering af parsere [cite: 159, 165]

    init = function()
      -- Definer reglerne før pluginnet indlæses [cite: 48, 190]
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          -- Start highlighting for alle understøttede filtyper [cite: 53, 189, 193]
          pcall(vim.treesitter.start)

          -- Aktiver indentation (bemærk de specifikke citationstegn fra GitHub) [cite: 56, 202, 203]
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

          -- Aktiver folding (fra side 4 i din GitHub PDF) [cite: 198]
          vim.wo.foldmethod = 'expr'
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
      })
    end,

    config = function()
      -- Her installerer vi selve sprogene [cite: 76, 176]
      local parsers = { "lua", "bash", "python", "javascript", "typescript", "tsx", "go", "gomod", "gosum", "gowork" }
      require('nvim-treesitter').install(parsers)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    -- branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {}
  },
  -- Automates installing servers you configure in lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "lua_ls", "pyright", "ts_ls", "rust_analyzer", "gopls" }
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Configure lua_ls to recognize 'hl' as a global variable
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "hl" }
            }
          }
        }
      })

      vim.lsp.config("pyright", {})

      vim.lsp.config("ts_ls", {
        -- Explicitly tells the language server to activate on plain JS, TS, and React components
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            inlayHints = {
              bindingModeHints = { enable = true },
              chainingHints = { enable = true },
              closureReturnTypeHints = { enable = "always" },
              parameterHints = { enable = true },
              typeHints = { enable = true },
            },
          }
        }
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            staticcheck = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })

      -- Enable all three servers
      vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "rust_analyzer", "gopls" })
    end,
  },
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    cond = function()
      return vim.fn.isdirectory(vim.fn.expand(obsidian_vault)) == 1
    end,
    opts = {
      legacy_commands = false,
      workspaces = {
        { name = "noter", path = obsidian_vault },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim"
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false,                    -- neo-tree will lazily load itself
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = true, -- This finds and highlights the file you just jumped into
        },
      },
    },
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets', 'giuxtaposition/blink-cmp-copilot' },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- AND/OR build from source
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      keymap = require("user.keymaps").blink,

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
      },

      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          }
        }
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")

      -- Define your linters here
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }

      -- Create an autocommand to trigger linting
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  -- Automates installing non-LSP tools (linters, formatters)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "eslint_d",
          "prettier",
          "goimports",
          "gofumpt",
        },
      })
    end,
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false }, -- disabled: blink.cmp will handle completion display instead
        panel = { enabled = false },      -- disabled: same reason
      })
    end,
  },
  {
    "giuxtaposition/blink-cmp-copilot",
    dependencies = { "zbirenbaum/copilot.lua" },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>mp",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Manual Format file",
      },
    },
    opts = {
      formatters_by_ft = {
        javascript = { "eslint_d", "prettier", stop_after_first = false },
        typescript = { "eslint_d", "prettier", stop_after_first = false },
        javascriptreact = { "eslint_d", "prettier", stop_after_first = false },
        typescriptreact = { "eslint_d", "prettier", stop_after_first = false },
        lua = { "stylua" },
      },
      -- This handles formatting automatically on every save
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    opts = {},
  }, {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {},
}
}
