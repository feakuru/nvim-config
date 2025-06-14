return {
  {
    'feakuru/mypy.nvim',
    config = function()
      local mypy = require 'mypy'
      mypy.setup()
      mypy.enabled = false

      vim.keymap.set('n', '<leader>mt', '<Cmd>MypyToggle<CR>', { desc = '[M]ypy [T]oggle' })
    end,
  },
}
