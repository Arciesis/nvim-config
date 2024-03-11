local dap_config = {
   "mfussenegger/nvim-dap",
   tags = "0.7.0",
   dependencies = {
      "jbyuki/one-small-step-for-vimkind",
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

      ----------------- C/C++/Rust config -------------------
      -- C/C++/Rust debug via gdb config
      dap.adapters.gdb = {
         type = "executable",
         command = "gdb",
         args = {"-i", "dap"},

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
            name = "Attach lua to Nvim",
            type = "nlua",
            request = "launch",
         }
      }

      dap.adapters.nlua = function(callback, config)
         callback({type = "server", host = config.host or "127.0.0.1", port = config.port or 8086})
      end
   end


}

return dap_config
