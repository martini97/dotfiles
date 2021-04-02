local utils = {}
local Path = require 'plenary.path'
local log = require 'martini97.log'

function utils.isempty(s)
  return s == nil or s == ''
end

function utils.safe_get_option(ns, name)
	local success, value = pcall(function ()
		return vim[ns][name]
	end)

  if not success then return nil end

  return value
end

function utils.tags_exists()
  for _, value in pairs(vim.opt.tags) do
    if Path:new(value):exists() then return true end
  end
end

-- Based on https://github.com/norcalli/nvim_utils/blob/master/lua/nvim_utils.lua#L554-L567
function utils.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup '..group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten{'autocmd', def}, ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

function utils.merge_tables(...)
  local result = {}
  for _, t in pairs({...}) do
    for key, value in pairs(t) do
      result[key] = value
    end
  end
  return result
end

function utils.asyncgrep(search, opts)
  search = search or vim.fn.expand("<cword>")
  opts = opts or {}

  local lines = {""}
  local winnr = vim.fn.win_id2win(vim.fn.win_getid())

  local grepprg = vim.o.grepprg
  if not grepprg then return end

  local cmd = vim.fn.expandcmd(vim.o.grepprg)

  if opts.full_word and string.match(grepprg, '^[ra]g%s') then
    cmd = cmd .. " --word-regexp"
  end

  cmd = cmd .. string.format(" %q", search)

  local function on_event(_, data, event)
    if event == "stdout" or event == "stderr" then
      if data then
        vim.list_extend(lines, data)
      end
    end

    if event == "exit" then
      vim.fn.setqflist({}, " ", {
        title = cmd,
        lines = lines,
      })
      vim.cmd("doautocmd QuickFixCmdPost")
      vim.cmd("copen")
      vim.cmd(winnr .. "wincmd w")
    end
  end

  return vim.fn.jobstart(cmd, {
    on_stderr = on_event,
    on_stdout = on_event,
    on_exit = on_event,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

function utils.goto_tag()
  if not utils.tags_exists() then
    log.error("Tags file not found.")
  end

  local success, _

  success, _ = pcall(function ()
    return vim.cmd("tjump " .. vim.fn.expand('<cexpr>'))
  end)

  if success then
    log.info("Tag found with <cexpr>")
    return
  end

  success, _ = pcall(function ()
    return vim.cmd("tjump " .. vim.fn.expand('<cword>'))
  end)

  if success then
    log.info("Tag found with <cword>")
    return
  end

  log.warn("Tag not found.")
end

-- TODO(martini97, 2021-04-02): handle visual selection
-- TODO(martini97, 2021-04-02): rename this, it won't be async because
--     it changes the buffer content.
function utils.asyncformat()
  local formatprg = ""
  local view = vim.fn.winsaveview()

  local has_opt = function (ns, opt)
    return not utils.isempty(utils.safe_get_option(ns, opt))
  end

  if has_opt('bo', 'formatprg') then
    formatprg = vim.bo.formatprg
  elseif has_opt('o', 'formatprg') then
    formatprg = vim.o.formatprg
  end

  if utils.isempty(formatprg) then
    vim.api.nvim_feedkeys('gg=G', 'n', true)
  else
    vim.cmd([[execute '%!]] .. formatprg .. [[']])
    -- TODO(martini97, 2021-04-02): figure out why this won't work
    -- vim.api.nvim_feedkeys('gggqG', 'n', true)
  end

  vim.api.nvim_feedkeys('``', 'n', true)
  vim.fn.winrestview(view)
end

return utils
