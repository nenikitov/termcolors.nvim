---@type HighlightBuilder
local builder = require('highlight_builder')
local generate_highlights_separated = require('termcolors.highlights.highlights')

--- Generate highlights based on the options
---@param colorscheme_options Options
---@return FullHighlight[]
return function(colorscheme_options)
    ---@type FullHighlight[]
    local highlights = {}

    local t = require('termcolors.colors.color_table')
    local g = builder.get_colors()
    local highlights_separated = generate_highlights_separated(t, g)

    for name, separated in pairs(highlights_separated) do
        if colorscheme_options.high_color_cterm and separated.gui then
            separated.cterm = builder.gui_to_cterm(separated.gui)
        end
        if not separated.gui and separated.cterm then
            separated.gui = builder.cterm_to_gui(separated.cterm)
        end

        highlights[name] = vim.tbl_deep_extend('force', separated.cterm, separated.gui)
    end
    return highlights
end

