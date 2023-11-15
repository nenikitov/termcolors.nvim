local apply = require('highlight_builder').apply

local defaults = require('termcolors.options')
local highlights = require('termcolors.highlights')
local setup_plugins = require('termcolors.plugins')

local T = {}

---@param options OptionsPartial | nil
function T.setup(options)
    -- Parse options
    ---@type Options
    local opts = vim.tbl_extend('force', defaults, options or {})

    -- Clear highlighting
    vim.cmd('hi clear')
    if vim.fn.exists('syntax on') then
        vim.cmd('syntax reset')
    end

    -- Vim options
    vim.g.colors_name = 'termcolors'

    -- Colorscheme
    apply(highlights(opts))

    -- Plugins
    --setup_plugins()
end

return T
