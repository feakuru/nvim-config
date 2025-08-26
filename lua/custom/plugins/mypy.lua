return {
  {
    'feakuru/mypy.nvim',
    config = function()
      local mypy = require 'mypy'
      mypy.setup {
        extra_args = { '--cache-fine-grained' },
      }
      vim.keymap.set('n', '<leader>mt', '<Cmd>MypyToggle<CR>', { desc = '[M]ypy [T]oggle' })
    end,
  },
}
