local Path = require("plenary.path")
local scandir = require("plenary.scandir")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local sorters = require("telescope.sorters")
local EntryManager = require("telescope.entry_manager")

local make_display = function(entry)
    local displayer = entry_display.create {
        separator = "",
        items = {{width = entry + 1}, {remaining = true}}
    }
    local hl = entry.directory == "start" and "Operator" or "Number"
    return displayer {{entry.name, hl, "Normal"}}
end

local preview_command = function(entry, bufnr)
    local readme, filetype
    if Path:new(entry .. "/README.md"):exists() then
        readme = vim.fn.readfile(Path:new(entry .. "/README.md"):absolute())
        filetype = "markdown"
    elseif Path:new(entry .. "/readme.md"):exists() then
        readme = vim.fn.readfile(Path:new(entry .. "/readme.md"):absolute())
        filetype = "markdown"
    end

    if filetype then vim.api.nvim_buf_set_option(bufnr, "filetype", filetype) end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, readme)
end

local picker = function(results, opts)
    return pickers.new(opts, {
        prompt_title = "",
        finder = finders.new_table {
            results = results,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = make_display,
                    ordinal = entry,
                    preview_command = preview_command
                }
            end
        },
        sorter = sorters.get_generic_fuzzy_sorter(),
        attach_mappings = function(prompt_bufnr, map)
            local start_task = function()
                local selection = actions.get_selected_entry(prompt_bufnr)
                actions.close(prompt_bufnr)

                local project = results[selection.index][1]

                local cmd = table.concat({"echo", project}, " ")

                vim.cmd(cmd)
            end

            map("i", "<CR>", start_task)
            map("n", "<CR>", start_task)

            return true
        end
    })
end

return require("telescope").register_extension {
    exports = {
        all = function(opts)
            opts = opts or {}
            local project_dirs = opts.project_dirs or
                                     {
                    Path:new(vim.env.HOME .. "/Code"):absolute()
                }
            local depth = opts.depth or 2
            local search_pattern = opts.search_pattern or "%.git$"
            local hidden = opts.hidden or true
            local add_dirs = opts.add_dirs or true
            local results = {}
            local p = picker(results, {})

            scandir.scan_dir_async(project_dirs, {
                depth = depth,
                search_pattern = search_pattern,
                hidden = hidden,
                add_dirs = add_dirs,
                on_insert = function(item)
                    local path = Path:new(Path:new(item):parent()):normalize()
                    table.insert(results, path)
                    p.manager.add_entry(1, "foo")
                end,
                on_exit = function(_)
                    if vim.tbl_isempty(results) then return end

                    p:find()
                end
            })
        end
    }
}
