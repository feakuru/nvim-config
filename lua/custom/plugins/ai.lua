return {
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = 'copilot',
      providers = {
        ollama = {
          endpoint = 'http://localhost:11434',
          model = 'qwen3:8b',
          extra_request_body = {
            repeat_penalty = 1.1,
          },
        },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional
      'nvim-telescope/telescope.nvim',
      'stevearc/dressing.nvim',
      'nvim-tree/nvim-web-devicons',
      {
        'github/copilot.lua',
        config = function()
          require('copilot').setup {}
        end,
      },
      'zbirenbaum/copilot.lua',
    },
  },
}
