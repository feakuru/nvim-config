return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
    lazy = false,
    keys = {
      {'-', '<Cmd>Oil<CR>', {desc = 'oil.nvim'}},
    }
  },
}
