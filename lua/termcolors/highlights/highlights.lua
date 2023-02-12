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
        --#region Cursor
        Cursor = {
            cterm = {
                ctermbg = t.normal.black
            },
            gui = {
                bg = mix(g.primary.background, g.normal.black, 0.85)
            }
        },
        CursorLine = copy_merge('Cursor'),
        CursorColumn = copy_merge('Cursor'),
        --#endregion

        --#region Menus
        PMenu = {
            cterm = {
                ctermbg = t.primary.background
            },
            gui = {
                bg = g.primary.background
            }
        },
        Visual = copy_merge('Cursor'),
        --#endregion

        --#region Syntax highlighting
        Normal = {
            cterm = {
                ctermfg = t.primary.foreground,
                ctermbg = t.primary.background,
            },
            gui = {
                fg = g.primary.foreground,
                bg = g.primary.background,
            }
        },
        Comment = {
            cterm = {
                ctermfg = t.bright.black
            }
        },
        Keyword = {
            cterm = {
                ctermfg = t.bright.cyan
            }
        },
        Include = {
            cterm = {
                ctermfg = t.bright.cyan
            }
        },
        Identifier = {
            cterm = {
                ctermfg = t.normal.magenta
            }
        },
        ['@namespace'] = {
            cterm = {
                ctermfg = t.normal.magenta
            }
        },
        Type = {
            cterm = {
                ctermfg = t.normal.magenta
            }
        },
        PreProc = {
            cterm = {
                ctermfg = t.normal.blue
            }
        },
        ['@decorator'] = copy_merge('PreProc'),
        Constant = {
            cterm = {
                ctermfg = t.normal.red
            }
        },
        ['@field'] = {
            cterm = {
                ctermfg = t.normal.yellow
            }
        },
        ['@property'] = {
            cterm = {
                ctermfg = t.normal.yellow
            }
        },
        StorageClass = {
            cterm = {
                ctermfg = t.bright.yellow
            }
        },
        Operator = copy_merge('Normal'),
        Delimiter = copy_merge('Normal'),
        Function = {
            cterm = {
                ctermfg = t.bright.blue
            }
        },
        ['@parameter'] = {
            cterm = {
                ctermfg = t.bright.magenta
            }
        },
        ['@type.qualifier'] = copy_merge('Keyword'),
        ['@variable'] = {
            cterm = {
                ctermfg = t.bright.red
            }
        },
        ['@selfTypeKeyword'] = {
            cterm = {
                ctermfg = t.normal.cyan
            }
        },
        String = {
            cterm = {
                ctermfg = t.bright.green
            }
        },
        SpecialChar = {
            cterm = {
                ctermfg = t.normal.red
            }
        },
        Character = {
            cterm = {
                ctermfg = t.normal.green
            }
        },
        Special = {
            cterm = {
                ctermfg = t.normal.red
            }
        },
        ['@constant.builtin'] = copy_merge('Constant'),
        Number = {
            cterm = {
                ctermfg = t.bright.yellow
            }
        },
        Boolean = {
            cterm = {
                ctermfg = t.bright.magenta
            }
        },
        Statement = copy_merge('Keyword'),
        ['@function.builtin'] = copy_merge('Keyword'),
        ['@constructor'] = copy_merge('Type'),
        Conditional = {
            cterm = {
                ctermfg = t.bright.yellow
            }
        },
        ['@keyword.return'] = copy_merge('Conditional'),
        ['@controlFlow'] = copy_merge('Conditional'),
        Repeat = copy_merge('Conditional'),
        --#endregion
    }

    return resolver.get()
end

