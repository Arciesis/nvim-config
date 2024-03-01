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
   end


}

return dap_config
