return {
  {
    'feakuru/mypy.nvim',
    -- dir = "~/projects/public/mypy.nvim/",
    config = function()
      local mypy = require 'mypy'
      mypy.setup {
        extra_args = { '--cache-fine-grained' },
      }
      mypy.enabled = false

      vim.keymap.set('n', '<leader>mt', '<Cmd>MypyToggle<CR>', { desc = '[M]ypy [T]oggle' })
    end,
  },
}
