local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.martini97.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.martini97.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

return {
  setup = function ()
    vim.keymap.inoremap {"<tab>", "v:lua.martini97.tab_complete()", expr = true}
    vim.keymap.snoremap {"<tab>", "v:lua.martini97.tab_complete()", expr = true}
    vim.keymap.inoremap {"<s-tab>", "v:lua.martini97.s_tab_complete()", expr = true}
    vim.keymap.snoremap {"<s-tab>", "v:lua.martini97.s_tab_complete()", expr = true}
  end,
}
