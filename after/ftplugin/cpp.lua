vim.opt_local.makeprg = "cmake -B build -G Ninja && ninja -C build"

-- 2. Safely ignore Ninja progress spam
-- local ninja_errfmt = "%-G[%*[^]]] %m," ..
--                      "%-Gninja: build stopped: subcommand failed.," ..
--                      "%-GFAILED: %m,"

vim.opt_local.errorformat = table.concat({
    "%Dninja: Entering directory %*[`']%f'",
    "%-Gninja: build stopped%.%#",
    "%-G[%*[0-9]/%*[0-9]] %.%#",
    "%-GFAILED: %.%#",
    "%f:%l:%c: %trror: %m,",    -- Capture Error line & col
    "%f:%l:%c: %tarning: %m,",  -- Capture Warning line & col
    "%f:%l:%c: %tote: %m,",     -- Capture Note line & col
    "%f:%l:%c: %m,",            -- Fallback: file:line:col
    "%f:%l: %m"                 -- Fallback: file:line
}, ",")

local group = vim.api.nvim_create_augroup("CppMake", { clear = false })
local bufnr = vim.api.nvim_get_current_buf()

local function is_quickfix_open()
    for _, win in ipairs(vim.fn.getwininfo()) do
        if win.quickfix == 1 and win.loclist == 0 then return true end
    end
    return false
end

vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    buffer = bufnr,
    callback = function()
        if is_quickfix_open() then
            vim.cmd("silent make!")
            vim.cmd("redraw!")
        end
    end,
})

vim.opt_local.shellpipe = "2>&1 | tee %s; exit ${PIPESTATUS[0]}"

if not vim.g.cpp_make_qf_hook then
    vim.g.cpp_make_qf_hook = true
    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
        group = group,
        pattern = "make",
        nested = true,
        callback = function()
            -- v:shell_error is the exit status of `tee`, so count real errors instead
            local errors = vim.tbl_filter(function(item)
                return item.valid == 1 and item.type ~= "W" and item.type ~= "I" and item.type ~= "N"
            end, vim.fn.getqflist())

            if #errors > 0 or vim.v.shell_error ~= 0 then
                vim.cmd("copen")
            else
                vim.cmd("cclose")
                vim.notify("Build OK", vim.log.levels.INFO)
            end
        end,
    })
end
