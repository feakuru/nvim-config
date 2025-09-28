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

      -- Debug adapters
      dap.adapters.gdb = {
        type = 'executable',
        command = 'gdb',
        args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
      }
      dap.adapters['rust-gdb'] = {
        type = 'executable',
        command = 'rust-gdb',
        args = { '--interpreter=dap', '--eval-command', 'set print pretty on' },
      }

      -- Debug configurations
      -- C and C++
      dap.configurations.c = {
        {
          name = 'Launch',
          type = 'gdb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          args = {}, -- provide arguments if needed
          cwd = '${workspaceFolder}',
          stopAtBeginningOfMainSubprogram = false,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
        {
          name = 'Select and attach to process',
          type = 'gdb',
          request = 'attach',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          pid = function()
            local name = vim.fn.input 'Executable name (filter): '
            return require('dap.utils').pick_process { filter = name }
          end,
          cwd = '${workspaceFolder}',
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'gdb',
          request = 'attach',
          target = 'localhost:1234',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
      }
      dap.configurations.cpp = dap.configurations.c

      -- Rust
      dap.configurations.rust = {
        {
          name = 'Launch',
          type = 'rust-gdb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          args = {}, -- provide arguments if needed
          cwd = '${workspaceFolder}',
          stopAtBeginningOfMainSubprogram = false,
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
        {
          name = 'Select and attach to process',
          type = 'rust-gdb',
          request = 'attach',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          pid = function()
            local name = vim.fn.input 'Executable name (filter): '
            return require('dap.utils').pick_process { filter = name }
          end,
          cwd = '${workspaceFolder}',
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'rust-gdb',
          request = 'attach',
          target = 'localhost:1234',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          setupCommands = {
            {
              text = '-enable-pretty-printing',
              description = 'enable pretty printing',
              ignoreFailures = false,
            },
          },
        },
      }
    end,
  },
}
