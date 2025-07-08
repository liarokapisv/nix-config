local overseer = require("overseer")

overseer.setup({
    task_list = {
        min_height = 16,
        width = 1.0,
        separator = "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
        bindings = {
            ["k"] = "PrevTask",
            ["j"] = "NextTask",
            ["h"] = "DecreaseDetail",
            ["l"] = "IncreaseDetail",
            ["<C-h>"] = false,
            ["<C-l>"] = false,
            ["<C-k>"] = false,
            ["<C-j>"] = false,
        },
    },
    bundles = {
        autostart_on_load = false,
    },
})

overseer.add_template_hook({ module = "^cargo$" }, function(task_defn, util)
    util.add_component(task_defn, 
        { "on_output_quickfix", tail = false, open = false, items_only = true }
    )
end)

vim.keymap.set('n', '<leader>r', '<cmd>OverseerRun<CR>', {
    desc = 'Run Overseer task',
    noremap = true,
    silent = true,
})

local overseerWindow = require('overseerWindow')

vim.keymap.set('n', '<leader>t', overseerWindow.toggle, {
    desc = 'Toggle Overseer task panel',
    noremap = true,
    silent = true,
})

vim.keymap.set('n', '<leader>l', '<cmd>OverseerLoadBundle!<CR>', {
    desc = 'Load Overseer bundle',
    noremap = true,
    silent = true,
})
vim.keymap.set('n', '<leader>s', '<cmd>OverseerSaveBundle<CR>', {
    desc = 'Save Overseer bundle',
    noremap = true,
    silent = true,
})
