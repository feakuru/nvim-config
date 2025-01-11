return {
  {
    'NachoNievaG/atac.nvim',
    dependencies = { 'akinsho/toggleterm.nvim' },
    config = function()
      require('atac').setup {
        --     dir = '~/my/work/directory', -- By default, the dir will be set as /tmp/atac
      }
      vim.keymap.set('n', '<leader>ta', '<Cmd>Atac<CR>', { desc = '[T]oggle [A]TAC' })
    end,
  },
}
