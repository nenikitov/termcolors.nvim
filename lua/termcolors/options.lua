---@alias OptsPalleteToken
--- | 'ui.accent'
--- | 'ui.split'
--- | 'ui.normal'
--- | 'ui.visual'
--- | 'ui.insert'
--- | 'ui.replace'
--- | 'ui.command'
--- | 'ui.search'
--- | 'syntax.comment'
--- | 'syntax.constant'
--- | 'syntax.identifier'
--- | 'syntax.function'
--- | 'syntax.keyword'
--- | 'syntax.operator'
--- | 'syntax.type'
--- | 'syntax.delimiter'
--- | 'diagnostic.error'
--- | 'diagnostic.warn'
--- | 'diagnostic.info'
--- | 'diagnostic.hint'
--- | 'diagnostic.ok'

---@alias OptsColor 'black' | 'red' | 'green' | 'yellow' | 'blue' | 'magenta' | 'cyan' | 'white'
---@alias OptsColorPartial OptsColor | nil

---@class OptsUi
---@field accent OptsColor
---@field split OptsColor
---@field normal OptsColor
---@field visual OptsColor
---@field insert OptsColor
---@field replace OptsColor
---@field command OptsColor
---@field search OptsColor
---@class OptsUiPartial
---@field accent OptsColorPartial
---@field split OptsColorPartial
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

---@class Options
---@field palette OptsPalette
---@field use_alternate boolean
---@field swap_alternate boolean
---@field popup_background boolean
---@field panel_background boolean | nil
---@field darken_inactive boolean
---@class OptionsPartial
---@field palette OptsPalettePartial
---@field use_alternate boolean | nil
---@field swap_alternate boolean | nil
--- Whether to highlight alternate versions of a token using different brightnesses.
--- For example, with this option, `if` and `function` keywords will be highlight in differently.
---@field panel_background boolean | nil
--- Whether to add background to panels.
---@field popup_background boolean | nil
--- Whether to add background to popups.
---@field darken_inactive boolean | nil
--- Whether to darken inactive buffers.

---@class Options
local options = {
    palette = {
        ui = {
            accent = 'magenta',
            split = 'black',
            normal = 'magenta',
            visual = 'blue',
            insert = 'cyan',
            replace = 'red',
            command = 'green',
            search = 'yellow',
        },
        syntax = {
            comment = 'black',
            constant = 'green',
            identifier = 'red',
            function_ = 'cyan',
            keyword = 'magenta',
            operator = 'white',
            type = 'yellow',
            delimiter = 'black',
        },
        diagnostic = {
            error = 'red',
            warn = 'yellow',
            info = 'blue',
            hint = 'magenta',
            ok = 'green',
        },
    },
    use_alternate = true,
    swap_alternate = false,
    popup_background = false,
    panel_background = false,
    darken_inactive = true,
}

return options
