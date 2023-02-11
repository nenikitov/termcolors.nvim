---@type HighlightBuilder
local builder = require('highlight-builder')

local c = require('termcolors.colors.color_table')
local t = c.term
local g = builder.get_colors(false)
local mix = builder.mix_colors


---@type {[string]: HighlightOptions} Highlights for simple 16 color terminal and GUI mode
local highlights = {
    Comment = {
        cterm = {
            ctermfg = t.bright.black
        },
        gui = {
            fg = mix(g.normal.black, g.bright.green, 0.5)
        }
    }
}

return highlights

