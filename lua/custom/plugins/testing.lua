return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
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
        },
      }
      vim.keymap.set('n', '<leader>tn', function()
        require('neotest').run.run()
      end, { desc = '[T]ests: Run [N]earest' })
      vim.keymap.set('n', '<leader>dn', function()
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
