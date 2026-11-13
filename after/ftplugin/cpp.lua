-- Wrap this in a FileType autocmd so it only applies to C/C++ buffers,
-- keeping your Zig environment completely separate.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function(args)
        local bufnr = args.buf

        -- 1. Set makeprg to compile the Wicked Engine project via CMake/Ninja
        vim.bo[bufnr].makeprg = "cmake --build build"

        -- 2. Clean up the Quickfix by ignoring Ninja build system spam.
        -- We append this to the existing default Clang/GCC errorformat.
        local ninja_ignores = "%-G[%d/%d] %m," ..             -- Ignore "[1/5] Building..."
            "%-Gninja: build stopped: subcommand failed.," .. -- Ignore failure summary
            "%-GFAILED: %m,"                                  -- Ignore failed target lines

        vim.bo[bufnr].errorformat = ninja_ignores .. vim.bo[bufnr].errorformat

        -- Helper function to check if the quickfix window is open
        local function is_quickfix_open()
            for _, win in ipairs(vim.fn.getwininfo()) do
                if win.quickfix == 1 and win.loclist == 0 then
                    return true
                end
            end
            return false
        end

        -- 3. Re-run :make! on save ONLY if the quickfix window is open
        vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = bufnr,
            callback = function()
                if is_quickfix_open() then
                    -- Use :silent make! to rebuild without prompting to press ENTER
                    vim.cmd("silent make!")
                    vim.cmd("redraw!")
                end
            end,
        })
    end,
})

-- 4. Global Quickfix toggler.
-- Keep this outside the FileType block. Because it triggers on "QuickFixCmdPost",
-- it will seamlessly handle both your Zig and C++ builds identically.
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "[^l]*",
    nested = true,
    callback = function()
        local qf = vim.fn.getqflist()
        local has_errors = false

        for _, item in ipairs(qf) do
            -- Clang/GCC linker errors (like "undefined reference") sometimes lack line numbers,
            -- but Neovim's default errorformat still tags them as valid=1.
            if item.valid == 1 then
                has_errors = true
                break
            end
        end

        if has_errors then
            vim.cmd("copen")
        else
            vim.cmd("cclose")
            vim.notify("All C++ errors resolved! Built successfully.", vim.log.levels.INFO)
        end
    end,
})
