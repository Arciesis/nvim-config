local none_config = {
   {
      "nvimtools/none-ls.nvim",
      dependencies = {
         "nvim-lua/plenary.nvim",
      },

      config = function(_, _)
         local nonels = require("null-ls")
         nonels.setup({
            sources = {
               nonels.builtins.code_actions.proselint,
               nonels.builtins.diagnostics.cmake_lint,
               nonels.builtins.diagnostics.codespell,
               nonels.builtins.diagnostics.cppcheck,
               nonels.builtins.diagnostics.gccdiag,
               nonels.builtins.diagnostics.proselint,
               nonels.builtins.diagnostics.selene,
               nonels.builtins.formatting.asmfmt,
               nonels.builtins.formatting.astyle.with({filetypes = {"arduino"}}),
               --  nonels.builtins.formatting.clang_format.
               nonels.builtins.formatting.cmake_format,
               nonels.builtins.formatting.codespell,
               nonels.builtins.formatting.shfmt,
            },
         })
      end
   }
}

return none_config
