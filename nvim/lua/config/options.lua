vim.opt.background = "dark"
vim.opt.clipboard = "unnamedplus"
-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.foldmethod = "manual"
vim.opt.inccommand = "split"
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.wildmenu = true
vim.opt.scrolloff = 10
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
-- Set highlight on search
vim.opt.hlsearch = false
-- Sync clipboard between OS and Neovim
vim.opt.clipboard = 'unnamedplus'
-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.termguicolors = true

-- Fold settings
-- vim.o.foldcolumn = '1'
-- vim.o.foldlevel = 99 -- Using ufo provider need a large value
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
