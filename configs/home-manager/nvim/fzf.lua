local fzf = require("fzf-lua")

fzf.setup({
    winopts = {
        preview = {
            vertical = "down:60%",
            layout = "vertical",
        },
    },
    fzf_colors = true,
})

local utils = require("utils")
local with_auto_dir = utils.with_auto_dir
local with_dir_search = utils.with_dir_search

fzf.register_ui_select()

vim.keymap.set('n', '<C-b>',        fzf.buffers,            {
    noremap = true, silent = true,
    desc    = "fzf-lua: buffers"
})
vim.keymap.set('n', '<C-p>',         with_auto_dir(fzf.files),       {
    noremap = true, silent = true,
    desc    = "fzf.lua: files at auto-dir"
})
vim.keymap.set('n', '<Leader>p',    with_dir_search(fzf.files),     {
    noremap = true, silent = true,
    desc    = "fzf-lua: files at prompted dir"
})
vim.keymap.set('n', '<C-g>',         with_auto_dir(fzf.live_grep),   {
    noremap = true, silent = true,
    desc    = "fzf-lua: live-grep at auto-dir"
})
vim.keymap.set('n', '<Leader>g',    with_dir_search(fzf.live_grep), {
    noremap = true, silent = true,
    desc    = "fzf-lua: live-grep at prompted dir"
})
vim.keymap.set('n', '<C-;>',         with_auto_dir(fzf.diagnostics_workspace),   {
    noremap = true, silent = true,
    desc    = "fzf-lua: diagnostics at auto-dir"
})
vim.keymap.set('n', '<Leader>;',    with_dir_search(fzf.diagnostics_workspace), {
    noremap = true, silent = true,
    desc    = "fzf-lua: diagnostics at prompted dir"
})
