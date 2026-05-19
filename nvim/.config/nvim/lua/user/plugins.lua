return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main", -- GitHub siger: Brug main for Nvim 0.12+ [cite: 105, 143, 146]
    lazy = false,    -- GitHub siger: Pluginnet understøtter IKKE lazy-loading [cite: 168]
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
      local parsers = { "lua", "bash", "python", "javascript", "typescript" }
      require('nvim-treesitter').install(parsers) 
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
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
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("lua_ls", {})
      vim.lsp.config("pyright", {})
      vim.lsp.enable({ "lua_ls", "pyright" })
    end,
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
    lazy = false, -- neo-tree will lazily load itself
  }
}
