local c = require('termcolors.colors.color_table')
local t = c.term


--#region Types

---@class CTerm
---@field bold boolean Bold.
---@field underline boolean Underline.
---@field undercurl boolean Curly underline.
---@field underdouble boolean Double underline.
---@field underdotted boolean Dotted underline.
---@field underdashed boolean Dashed underline.
---@field strikethrough boolean Strike through.
---@field reverse boolean Reverse background and foreground colors.
---@field italic boolean Italicize.

---@alias CTermColor number | nil | 'NONE' | 'Black' | 'DarkRed' | 'DarkGreen' | 'DarkYellow' | 'DarkBlue' | 'DarkMagenta' | 'DarkCyan' | 'Gray' | 'DarkGray' | 'Red' | 'Green' | 'Yellow' | 'Blue' | 'Magenta' | 'Cyan' | 'White'

---@class HighlightTable
---@field ctermfg CTermColor Terminal text color.
---@field ctermbg CTermColor Terminal background color.
---@field cterm CTerm Terminal font modifiers.
---@field fg string GUI text color ('#RRGGBB' or color name).
---@field bg string GUI background color ('#RRGGBB' or color name).
---@field sp string GUI special color ('#RRGGBB' or color name).
---@field bold boolean Bold.
---@field underline boolean Underline.
---@field undercurl boolean Curly underline.
---@field underdouble boolean Double underline.
---@field underdotted boolean Dotted underline.
---@field underdashed boolean Dashed underline.
---@field strikethrough boolean Strike through.
---@field reverse boolean Reverse background and foreground colors.
---@field italic boolean Italicize.

---@class HighlightLink
---@field link string Name of another highlight group to link to.

---@alias HighlightFunction fun(): Highlight

---@alias Highlight HighlightTable | HighlightLink | HighlightFunction

--#endregion


--#region Helpers

--- Container for all highlights.
---@type {[string]: Highlight}
local highlights = {}

--- Resolve merged highlights.
---@param name string Name of the highlight group.
---@return Highlight Resolved highlight group.
local function resolve_highlight(name)
    if type(highlights[name]) == 'function' then
        highlights[name] = highlights[name]()
    end
    return highlights[name]
end

--- Resolve all existing merged highlights.
---@return HighlightTable[] Resolved highlight groups.
local function resolve_highlights()
    for name, _ in pairs(highlights) do
        highlights[name] = resolve_highlight(name)
    end
    return highlights
end

--- Combine highlights in order of importance.
---@param ... string | HighlightTable Name of a highlight group or highlight parameters.
---@return HighlightFunction Function to call to generate a highlight group.
local function merge_highlights(...)
    local args = { ... }

    return function()
        local result = {}
        for _, v in ipairs(args) do
            local current
            if type(v) == 'string' then
                -- Value is the name of the highlight, copy values
                current = resolve_highlight(v)
            elseif type(v) == 'table' then
                current = v
            end
            result = vim.tbl_deep_extend('force', result, current)
        end
        return result
    end
end

--- Add new highlights to the list.
---@param new_highlights {[string]: Highlight} New highlights.
local function set_highlights(new_highlights)
    for k, v in pairs(new_highlights) do
        highlights[k] = v
    end
end

--#endregion

set_highlights {
    --#region Cursor
    Cursor = {
        ctermbg = t.normal.black,
    },
    CursorLine = { link = 'Cursor' },
    CursorColumn = { link = 'Cursor' },
    --#endregion

    Normal = {
        ctermfg = t.primary.foreground, ctermbg = t.primary.background,
    },
    PMenu = { link = 'Normal' },
    Comment = {
        ctermfg = t.bright.black
    },

    -- Indent blankline
    IndentBlanklineChar = {
        ctermfg = t.bright.black
    },
    IndentBlanklineSpaceChar = { link = 'IndentBlanklineChar' },
    IndentBlanklineSpaceCharBlankline = { link = 'IndentBlanklineSpaceChar' },
    IndentBlanklineContextChar = {
        ctermfg = t.normal.yellow
    },
    IndentBlanklineContextSpaceChar = { link = 'IndentBlanklineContextChar' },
    IndentBlanklineContextSpaceCharBlankline = { link = 'IndentBlanklineContextSpaceChar' },
    IndentBlanklineContextStart = {
        cterm = { underline = true },
    },

    -- Highlighting
    Keyword = {
        ctermfg = t.bright.cyan
    },
    Include = {
        ctermfg = t.normal.magenta
    },
    Identifier = {
        ctermfg = t.normal.magenta
    },
    ['@namespace'] = {
        ctermfg = t.normal.magenta
    },
    Type = {
        ctermfg = t.normal.magenta
    },
    PreProc = {
        ctermfg = t.normal.blue
    },
    ['@decorator'] = { link = 'PreProc' },
    Constant = {
        ctermfg = t.normal.red
    },
    ['@field'] = {
        ctermfg = t.normal.yellow
    },
    ['@property'] = {
        ctermfg = t.normal.yellow
    },
    StorageClass = {
        ctermfg = t.bright.yellow
    },
    Operator = { link = 'Normal' },
    Delimiter = { link = 'Normal' },
    Function = {
        ctermfg = t.bright.blue
    },
    ['@parameter'] = {
        ctermfg = t.bright.magenta
    },
    ['@type.qualifier'] = { link = 'Keyword' },
    ['@variable'] = {
        ctermfg = t.bright.red
    },
    ['@selfTypeKeyword'] = {
        ctermfg = t.normal.cyan
    },
    String = {
        ctermfg = t.bright.green
    },
    SpecialChar = {
        ctermfg = t.normal.red
    },
    Character = {
        ctermfg = t.normal.green
    },
    Special = {
        ctermfg = t.normal.red
    },
    ['@constant.builtin'] = { link = 'Constant' },
    Number = {
        ctermfg = t.normal.yellow
    },
    Boolean = {
        ctermfg = t.bright.magenta
    },
    Statement = { link = 'Keyword' },
    ['@function.builtin'] = { link = 'Function' },
    ['@constructor'] = { link = 'Type' },
    ['@keyword.return'] = {
        ctermfg = t.bright.yellow
    },
    Conditional = {
        ctermfg = t.bright.yellow
    },
    ['@controlFlow'] = { link = 'Conditional' },
    Repeat = { link = 'Conditional' },

    Title = {
        ctermfg = t.bright.yellow
    },
    ['@tag'] = {
        ctermfg = t.bright.magenta
    },
    ['@tag.delimiter'] = {
        ctermfg = t.normal.magenta
    },
    ['@tag.attribute'] = {
        ctermfg = t.normal.yellow
    },


    --[[
    Label = {
        ctermfg = t.bright.cyan
    },
    String = {
        ctermfg = t.normal.yellow
    },
    Delimiter = { link = 'Normal' },
    Comment = {
        ctermfg = t.normal.green,
        cterm = { italic = true },
    },
    Constant = {
        ctermfg = t.bright.blue,
    },
    Boolean = { link = 'Constant' },
    Number = {
        ctermfg = t.bright.green
    },
    Keyword = {
        ctermfg = t.bright.blue
    },
    Function = {
        ctermfg = t.bright.yellow
    },
    Identifier = {
        ctermfg = t.bright.cyan
    },
    Class = {
        ctermfg = t.bright.green
    },
    ['@constructor'] = { link = 'Class' },
    ['@property'] = {
        ctermfg = t.normal.cyan
    },
    Statement = {
        ctermfg = t.normal.magenta,
    },
    ['@keyword.return'] = { link = 'Statement' },
    ['@keyword.function'] = { link = 'Statement' },
    ['@keyword.operator'] = { link = 'Statement' },
    Repeat = { link = 'Statement' },
    Operator = { link = 'Normal' },
    PreProc = {
        ctermfg = t.normal.magenta
    },
    Conditional = { link = 'Statement' },
    StorageClass = { link = 'Constant' },
    ['@type.builtin'] = { link = 'Constant' },
    ['@type.qualifier'] = { link = 'Constant' },
    ['@namespace'] = { link = 'Type' },
    Type = { link = 'Class' },
    ['@constant.builtin'] = { link = 'Constant' },
    ['@function.builtin'] = { link = '@function' },
    ['@function.macro'] = { link = 'Macro' },
    ['@symbol'] = { link = 'Identifier' },
    ['@decorator'] = { link = 'Class' },
    Macro = { link = 'Constant' },
    Character = {
        ctermfg = t.normal.yellow
    },
    PMenu = merge_highlights('Normal', { ctermfg = 'NONE' }),



    Title = {
        ctermfg = t.bright.blue,
        cterm = { bold = true }
    },
    markdownH1Delimiter = { link = '@punctuation.special' },
    markdownH2Delimiter = { link = 'markdownH1Delimiter' },
    markdownH3Delimiter = { link = 'markdownH1Delimiter' },
    markdownH4Delimiter = { link = 'markdownH1Delimiter' },
    markdownH5Delimiter = { link = 'markdownH1Delimiter' },
    markdownH6Delimiter = { link = 'markdownH1Delimiter' },
    markdownCodeBlock = { link = '@text.literal' },
    markdownCodeDelimiter = { link = 'markdownCodeBlock' },
    markdownLinkText = { link = '@text.reference' },
    markdownUrl = { link = '@text.uri' },
    markdownCode = { link = 'markdownCodeBlock' },
    ['@punctuation.special'] = {
        ctermfg = t.normal.cyan
    },
    ['@text.literal'] = { link = 'String' },
    ['@text.reference'] = {
        ctermfg = t.normal.cyan
    },
    ['@text.uri'] = {
        ctermfg = t.bright.cyan,
        cterm = { underline = true }
    },
    ['@text.emphasis'] = {
        cterm = { italic = true }
    },
    ['@text.strong'] = {
        cterm = { bold = true }
    },

    Tag = {
        ctermfg = t.bright.blue
    },
    --]]



    -- TODO Highlight THIS
    --[[
    NonText = {
        ctermfg = t.normal.white
    },
    Error = {
        ctermfg = t.normal.red
    },
    Special = {
        ctermfg = t.normal.magenta
    }, ]]
    --#endregion

    --#region Other highlight groups
    --[[
    Label = { link = 'Statement' },
    Operator = { link = 'Normal' },
    Exception = { link = 'Statement' },
    Include = { link = 'PreProc' },
    Define = { link = 'PreProc' },
    Macro = { link = 'PreProc' },
    PreCondit = { link = 'PreProc' },
    Structure = { link = 'Type' },
    Typedef = { link = 'Type' },
    Tag = { link = 'Special' },
    SpecialChar = {
        ctermfg = t.bright.yellow,
        cterm = { bold = true }
    },
    Delimiter = { link = 'Normal' },
    SpecialComment = { link = 'Comment' },
    Debug = { link = 'Special' }, ]]
    --#endregion


    --#region Treesitter highlight
    --[[ ['@field'] = {
        ctermfg = t.bright.cyan
    }, ]]
    --#endregion


    --#region Columns
    LineNr = {
        ctermfg = t.bright.black
    },
    CursorLineNr = merge_highlights(
        'CursorLine',
        { ctermfg = t.normal.white }
    ),
    SignColumn = { link = 'Normal' },
    --#endregion

    --#region Scorllbar
    ScrollbarHandle = {
        ctermbg = t.normal.black
    },
    -- Cursor
    ScrollbarCursor = {
        ctermfg = t.normal.white
    },
    ScrollbarCursorHandle = merge_highlights('ScrollbarHandle', 'ScrollbarCursor'),
    -- Search
    ScrollbarSearch = {
        ctermfg = t.normal.cyan
    },
    ScrollbarSearchHandle = merge_highlights('ScrollbarHandle', 'ScrollbarSearch'),
    -- Error
    ScrollbarError = merge_highlights('DiagnosticError'),
    ScrollbarErrorHandle = merge_highlights('ScrollbarHandle', 'ScrollbarError'),
    -- Warn
    ScrollbarWarn = merge_highlights('DiagnosticWarn'),
    ScrollbarWarnHandle = merge_highlights('ScrollbarHandle', 'ScrollbarWarn'),
    -- Info
    ScrollbarInfo = merge_highlights('DiagnosticInfo'),
    ScrollbarInfoHandle = merge_highlights('ScrollbarHandle', 'ScrollbarInfo'),
    -- Hint
    ScrollbarHint = merge_highlights('DiagnosticHint'),
    ScrollbarHintHandle = merge_highlights('ScrollbarHandle', 'ScrollbarHint'),
    -- Misc
    ScrollbarMisc = {
        ctermfg = t.normal.magenta
    },
    ScrollbarMiscHandle = merge_highlights('ScrollbarHandle', 'ScrollbarMisc'),
    -- Git Add
    ScrollbarGitAdd = merge_highlights('GitSignsAdd'),
    ScrollbarGitAddHandle = merge_highlights('ScrollbarHandle', 'ScrollbarGitAdd'),
    -- Git Change
    ScrollbarGitChange = merge_highlights('GitSignsChange'),
    ScrollbarGitChangeHandle = merge_highlights('ScrollbarHandle', 'ScrollbarGitChange'),
    -- Git Delete
    ScrollbarGitDelete = merge_highlights('GitSignsDelete'),
    ScrollbarGitDeleteHandle = merge_highlights('ScrollbarHandle', 'ScrollbarGitDelete'),
    --#endregion

    --#region GitSigns
    -- Signs
    GitSignsAdd = {
        ctermfg = t.bright.green
    },
    GitSignsChange = {
        ctermfg = t.bright.blue
    },
    GitSignsDelete = {
        ctermfg = t.bright.red
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
        ctermbg = t.normal.green
    },
    GitSignsChangePreview = {
        ctermbg = t.normal.blue
    },
    GitSignsDeletePreview = {
        ctermbg = t.normal.red
    },
    --#endregion

    --#region Diagnostics
    DiagnosticError = {
        ctermfg = t.bright.red
    },
    DiagnosticWarn = {
        ctermfg = t.bright.yellow
    },
    DiagnosticInfo = {
        ctermfg = t.bright.blue
    },
    DiagnosticHint = {
        ctermfg = t.normal.white
    },
    DiagnosticUnderlineError = {
        cterm = { undercurl = true },
        sp = '#ff0000'
    },
    DiagnosticUnderlineWarn = {
        cterm = { undercurl = true },
        sp = '#ffff00'
    },
    DiagnosticUnderlineInfo = {
        cterm = { undercurl = true },
        sp = '#0000ff'
    },
    DiagnosticUnderlineHint = {
        cterm = { undercurl = true },
        sp = '#808080'
    },
    --#endregion

    -- #region Bufferline
    BufferLineFill = {
        ctermbg = t.normal.black
    },
    -- Modified circle
    BufferLineModified = {
        ctermfg = t.normal.yellow
    },
    BufferLineModifiedVisible = { link = 'BufferLineModified' },
    BufferLineModifiedSelected = { link = 'BufferLineModified' },
    -- Close button
    BufferLineCloseButton = { link = 'BufferLineBuffer' },
    BufferLineCloseButtonVisible = { link = 'BufferLineBufferVisible' },
    BufferLineCloseButtonSelected = { link = 'BufferLineBufferSelected' },
    -- Dev Icons
    BufferLineDevIconDefaultInactive = { link = 'BufferLineBuffer' },
    BufferLineDevIconDefaultSelected = { link = 'BufferLineBufferSelected' },
    -- Picker
    BufferLinePickTemplate = {
        ctermfg = t.normal.blue,
        cterm = { bold = true, italic = true }
    },
    BufferLinePick = merge_highlights('BufferLineBuffer', 'BufferLinePickTemplate'),
    BufferLinePickVisible = merge_highlights('BufferLineBufferVisible', 'BufferLinePickTemplate'),
    BufferLinePickSelected = merge_highlights('BufferLineBufferSelected', 'BufferLinePickTemplate'),
    -- Numbers
    BufferLineNumbersTemplate = {
        ctermfg = t.normal.magenta,
        cterm = { bold = true, italic = true }
    },
    BufferLineNumbers = merge_highlights('BufferLineBuffer', 'BufferLineNumbersTemplate'),
    BufferLineNumbersVisible = merge_highlights('BufferLineBufferVisible', 'BufferLineNumbersTemplate'),
    BufferLineNumbersSelected = merge_highlights('BufferLineBufferSelected', 'BufferLineNumbersTemplate'),
    -- Normal
    BufferLineBuffer = {
        ctermbg = t.normal.black
    },
    BufferLineBufferVisible = {
        ctermbg = 'NONE'
    },
    BufferLineBufferSelected = {
        ctermfg = t.bright.white, ctermbg = 'NONE',
        cterm = { bold = true, italic = true },
    },
    BufferLineBackground = { link = 'BufferLineBuffer' },
    -- Generic diagnostic
    BufferLineDiagnostic = { link = 'BufferLineBuffer' },
    BufferLineDiagnosticVisible = { link = 'BufferLineBufferVisible' },
    BufferLineDiagnosticSelected = { link = 'BufferLineBufferSelected' },
    -- Error
    BufferLineError = merge_highlights('BufferLineBuffer', 'DiagnosticUnderlineError'),
    BufferLineErrorVisible = merge_highlights('BufferLineError', 'BufferLineBufferVisible'),
    BufferLineErrorSelected = merge_highlights('BufferLineError', 'BufferLineBufferSelected'),
    BufferLineErrorDiagnostic = merge_highlights('BufferLineBuffer', 'DiagnosticError'),
    BufferLineErrorDiagnosticVisible = merge_highlights('BufferLineErrorDiagnostic', 'BufferLineBufferVisible'),
    BufferLineErrorDiagnosticSelected = merge_highlights('BufferLineErrorDiagnostic', 'BufferLineBufferVisible'),
    -- Warning
    BufferLineWarning = merge_highlights('BufferLineBuffer', 'DiagnosticUnderlineWarn'),
    BufferLineWarningVisible = merge_highlights('BufferLineWarning', 'BufferLineBufferVisible'),
    BufferLineWarningSelected = merge_highlights('BufferLineWarning', 'BufferLineBufferSelected'),
    BufferLineWarningDiagnostic = merge_highlights('BufferLineBuffer', 'DiagnosticWarn'),
    BufferLineWarningDiagnosticVisible = merge_highlights('BufferLineWarningDiagnostic', 'BufferLineBufferVisible'),
    BufferLineWarningDiagnosticSelected = merge_highlights('BufferLineWarningDiagnostic', 'BufferLineBufferVisible'),
    -- Info
    BufferLineInfo = merge_highlights('BufferLineBuffer', 'DiagnosticUnderlineInfo'),
    BufferLineInfoVisible = merge_highlights('BufferLineInfo', 'BufferLineBufferVisible'),
    BufferLineInfoSelected = merge_highlights('BufferLineInfo', 'BufferLineBufferSelected'),
    BufferLineInfoDiagnostic = merge_highlights('BufferLineBuffer', 'DiagnosticInfo'),
    BufferLineInfoDiagnosticVisible = merge_highlights('BufferLineInfoDiagnostic', 'BufferLineBufferVisible'),
    BufferLineInfoDiagnosticSelected = merge_highlights('BufferLineInfoDiagnostic', 'BufferLineBufferVisible'),
    -- Hint
    BufferLineHint = merge_highlights('BufferLineBuffer', 'DiagnosticUnderlineHint'),
    BufferLineHintVisible = merge_highlights('BufferLineHint', 'BufferLineBufferVisible'),
    BufferLineHintSelected = merge_highlights('BufferLineHint', 'BufferLineBufferSelected'),
    BufferLineHintDiagnostic = merge_highlights('BufferLineBuffer', 'DiagnosticHint'),
    BufferLineHintDiagnosticVisible = merge_highlights('BufferLineHintDiagnostic', 'BufferLineBufferVisible'),
    BufferLineHintDiagnosticSelected = merge_highlights('BufferLineHintDiagnostic', 'BufferLineBufferVisible'),
    --#endregion

    --#region Other
    Underlined = {
        cterm = { underline = true }
    },
    Visual = {
        ctermbg = t.normal.black
    },
    --#endregion
}

--- Generate highlights based on the options
---@param options Options
---@return HighlightTable[]
return function(options)
    return resolve_highlights()
end

