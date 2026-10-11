-- Helpers for treating Mason as a fallback for binaries the system doesn't provide.
local M = {}

local mason_bin = vim.fs.normalize(vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'bin'))

--- Is `bin` executable from some PATH entry other than Mason's own bin dir?
--- Independent of whether (or where) Mason has already added itself to PATH.
---@param bin string
---@return boolean
function M.on_system(bin)
  for dir in vim.gsplit(vim.env.PATH or '', ':', { plain = true, trimempty = true }) do
    if vim.fs.normalize(dir) ~= mason_bin and vim.fn.executable(vim.fs.joinpath(dir, bin)) == 1 then return true end
  end
  return false
end

return M
