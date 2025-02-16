return {
  {
    'rcarriga/nvim-notify',
    config = {
      fps = 60,
      level = 1,
      render = 'compact',
      stages = 'fade',
      timeout = 2500,
    },
    {
      'epwalsh/obsidian.nvim',
      version = '*',
      lazy = true,
      event = {
        'BufReadPre ' .. vim.fn.expand '~' .. '/Obsidian/*.md',
      },
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
      opts = {
        workspaces = {
          -- TODO: generate config of this form automatically from filesystem
          -- {
          --   name = '<name>',
          --   path = '<folder>',
          -- },
        },
      },
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    keys = {
      { '<leader>n', '<Cmd>Telescope notify<CR>', { desc = 'Telescope: notifications' } },
    },
  },
}
