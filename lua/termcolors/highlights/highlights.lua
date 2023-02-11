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
        Comment = {
            cterm = {
                ctermfg = t.bright.black
            },
            gui = {
                fg = mix(g.bright.black, g.bright.green, 0.5)
            }
        },
        Identifier = copy_merge(
            'Comment',
            {
                cterm = { cterm = { bold = true } },
                gui = { bold = true }
            }
        )
    }

    return resolver.get()
end

