local c = require('termcolors.colors')
local t = c.term
local g = c.gui



return {
    --#region Cursor
    Cursor = {
        ctermbg = t.normal.black,
        bg = g.normal.black
    },
    CursorLine = {
        ctermbg = t.normal.black,
        bg = g.normal.black
    },
    CursorColumn = {
        ctermbg = t.normal.black,
        bg = g.normal.black
    },
    --#endregion

    --#region Default highlight groups
    Normal = {
        fg = g.primary.foreground, bg = g.primary.background
    },
    NonText = {
        ctermfg = t.normal.white
    },
    Comment = {
        ctermfg = t.normal.green,
        cterm = { italic = true }
    },
    Constant = {
        ctermfg = t.normal.blue,
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
        ctermfg = t.normal.blue,
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
    Boolean = {
        ctermfg = t.normal.blue
    },
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
    SpecialComment = { link = 'Comment', cterm = { bold = true } },
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
    GitSignsAdd = {
        ctermfg = t.normal.green
    },
    GitSignsChange = {
        ctermfg = t.normal.blue
    },
    GitSignsDelete = {
        ctermfg = t.normal.red
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
        ctermfg = t.normal.white,
        cterm = { undercurl = true }
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


    --#region Other
    Underlined = {
        cterm = { underline = true }
    },
    --#endregion
}

