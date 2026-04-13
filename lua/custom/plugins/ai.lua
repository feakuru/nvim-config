vim.pack.add {
  'https://github.com/yetone/avante.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  --- The below dependencies are optional
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/stevearc/dressing.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
}

---@module 'avante'
---@type avante.Config
require('avante').setup {
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
}
