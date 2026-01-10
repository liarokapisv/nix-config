M = {}

function M.buffer_dir()
    return vim.fn.expand("%:p:h")
end

function M.git_root(path)
  local out = vim.fn.systemlist("git -C " .. path .. " rev-parse --show-toplevel")
  return vim.v.shell_error == 0 and out[1] or nil
end

function M.choose_cwd()
    local buffer_dir = M.buffer_dir()
    local root = M.git_root(buffer_dir)
    if root then
        return root
    else
        return buffer_dir
    end
end

function M.with_auto_dir(cmd)
  return function()
    cmd({ cwd = M.choose_cwd() })
  end
end

function M.with_dir_search(cmd)
  return function()
    vim.ui.input({
      prompt     = "Enter a directory: ",
      completion = "dir",
    }, function(input)
      if not input or input == "" then
        return M.with_auto_dir(cmd)
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
