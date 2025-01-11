return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      vim.keymap.set('n', '<leader>db', '<Cmd>DapToggleBreakpoint<CR>', { desc = '[D]ebug [B]reakpoint' })
      vim.keymap.set('n', '<F5>', function()
        require('dap').continue()
      end, { desc = 'Step Over' })
      vim.keymap.set('n', '<F6>', function()
        require('dap').step_into()
      end, { desc = 'Step Into' })
      vim.keymap.set('n', '<F7>', function()
        require('dap').step_over()
      end, { desc = 'Step Over' })
      vim.keymap.set('n', '<F8>', function()
        require('dap').step_out()
      end, { desc = 'Step Out' })
      vim.keymap.set('n', '<F9>', function()
        require('dap').terminate()
      end, { desc = 'Terminate' })
    end,
  },
  {
    'mfussenegger/nvim-dap-python',
    ft = 'python',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      local path = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
      require('dap-python').setup(path)
    end,
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      local dapui_setup_opts = {
        controls = {
          icons = {
            disconnect = '',
            pause = '',
            play = '|F5',
            run_last = '',
            step_back = '',
            step_into = '|F6',
            step_out = '|F8',
            step_over = '|F7',
            terminate = '|F9',
          },
        },
      }
      dap.listeners.before.attach.dapui_config = function()
        dapui.setup(dapui_setup_opts)
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.setup(dapui_setup_opts)
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
