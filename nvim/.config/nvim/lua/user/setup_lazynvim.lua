-- This code is drawn directly from the following website: https://lazy.folke.io/installation.

require("lazy").setup({
  spec = {
    -- Import plugins.
    { import = "user.plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- Colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- Automatically check for plugin updates.
  checker = { enabled = true },
})
