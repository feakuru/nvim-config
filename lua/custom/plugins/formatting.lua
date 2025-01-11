return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    ft = { 'python' },
    opts = function()
      local null_ls = require 'null-ls'
      local virtual = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX' or os.getenv 'HOME' .. '/.local'
      return {
        sources = {
          null_ls.builtins.diagnostics.mypy.with {
            command = virtual .. '/bin/mypy',
          },
          null_ls.builtins.formatting.isort.with { prefer_local = true },
        },
        debug = true,
      }
    end,
  },
}
