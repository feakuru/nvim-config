vim.pack.add {
  'https://github.com/folke/noice.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/rcarriga/nvim-notify',
}

require('notify').setup {
  fps = 100,
  level = 1,
  -- render = 'compact',
  stages = 'fade',
  timeout = 2000,
}

require('noice').setup {
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
}

vim.keymap.set('n', '<leader>n', '<Cmd>Telescope notify<CR>', { desc = 'Telescope: [N]otifications' })
