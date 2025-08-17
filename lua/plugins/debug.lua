function parse_args_from_string(str)
    if not str or str == "" then return {} end
    local args = {}
    local i, len = 1, #str
    while i <= len do
        while i <= len and str:sub(i, i):match("%s") do i = i + 1 end
        if i > len then break end
        local c = str:sub(i, i)
        if c == '"' or c == "'" then
            local quote = c; i = i + 1; local token = ""
            while i <= len do
                local ch = str:sub(i, i)
                if ch == "\\" then
                    local nextc = str:sub(i + 1, i + 1)
                    if nextc ~= "" then
                        token = token .. nextc; i = i + 2
                    else
                        i = i + 1
                    end
                elseif ch == quote then
                    i = i + 1; break
                else
                    token = token .. ch; i = i + 1
                end
            end
            table.insert(args, token)
        else
            local token = ""
            while i <= len and not str:sub(i, i):match("%s") do
                token = token .. str:sub(i, i); i = i + 1
            end
            table.insert(args, token)
        end
    end
    return args
end

return {
    -- can install codelldb with :MasonInstall codelldb
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    -- core dap plugin
    {
        "mfussenegger/nvim-dap",
        keys = { "<F5>", "<F10>", "<F11>", "<F12>", "<leader>b" }, -- lazy-load helpful keys
        config = function()
            local dap_ok, dap = pcall(require, "dap")
            if not dap_ok then return end

            -- detect codelldb adapter: prefer Mason-installed path, else fall back to 'codelldb' on PATH
            local mason_codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb"
            local adapter_cmd = "codelldb"
            if vim.loop.fs_stat(mason_codelldb) then
                adapter_cmd = mason_codelldb
            end

            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = adapter_cmd,
                    args = { "--port", "${port}" },
                },
            }

            -- Zig configurations
            dap.configurations.zig = {
                {
                    name = "Launch Zig executable",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        local cwd = vim.fn.getcwd()
                        local default = cwd .. "/zig-out/bin/"
                        return vim.fn.input("Path to executable: ", default, "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    args = {},
                    runInTerminal = true,
                },
                {
                    name = "Launch Zig executable with cli args",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        local cwd = vim.fn.getcwd()
                        local default = cwd .. "/zig-out/bin/"
                        return vim.fn.input("Path to executable: ", default, "file")
                    end,
                    args = function()
                        local s = vim.fn.input("Args: ")
                        return parse_args_from_string(s)
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    runInTerminal = true,
                },
                {
                    name = "Attach to process",
                    type = "codelldb",
                    request = "attach",
                    pid = require("dap.utils").pick_process,
                    cwd = "${workspaceFolder}",
                },
            }

            -- keymaps (you can remove/adjust these)
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true }
            map("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>",
                { noremap = true, silent = true, desc = "launch debugger" })
            map("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>",
                { noremap = true, silent = true, desc = "Step over" })
            map("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>",
                { noremap = true, silent = true, desc = "Step Into" })
            map("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true, silent = true, desc = "Step Out" })
            map("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>",
                { noremap = true, silent = true, desc = "Toggle Breakpoint" })
            map("n", "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
                { noremap = true, silent = true, desc = "Set Breakpoint Condidition" })
            map("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>",
                { noremap = true, silent = true, desc = "debugger Repl" })
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio", },

        config = function()
            local ok1, dapui = pcall(require, "dapui")
            local ok2, dap   = pcall(require, "dap")
            if not ok1 or not ok2 then return end

            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸" },
                mappings = {
                    -- Use enter to open, 'u' to remove, 'r' to toggle repl
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes",      size = 0.40 },
                            { id = "breakpoints", size = 0.15 },
                            { id = "stacks",      size = 0.25 },
                            { id = "watches",     size = 0.20 },
                        },
                        size = 40, -- columns
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl",    size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size = 10, -- lines
                        position = "bottom",
                    },
                },
                floating = {
                    max_height = 0.9,
                    max_width = 0.5,
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
            })

            -- auto open/close UI on debug sessions
            dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

            -- optional keymaps to toggle ui
            vim.keymap.set("n", "<Leader>du", "<Cmd>lua require'dapui'.toggle()<CR>",
                { noremap = true, silent = true, desc = "Toggle debugger UI" })
        end,
    },
}
