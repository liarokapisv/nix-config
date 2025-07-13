-- cwatchfile/init.lua
-- A plugin to watch a quickfix file and populate quickfix + diagnostics on change

local uv = vim.loop
local M = {}

-- Namespace for diagnostics
local ns = vim.api.nvim_create_namespace("cwatchfile")

-- Set default display options for our namespace
vim.diagnostic.config({
    underline        = true,
    signs            = true,
    virtual_text     = true,
    update_in_insert = false,
}, ns)

-- Notification helper
local function notify(msg, level)
    vim.notify("[cwatchfile] " .. msg, level or vim.log.levels.INFO)
end

local syncing = false
-- Clear cwatchfile diagnostics when LSP diagnostics arrive
vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function(args)
        if syncing then
            return
        end

        local bufnr = args.buf

        syncing = true
        vim.diagnostic.reset(ns, bufnr)
        syncing = false

        local errs = vim.diagnostic.get(nil, { severity = vim.diagnostic.severity.ERROR });
        local limit = #errs > 0 and vim.diagnostic.severity.ERROR or vim.diagnostic.severity.WARN;
        local title = "Diagnostics " .. tostring(vim.loop.hrtime())

        vim.diagnostic.setqflist({
            title = title,
            open = false,
            severity = limit,
        })
    end,
})

-- Preload files from quickfix into buffers
local function preload_qf_buffers()
    local seen = {}
    for _, it in ipairs(vim.fn.getqflist()) do
        if it.filename and not seen[it.filename] then
            local b = vim.fn.bufadd(it.filename)
            vim.fn.bufload(b)
            seen[it.filename] = true
        end
    end
end

-- Render only built-in diagnostics (signs, virtual text, underlines)
function M.render(bufnr)
    vim.diagnostic.show(ns, bufnr)
end

-- Extract diagnostics from quickfix and schedule rendering
function M.extract()
    local items = vim.fn.getqflist()
    -- if no quickfix entries, clear diagnostics and bail
    if #items == 0 then
        vim.diagnostic.reset(ns)
        return
    end

    local bufs = {}
    local sev_map = {
        E = vim.diagnostic.severity.ERROR,
        W = vim.diagnostic.severity.WARN,
        I = vim.diagnostic.severity.INFO,
        H = vim.diagnostic.severity.HINT,
    }

    for _, it in ipairs(items) do
        local buf = it.bufnr
        if buf and buf > 0 and it.lnum then
            -- compute 0-based line
            local l = it.lnum - 1
            local c = it.col - 1;
            -- build diagnostic covering from start_c to end of line
            local diag = {
                lnum     = l,
                end_lnum = l,
                col      = c,
                end_col  = 128,
                message  = it.text or "",
                severity = sev_map[it.type] or vim.diagnostic.severity.ERROR,
                source   = "cwatchfile",
            }

            bufs[buf] = bufs[buf] or {}
            table.insert(bufs[buf], diag)
        end
    end

    syncing = true
    for buf, diags in pairs(bufs) do
        vim.diagnostic.set(ns, buf, diags, {
            underline        = true,
            virtual_text     = true,
            signs            = true,
            update_in_insert = false,
        })
        vim.schedule(function()
            M.render(buf)
        end)
    end
    syncing = false
end

-- Stop watching and clean up diagnostics
function M.stop()
    if M._watch then M._watch:stop(); M._watch:close() end
    if M._timer then M._timer:stop(); M._timer:close() end

    -- clear all diagnostics for our namespace
    vim.diagnostic.reset(ns)

    if M._file then
        notify("Stopped: " .. M._file)
    end

    M._watch, M._timer, M._file = nil, nil, nil
end

-- Watch a quickfix file for changes
function M.watch(file, jump)
    M.stop()

    M._file  = file
    M._watch = uv.new_fs_event()

    -- debounce on change
    local function on_change()
        if M._timer then M._timer:stop(); M._timer:close() end
        M._timer = uv.new_timer()
        M._timer:start(500, 0, vim.schedule_wrap(function()
            pcall(vim.cmd, (jump and ":cfile" or ":cgetfile") .. " " .. vim.fn.fnameescape(file))
            preload_qf_buffers()
            M.extract()
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

-- Show diagnostics on buffer enter if present
vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(args)
        if not vim.tbl_isempty(vim.diagnostic.get(args.buf, { namespace = ns })) then
            M.render(args.buf)
        end
    end,
    desc = "Show cwatchfile diagnostics when entering buffer",
})

return M

