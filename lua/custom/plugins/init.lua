-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
local function do_custom_commit(prefix)
  local ok, _ = pcall(vim.cmd, 'G commit -a')
  if ok then
    local branch = vim.fn.system "git branch --show-current | tr -d '\n'"
    local ticket = branch:match '([A-Z]+%-%d+)'
    vim.cmd 'startinsert'
    if not ticket then
      vim.api.nvim_put({ string.format('%s: ', prefix) }, 'c', true, true)
      return
    end
    if prefix == '' then
      vim.api.nvim_put({ string.format('%s: ', ticket) }, 'c', true, true)
      return
    end
    vim.api.nvim_put({ string.format('%s(%s): ', prefix, ticket) }, 'c', true, true)
  end
end

local function wrap_git_cmd(command)
  local ok, err = pcall(vim.cmd, 'G ' .. command)
  if not ok then
    vim.health.warn(string.format("Could not %s: '%s'", command, err))
  end
  return ok
end

return {
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        view = {
          width = { min = 30, max = 150 },
          relativenumber = true,
          number = true,
        },
        update_focused_file = {
          enable = true,
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
          custom = {
            '.*.null-ls_.*',
          },
        },
      }
      vim.keymap.set('n', '<leader>tt', '<Cmd>NvimTreeToggle<CR>', { desc = '[T]oggle NVim[T]ree' })
    end,
  },
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    ft = { 'python' },
    opts = function()
      local null_ls = require 'null-ls'
      local virtual = os.getenv 'VIRTUAL_ENV' or os.getenv 'CONDA_PREFIX' or os.getenv 'HOME' .. '/.local'
      return {
        sources = {
          null_ls.builtins.diagnostics.mypy.with {
            command = virtual .. '/bin/mypy',
          },
          null_ls.builtins.formatting.isort.with { prefer_local = true },
        },
        debug = true,
      }
    end,
  },
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
      vim.keymap.set('n', '<leader>tdn', function()
        require('neotest').run.run { strategy = 'dap' }
      end, { desc = '[T]ests: [D]ebug [N]earest' })
      vim.keymap.set('n', '<leader>tf', function()
        require('neotest').run.run(vim.fn.expand '%')
      end, { desc = '[T]ests: Run all tests in [F]ile' })
      vim.keymap.set('n', '<leader>to', function()
        require('neotest').output.open { enter = true }
      end, { desc = '[T]ests: Open [O]utput Window' })
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
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gb', '<Cmd>Telescope git_branches<CR>', { desc = '[G]it [B]ranches' })
      vim.keymap.set('n', '<leader>gs', '<Cmd>Git<CR>', { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<leader>gcf', function()
        do_custom_commit 'feat'
      end, { desc = '[G]it [C]ommit [F]eat' })
      vim.keymap.set('n', '<leader>gcc', function()
        do_custom_commit 'chore'
      end, { desc = '[G]it [C]ommit [C]hore' })
      vim.keymap.set('n', '<leader>gcr', function()
        do_custom_commit 'refactor'
      end, { desc = '[G]it [C]ommit [R]efactor' })
      vim.keymap.set('n', '<leader>gce', '<Cmd>Git commit -a<CR>', { desc = '[G]it [C]ommit [E]mpty' })

      vim.keymap.set('n', '<leader>gp', '<Cmd>Git push<CR>', { desc = '[G]it [P]ush' })
      vim.keymap.set('n', '<leader>gf', '<Cmd>Git pull<CR>', { desc = '[G]it [F]pull' })
      vim.keymap.set('n', '<leader>gd', '<Cmd>Git diff<CR>', { desc = '[G]it [D]iff' })
      vim.keymap.set('n', '<leader>gl', '<Cmd>Git log<CR>', { desc = '[G]it [L]og' })
      vim.keymap.set('n', '<leader>gw', function()
        if vim.bo.filetype == 'fugitiveblame' then
          vim.cmd 'q'
        else
          vim.cmd 'G blame'
        end
      end, { desc = '[G]it [W]hodunit (Blame)' })
      vim.keymap.set('n', '<leader>gM', function()
        local commands = {
          'checkout main',
          'pull',
          'checkout -',
          'merge main',
        }
        for _, command in ipairs(commands) do
          if not wrap_git_cmd(command) then
            return
          end
        end
      end, { desc = '[G]it merge in [M]ain branch' })
    end,
  },
  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      local dropbar_api = require 'dropbar.api'
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick in Dropbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Goto start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end,
    opts = {
      general = { update_interval = 10 },
    },
  },
  {
    'NachoNievaG/atac.nvim',
    dependencies = { 'akinsho/toggleterm.nvim' },
    config = function()
      require('atac').setup {
        --     dir = '~/my/work/directory', -- By default, the dir will be set as /tmp/atac
      }
      vim.keymap.set('n', '<leader>ta', '<Cmd>Atac<CR>', { desc = '[T]oggle [A]TAC' })
    end,
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },
  'ThePrimeagen/vim-be-good',
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-completion',
  'kristijanhusak/vim-dadbod-ui',
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

      require('ufo').setup()
    end,
  },
  {
    'rmagatti/auto-session',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('auto-session').setup {
        auto_session_suppress_dirs = { '~/', '~/projects', '~/Downloads', '/' },
      }
    end,
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
      { '<leader>tvn', '<Cmd>Telescope notify<CR>', { desc = '[T]elescope: [v]iew [n]otifications' } },
    },
  },
  {
    'kawre/leetcode.nvim',
    build = ':TSUpdate html',
    dependencies = {

      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim', -- required by telescope
      'MunifTanjim/nui.nvim',

      -- optional
      'nvim-treesitter/nvim-treesitter',
      'rcarriga/nvim-notify',
      'nvim-tree/nvim-web-devicons',
    },
    cmd = 'Leet',
    opts = {
      plugins = {
        non_standalone = true,
      },
    },
  },
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
}
