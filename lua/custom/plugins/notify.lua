return {
  {
    'rcarriga/nvim-notify',
    config = {
      fps = 100,
      level = 1,
      render = 'compact',
      stages = 'fade',
      timeout = 2000,
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
      { '<leader>n', mode = { 'n' }, '<Cmd>Telescope notify<CR>', desc = 'Telescope: [N]otifications' },
    },
  },
}
