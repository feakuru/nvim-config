-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

vim.pack.add {
  { src = 'https://github.com/nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  { src = 'https://github.com/s1n7ax/nvim-window-picker', version = vim.version.range '2.*' },
}

require('window-picker').setup()

vim.keymap.set('n', '\\', '<Cmd>Neotree reveal<CR>', { desc = 'NeoTree reveal', silent = true })

-- Create a new file/dir as a *sibling* of the focused node, i.e. in the directory that
-- contains it, rather than inside it. Neo-tree's built-in `insert_as = 'sibling'` makes an
-- exception for expanded directories (it still inserts into them); this is unconditional.
---@param state table neo-tree source state
local function add_sibling(state)
  local node = state.tree:get_node()
  if not node then
    vim.notify('No node selected.', vim.log.levels.WARN)
    return
  end

  -- Root node has no parent, so fall back to creating inside it.
  local target = node:get_parent_id() or node:get_id()
  require('neo-tree.sources.filesystem.lib.fs_actions').create_node(target, nil, target)
end

require('neo-tree').setup {
  filesystem = {
    -- Do NOT let neo-tree issue `tcd`/`lcd`/`cd`. Revealing a file outside the cwd used to
    -- re-root the tree and drag the tab's cwd along with it, with no way back.
    -- With this off the binding is one-way-off entirely: neo-tree's root is its own business.
    bind_to_cwd = false,
    cwd_target = { sidebar = 'none', current = 'none' },
    window = {
      mappings = {
        ['\\'] = 'close_window',

        -- `a` creates inside the focused directory, `A` creates a directory there.
        -- `<C-a>` creates alongside the focused node instead.
        ['<C-a>'] = add_sibling,

        ['Y'] = function(state)
          local node = state.tree:get_node()
          if not node or not node.id then
            vim.notify('No node selected.', vim.log.levels.WARN)
            return
          end

          if vim.fn.has 'clipboard' == 0 then
            vim.notify('System clipboard is not available.', vim.log.levels.ERROR)
            return
          end

          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local choices = {
            { label = 'Absolute path', value = filepath },
            { label = 'Path relative to CWD', value = modify(filepath, ':.') },
            { label = 'Path relative to HOME', value = modify(filepath, ':~') },
            { label = 'Filename', value = filename },
            { label = 'Filename without extension', value = modify(filename, ':r') },
            { label = 'Extension of the filename', value = modify(filename, ':e') },
          }

          vim.ui.select(choices, {
            prompt = 'Choose to copy to clipboard:',
            format_item = function(item) return string.format('%-30s %s', item.label, item.value) end,
          }, function(choice)
            if not choice then
              vim.notify('Copy cancelled.', vim.log.levels.INFO)
              return
            end

            local value_to_copy = choice.value

            vim.fn.setreg('+', value_to_copy)
            vim.notify('Copied to clipboard: ' .. value_to_copy)
          end)
        end,
      },
    },
  },
  -- Same as above: the buffers source also two-way binds to the cwd by default.
  buffers = { bind_to_cwd = false },
  event_handlers = {
    {
      event = 'neo_tree_buffer_enter',
      handler = function() vim.o.relativenumber = true end,
    },
  },
}
