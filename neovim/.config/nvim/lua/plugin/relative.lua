local Path = require 'plenary.path'
local log = require 'martini97.log'

local function leader(key)
  return "<space>e"..key
end

local function relative(operation)
  return function ()
    local path = Path:new(vim.fn.expand('%') or vim.loop.cwd())
    local target_direcory = "./"

    if path:is_dir() then
      target_direcory = path:normalize()
    elseif path:is_file() then
      target_direcory = Path:new(path:parent()):normalize()
    end

    if target_direcory == "" then
      target_direcory = "./"
    end

    if target_direcory:sub(-#"/") ~= "/" then
      target_direcory = target_direcory .. "/"
    end

    vim.api.nvim_feedkeys(':' .. operation .. ' ' .. target_direcory, 'n', false)
  end
end

local function keymaps()
  vim.keymap.nnoremap {leader"e", relative("edit")}
  vim.keymap.nnoremap {leader"v", relative("vsplit")}
  vim.keymap.nnoremap {leader"r", relative("read")}
  vim.keymap.nnoremap {leader"t", relative("tabedit")}
end

keymaps()
