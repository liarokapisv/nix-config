local oil = require("oil")

oil.setup({
    keymaps = {
        -- remove pane movement mappings
        ['<C-h>'] = false,
        ['<C-j>'] = false,
        ['<C-k>'] = false,
        ['<C-l>'] = false,

        -- remove Oil’s <C-p> preview mapping so it falls back to whatever <C-p> does normally
        ['<C-p>'] = false,

        -- map Shift-K to the preview action (same as C-p used to be)
        ['K'] = 'actions.preview',
        ['H'] = 'actions.parent',
        ['L'] = 'actions.select',
    },
})

local utils = require("utils")
local with_auto_dir = utils.with_auto_dir
local with_dir_search = utils.with_dir_search

vim.keymap.set('n', '<C-l>', with_auto_dir(function(opts) oil.open_float(opts.cwd) end), {
    noremap = true, silent = true,
    desc = 'oil: open at auto-dir',
})

vim.keymap.set('n', '<Leader>l', with_dir_search(function(opts) oil.open_float(opts.cwd) end), {
    noremap = true, silent = true,
    desc = 'oil: open at prompted-dir',
})
