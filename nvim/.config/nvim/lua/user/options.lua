local opt = vim.opt

-- Appearance.
opt.number = true           -- Show line numbers.
opt.relativenumber = true   -- Show relative line numbers.
opt.termguicolors = true    -- Activate 24-bit RGB colors (important for modern themes).
opt.signcolumn = "yes"      -- Altid vis kolonnen til venstre (så LSP-ikoner ikke får koden til at "hoppe")
opt.cursorline = true       -- Marker den linje, markøren står på
opt.scrolloff = 8           -- Hold altid 8 linjer synlige over/under markøren, når du scroller
vim.opt.foldlevel = 99 -- Start med alle folds åbne (højt tal = ingen automatisk foldning)

-- For linting.
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    prefix = "●", -- Can be any symbol you like
  },
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always", -- This shows 'eslint_d' next to the error message
  },
})

-- Tabs and indenting.
opt.expandtab = true        -- Konverter tabs til mellemrum
opt.shiftwidth = 2          -- Antal mellemrum ved indrykning
opt.tabstop = 2             -- Hvor mange mellemrum et tab-tegn fylder
opt.softtabstop = 2
opt.smartindent = true      -- Gør indrykning intelligent (f.eks. efter en "if" i Python)

-- Search.
opt.ignorecase = true       -- Ignorer store/små bogstaver ved søgning...
opt.smartcase = true        -- ...medmindre du specifikt skriver et stort bogstav
opt.hlsearch = true         -- Highlight alle fundne ord

-- System and performance.
opt.mouse = "a"             -- Tillad brug af mus (godt når man er ny i Vim)
opt.clipboard = "unnamedplus" -- Brug systemets udklipsholder (kræver 'wl-copy' på Wayland/Arch)
opt.updatetime = 250        -- Gør NeoVim hurtigere til at opdatere (f.eks. til LSP hover-vinduer)
opt.timeoutlen = 300        -- Hvor hurtigt NeoVim reagerer på key-kombinationer (leader keys)
opt.undofile = true         -- Gem fortryd-historik i en fil (selv efter du har lukket NeoVim!)
opt.completeopt = "menuone,noselect" -- Bedre indstillinger til auto-completion

-- Other small adjustments.
opt.splitbelow = true       -- Åbn nye horisontale splits i bunden
opt.splitright = true       -- Åbn nye vertikale splits til højre
