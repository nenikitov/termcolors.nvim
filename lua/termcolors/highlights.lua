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
        ctermfg = t.primary.foreground, ctermbg = t.primary.background,
        fg = g.primary.foreground, bg = g.primary.background
    },
    Comment = {
        ctermfg = t.normal.green,
        cterm = { italic = true }
    },
    Constant = {
        ctermfg = t.normal.blue,
    },
    Identifier = {
        ctermfg = t.bright.cyan
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
    Delimiter = { link = 'Special' },
    SpecialComment = { link = 'Comment', cterm = { bold = true } },
    Debug = { link = 'Special' },
    --#endregion





    ColorColumn = {
        ctermbg = t.normal.black,
    },
    Underlined = {
        cterm = { underline = true }
    },
}

