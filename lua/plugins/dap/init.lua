local dap_config = {
   "mfussenegger/nvim-dap",
   tags = "0.7.0",
   dependencies = {
      "rcarriga/nvim-dap-ui",
   },

   config = function(_, _)
      local dap = require("dap")
      local dapui = require("dapui")


      function _G.dapRunConfigWithArgs()
         local dap = require('dap')
         local ft = vim.bo.filetype
         if ft == "" then
            print("Filetype option is required to determine which dap configs are available")
            return
         end
         local configs = dap.configurations[ft]
         if configs == nil then
            print("Filetype \"" .. ft .. "\" has no dap configs")
            return
         end
         local mConfig = nil
         vim.ui.select(
         configs,
         {
            prompt = "Select config to run: ",
            format_item = function(config)
               return config.name
            end
         },
         function(config)
            mConfig = config
         end
         )

         -- redraw to make ui selector disappear
         vim.api.nvim_command("redraw")

         if mConfig == nil then
            return
         end
         vim.ui.input(
         {
            prompt = mConfig.name .." - with args: ",
         },
         function(input)
            if input == nil then
               return
            end
            local args = vim.split(input, ' ', {plain = true})
            mConfig.args = args
            dap.run(mConfig)
         end
         )
      end 

      --  dap.setup()
      dapui.setup()
      -- Auto open dapui when the dap opens
      dap.listeners.before.attach.dapui_config = function()
         dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
         dapui.open()
      end
      --[[ dap.listeners.before.event_terminated.dapui_config = function()
         dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
         dapui.close()
      end --]]

      local function get_args()
         local args = {}
         repeat
            local cpt = 0
            args[cpt] = vim.fn.input("args: ")
         until args[cpt] == ""
         return args
      end

      ----------------- C/C++/Rust config -------------------
      -- C/C++/Rust debug via gdb config
      dap.adapters.gdb = {
         type = "executable",
         command = "gdb",
         args = {"-i", "dap"}, -- TODO: verify that the arguments are corrects

         --[[ enrich_config = function (config, on_config)
            local final_config = vim.deepcopy(config)
            final_config.run_args = get_args()
            on_config(final_config)
         end --]]
      }

      -- C
      dap.configurations.c = {
         {
            name = "Standard C",
            type = "gdb",
            request = "launch",
            program = function()
               return vim.fn.input("path to executable: ", vim.fn.getcwd().."/".."debug/main")
            end,
            cwd = "${workspaceFolder}",
            stopAtBeginninfOfMainSubProgram = true,
         },
      }

      ----------------- Lua config -------------------
      dap.configurations.lua = {
         {
            name = "Current file (local-lua-dgb, lua)",
            type = "local-lua",
            request = "launch",
            cwd = "${workspaceFolder}",
            program = {
               lua = "lua", -- TODO: make this auto set with the current var of luaver or with a workspace setting (maybe a session)
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
