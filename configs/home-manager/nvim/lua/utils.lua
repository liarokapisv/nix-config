M = {}

function M.git_root()
  local out = vim.fn.systemlist("git rev-parse --show-toplevel")
  return vim.v.shell_error == 0 and out[1] or nil
end

function M.git_ls_files_from_root()
  local root = M.git_root()
  return root and vim.fn.systemlist("git ls-files -- " .. root)
end

function M.with_auto_dir(cmd)
  return function()
    local dir = vim.fn.expand("%:p:h")
    local root = M.git_root()
    -- fnamemodify ':.' makes path relative. This is to help LSPs.
    cmd(root and { cwd = vim.fn.fnamemodify(root, ':.') } or {})
  end
end

function M.with_dir_search(cmd)
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

return M
