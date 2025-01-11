local function wrap_git_cmd(command)
  local ok, err = pcall(vim.cmd, 'G ' .. command)
  if not ok then
    vim.health.warn(string.format("Could not %s: '%s'", command, err))
  end
  return ok
end

local function do_custom_commit(prefix)
  local ok, _ = wrap_git_cmd 'commit -a'
  if not ok then
    return
  end

  local branch = vim.fn.system "git branch --show-current | tr -d '\n'"
  local ticket = branch:match '([A-Z]+%-%d+)'
  if not ticket or ticket == '' then
    if prefix and #prefix > 0 then
      prefix = string.format('%s: ', prefix)
    end
  elseif not prefix or prefix == '' then
    prefix = string.format('%s: ', ticket)
  end

  -- TODO: this starts inserting even if commit command failed,
  -- the `ok` above is clearly not enough (re: nothing to commit)
  vim.cmd 'startinsert'
  if prefix and #prefix > 0 then
    vim.api.nvim_put({ prefix }, 'c', true, true)
  end
end

return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set('n', '<leader>gb', '<Cmd>Telescope git_branches<CR>', { desc = '[G]it [B]ranches' })
      vim.keymap.set('n', '<leader>gs', '<Cmd>Git<CR>', { desc = '[G]it [S]tatus' })
      vim.keymap.set('n', '<leader>gaa', '<Cmd>Git add -A<CR>', { desc = '[G]it [A]dd [A]ll' })
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
}