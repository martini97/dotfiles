local M = {}
local handlers = {}
local utils = require "martini97.utils"

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
        local has_result = result ~= nil and not vim.tbl_isempty(result)
        if has_result then return default_handler(nil, method, result) end

        utils.asyncformat()
    end
end

-- disable virtual text
--[[ handlers["textDocument/publishDiagnostics"] =
    function(_)
        return vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = false,
            update_in_insert = true,
            signs = false
        })
    end ]]

function M.setup()
    for key, value in pairs(handlers) do
        local default_handler = vim.lsp.handlers[key]
        vim.lsp.handlers[key] = value(default_handler)
    end
end

return M
