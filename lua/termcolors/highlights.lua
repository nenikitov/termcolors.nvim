local c = require('termcolors.colors')
local u = require('termcolors.utils')
local t = c.term
local g = c.gui


local function get_highlight(name)
    -- Get styles
    local hl = {}
    local term = vim.api.nvim_get_hl_by_name(name, false)
    local gui = vim.api.nvim_get_hl_by_name(name, true)

    -- Copy GUI styles
    if gui.foreground ~= nil then
        hl.fg, gui.foreground = u.int_to_hex(gui.foreground), nil
    end
    if gui.background ~= nil then
        hl.bg, gui.background = u.int_to_hex(gui.background), nil
    end
    if gui.special ~= nil then
        hl.sp, gui.special = u.int_to_hex(gui.special), nil
    end
    for k, v in pairs(gui) do
        hl[k] = v
    end

    -- Copy Term styles
    hl.ctermfg, term.foreground = term.foreground, nil
    hl.ctermbg, term.background = term.background, nil
    hl.cterm = {}
    for k, v in pairs(term) do
        hl.cterm[k] = v
    end

    -- Remove unneeded marker of an empty dictionary
    -- https://github.com/neovim/neovim/issues/20504#issuecomment-1269765400
    hl[true] = nil

    return hl
end

local function merge_highlights(...)
    local args = { ... }

    return function()
        local result = {}
        for _, v in ipairs(args) do
            -- Copy all values from a highlight if the name is passed
            local current = type(v) == 'string' and get_highlight(v) or v
            result = vim.tbl_deep_extend('force', result, current)
        end
        return result
    end
end


return {
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
    },
    BufferLineBufferSelected = {
        cterm = { bold = true, italic = true },
    },
    -- Error
    BufferLineError = { link = 'DiagnosticError' },
    BufferLineErrorVisible = merge_highlights('BufferLineBufferVisible', 'BufferLineError'),
    BufferLineErrorSelected = merge_highlights('BufferLineBufferSelected', 'BufferLineError'),
    BufferLineErrorDiagnostic = { link = 'BufferLineError' },
    BufferLineErrorDiagnosticVisible = { link = 'BufferLineErrorVisible' },
    BufferLineErrorDiagnosticSelected = { link = 'BufferLineErrorSelected' },
    -- Warning
    BufferLineWarning = { link = 'DiagnosticWarn' },
    BufferLineWarningVisible = merge_highlights('BufferLineBufferVisible', 'BufferLineWarning'),
    BufferLineWarningSelected = merge_highlights('BufferLineBufferSelected', 'BufferLineWarning'),
    BufferLineWarningDiagnostic = { link = 'BufferLineWarning' },
    BufferLineWarningDiagnosticVisible = { link = 'BufferLineWarningVisible' },
    BufferLineWarningDiagnosticSelected = { link = 'BufferLineWarningSelected' },
    -- Info
    BufferLineInfo = { link = 'DiagnosticInfo' },
    BufferLineInfoVisible = merge_highlights('BufferLineBufferVisible', 'BufferLineInfo'),
    BufferLineInfoSelected = merge_highlights('BufferLineBufferSelected', 'BufferLineInfo'),
    BufferLineInfoDiagnostic = { link = 'BufferLineInfo' },
    BufferLineInfoDiagnosticVisible = { link = 'BufferLineInfoVisible' },
    BufferLineInfoDiagnosticSelected = { link = 'BufferLineInfoSelected' },
    -- Hint
    BufferLineHint = { link = 'DiagnosticHint' },
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

