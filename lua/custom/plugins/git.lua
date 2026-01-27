local function wrap_git_cmd(command)
  local ok, err = pcall(vim.cmd, 'horizontal terminal git ' .. command)
  if not ok then
    vim.health.warn(string.format("Could not %s: '%s'", command, err))
  end
  return ok
end

local function do_custom_commit(prefix)
  -- only do `git commit -a` if we haven't specifically staged some files
  local diff = vim.fn.system 'git diff --name-only --cached'
  local prompt = 'Commit message'
  if prefix and #prefix > 0 then
    prompt = prompt .. ' (' .. prefix .. '):'
    prefix = prefix .. ': '
  else
    prompt = prompt .. ':'
  end
  local msg = vim.fn.input { prompt = prompt }
  if #msg <= 0 then
    vim.notify('Empty commit message, aborting.', vim.log.levels.WARN)
    return
  end
  local cmd = 'commit -a -m "' .. prefix .. msg .. '"'
  if diff and #diff > 0 then
    cmd = 'commit -m "' .. prefix .. msg .. '"'
  end
  local ok = wrap_git_cmd(cmd)
  if not ok then
    return
  end
end

return {
  {
    'tpope/vim-fugitive',
    config = function()
      -- basic stuff
      vim.keymap.set('n', '<leader>gs', '<Cmd>Git<CR>', { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<leader>ga', '<Cmd>Git add -A<CR>', { desc = '[G]it [A]dd All' })
      vim.keymap.set('n', '<leader>gb', '<Cmd>Telescope git_branches<CR>', { desc = '[G]it [B]ranches' })
      vim.keymap.set('n', '<leader>gp', function()
        wrap_git_cmd 'push'
      end, { desc = '[G]it [P]ush' })
      vim.keymap.set('n', '<leader>gf', '<Cmd>Git pull --all<CR>', { desc = '[G]it [F]pull' })
      vim.keymap.set('n', '<leader>gd', '<Cmd>Git diff<CR>', { desc = '[G]it [D]iff' })
      vim.keymap.set('n', '<leader>gl', '<Cmd>Git log<CR>', { desc = '[G]it [L]og' })
      vim.keymap.set('n', '<leader>gSs', '<Cmd>Git stash<CR>', { desc = '[G]it [S]tash' })
      vim.keymap.set('n', '<leader>gSa', '<Cmd>Git stash apply<CR>', { desc = '[G]it [S]tash [A]pply' })
      vim.keymap.set('n', '<leader>gm', '<Cmd>Git mergetool<CR>', { desc = '[G]it [M]ergetool' })
      vim.keymap.set('n', '<leader>gn', '<Cmd>Neogit<CR>', { desc = '[N]eo[G]it' })

      -- various commit prefixes
      vim.keymap.set('n', '<leader>gcf', function()
        do_custom_commit 'feat'
      end, { desc = '[G]it [C]ommit [F]eat' })
      vim.keymap.set('n', '<leader>gcc', function()
        do_custom_commit 'chore'
      end, { desc = '[G]it [C]ommit [C]hore' })
      vim.keymap.set('n', '<leader>gcr', function()
        do_custom_commit 'refactor'
      end, { desc = '[G]it [C]ommit [R]efactor' })
      vim.keymap.set('n', '<leader>gce', function()
        do_custom_commit ''
      end, { desc = '[G]it [C]ommit [E]mpty' })

      -- blame: will handle opening on another file
      vim.keymap.set('n', '<leader>gw', function()
        if vim.bo.filetype == 'fugitiveblame' then
          vim.cmd 'q'
        else
          vim.cmd 'G blame'
        end
      end, { desc = '[G]it [W]hodunit (Blame)' })

      -- Close fugitive status window with `q`
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'fugitive',
        callback = function()
          vim.keymap.set('n', 'q', '<Cmd>q<CR>', { buffer = true, desc = 'Close fugitive status' })
        end,
      })

      local ts_builtin = require 'telescope.builtin'
      local ts_actions = require 'telescope.actions'
      local ts_actions_state = require 'telescope.actions.state'

      local function select_git_branch(options, callback)
        ts_builtin.git_branches {
          prompt_title = options.prompt,
          default_text = options.default,
          attach_mappings = function(_, map)
            map('i', '<CR>', function(prompt_bufnr)
              local selection = ts_actions_state.get_selected_entry()
              ts_actions.close(prompt_bufnr)
              callback(selection.value)
            end, { desc = 'Confirm choice' })
            map('n', '<CR>', function(prompt_bufnr)
              local selection = ts_actions_state.get_selected_entry()
              ts_actions.close(prompt_bufnr)
              callback(selection.value)
            end, { desc = 'Confirm choice' })
            -- allow clearing prompt with <C-u>
            map('i', '<C-u>', false)
            map('n', '<C-u>', false)
            return true
          end,
        }
      end

      vim.keymap.set('n', '<leader>gM', function()
        select_git_branch({ prompt = 'Branch to merge in:', default = 'develop' }, function(branch_name)
          if not wrap_git_cmd('merge ' .. branch_name) then
            return
          end
        end)
      end, { desc = '[G]it pull and [M]erge' })

      vim.keymap.set('n', '<leader>gRs', function()
        select_git_branch({ prompt = 'Branch to rebase onto:', default = 'origin/develop' }, function(branch_name)
          local commands = {
            'pull',
            'rebase ' .. branch_name,
          }
          for _, command in ipairs(commands) do
            if not wrap_git_cmd(command) then
              return
            end
          end
        end)
      end, { desc = '[G]it [R]ebase [S]tart' })
      vim.keymap.set('n', '<leader>gRc', '<Cmd>Git rebase --continue<CR>', { desc = '[G]it [R]ebase [C]ontinue' })
      vim.keymap.set('n', '<leader>gRa', '<Cmd>Git rebase --abort<CR>', { desc = '[G]it [R]ebase [A]bort' })
    end,
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim', -- optional
    },
  },
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = function()
      require('git-conflict').setup {
        default_mappings = false,
      }
      vim.keymap.set('n', '<leader>ro', '<Cmd>GitConflictChooseOurs<CR>', { desc = '[O]urs' })
      vim.keymap.set('n', '<leader>rt', '<Cmd>GitConflictChooseTheirs<CR>', { desc = '[T]heirs' })
      vim.keymap.set('n', '<leader>rb', '<Cmd>GitConflictChooseBoth<CR>', { desc = '[B]oth' })
      vim.keymap.set('n', '<leader>rn', '<Cmd>GitConflictChooseNone<CR>', { desc = '[N]one' })
    end,
  },
}
