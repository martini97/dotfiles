local M = {}
local lualine = require 'lualine'
local icons = require 'nvim-web-devicons'

function M.setup()
    icons.setup()
    lualine.setup {
        options = {theme = 'dracula'},
        sections = {
            lualine_a = {{'mode', upper = true}},
            lualine_b = {{'branch', icon = ''}},
            lualine_c = {{'filename', file_status = true}},
            lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_y = {'progress'},
            lualine_z = {'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_d = {},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        extensions = {'fugitive'}
    }
end

return M
