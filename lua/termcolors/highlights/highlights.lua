---@type HighlightBuilder
local builder = require('highlight_builder')
local mix = builder.mix_colors
local Resolver = require('termcolors.highlights.resolver')

--- Get highlights of the colorscheme.
---@param t TermColorTable Terminal colors.
---@param g GuiColorTable GUI colors.
---@return {[string]: SeparatedHighlight} highlight Highlight groups.
return function(t, g)
    local resolver = Resolver()
    local copy_merge = resolver.copy_merge

    resolver.set {
        Cursor = {
            cterm = {
                ctermbg = t.normal.black
            },
            gui = {
                bg = mix(g.primary.background, g.normal.black, 0.75)
            }
        },
        CursorLine = copy_merge('Cursor'),
        CursorColumn = copy_merge('Cursor'),
    }

    return resolver.get()
end

