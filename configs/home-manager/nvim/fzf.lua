local fzf = require("fzf-lua")

local function git_root()
  local out = vim.fn.systemlist("git rev-parse --show-toplevel")
  return vim.v.shell_error == 0 and out[1] or nil
end

local function with_auto_dir(cmd)
  return function()
    local root = git_root()
    cmd(root and { cwd = root } or {})
  end
end

local function with_dir_search(cmd)
  return function()
    vim.ui.input({
      prompt     = "Enter a directory (or . for cwd): ",
      completion = "dir",
    }, function(input)
      if not input or input == "" or input == "." then
        return cmd()
      end

      local dir  = vim.fs.normalize(input)
      local stat = vim.uv.fs_stat(dir)
      if stat and stat.type == "directory" then
        cmd({ cwd = dir })
      else
        vim.notify("Invalid directory: " .. input, vim.log.levels.WARN)
      end
    end)
  end
end

fzf.register_ui_select()

vim.keymap.set('n', '<C-\\>',        fzf.buffers,            {
  noremap = true, silent = true,
  desc    = "fzf-lua: buffers"
})
vim.keymap.set('n', '<C-p>',         with_auto_dir(fzf.files),       {
  noremap = true, silent = true,
  desc    = "fzf.luafiles: git-root or cwd"
})
vim.keymap.set('n', '<Leader>p',    with_dir_search(fzf.files),     {
  noremap = true, silent = true,
  desc    = "fzf-lua: files in prompted dir"
})
vim.keymap.set('n', '<C-g>',         with_auto_dir(fzf.live_grep),   {
  noremap = true, silent = true,
  desc    = "fzf-lua: live-grep at git-root or cwd"
})
vim.keymap.set('n', '<Leader>g',    with_dir_search(fzf.live_grep), {
  noremap = true, silent = true,
  desc    = "fzf-lua: live-grep in prompted dir"
})
