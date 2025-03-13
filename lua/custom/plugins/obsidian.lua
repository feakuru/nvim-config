local function get_last_folder_name(folder_name)
  local name_iterator = string.gmatch(folder_name, '([^/]+)')
  local cur_name = name_iterator()
  while cur_name ~= nil do
    cur_name = name_iterator()
  end
  return cur_name
end

local obsidian_workspaces = {}
for dir in io.popen([[ls -d ~/Obsidian/*/ ]]):lines() do
  table.insert(obsidian_workspaces, { name = get_last_folder_name(dir), path = dir })
end

return {
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
      workspaces = obsidian_workspaces,
    },
  },
}
