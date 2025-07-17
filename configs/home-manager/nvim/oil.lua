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
        ['<Esc>'] = 'actions.close',
    },
})

local utils = require("utils")
local buffer_dir = utils.buffer_dir

vim.keymap.set('n', '<C-l>', function() oil.open_float(buffer_dir()) end, {
    noremap = true, silent = true,
    desc = 'oil: open at auto-dir',
})
