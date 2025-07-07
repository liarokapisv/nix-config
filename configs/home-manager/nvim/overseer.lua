local overseer = require("overseer")

overseer.setup({
    task_list = {
        min_height = 16,
    }
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

vim.keymap.set('n', '<leader>t', '<cmd>OverseerToggle<CR>', {
    desc = 'Toggle Overseer task panel',
    noremap = true,
    silent = true,
})
