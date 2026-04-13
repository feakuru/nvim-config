vim.pack.add { 'https://github.com/feakuru/mypy.nvim' }

local mypy = require 'mypy'
mypy.setup {
  extra_args = { '--cache-fine-grained' },
}
vim.keymap.set('n', '<leader>mt', '<Cmd>MypyToggle<CR>', { desc = '[M]ypy [T]oggle' })
