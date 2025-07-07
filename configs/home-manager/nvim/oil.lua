require("oil").setup({
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

vim.keymap.set('n', '<leader>o', '<cmd>Oil<CR>', {
    desc = 'Open Oil Buffer',
    noremap = true,
    silent = true,
})
