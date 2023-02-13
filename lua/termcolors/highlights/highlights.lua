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
        Visual = copy_merge('CursorLine'),
        SignColumn = copy_merge('Normal'),
        MatchParen = {
            cterm = {
                cterm = { bold = true }
            },
            gui = {
                bg = mix(g.normal.black, g.bright.black, 0.5),
                bold = true
            }
        },
        --#endregion

        --#region Line numbers
        LineNr = {
            cterm = {
                ctermfg = t.bright.black
            }
        },
        CursorLineNr = copy_merge(
            'CursorLine',
            'LineNr',
            { cterm = { ctermfg = t.normal.white } }
        ),
        EndOfBuffer = copy_merge('LineNr'),
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
        SpecialKey = copy_merge('Comment'),
        NonText = copy_merge('Comment'),
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

        --#region Diagnostics
        DiagnosticError = {
            cterm = {
                ctermfg = t.bright.red
            }
        },
        DiagnosticWarn = {
            cterm = {
                ctermfg = t.bright.yellow
            }
        },
        DiagnosticInfo = {
            cterm = {
                ctermfg = t.bright.blue
            }
        },
        DiagnosticHint = {
            cterm = {
                ctermfg = t.normal.white
            }
        },
        DiagnosticUnderlineError = {
            cterm = {
                cterm = { undercurl = true }
            },
            gui = {
                undercurl = true,
                sp = g.bright.red
            }
        },
        DiagnosticUnderlineWarn = {
            cterm = {
                cterm = { undercurl = true }
            },
            gui = {
                undercurl = true,
                sp = g.bright.yellow
            }
        },
        DiagnosticUnderlineInfo = {
            cterm = {
                cterm = { undercurl = true }
            },
            gui = {
                undercurl = true,
                sp = g.bright.blue
            }
        },
        DiagnosticUnderlineHint = {
            cterm = {
                cterm = { undercurl = true }
            },
            gui = {
                undercurl = true,
                sp = g.normal.white
            }
        },
        --#endregion

        --#region GitSigns
        -- Signs
        GitSignsAdd = {
            cterm = {
                ctermfg = t.normal.green
            }
        },
        GitSignsChange = {
            cterm = {
                ctermfg = t.normal.blue
            }
        },
        GitSignsDelete = {
            cterm = {
                ctermfg = t.normal.red
            }
        },
        GitSignsUntracked = copy_merge('GitSignsAdd'),
        GitSignsTopdelete = copy_merge('GitSignsDelete'),
        GitSignsChangedelete = copy_merge('GitSignsDelete'),
        -- Line numbers
        GitSignsAddLn = copy_merge('GitSignsAdd'),
        GitSignsChangeLn = copy_merge('GitSignsChange'),
        GitSignsDeleteLn = copy_merge('GitSignsDelete'),
        -- Preview
        GitSignsAddPreview = {
            cterm = {
                ctermbg = t.normal.green,
            },
            gui = {
                bg = mix(g.primary.background, g.normal.green, 0.75)
            }
        },
        GitSignsChangePreview = {
            cterm = {
                ctermbg = t.normal.blue,
            },
            gui = {
                bg = mix(g.primary.background, g.normal.blue, 0.75)
            }
        },
        GitSignsDeletePreview = {
            cterm = {
                ctermbg = t.normal.red,
            },
            gui = {
                bg = mix(g.primary.background, g.normal.red, 0.75)
            }
        },
        --#endregion

        --#region Indent Blankline
        IndentBlanklineChar = {
            cterm = {
                ctermfg = t.bright.black
            }
        },
        IndentBlanklineSpaceChar = copy_merge('IndentBlanklineChar'),
        IndentBlanklineSpaceCharBlankline = copy_merge('IndentBlanklineSpaceChar'),
        IndentBlanklineContextChar = {
            cterm = {
                ctermfg = t.normal.yellow
            }
        },
        IndentBlanklineContextSpaceChar = copy_merge('IndentBlanklineContextChar'),
        IndentBlanklineContextSpaceCharBlankline = copy_merge('IndentBlanklineContextSpaceChar'),
        IndentBlanklineContextStart = {
            cterm = {
                cterm = { underline = true },
            },
            gui = {
                underline = true,
                sp = g.normal.yellow
            }
        }
        --#endregion

        --#region Whichkey
        --#endregion
    }

    return resolver.get()
end

