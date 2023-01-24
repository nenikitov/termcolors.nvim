local options_default = require('termcolors.options')
local highlights = require('termcolors.highlights')

local T = {}

function T.setup(options_user)
    -- Parse options
    local options = vim.tbl_deep_extend('force', options_default, options_user or {})

    -- Clear highlighting
    vim.cmd('hi clear')
    if vim.fn.exists('syntax on') then
        vim.cmd('syntax reset')
    end

    -- Vim options
    vim.g.colors_name = 'termcolors'

    -- Colorscheme
    local highlights_to_lateinit = {}
    for name, highlight in pairs(highlights) do
        if type(highlight) == 'function' then
            highlights_to_lateinit[name] = highlight
        else
        vim.api.nvim_set_hl(0, name, highlight)
        end
    end
    for name, highlight in pairs(highlights_to_lateinit) do
        print('lua vim.api.nvim_set_hl(0, \'' .. name .. '\', ' .. vim.inspect(highlight(), { newline = ' ', indent = '' }) .. ')')
        vim.api.nvim_set_hl(0, name, highlight())
    end
end

return T

