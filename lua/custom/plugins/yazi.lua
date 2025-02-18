return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>y.",
      mode = { "n", "v" },
      "<Cmd>Yazi<CR>",
      desc = "Open yazi here",
    },
    {
      "<leader>yy",
      "<Cmd>Yazi cwd<CR>",
      desc = "Open Yazi in cwd",
    },
    {
      "<leader>yr",
      "<Cmd>Yazi toggle<CR>",
      desc = "Resume yazi",
    },
  },
  opts = {
    open_for_directories = false,
    keymaps = {
      show_help = "<f1>",
    },
  },
}
