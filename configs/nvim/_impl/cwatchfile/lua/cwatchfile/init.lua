-- cwatchfile/init.lua
-- A plugin to watch a errorformat-compatible file and populate diagnostics on change

local M = {}
local uv = vim.loop

local function notify(msg, level)
    vim.notify("[cwatchfile] " .. msg, level or vim.log.levels.INFO)
end

-- Extract diagnostics from error file
function M.extract(file)
    local saved_items = vim.fn.getqflist()
    vim.cmd(":cgetfile " .. vim.fn.fnameescape(file))
    local items = vim.fn.getqflist()
    vim.fn.setqflist(saved_items)

    local bufs = {}
    local sev_map = {
        E = vim.diagnostic.severity.ERROR,
        W = vim.diagnostic.severity.WARN,
        I = vim.diagnostic.severity.INFO,
        H = vim.diagnostic.severity.HINT,
    }

    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        return
    end

    local client = clients[1]

    for _, it in ipairs(items) do
        local bufnr = it.bufnr
        if bufnr > 0 then
            if bufnr and bufnr > 0 and it.lnum and it.lnum > 0 and it.col and it.col > 0 then
                vim.fn.bufload(bufnr)
                -- compute 0-based line
                local l = it.lnum - 1
                local c = it.col - 1;
                -- build diagnostic covering from start_c to end of line
                local diag = {
                    lnum     = l,
                    end_lnum = l,
                    col      = c,
                    end_col  = c,
                    message  = it.text or "",
                    severity = sev_map[it.type] or vim.diagnostic.severity.ERROR,
                    source   = "cwatchfile";
                }

                bufs[bufnr] = bufs[bufnr] or {}
                table.insert(bufs[bufnr], diag)
            end
        end
    end

    -- mimic LSP server, these will get overwritten as appropriate.
    for bufnr, diags in pairs(bufs) do
        local ns = vim.lsp.diagnostic.get_namespace(client.id)
        vim.diagnostic.set(ns, bufnr, diags, {
            underline        = true,
            virtual_text     = true,
            signs            = true,
            update_in_insert = false,
        })
    end
end

-- Stop watching
function M.stop()
    if M._watch then M._watch:stop(); M._watch:close() end
    if M._timer then M._timer:stop(); M._timer:close() end

    if M._file then
        notify("Stopped: " .. M._file)
    end

    M._watch, M._timer, M._file = nil, nil, nil
end

-- Watch an errorformat-compatible file for changes
function M.watch(file, jump)
    M.stop()

    M._file  = file
    M._watch = uv.new_fs_event()

    -- initial load
    vim.schedule(function()
        M.extract(vim.fn.fnameescape(file))
    end)

    -- debounce on change
    local function on_change()
        if M._timer then M._timer:stop(); M._timer:close() end
        M._timer = uv.new_timer()
        M._timer:start(500, 0, vim.schedule_wrap(function()
            M.extract(vim.fn.fnameescape(file))
            M._timer:close(); M._timer = nil
        end))
    end

    local ok, err = pcall(function() M._watch:start(file, {}, on_change) end)
    notify(ok and ("Watching: " .. file) or ("Failed: " .. err), ok and nil or vim.log.levels.ERROR)
end

-- User command
vim.api.nvim_create_user_command("CWatchFile", function(opts)
    if opts.args ~= "" then
        M.watch(opts.args, opts.bang)
    else
        M.stop()
    end
end, { nargs = "?", bang = true, complete = "file", desc = "Watch quickfix + diagnostics on change" })

return M
