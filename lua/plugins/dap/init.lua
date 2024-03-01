local dap_config = {
   "mfussenegger/nvim-dap",
   dependencies = {
      "rcarriga/nvim-dap-ui",
   },

   config = function(_, _)
      local dap = require("dap")
      local dapui = require("dapui")

      --  dap.setup()
      dapui.setup()

      -- Auto open dapui when the dap opens
      dap.listeners.before.attach.dapui_config = function()
         dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
         dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
         dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
         dapui.close()
      end

      -- C/C++/Rust debug via gdb config
      dap.adapters.gdb = {
         type = "executable",
         command = "gdb",
         args = {"-i", "dap"}, -- TODO verify that the arguments are corrects
      }

      dap.configurations.c = {
         {
            name = "launch gdb",
            type = "gdb",
            request = "launch",
            program = function()
               return vim.fn.input("path to executable: ", vim.fn.getcwd().."/".."file")
            end,
            cwd = "${workspaceFolder}",
            stopAtBeginninfOfMainSubProgram = false,
            options = {
               source_filetype = "c"
            },
         },
      }

      dap.configurations.lua = {
         {
            name = "Current file (local-lua-dgb, lua)",
            type = "local-lua",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = {
               lua = "lua", -- TODO make this auto set with the current var of luaver or with a worspace setting (maybe a session)
               file = "${file}"
            },
            args = {},
         }
      }

      dap.adapters["local-lua"] = {
         type = "executable",
         command = "node",
         args = {
            "/home/arciesis/git/local-lua-debugger-vscode/extension/debugAdapter.js",
         },
         enrich_config = function(config, on_config)
            if not config["extensionPath"] then
               local c = vim.deepcopy(config)
               c.extensionPath = "/home/arciesis/git/local-lua-debugger-vscode/"
               on_config(c)
            else
               on_config(config)
            end
         end
      }

      local vscode = require("dap.ext.vscode")
      vscode.load_launchjs(vim.fn.getcwd().."/launch.json", {lua_local = {"lua"}})
   end


}

return dap_config
