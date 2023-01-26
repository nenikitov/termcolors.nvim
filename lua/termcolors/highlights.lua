local c = require('termcolors.colors')
local t = c.term
local g = c.gui


local highlights = {}

local function resolve_highlight(highlight)
    if type(highlights[highlight]) == 'function' then
        highlights[highlight] = highlights[highlight]()
    end
    return highlights[highlight]
end

local function resolve_highlights()
    for name, _ in pairs(highlights) do
        highlights[name] = resolve_highlight(name)
    end
end

local function merge_highlights(...)
    local args = { ... }

    return function()
        local result = {}
        for _, v in ipairs(args) do
            local current = v
            if type(v) == 'string' then
                -- Value is the name of the highlight, copy values
                current = resolve_highlight(v)
            end
            result = vim.tbl_deep_extend('force', result, current)
        end
        return result
    end
end

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
        ctermbg = 'NONE',
        cterm = { bold = true, italic = true },
    },
    -- Generic diagnostic
    BufferLineDiagnostic = { link = 'BufferLineBuffer' },
    BufferLineDiagnosticVisible = { link = 'BufferLineBufferVisible' },
    BufferLineDiagnosticSelected = { link = 'BufferLineBufferSelected' },
    -- Error
    BufferLineError = merge_highlights('BufferLineBuffer', 'DiagnosticError'),
    BufferLineErrorVisible = merge_highlights('BufferLineError', 'BufferLineBufferVisible'),
    BufferLineErrorSelected = merge_highlights('BufferLineError', 'BufferLineBufferSelected'),
    BufferLineErrorDiagnostic = { link = 'BufferLineError' },
    BufferLineErrorDiagnosticVisible = { link = 'BufferLineErrorVisible' },
    BufferLineErrorDiagnosticSelected = { link = 'BufferLineErrorSelected' },
    -- Warning
    BufferLineWarning = merge_highlights('BufferLineBuffer', 'DiagnosticWarn'),
    BufferLineWarningVisible = merge_highlights('BufferLineBufferVisible', 'BufferLineWarning'),
    BufferLineWarningSelected = merge_highlights('BufferLineWarning', 'BufferLineBufferSelected'),
    BufferLineWarningDiagnostic = { link = 'BufferLineWarning' },
    BufferLineWarningDiagnosticVisible = { link = 'BufferLineWarningVisible' },
    BufferLineWarningDiagnosticSelected = { link = 'BufferLineWarningSelected' },
    -- Info
    BufferLineInfo = merge_highlights('BufferLineBuffer', 'DiagnosticInfo'),
    BufferLineInfoVisible = merge_highlights('BufferLineBufferVisible', 'BufferLineInfo'),
    BufferLineInfoSelected = merge_highlights('BufferLineBufferSelected', 'BufferLineInfo'),
    BufferLineInfoDiagnostic = { link = 'BufferLineInfo' },
    BufferLineInfoDiagnosticVisible = { link = 'BufferLineInfoVisible' },
    BufferLineInfoDiagnosticSelected = { link = 'BufferLineInfoSelected' },
    -- Hint
    BufferLineHint = merge_highlights('BufferLineBuffer', 'DiagnosticHint'),
    BufferLineHintVisible = merge_highlights('BufferLineBufferVisible', 'BufferLineHint'),
    BufferLineHintSelected = merge_highlights('BufferLineBufferSelected', 'BufferLineHint'),
    BufferLineHintDiagnostic = { link = 'BufferLineHint' },
    BufferLineHintDiagnosticVisible = { link = 'BufferLineHintVisible' },
    BufferLineHintDiagnosticSelected = { link = 'BufferLineHintSelected' },
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

resolve_highlights()

return highlights

