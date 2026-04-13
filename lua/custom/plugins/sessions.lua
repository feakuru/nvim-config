vim.pack.add {
  'https://github.com/rmagatti/auto-session',
  'https://github.com/nvim-telescope/telescope.nvim',
}

require('auto-session').setup {
  auto_session_suppress_dirs = { '~/', '~/projects', '~/Downloads', '/' },
  post_restore_cmds = { 'stopinsert' },
}
vim.keymap.set('n', '<leader>ds', '<Cmd>AutoSession delete<CR>', { desc = '[D]elete [S]ession' })
