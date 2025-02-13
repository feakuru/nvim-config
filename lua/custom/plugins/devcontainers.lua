return {
  'https://codeberg.org/esensar/nvim-dev-container',
  dependencies = 'nvim-treesitter/nvim-treesitter',
  config = function ()
    require('devcontainer').setup({})

    vim.keymap.set('n', '<leader>du', '<Cmd>DevcontainerStart<CR>', { desc = '[D]evcontainers [U]p' })
    vim.keymap.set('n', '<leader>da', '<Cmd>DevcontainerAttach<CR>', { desc = '[D]evcontainers [A]ttach' })
    vim.keymap.set('n', '<leader>dd', '<Cmd>DevcontainerStopAll<CR>', { desc = '[D]evcontainers [D]own (All)' })
    vim.keymap.set('n', '<leader>dc', '<Cmd>DevcontainerRemoveAll<CR>', { desc = '[D]evcontainers [C]lean (All)' })
    vim.keymap.set('n', '<leader>dl', '<Cmd>DevcontainerLogs<CR>', { desc = '[D]evcontainers [L]ogs' })
  end
}
