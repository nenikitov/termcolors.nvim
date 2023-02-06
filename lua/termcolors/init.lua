local options_default = require('termcolors.options')
local highlights = require('termcolors.highlights')

local T = {}

function T.setup(options_user)
    local cached_colors_status, cached_colors = pcall(require, 'termcolors.')

    -- print(u.execute_shell(
    --     'python ' .. u.script_path() .. '../../py/get_colors.py'
    -- ))

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
    for name, highlight in pairs(highlights) do
        vim.api.nvim_set_hl(0, name, highlight)
    end
end

return T

