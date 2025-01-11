return {
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        view = {
          width = { min = 30, max = 150 },
          relativenumber = true,
          number = true,
        },
        update_focused_file = {
          enable = true,
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
          custom = {
            '.*.null-ls_.*',
          },
        },
      }
      vim.keymap.set('n', '<leader>tt', '<Cmd>NvimTreeToggle<CR>', { desc = '[T]oggle NVim[T]ree' })
    end,
  },
}
