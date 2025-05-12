return {
  {
    'feakuru/mypy.nvim',
    config = function()
      require('mypy').setup()
      vim.keymap.set('n', '<leader>mt', '<Cmd>MypyToggle<CR>', {desc = "[M]ypy [T]oggle"})
    end,
  },
}
