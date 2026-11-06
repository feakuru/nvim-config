-- `vim.g.no_plugin_maps` (init.lua) disables the built-in man ftplugin mappings,
-- so restore them here. Mirrors $VIMRUNTIME/ftplugin/man.vim.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-man-maps', { clear = true }),
  pattern = 'man',
  callback = function(args)
    local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = args.buf, silent = true, nowait = true, desc = desc }) end
    map('q', '<Cmd>lclose<CR><C-W>q', 'Close man page')
    map('j', 'gj', 'Down (display line)')
    map('k', 'gk', 'Up (display line)')
    map('gO', function() require('man').show_toc() end, 'Man page outline')
    map('<2-LeftMouse>', '<Cmd>Man<CR>', 'Open man page under cursor')

    -- less-like half-page scrolling
    map('d', '<C-d>', 'Half page down')
    map('u', '<C-u>', 'Half page up')
  end,
})
