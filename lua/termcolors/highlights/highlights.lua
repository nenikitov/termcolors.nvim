---@type HighlightBuilder
local builder = require('highlight_builder')
local mix = builder.mix_colors
local Resolver = require('termcolors.highlights.resolver')

--- Get highlights of the colorscheme.
---@param t TermColorTable Terminal colors.
---@param g GuiColorTable GUI colors.
---@return {[string]: SeparatedHighlightOrLink} highlight Highlight groups.
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
        CursorColumn = { link = 'CursorLine' },
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
        SignColumn = { link = 'Normal' },
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
        EndOfBuffer = { link = 'LineNr' },
        --#endregion

        --#region Syntax highlighting
        Normal = {
            cterm = {
                ctermfg = t.primary.foreground,
                ctermbg = t.primary.background,
            },
            gui = {
                fg = g.primary.foreground,
                bg = nil,
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
        ['@decorator'] = { link = 'PreProc' },
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
        Operator = { link = 'Conditional' },
        Delimiter = { link = 'Normal' },
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
        ['@type.qualifier'] = { link = 'Keyword' },
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
        ['@constant.builtin'] = { link = 'Constant' },
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
        Statement = { link = 'Keyword' },
        ['@function.builtin'] = { link = 'Function' },
        ['@constructor'] = { link = 'Type' },
        Conditional = {
            cterm = {
                ctermfg = t.bright.yellow
            }
        },
        ['@keyword.return'] = { link = 'Conditional' },
        ['@controlFlow'] = { link = 'Conditional' },
        Repeat = { link = 'Conditional' },
        Title = {
            cterm = {
                ctermfg = t.bright.yellow,
                cterm = { bold = true }
            }
        },
        ['@ponctuation.delimiter'] = { link = 'Delimiter' },
        Tag = { link = 'Structure' },
        htmlTag = { link = 'Tag' },
        htmlTagName = { link = 'Tag' },
        htmlArg = { link = '@property' },
        ['@tag.attribute'] = { link = '@property' },
        Underlined = {
            cterm = {
                cterm = { underline = true }
            }
        },
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

        --#region Packer
        WarningMsg = { link = 'DiagnosticWarn' },
        packerStatusSuccess = {
            cterm = {
                ctermfg = t.bright.green
            }
        },
        packerSuccess = { link = 'packerStatusSuccess' },
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
        GitSignsUntracked = { link = 'GitSignsAdd' },
        GitSignsTopdelete = { link = 'GitSignsDelete' },
        GitSignsChangedelete = { link = 'GitSignsDelete' },
        -- Line numbers
        GitSignsAddLn = { link = 'GitSignsAdd' },
        GitSignsChangeLn = { link = 'GitSignsChange' },
        GitSignsDeleteLn = { link = 'GitSignsDelete' },
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
        -- Diff
        DiffAdd = copy_merge('GitSignsAdd'),
        DiffChange = copy_merge('GitSignsChange'),
        DiffDelete = copy_merge('GitSignsDelete'),
        --#endregion

        --#region Indent Blankline
        IndentBlanklineChar = {
            cterm = {
                ctermfg = t.bright.black
            }
        },
        IndentBlanklineSpaceChar = { link = 'IndentBlanklineChar' },
        IndentBlanklineSpaceCharBlankline = { link = 'IndentBlanklineSpaceChar' },
        IndentBlanklineContextChar = {
            cterm = {
                ctermfg = t.normal.yellow
            }
        },
        IndentBlanklineContextSpaceChar = { link = 'IndentBlanklineContextChar' },
        IndentBlanklineContextSpaceCharBlankline = { link = 'IndentBlanklineContextSpaceChar' },
        IndentBlanklineContextStart = {
            cterm = {
                cterm = { underline = true },
            },
            gui = {
                underline = true,
                sp = g.normal.yellow
            }
        },
        --#endregion

        --#region Whichkey
        WhichKey = { link = 'Function' },
        WhichKeyDesc = { link = 'String' },
        WhichKeyGroup = { link = '@variable' },
        --#endregion

        --#region Rainbow
        rainbowcol1 = {
            cterm = {
                ctermfg = t.normal.yellow,
            }
        },
        rainbowcol2 = {
            cterm = {
                ctermfg = t.normal.blue,
            }
        },
        rainbowcol3 = {
            cterm = {
                ctermfg = t.normal.magenta,
            }
        },
        rainbowcol4 = {
            cterm = {
                ctermfg = t.normal.cyan,
            }
        },
        rainbowcol5 = {
            cterm = {
                ctermfg = t.normal.green,
            }
        },
        rainbowcol6 = {
            cterm = {
                ctermfg = t.normal.red,
            }
        },
        rainbowcol7 = {
            cterm = {
                ctermfg = t.normal.white,
            }
        },
        --#endregion

        --#region Telescope
        TelescopeTitle = { link = 'FloatTitle' },
        TelescopeBorder = { link = 'FloatBorder' },
        TelescopeMatching = { link = 'Search' },
        --#endregion

        --#region LuaLine
        -- Normal
        LuaLineNormalA = {
            cterm = {
                ctermfg = t.normal.cyan,
                cterm = { reverse = true, bold = true }
            }
        },
        LuaLineNormalB = copy_merge(
            'LuaLineNormalA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineNormalC = {
            cterm = {
                ctermfg = t.normal.white,
                ctermbg = t.normal.black
            }
        },
        LuaLineNormalAB = copy_merge(
            'LuaLineNormalA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineNormalBC = {
            cterm = {
                ctermfg = t.bright.black,
                ctermbg = t.normal.black
            }
        },
        -- Insert
        LuaLineInsertA = {
            cterm = {
                ctermfg = t.bright.green,
                cterm = { reverse = true, bold = true }
            }
        },
        LuaLineInsertB = copy_merge(
            'LuaLineInsertA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineInsertC = copy_merge('LuaLineNormalC'),
        LuaLineInsertAB = copy_merge(
            'LuaLineInsertA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineInsertBC = copy_merge('LuaLineNormalBC'),
        -- Visual
        LuaLineVisualA = {
            cterm = {
                ctermfg = t.bright.blue,
                cterm = { reverse = true, bold = true }
            }
        },
        LuaLineVisualB = copy_merge(
            'LuaLineVisualA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineVisualC = copy_merge('LuaLineNormalC'),
        LuaLineVisualAB = copy_merge(
            'LuaLineVisualA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineVisualBC = copy_merge('LuaLineNormalBC'),
        -- Replace
        LuaLineReplaceA = {
            cterm = {
                ctermfg = t.bright.red,
                cterm = { reverse = true, bold = true }
            }
        },
        LuaLineReplaceB = copy_merge(
            'LuaLineReplaceA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineReplaceC = copy_merge('LuaLineNormalC'),
        LuaLineReplaceAB = copy_merge(
            'LuaLineReplaceA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineReplaceBC = copy_merge('LuaLineNormalBC'),
        -- Command
        LuaLineCommandA = {
            cterm = {
                ctermfg = t.bright.magenta,
                cterm = { reverse = true, bold = true }
            }
        },
        LuaLineCommandB = copy_merge(
            'LuaLineCommandA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineCommandC = copy_merge('LuaLineNormalC'),
        LuaLineCommandAB = copy_merge(
            'LuaLineCommandA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineCommandBC = copy_merge('LuaLineNormalBC'),
        -- Inactive
        LuaLineInactiveA = {
            cterm = {
                ctermfg = t.normal.white,
                cterm = { reverse = true, bold = true }
            }
        },
        LuaLineInactiveB = copy_merge(
            'LuaLineInactiveA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineInactiveC = copy_merge('LuaLineNormalC'),
        LuaLineInactiveAB = copy_merge(
            'LuaLineInactiveA',
            {
                cterm = {
                    ctermbg = t.bright.black,
                    cterm = { reverse = false }
                }
            }
        ),
        LuaLineInactiveBC = copy_merge('LuaLineNormalBC'),
        -- TODO Better GIT and Diagnostics highlight
        --#endregion

        --#region Notify
        -- Error
        NotifyERRORBorder = {
            cterm = {
                ctermfg = t.normal.red
            }
        },
        NotifyERRORIcon = {
            cterm = {
                ctermfg = t.bright.red
            }
        },
        NotifyERRORTitle = { link = 'NotifyERRORIcon' },
        NotifyERRORBody = { link = 'Normal' },
        -- Warning
        NotifyWARNBorder = {
            cterm = {
                ctermfg = t.normal.yellow
            }
        },
        NotifyWARNIcon = {
            cterm = {
                ctermfg = t.bright.yellow
            }
        },
        NotifyWARNTitle = { link = 'NotifyWARNIcon' },
        NotifyWARNBody = { link = 'Normal' },
        -- Info
        NotifyINFOBorder = {
            cterm = {
                ctermfg = t.normal.blue
            }
        },
        NotifyINFOIcon = {
            cterm = {
                ctermfg = t.bright.blue
            }
        },
        NotifyINFOTitle = { link = 'NotifyINFOIcon' },
        NotifyINFOBody = { link = 'Normal' },
        -- Debug
        NotifyDEBUGBorder = {
            cterm = {
                ctermfg = t.bright.black
            }
        },
        NotifyDEBUGIcon = {
            cterm = {
                ctermfg = t.normal.white
            }
        },
        NotifyDEBUGTitle = { link = 'NotifyDEBUGIcon' },
        NotifyDEBUGBody = { link = 'Normal' },
        -- Trace
        NotifyTRACEBorder = {
            cterm = {
                ctermfg = t.normal.magenta
            }
        },
        NotifyTRACEIcon = {
            cterm = {
                ctermfg = t.bright.magenta
            }
        },
        NotifyTRACETitle = { link = 'NotifyTRACEIcon' },
        NotifyTRACEBody = { link = 'Normal' },
        --#endregion

        --#region NvimTree
        -- Git
        NvimTreeGitNew = { link = 'GitSignsAdd' },
        NvimTreeGitRenamed = { link = 'GitSignsAdd' },
        NvimTreeGitDirty = { link = 'GitSignsChange' },
        NvimTreeGitDeleted = { link = 'GitSignsDelete' },
        NvimTreeGitMerge = {
            cterm = {
                ctermfg = t.normal.magenta
            }
        },
        NvimTreeGitIgnored = {
            cterm = {
                ctermfg = t.bright.black
            }
        },
        NvimTreeGitStaged = {
            cterm = {
                ctermfg = t.normal.yellow
            }
        },
        NvimTreeModifiedFile = { link = 'NvimTreeGitDirty' },
        -- Folders
        Directory = { link = 'Normal' },
        NvimTreeIndentMarker = { link = 'IndentBlanklineChar' },
        NvimTreeFolderIcon = { link = 'IndentBlanklineContextChar' },
        NvimTreeRootFolder = { link = 'Title' },
        -- Types
        NvimTreeNormal = { link = 'PMenu' },
        NvimTreeSymlink = {
            cterm = {
                cterm = { italic = true }
            }
        },
        NvimTreeOpenedFile = {
            cterm = {
                cterm = { bold = true }
            }
        },
        NvimTreeExecFile = { link = 'NvimTreeNormal' },
        NvimTreeImageFile = { link = 'NvimTreeNormal' },
        NvimTreeSpecialFile = { link = 'NvimTreeNormal' },
        -- Other
        NvimTreeBookmark = {
            cterm = {
                ctermfg = t.bright.yellow
            }
        },
        NvimTreeWindowPicker = copy_merge(
            'Title',
            { cterm = { cterm = { reverse = true }}}
        ),
        NvimTreeLiveFilterValue = { link = 'NvimTreeNormal' },
        NvimTreeLiveFilterPrefix = { link = 'NvimTreeRootFolder' },
        --#endregion
    }

    return resolver.get()
end
