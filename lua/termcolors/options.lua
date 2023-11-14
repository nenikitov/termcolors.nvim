---@alias OptsColor 'black' | 'red' | 'green' | 'yellow' | 'blue' | 'magenta' | 'cyan' | 'white'
---@alias OptsColorPartial OptsColor | nil

---@class OptsUi
---@field accent OptsColor
---@field normal OptsColor
---@field visual OptsColor
---@field insert OptsColor @field replace OptsColor
---@field command OptsColor
---@field search OptsColor
---@class OptsUiPartial
---@field accent OptsColorPartial
---@field normal OptsColorPartial
---@field visual OptsColorPartial
---@field insert OptsColorPartial
---@field replace OptsColorPartial
---@field command OptsColorPartial
---@field search OptsColorPartial

---@class OptsSyntax
---@field comment OptsColor
---@field constant OptsColor
---@field identifier OptsColor
---@field function_ OptsColor
---@field keyword OptsColor
---@field operator OptsColor
---@field type OptsColor
---@field delimiter OptsColor
---@class OptsSyntaxPartial
---@field comment OptsColorPartial
---@field constant OptsColorPartial
---@field identifier OptsColorPartial
---@field function_ OptsColorPartial
---@field keyword OptsColorPartial
---@field operator OptsColorPartial
---@field type OptsColorPartial
---@field delimiter OptsColorPartial

---@class OptsDiagnostic
---@field error OptsColor
---@field warn OptsColor
---@field info OptsColor
---@field hint OptsColor
---@field ok OptsColor
---@class OptsDiagnosticPartial
---@field error OptsColorPartial
---@field warn OptsColorPartial
---@field info OptsColorPartial
---@field hint OptsColorPartial
---@field ok OptsColorPartial

---@class OptsPalette
---@field ui OptsUi
---@field syntax OptsSyntax
---@field diagnostic OptsDiagnostic
---@class OptsPalettePartial
---@field ui OptsUiPartial
---@field syntax OptsSyntaxPartial
---@field diagnostic OptsDiagnosticPartial

---@alias OptsUseAlternate
--- | false Do not highlight.
--- | 'regular' Highlight.
--- | 'swap' Highlight and swap dark and bright.

---@class Options
---@field palette OptsPalette
---@field use_alternate OptsUseAlternate
---@field popup_background boolean
---@field darken_inactive boolean
---@class OptionsPartial
---@field palette OptsPalettePartial
---@field use_alternate OptsUseAlternate | nil
--- Whether to highlight alternate versions of a token using different brightnesses.
--- For example, with this option, `if` and `function` keywords will be highlight in differently.
---@field popup_background boolean | nil
--- Whether to add background to popups.
---@field darken_inactive boolean | nil
--- Whether to darken inactive buffers.

---@class Options
local options = {
    palette = {
        ui = {
            ---@type OptsColor
            accent = 'magenta',
            ---@type OptsColor
            normal = 'magenta',
            ---@type OptsColor
            visual = 'blue',
            ---@type OptsColor
            insert = 'cyan',
            ---@type OptsColor
            replace = 'red',
            ---@type OptsColor
            command = 'green',
            ---@type OptsColor
            search = 'yellow',
        },
        syntax = {
            ---@type OptsColor
            comment = 'black',
            ---@type OptsColor
            constant = 'green',
            ---@type OptsColor
            identifier = 'red',
            ---@type OptsColor
            function_ = 'cyan',
            ---@type OptsColor
            keyword = 'magenta',
            ---@type OptsColor
            operator = 'white',
            ---@type OptsColor
            type = 'yellow',
            ---@type OptsColor
            delimiter = 'black',
        },
        diagnostic = {
            ---@type OptsColor
            error = 'red',
            ---@type OptsColor
            warn = 'yellow',
            ---@type OptsColor
            info = 'blue',
            ---@type OptsColor
            hint = 'magenta',
            ---@type OptsColor
            ok = 'green',
        },
    },
    use_alternate = 'regular',
    popup_background = true,
    darken_inactive = true,
}

return options
