local M = {}
local autopairs = require('nvim-autopairs')

_G.MyUtils = {}

function _G.MyUtils.completion_confirm ()
  if vim.fn.pumvisible() ~= 0  then
    if vim.fn.complete_info()["selected"] ~= -1 then
      vim.fn["compe#confirm"]()
      return autopairs.esc("<c-y>")
    else
      vim.defer_fn(function()
        vim.fn["compe#confirm"]("<cr>")
      end, 20)
      return autopairs.esc("<c-n>")
    end
  else
    return autopairs.check_break_line_char()
  end
end



local function fix_enter ()
  vim.g.completion_confirm_key = ""
  vim.api.nvim_set_keymap('i' , '<CR>','v:lua.MyUtils.completion_confirm()', {expr = true , noremap = true})
end

function M.setup ()
  autopairs.setup()
  fix_enter()
end

return M
