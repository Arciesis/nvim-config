-- Set makeprg
vim.opt_local.makeprg = "zig build"

-- Ignore anyzig lines, then parse Zig compiler errors
vim.opt_local.errorformat = "%-Ganyzig: %m," ..
                            "%-G\\s%#," ..                -- ignore empty/whitespace-only lines
                            "%f:%l:%c: %t%*[^:]: %m," ..  -- file:line:col: error/note: msg
                            "%f:%l:%c: %m"                -- file:line:col: msg


-- Helper function to check if the quickfix window is currently open
local function is_quickfix_open()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 and win.loclist == 0 then
      return true
    end
  end
  return false
end

-- Re-run :make! on save ONLY if the quickfix window is open
vim.api.nvim_create_autocmd("BufWritePost", {
  buffer = 0, -- restricts to current Zig buffer
  callback = function()
    if is_quickfix_open() then
      -- Use :silent make! to rebuild without prompting to press ENTER
      vim.cmd("silent make!")
      vim.cmd("redraw!")
    end
  end,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = "[^l]*",
  nested = true,
  callback = function()
    local qf = vim.fn.getqflist()
    -- Filter out purely informational or valid entries if necessary
    local has_errors = false
    for _, item in ipairs(qf) do
      if item.valid == 1 then
        has_errors = true
        break
      end
    end

    if has_errors then
      vim.cmd("copen")
    else
      vim.cmd("cclose")
      vim.notify("All errors resolved!", vim.log.levels.INFO)
    end
  end,
})
