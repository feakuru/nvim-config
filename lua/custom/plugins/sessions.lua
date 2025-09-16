return {
  {
    'rmagatti/auto-session',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('auto-session').setup {
        auto_session_suppress_dirs = { '~/', '~/projects', '~/Downloads', '/' },
      }
      vim.keymap.set('n', '<leader>ds', '<Cmd>AutoSession delete<CR>', { desc = '[D]elete [S]ession' })
    end,
  },
}
