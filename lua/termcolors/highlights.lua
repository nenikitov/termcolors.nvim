local c = require('termcolors.colors')
local t = c.term
local g = c.gui


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

set_highlights {
    --#region Cursor
    Cursor = {
        ctermbg = t.normal.black,
        bg = g.normal.black
    },
    CursorLine = {
        ctermbg = t.normal.black,
    },
    CursorColumn = {
        ctermbg = t.normal.black,
        bg = g.normal.black
    },
    --#endregion

    --#region Default highlight groups
    Normal = {
        ctermfg = t.primary.foreground, ctermbg = t.primary.background,
        -- fg = g.primary.foreground, bg = g.primary.background
    },
    NonText = {
        ctermfg = t.normal.white
    },
    Error = {
        ctermfg = t.normal.red
    },
    Comment = {
        ctermfg = t.normal.green,
        cterm = { italic = true },
    },
    Constant = {
        ctermfg = t.bright.blue,
    },
    Identifier = {
        ctermfg = t.normal.cyan
    },
    Statement = {
        ctermfg = t.normal.magenta,
    },
    PreProc = {
        ctermfg = t.normal.magenta
    },
    Type = {
        ctermfg = t.bright.blue,
    },
    Special = {
        ctermfg = t.normal.magenta
    },
    --#endregion

    --#region Other highlight groups
    String = {
        ctermfg = t.normal.yellow
    },
    Character = {
        ctermfg = t.normal.yellow
    },
    Number = {
        ctermfg = t.bright.green
    },
    Boolean = { link = 'Constant' },
    Function = {
        ctermfg = t.bright.yellow
    },
    Conditional = { link = 'Statement' },
    Repeat = { link = 'Statement' },
    Label = { link = 'Statement' },
    Operator = { link = 'Normal' },
    Keyword = { link = 'Statement' },
    Exception = { link = 'Statement' },
    Include = { link = 'PreProc' },
    Define = { link = 'PreProc' },
    Macro = { link = 'PreProc' },
    PreCondit = { link = 'PreProc' },
    StorageClass = { link = 'Type' },
    Structure = { link = 'Type' },
    Typedef = { link = 'Type' },
    Tag = { link = 'Special' },
    SpecialChar = {
        ctermfg = t.bright.yellow,
        cterm = { bold = true }
    },
    Delimiter = { link = 'Normal' },
    SpecialComment = { link = 'Comment' },
    Debug = { link = 'Special' },
    --#endregion


    --#region Treesitter highlight
    ['@field'] = {
        ctermfg = t.bright.cyan
    },
    --#endregion


    --#region Columns
    LineNr = {
        ctermfg = t.normal.white
    },
    CursorLineNr = {
        ctermbg = t.normal.black
    },
    SignColumn = {
        ctermfg = t.normal.white
    },
    --#endregion

    --#region GitSigns
    -- Signs
    GitSignsAdd = {
        ctermfg = t.normal.green
    },
    GitSignsChange = {
        ctermfg = t.normal.blue
    },
    GitSignsDelete = {
        ctermfg = t.normal.red
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
        ctermfg = t.normal.red
    },
    DiagnosticWarn = {
        ctermfg = t.normal.yellow
    },
    DiagnosticInfo = {
        ctermfg = t.normal.blue
    },
    DiagnosticHint = {
        ctermfg = t.normal.white
    },
    DiagnosticUnderlineError = {
        cterm = { undercurl = true },
        sp = g.normal.red,
    },
    DiagnosticUnderlineWarn = {
        cterm = { undercurl = true },
        sp = g.normal.yellow,
    },
    DiagnosticUnderlineInfo = {
        cterm = { undercurl = true },
        sp = g.normal.blue,
    },
    DiagnosticUnderlineHint = {
        cterm = { undercurl = true },
        sp = g.normal.white,
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
        ctermbg = t.normal.blue
    }
    --#endregion
}

return resolve_highlights()

