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
    --#endregion

    ColorColumn = {
        ctermbg = t.normal.black,
        bg = g.normal.black
    },
}

