return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('codecompanion').setup {
        strategies = {
          chat = {
            adapter = 'deepseek',
          },
          inline = {
            adapter = 'deepseek',
          },
        },
        adapters = {
          deepseek = function()
            return require('codecompanion.adapters').extend('ollama', {
              name = 'deepseek',
              schema = {
                model = {
                  default = 'deepseek-r1:8b',
                },
                num_ctx = {
                  default = 2048,
                },
              },
            })
          end,
        },
      }
    end,
  },
}
