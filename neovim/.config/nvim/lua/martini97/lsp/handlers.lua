local M = {}
local handlers = {}
local utils = require 'martini97.utils'

handlers["textDocument/definition"] = function(default_handler)
    return function(_, method, result)
        if result ~= nil then return default_handler(nil, method, result) end

        utils.goto_tag()
    end
end

handlers["textDocument/references"] = function(default_handler)
    return function(_, method, result)
        -- if no results or only the current ocurrence was found.
        if result ~= nil and #result > 1 then
            return default_handler(nil, method, result)
        end

        utils.asyncgrep(nil, {full_word = true})
    end
end

handlers["textDocument/formatting"] = function(default_handler)
    return function(_, method, result)
        if result ~= nil then return default_handler(nil, method, result) end

        utils.asyncformat()
    end
end

function M.setup()
    for key, value in pairs(handlers) do
        local default_handler = vim.lsp.handlers[key]
        vim.lsp.handlers[key] = value(default_handler)
    end
end

return M
