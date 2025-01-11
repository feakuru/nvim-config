-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

return {
  'ThePrimeagen/vim-be-good',
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
}
