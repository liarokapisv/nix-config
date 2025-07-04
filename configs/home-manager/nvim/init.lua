-- init.lua: Neovim configuration in Lua

-- Leader Key
vim.g.mapleader = ' '  -- prefix for custom mappings

-- Global UI Options
vim.o.number         = true  -- show absolute line numbers
vim.o.relativenumber = true  -- show relative line numbers
vim.o.mouse          = ''    -- disable mouse across all modes
vim.o.modeline       = false -- disable modelines for security
vim.o.updatetime     = 500   -- faster CursorHold events (default 4000)

-- Indentation and Tabs
vim.o.expandtab      = true  -- use spaces instead of tabs
vim.o.tabstop        = 4     -- spaces per Tab
vim.o.shiftwidth     = 4     -- spaces per indent
vim.o.softtabstop    = 0     -- no extra soft-tabs
vim.o.smarttab       = true  -- smart <Tab> behavior

-- File Search & Completion
vim.o.path           = '**'  -- recursive file search
vim.o.wildmenu       = true  -- enhanced cmd-line menu
vim.opt.wildmode     = { 'longest', 'list', 'full' }    -- sequence for completion
vim.opt.completeopt  = { 'menu', 'menuone', 'noselect' } -- controls menu behavior

-- Window Splitting Behavior
vim.o.splitright     = true  -- vertical splits go right
vim.o.splitbelow     = true  -- horizontal splits go below

-- Persistent Undo
vim.o.undofile       = true  -- persistent undo
vim.o.undodir        = vim.fn.stdpath('config') .. '/undo'  -- undo files location
vim.o.undolevels     = 1000  -- undo levels
vim.o.undoreload     = 10000 -- max lines to save for undo

-- Miscellaneous Behavior
vim.opt.backspace    = { 'indent', 'eol', 'start' }  -- backspace behavior

-- Key Mappings
vim.keymap.set('n', 'Q',        '<Nop>',              { silent = true })                -- disable Ex mode
vim.keymap.set('n', '<Leader>w','<cmd>w<CR>',         { noremap = true, silent = true })  -- save buffer
vim.keymap.set('n', '<C-p>',    '<cmd>FzfLua files<CR>',{ noremap = true, silent = true })  -- fzf-lua file search

-- Filetype-specific Settings (YAML)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'yaml',
  callback = function()
    vim.opt_local.expandtab      = true  -- spaces, not tabs
    vim.opt_local.tabstop        = 2     -- 2 spaces per tab
    vim.opt_local.shiftwidth     = 2     -- 2 spaces per indent
    vim.opt_local.softtabstop    = 2     -- indent editing uses shiftwidth
  end
})

