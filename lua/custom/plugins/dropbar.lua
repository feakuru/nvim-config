return {
  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      local dropbar_api = require 'dropbar.api'
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Dropbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Goto start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
      local default_config = require 'dropbar.configs'.opts
      require('dropbar').setup {
        bar = {
          enable = function(buf, win)
            return default_config.bar.enable(buf, win)
              or vim.bo[buf].ft == 'fugitiveblame'
          end,
          sources = function(buf, win)
            if vim.bo[buf].ft == 'fugitiveblame' then
              return {}
            end
            return default_config.bar.sources(buf, win)
          end
        },
      }
    end
  },
}
