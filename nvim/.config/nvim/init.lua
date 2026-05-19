-- Define the leader shortcuts.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Bootstrap lazy.nvim.
require("user.bootstrap_lazynvim")

-- Set up lazy.nvim.
require("user.setup_lazynvim")

-- Load options and keymaps.
require("user.options")
require("user.keymaps")
