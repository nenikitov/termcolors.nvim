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
        if separated.link then
            -- Highlight is a link
            highlights[name] = { link = separated.link }
        else
            -- Highlight has values to populate
            if colorscheme_options.high_color_cterm and separated.gui then
                -- We can and should adapt GUI style to CTERM
                ---@type TermHighlight
                local old_cterm = vim.deepcopy(separated.cterm)
                separated.cterm = builder.gui_to_cterm(separated.gui)
                if old_cterm.ctermfg == 'NONE' then
                    separated.cterm.ctermfg = nil
                end
                if old_cterm.ctermbg == 'NONE' then
                    separated.cterm.ctermbg = nil
                end
            end
            if not separated.gui and separated.cterm then
                -- We need to adapt CTERM style to GUI
                separated.gui = builder.cterm_to_gui(separated.cterm)
            end

            highlights[name] = vim.tbl_deep_extend('force', separated.cterm, separated.gui)
        end
    end

    return highlights
end

