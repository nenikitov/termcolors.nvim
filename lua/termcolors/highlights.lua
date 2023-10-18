local Color = require('highlight_builder').color.Gui
local Term = require('highlight_builder').color.Term
local indexes = Term.indexes

local build = require('highlight_builder').build

local palette = require('highlight_builder').palette.custom({
    primary = {
        bg = '#1A1C22',
        fg = '#B7C2C8',
    },
    dark = {
        black = '#20232A',
        red = '#D9526B',
        green = '#7CB854',
        yellow = '#F7A074',
        blue = '#3D90E3',
        magenta = '#C388EB',
        cyan = '#52AEBA',
        white = '#959A9E',
    },
    bright = {
        black = '#5F6774',
        red = '#F8929D',
        green = '#BCDE79',
        yellow = '#F9C097',
        blue = '#85BDF6',
        magenta = '#DDADF5',
        cyan = '#95E4DD',
        white = '#DDEBF2',
    },
}, true)

---@param c integer | 'NONE'
---@return Color.Gui | nil
local function lookup(c)
    if c == 'NONE' then
        return nil
    end
    return palette.indexed[Term.lookup(c)]
end

---@param options Options
---@return {[string]: HighlightCompiled}
return function(options)
    return build(palette, function(get, set)
        -- Menus
        set('Normal', {
            tty = {
                bg = indexes.primary.bg,
                fg = indexes.primary.fg,
            },
        })
        set('Visual', {
            tty = {
                bg = indexes.normal.white,
                fg = 0,
            },
            gui = {
                bg = palette.primary.bg:blend(lookup(indexes.normal.blue), 0.25),
            },
        })
        set('PMenu', {
            tty = {
                bg = indexes.normal.black,
            },
        })

        -- Lines and columns
        set('CursorLine', {
            tty = {
                bg = indexes.normal.black,
            },
        })
        set('CursorColumn', { link = 'CursorLine' })
        set('SignColumn', {
            tty = {
                fg = indexes.normal.white,
            },
        })
        set('FoldColumn', { link = 'SignColumn' })
        set('LineNr', { link = 'Comment' })
        set('CursorLineNr', {
            tty = {
                bg = get('CursorLine').tty.bg,
            },
        })

        -- Diagnostics
        set('DiagnosticError', {
            tty = {
                fg = indexes.normal.red,
            },
        })
        set('DiagnosticWarn', {
            tty = {
                fg = indexes.normal.yellow,
            },
        })
        set('DiagnosticInfo', {
            tty = {
                fg = indexes.normal.blue,
            },
        })
        set('DiagnosticHint', {
            tty = {
                fg = indexes.normal.magenta,
            },
        })
        set('DiagnosticOk', {
            tty = {
                fg = indexes.normal.green,
            },
        })
        set('DiagnosticDeprecated', {
            gui = {
                style = {
                    strikethrough = true,
                },
            },
        })
        set('DiagnosticSignError', { link = 'DiagnosticError' })
        set('DiagnosticSignWarn', { link = 'DiagnosticWarn' })
        set('DiagnosticSignInfo', { link = 'DiagnosticInfo' })
        set('DiagnosticSignHint', { link = 'DiagnosticHint' })
        set('DiagnosticSignOk', { link = 'DiagnosticOk' })
        set('DiagnosticUnderlineError', {
            gui = {
                sp = get('DiagnosticError').gui.fg,
                style = {
                    undercurl = true,
                },
            },
        })
        set('DiagnosticUnderlineWarn', {
            gui = {
                sp = get('DiagnosticWarn').gui.fg,
                style = {
                    undercurl = true,
                },
            },
        })
        set('DiagnosticUnderlineInfo', {
            gui = {
                sp = get('DiagnosticInfo').gui.fg,
                style = {
                    undercurl = true,
                },
            },
        })
        set('DiagnosticUnderlineHint', {
            gui = {
                sp = get('DiagnosticHint').gui.fg,
                style = {
                    undercurl = true,
                },
            },
        })
        set('DiagnosticUnderlineOk', {
            gui = {
                sp = get('DiagnosticOk').gui.fg,
                style = {
                    undercurl = true,
                },
            },
        })
        set('DiagnosticVirtualTextError', {
            tty = {
                fg = get('DiagnosticError').tty.fg,
                bg = get('CursorLine').tty.bg,
            },
            gui = {
                fg = get('DiagnosticError').gui.fg,
                bg = palette.primary.bg:blend(get('DiagnosticError').gui.fg, 0.15),
            },
        })
        set('DiagnosticVirtualTextWarn', {
            tty = {
                fg = get('DiagnosticWarn').tty.fg,
                bg = get('CursorLine').tty.bg,
            },
            gui = {
                fg = get('DiagnosticWarn').gui.fg,
                bg = palette.primary.bg:blend(get('DiagnosticWarn').gui.fg, 0.15),
            },
        })
        set('DiagnosticVirtualTextInfo', {
            tty = {
                fg = get('DiagnosticInfo').tty.fg,
                bg = get('CursorLine').tty.bg,
            },
            gui = {
                fg = get('DiagnosticInfo').gui.fg,
                bg = palette.primary.bg:blend(get('DiagnosticInfo').gui.fg, 0.15),
            },
        })
        set('DiagnosticVirtualTextHint', {
            tty = {
                fg = get('DiagnosticHint').tty.fg,
                bg = get('CursorLine').tty.bg,
            },
            gui = {
                fg = get('DiagnosticHint').gui.fg,
                bg = palette.primary.bg:blend(get('DiagnosticHint').gui.fg, 0.15),
            },
        })
        set('DiagnosticVirtualTextOk', {
            tty = {
                fg = get('DiagnosticOk').tty.fg,
                bg = get('CursorLine').tty.bg,
            },
            gui = {
                fg = get('DiagnosticOk').gui.fg,
                bg = palette.primary.bg:blend(get('DiagnosticOk').gui.fg, 0.25),
            },
        })

        -- Diff
        set('DiffDelete', {
            tty = {
                bg = Term.darken(get('DiagnosticError').tty.fg),
            },
        })
        set('DiffChange', {
            tty = {
                bg = Term.darken(get('DiagnosticWarn').tty.fg),
            },
        })
        set('DiffText', {
            tty = {
                bg = Term.darken(get('DiagnosticHint').tty.fg),
            },
        })
        set('DiffAdd', {
            tty = {
                bg = Term.darken(get('DiagnosticOk').tty.fg),
            },
        })

        -- Git
        set('GitSignsDelete', {
            tty = {
                fg = Term.brighten(get('DiffDelete').tty.bg),
            },
        })
        set('GitSignsStagedDelete', {
            tty = {
                fg = Term.darken(get('GitSignsDelete').tty.fg),
            },
        })
        set('GitSignsTopdelete', { link = 'GitSignsDelete' })
        set('GitSignsStagedTopdelete', { link = 'GitSignsStagedDelete' })
        set('GitSignsChangedelete', { link = 'GitSignsDelete' })
        set('GitSignsStagedChangedelete', { link = 'GitSignsStagedDelete' })
        set('GitSignsChange', {
            tty = {
                fg = Term.darken(get('DiffChange').tty.bg),
            },
        })
        set('GitSignsStagedChange', {
            tty = {
                fg = Term.darken(get('GitSignsChange').tty.fg),
            },
        })
        set('GitSignsAdd', {
            tty = {
                fg = Term.darken(get('DiffAdd').tty.bg),
            },
        })
        set('GitSignsStagedAdd', {
            tty = {
                fg = Term.darken(get('GitSignsAdd').tty.fg),
            },
        })

        -- Indent blankline
        set('IblIndent', {
            tty = {
                fg = indexes.bright.black,
            },
        })
        set('IblScope', {
            tty = {
                fg = indexes.normal.white,
            },
        })

        -- Text
        set('Title', {
            tty = {
                fg = indexes.normal.magenta,
            },
            gui = {
                fg = lookup(indexes.normal.magenta),
                style = {
                    bold = true,
                },
            },
        })
        set('@text.emphasis', {
            tty = {
                fg = indexes.normal.cyan,
            },
            gui = {
                fg = lookup(indexes.normal.cyan),
                style = {
                    italic = true,
                },
            },
        })
        set('@text.strong', {
            tty = {
                fg = indexes.normal.green,
            },
            gui = {
                fg = lookup(indexes.normal.green),
                style = {
                    bold = true,
                },
            },
        })
        set('@text.strike', {
            tty = {
                fg = indexes.normal.red,
            },
            gui = {
                fg = lookup(indexes.normal.red),
                style = {
                    underdouble = true,
                },
            },
        })
        set('@text.reference', {
            tty = {
                fg = indexes.normal.yellow,
            },
        })
        set('@text.uri', {
            tty = {
                fg = indexes.bright.yellow,
            },
            gui = {
                fg = lookup(indexes.bright.yellow),
                style = {
                    underline = true,
                },
            },
        })
        set('@text.quote', {
            tty = {
                fg = indexes.bright.yellow,
            },
        })
        set('@text.literal', {
            tty = {
                fg = indexes.normal.yellow,
            },
        })
        set('@text.environment', { link = 'Keyword' })
        set('@text.environment.name', { link = 'Constant' })

        -- Markdown
        set('@punctuation.delimiter.markdown')
        set('@punctuation.delimiter.markdown_inline')
        set('@label.markdown')
        set('@lsp.type.class.markdown', { link = '@text.uri' })

        -- Syntax
        set('Comment', {
            tty = {
                fg = indexes.bright.black,
            },
            gui = {
                fg = lookup(indexes.bright.black),
                style = {
                    italic = true,
                },
            },
        })
        set('NonText', {
            tty = {
                fg = indexes.bright.black,
            },
        })
        set('Tag', { link = 'Identifier' })
        set('@tag.attribute', { link = 'Constant' })

        -- Keywords
        set('Statement', {
            tty = {
                fg = indexes.bright.magenta,
            },
        })
        set('Keyword', {
            tty = {
                fg = Term.darken(get('Statement').tty.fg),
            },
            gui = {
                fg = lookup(Term.darken(get('Statement').tty.fg)),
                style = {
                    italic = true,
                },
            },
        })
        set('Operator', {
            tty = {
                fg = indexes.normal.white,
            },
        })
        set('@punctuation.special', { link = 'Operator' })
        set('Delimiter', {
            tty = {
                fg = indexes.bright.black,
            },
        })
        set('@lsp.type.keyword', { link = 'Keyword' })

        -- Variables
        set('Identifier', {
            tty = {
                fg = indexes.normal.red,
            },
        })
        set('@constant', { link = '@namespace' })

        -- Constants
        set('Constant', {
            tty = {
                fg = indexes.normal.yellow,
            },
        })
        set('String', {
            tty = {
                fg = Term.brighten(get('Constant').tty.fg),
            },
        })
        set('SpecialChar', { link = 'Function' })
        set('@lsp.type.string', { link = 'String' })

        -- Types
        set('Type', {
            tty = {
                fg = indexes.bright.green,
            },
        })
        set('StorageClass', { link = 'Keyword' })
        set('@type.builtin', {
            tty = {
                fg = Term.darken(get('Type').tty.fg),
            },
        })
        set('@type.qualifier', { link = 'Keyword' })
        set('@lsp.type.macro', { link = 'Type' })

        -- Namespaces
        set('@lsp.type.namespace', { link = '@namespace' })
        set('@namespace', { link = '@type.builtin' })

        -- Functions
        set('Function', {
            tty = {
                fg = indexes.normal.cyan,
            },
        })
        set('@function.builtin')
        set('@constructor', { link = 'Function' })

        -- Macros
        set('PreProc', { link = 'Keyword' })
        set('@function.macro', { link = 'Function' })

        -- Lua
        set('@constructor.lua', { link = 'Operator' })
        set('@lsp.type.type.lua')
        set('@lsp.mod.global', { link = '@namespace' })

        -- JSON
        set('@label.json', { link = 'Identifier' })

        -- Rust
        set('@constant.builtin', { link = 'Constant' })

        -- Css
        set('@type.tag.css', { link = 'Keyword' })
        set('@property.class.css', { link = 'Type' })
        set('@property.id.css', { link = 'Function' })
    end)
end
