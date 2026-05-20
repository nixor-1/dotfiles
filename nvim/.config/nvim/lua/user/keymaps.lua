-- Leader key (space key).
vim.g.mapleader = " "

-- Normal NeoVim shortcuts.
vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>', { desc = "Stop highlight efter søgning" })

-- Navigate windows easily using Ctrl + h/j/k/l.
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Skift til venstre vindue" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Skift til højre vindue" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Skift til nedre vindue" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Skift til øvre vindue" })

-- Ctrl + Left Click to go to source definition
vim.keymap.set('n', '<C-LeftMouse>', '<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Gå til definition' })

-- Toggle between the current and last active file
vim.keymap.set('n', '<leader><leader>', '<cmd>e #<CR>', { desc = 'Skift til sidste fil' })

-- LSP shortcuts.
-- Are inactive if no LSP is active.
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Gå til definition" })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Vis dokumentation (Hover)" })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Omdøb variabel" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code actions" })

-- Telescope shortcuts.
-- A protectured require (pcall) is used so that NeoVim does not crash if Telescope fails.
local status_ok, builtin = pcall(require, "telescope.builtin")
if status_ok then
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Find filer" })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Søg i tekst (grep)" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Åbne buffere" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Søg i hjælp" })
end

-- Neotree shortcuts.
-- Open Neotree if closed, focus it if not already focused.
vim.keymap.set('n', '<leader>e', ':Neotree focus<CR>', { silent = true, desc = "Vis/fokuser filmenu" })
-- Dynamically resize windows/Neo-tree using Ctrl + arrow keys.
vim.keymap.set('n', '<C-Right>', ':vertical resize +3<CR>', { silent = true, desc = "Gør vindue bredere" })
vim.keymap.set('n', '<C-Left>', ':vertical resize -3<CR>', { silent = true, desc = "Gør vindue smallere" })
