local snp_utils = require("snippets.utils")
local snippets = require("snippets")
local utils = require("martini97.utils")

snippets.use_suggested_mappings()
snippets.set_ux(require("snippets.inserters.vim_input"))

function React_use_state_setter(string)
    -- handle boolean state (eg: [isLoading, setLoading])
    if string.match(string, "is[A-Z]") then string = string:gsub("^is", "") end
    string = string:gsub("^%l", string.upper)
    return "set" .. string
end

function Jest_as_mocked(string)
    string = string:gsub("^%l", string.upper)
    return "mocked" .. string
end

local js_snippets = {
    clv = snp_utils.match_indentation [[console.log('$1: ', $1)]],
    useS = snp_utils.match_indentation [[const [$1, ${2:${1|React_use_state_setter(S.v)}}] = useState($3)]],
    desc = snp_utils.match_indentation [[
describe('$1', () => {
  $0
})]],
    it = snp_utils.match_indentation [[
it('$1', ${2:async}() => {
  $0
})]],
    mock = snp_utils.match_indentation [[
jest.mock('$1', () => ({
  __esModule: true,
  $2: jest.fn(),
}))]],
    asmocked = snp_utils.match_indentation [[
const ${2:${1|Jest_as_mocked(S.v)}} = $1 as jest.MockedFunction<typeof $1>
]],
    actimmediate = snp_utils.match_indentation [[
await act(async () => {
  await new Promise((r) => setImmediate(r))
})]]
}

local jsx_snippets = {ir = [[import React from 'react']]}

local ts_snippets = {}

local tsx_snippets = {}

snippets.snippets = {
    _global = {
        todo = snp_utils.force_comment(
            "TODO(martini97, ${=os.date('%Y-%m-%d')}): "),
        now = snp_utils.force_comment("${=os.date()}"),
        bang = snp_utils.force_comment [[#!/usr/bin/env ${1:bash}]],
        date = "${=os.date('%Y-%m-%d')}",
    },
    lua = {
        pdb = snp_utils.match_indentation [[require'plenary.path':new('debug.txt'):write('test\n', 'a')]],
        req = snp_utils.match_indentation [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = require '$1']],
        fun = snp_utils.match_indentation [[
function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})
  $0
end]],
        ["for"] = snp_utils.match_indentation [[
for ${1:k}, ${2:p} in ipairs(${3}) do
  ${0}
end
]]
    },
    python = {
        pdb = snp_utils.match_indentation [[__import__("pdb").set_trace()]]
    },
    javascript = js_snippets,
    javascriptreact = utils.merge_tables(js_snippets, jsx_snippets),
    typescript = utils.merge_tables(js_snippets, ts_snippets),
    typescriptreact = utils.merge_tables(js_snippets, ts_snippets, tsx_snippets)
}
