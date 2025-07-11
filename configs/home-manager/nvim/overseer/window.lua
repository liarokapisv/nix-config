local config = require("overseer.config")
local layout = require("overseer.layout")
local task_list = require("overseer.task_list")
local util = require("overseer.util")
local super = require("overseer.window")

local M = super

---@param direction "left"|"right"|"bottom"
---@param existing_win integer
local function create_overseer_window(direction, existing_win)
  local bufnr = task_list.get_or_create_bufnr()

  local my_winid = vim.api.nvim_get_current_win()
  if existing_win then
    util.go_win_no_au(existing_win)
  else
    local split_direction = direction == "left" and "topleft" or "botright"
    vim.cmd.split({
      mods = { vertical = direction ~= "bottom", noautocmd = true, split = split_direction },
    })
  end
  local winid = vim.api.nvim_get_current_win()

  -- create the output window if we're opening on the bottom
  util.go_buf_no_au(bufnr)
  local default_opts = {
    listchars = "tab:> ",
    winfixwidth = true,
    winfixheight = true,
    number = false,
    signcolumn = "no",
    foldcolumn = "0",
    relativenumber = false,
    wrap = false,
    spell = false,
  }
  for k, v in pairs(default_opts) do
    vim.api.nvim_set_option_value(k, v, { scope = "local", win = 0 })
  end
  vim.api.nvim_win_set_width(0, layout.calculate_width(nil, config.task_list))
  if direction == "bottom" then
    vim.api.nvim_win_set_height(0, layout.calculate_height(nil, config.task_list))
  end
  -- Set the filetype only after we enter the buffer so that FileType autocmds
  -- behave properly
  vim.bo[bufnr].filetype = "OverseerList"

  util.go_win_no_au(my_winid)

  return winid
end

---@param opts? overseer.WindowOpts
M.open = function(opts)
  opts = vim.tbl_deep_extend("keep", opts or {}, {
    enter = true,
    direction = config.task_list.direction,
  })
  local winid = M.get_win_id()
  if winid == nil then
    winid = create_overseer_window(opts.direction, opts.winid)
    vim.api.nvim_create_autocmd("WinClosed", {
      desc = "Watch for Overseer task list window close",
      pattern = tostring(winid),
      nested = true,
      once = true,
      callback = function()
        vim.api.nvim_exec_autocmds("User", { pattern = "OverseerListClose", modeline = false })
      end,
    })
  end
  if opts.enter then
    vim.api.nvim_set_current_win(winid)
  end
  if opts.focus_task_id then
    local sidebar = require("overseer.task_list.sidebar")
    local sb = sidebar.get_or_create()
    sb:focus_task_id(opts.focus_task_id)
  end
end

M.toggle = function(opts)
  if M.is_open() then
    M.close()
  else
    M.open(opts)
  end
end

return M
