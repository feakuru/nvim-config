return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
      'rouge8/neotest-rust',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
            args = { '-vv' },
            -- an experimental option that made my pc overheat when debugging tests:
            -- pytest_discover_instances = true,
          },
          require 'neotest-rust' {
            args = { '--no-capture' },
            dap_adapter = 'gdb',
          },
        },
      }
      vim.keymap.set('n', '<leader>tn', function()
        require('neotest').run.run()
      end, { desc = '[T]ests: Run [N]earest' })
      vim.keymap.set('n', '<leader>tdn', function()
        require('neotest').run.run { strategy = 'dap' }
      end, { desc = '[D]ebug [N]earest test' })
      vim.keymap.set('n', '<leader>tf', function()
        require('neotest').run.run(vim.fn.expand '%')
      end, { desc = '[T]ests: Run all tests in [F]ile' })
      vim.keymap.set('n', '<leader>to', function()
        require('neotest').output.open { enter = true }
      end, { desc = '[T]ests: Open [O]utput Window' })
    end,
  },
}
