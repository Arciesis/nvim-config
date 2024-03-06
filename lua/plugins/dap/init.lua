local dap_config = {
   {
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


         --------------- Lua config -------------------
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

         --  local vscode = require("dap.ext.vscode")
         --  vscode.load_launchjs(vim.fn.getcwd().."/launch.json", {local-lua = {"lua"}})

         ------------- Emebedded C/C++ config ---------------------------------------
         dap.adapters.cortex_debug = {
            id = "cortex-debug",
            type = "executable",
            command = "node",
            args = { "/home/arciesis/git/cortex-debug/dist/debugadapter.js" },
            --  options = {
            --  detached = true,
            --  },
         }

         --  require("dap.ext.vscode").load_launchjs(vim.fn.getcwd().."/launch.json", {["cortex-debug"] = "c"})


         dap.configurations.c = {
            {
               cwd = "/home/arciesis/dev/C/embedded/udemy/embedded_C/My_workspace/target/007BlinkingLedSoftware/Debug/",
               executable = "./007BlinkingLedSoftware.elf",
               name = "Debug with OpenOCD",
               request = "launch",
               type = "cortex-debug",
               servertype = "openocd",
               armTooclchainPath =
               "/usr/bin/",
               toolchainPrefix = "arm-none-eabi",
               searchDir = {
                 "/opt/st/stm32cubeide_1.13.2/plugins/com.st.stm32cube.ide.mcu.debug.openocd_2.1.0.202306221132/resources/openocd/st_scripts/",
               },
               configFiles = {
                  "interface/stlink.cfg",
                  "target/stm32f4.cfg",
                  --  "STM32f411RETX_FLASH.ld",
                  --  "STM32f411RETX_RAM.ld",
               },
               --  searchDir = {},
               runEntryPoint = "main",
               showDevDebugOutput = true,
               gdbPath = "/usr/bin/arm-none-eabi-gdb",
               device = "stlink",
               --  debugServer= "4711",
            },
         }
         --  {
         --  type = "cortex_debug",
         --  request = "launch",
         --  servertype = "stlink",
         --  cwd = "/home/arciesis/dev/C/embedded/udemy/embedded_C/My_workspace/target/007BlinkingLedSoftware/",
         --  executable = "./Debug/007BlinkingLedSoftware.elf",
         --  name = "Debug (ST-Util)",
         --  device = "STM32f411RE-C04",
         --  v1 = false,
         --  gdbPath = "/usr/bin/arm-none-eabi-gdb",
         --  chainedConfigurations = "target extended-target :3333",
         --  gdbTarget = ":50000",
         --  showDevDebugOutput = "raw",

         --  },
         --  }
      end
   },
   {
      "jedrzejboczar/nvim-dap-cortex-debug",
      dependencies = {
         "mfussenegger/nvim-dap",
      },

      config = function(_, _)
         require('dap-cortex-debug').setup {
            debug = false, -- log debug messages
            -- path to cortex-debug extension, supports vim.fn.glob
            extension_path = "~/git/cortex-debug/",
            lib_extension = nil,                   -- tries auto-detecting, e.g. 'so' on unix
            node_path = 'node',                    -- path to node.js executable
            dapui_rtt = true,                      -- register nvim-dap-ui RTT element
            dap_vscode_filetypes = { 'c', 'cpp' }, -- make :DapLoadLaunchJSON register cortex-debug for C/C++, set false to disable
         }
      end
   },
}

return dap_config
