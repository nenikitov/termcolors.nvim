local Color = require('highlight_builder').color.Gui
local Term = require('highlight_builder').color.Term

local build = require('highlight_builder').build

local palette = require('highlight_builder').palette.custom({
    primary = {
        bg = '#171A22',
        fg = '#B7C2C8',
    },
    dark = {
        black = '#20232B',
        red = '#DA5261',
        green = '#56B877',
        yellow = '#DB8878',
        blue = '#4788F0',
        magenta = '#AF6ADB',
        cyan = '#49B2BB',
        white = '#8B909D',
    },
    bright = {
        black = '#555A66',
        red = '#fa788e',
        green = '#A7FA9C',
        yellow = '#F9C097',
        blue = '#81B5FF',
        magenta = '#D9A1FF',
        cyan = '#69F3FF',
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

---@param accent Color.Gui | nil
---@param brightness number | nil
---@return Color.Gui | nil color
local function blend_accent(accent, brightness)
    if not brightness then
        brightness = 10
    end
    if not accent then
        return nil
    end

    local _, _, b_v = lookup(Term.indexes.normal.black):to_hsv()
    local a_h, a_s, _ = accent:to_hsv()
    return Color.from_hsv(a_h, a_s, b_v):brighten(brightness)
end

---@param options Options
return function(options)
    ---@param token OptsPalleteToken
    ---@return TermLow8
    local function index_low(token)
        local group, highlight = token:match([[^(.+)%.(.*)$]])
        if highlight == 'function' then
            highlight = 'function_'
        end

        return Term.indexes.normal[options.palette[group][highlight]]
    end

    ---@param token OptsPalleteToken
    ---@param alternate boolean | nil
    ---@param force_use_alternative boolean | nil
    ---@return Term16
    local function index(token, alternate, force_use_alternative)
        ---@type Term16
        local reg = index_low(token)
        ---@type Term16
        local alt = Term.brighten(reg)

        if options.swap_alternate then
            reg, alt = alt, reg
        end

        if options.use_alternate or force_use_alternative then
            return alternate and alt or reg
        else
            return reg
        end
    end

    return build(palette, function(get, set)
        --#region UI

        -- Main
        set('Normal', {
            tty = {
                bg = Term.indexes.primary.bg,
                fg = Term.indexes.primary.fg,
            },
        })
        if options.darken_inactive then
            set('NormalNC', {
                tty = get('Normal').tty,
                gui = {
                    bg = palette.primary.bg:darken(0.15),
                },
            })
        end
        set('Visual', {
            tty = {
                bg = Term.indexes.normal.white,
                fg = 0,
            },
            gui = {
                bg = blend_accent(lookup(index('ui.visual')), 15),
            },
        })
        set('Error', { link = 'DiagnosticError' })
        set('ErrorMsg', { link = 'DiagnosticError' })
        set('WarningMsg', { link = 'DiagnosticWarn' })

        -- Splits
        set('VertSplit', {
            tty = {
                fg = index('ui.split', true, true),
            },
        })

        -- Floating menus
        set('Pmenu', {
            tty = {
                bg = options.popup_background and Term.indexes.normal.black or 'NONE',
            },
        })
        set('PmenuSel', { link = 'Visual' })
        set('PmenuSbar', { link = 'Pmenu' })
        set('PmenuThumb', { link = 'StatusLine' })
        set('FloatBorder', {
            tty = {
                bg = get('Pmenu').tty.bg,
                fg = get('VertSplit').tty.fg,
            },
        })

        -- Cursor
        set('CursorLine', {
            tty = {
                bg = Term.indexes.normal.black,
            },
        })
        set('CursorColumn', { link = 'CursorLine' })
        set('Cursor', { link = 'TermCursor' })

        -- Gutter
        set('SignColumn', {
            tty = {
                fg = 'NONE',
                bg = options.panel_background and Term.indexes.normal.black or 'NONE',
            },
        })
        set('FoldColumn', { link = 'SignColumn' })
        set('LineNr', {
            tty = {
                fg = Term.indexes.bright.black,
                bg = options.panel_background and Term.indexes.normal.black or 'NONE',
            },
        })
        set('CursorLineNr', {
            tty = {
                fg = 'NONE',
                bg = options.panel_background and Term.indexes.normal.black or 'NONE',
            },
        })
        set('WildMenu', { link = 'Visual' })

        -- Status line
        set('StatusLine', {
            tty = {
                bg = Term.indexes.normal.white,
                fg = Term.indexes.normal.black,
            },
            gui = {
                bg = lookup(Term.indexes.bright.black),
                fg = lookup(Term.indexes.bright.white),
            },
        })
        set('StatusLineNC', {
            tty = {
                bg = Term.indexes.normal.black,
                fg = Term.indexes.normal.white,
            },
        })
        set('TabLineFill', { link = 'StatusLineNC' })
        set('TabLine', { link = 'StatusLineNC' })
        set('TabLineSel', { link = 'StatusLine' })

        -- Other
        set('Search', {
            tty = {
                bg = index_low('ui.search'),
                fg = Term.indexes.normal.black,
            },
            gui = {
                bg = blend_accent(lookup(index('ui.search')), 15),
            },
        })
        set('IncSearch', {
            tty = {
                bg = get('Search').tty.bg,
                fg = get('Search').tty.fg,
                style = {
                    bold = true,
                },
            },
            gui = {
                bg = blend_accent(lookup(index('ui.search')), 30),
            },
        })
        set('CurSearch', { link = 'IncSearch' })
        set('ColorColumn', {
            tty = {
                bg = index_low('ui.accent'),
            },
            gui = {
                bg = blend_accent(lookup(index('ui.accent')), 15),
            },
        })
        set('MatchParen', {
            tty = {
                fg = index('ui.accent'),
            },
        })
        set('Conceal', { link = 'Delimiter' })
        set('Folded', { link = 'CursorLine' })
        set('MoreMsg', { link = 'Keyword' })
        set('Question', { link = 'Title' })

        --#endregion

        --#region Diagnostics

        ---@param diagnostic 'Error' | 'Warn' | 'Info' | 'Hint' | 'Ok'
        ---@param color TermLow8
        local function set_diagnostic(diagnostic, color)
            set('Diagnostic' .. diagnostic, {
                tty = {
                    fg = color,
                },
            })
            set('DiagnosticSign' .. diagnostic, {
                tty = {
                    bg = get('SignColumn').tty.bg,
                    fg = color,
                },
            })
            set('DiagnosticUnderline' .. diagnostic, {
                gui = {
                    sp = get('Diagnostic' .. diagnostic).gui.fg,
                    style = {
                        undercurl = true,
                    },
                },
            })
            set('DiagnosticVirtualText' .. diagnostic, {
                tty = {
                    bg = get('CursorLine').tty.bg,
                    fg = get('Diagnostic' .. diagnostic).tty.fg,
                },
                gui = {
                    bg = blend_accent(lookup(get('Diagnostic' .. diagnostic).tty.fg)),
                    fg = get('Diagnostic' .. diagnostic).gui.fg,
                },
            })
        end
        set_diagnostic('Error', index_low('diagnostic.error'))
        set_diagnostic('Warn', index_low('diagnostic.warn'))
        set_diagnostic('Info', index_low('diagnostic.info'))
        set_diagnostic('Hint', index_low('diagnostic.hint'))
        set_diagnostic('Ok', index_low('diagnostic.ok'))
        set('SpellBad', { link = 'DiagnosticUnderlineError' })
        set('SpellCap', { link = 'DiagnosticUnderlineWarn' })
        set('SpellLocal', { link = 'DiagnosticUnderlineInfo' })
        set('SpellRare', { link = 'DiagnosticUnderlineHint' })
        set('DiagnosticDeprecated', {
            gui = {
                style = {
                    strikethrough = true,
                },
            },
        })

        --#endregion

        --#region Diff

        ---@param diff 'Delete' | 'Change' | 'Text' | 'Add'
        ---@param diagnostic 'Error' | 'Warn' | 'Info' | 'Hint' | 'Ok'
        local function set_diff(diff, diagnostic)
            set('Diff' .. diff, {
                tty = {
                    bg = Term.darken(get('Diagnostic' .. diagnostic).tty.fg),
                },
            })
        end
        set_diff('Delete', 'Error')
        set_diff('Change', 'Warn')
        set_diff('Text', 'Hint')
        set_diff('Add', 'Ok')

        --#endregion

        --#region Syntax

        -- NonText
        set('Comment', {
            tty = {
                fg = index('syntax.comment', true, true),
            },
            gui = {
                fg = lookup(index('syntax.comment', true, true)),
                style = {
                    italic = true,
                },
            },
        })
        set('NonText', { link = 'Comment' })

        -- Constants
        set('Constant', {
            tty = {
                fg = index('syntax.constant'),
            },
        })
        set('String', {
            tty = {
                fg = index('syntax.constant', true),
            },
        })

        -- Code
        set('Identifier', {
            tty = {
                fg = index('syntax.identifier'),
            },
        })
        set('Function', {
            tty = {
                fg = index('syntax.function'),
            },
        })

        -- Keywords
        set('Statement', {
            tty = {
                fg = index('syntax.keyword', true),
            },
        })
        set('Keyword', {
            tty = {
                fg = index('syntax.keyword'),
            },
            gui = {
                fg = lookup(index('syntax.keyword')),
                style = {
                    italic = true,
                },
            },
        })
        set('Operator', {
            tty = {
                fg = index('syntax.operator'),
            },
        })

        -- Macros
        set('PreProc', { link = 'Keyword' })

        -- Types
        set('Type', {
            tty = {
                fg = index('syntax.type'),
            },
        })
        set('StorageClass', { link = 'Keyword' })

        -- Special
        set('Special', { link = 'Function' })
        set('Tag', { link = 'Identifier' })
        set('Delimiter', {
            tty = {
                fg = index('syntax.delimiter', true, true),
            },
        })
        set('Noise', { link = 'Delimiter' })

        -- Other
        set('Underlined', {
            gui = {
                style = {
                    underline = true,
                },
            },
        })

        --#endregion

        --#region Plugins

        -- Telescope

        set('TelescopeNormal', { link = 'Pmenu' })
        set('TelescopeBorder', { link = 'FloatBorder' })
        set('TelescopeTitle', { link = 'FloatTitle' })
        set('TelescopePromptTitle', { link = 'Special' })
        set('TelescopeMatching', { link = 'Search' })
        set('TelescopePromptPrefix', { link = 'NoiceCmdlineIconSearch' })
        set('TelescopeResultsClass', { link = 'Structure' })
        set('TelescopeResultsConstant', { link = 'Constant' })
        set('TelescopeResultsField', { link = '@field' })
        set('TelescopeResultsFunction', { link = 'Function' })
        set('TelescopeResultsMethod', { link = 'Function' })
        set('TelescopeResultsOperator', { link = 'Operator' })
        set('TelescopeResultsStruct', { link = 'Structure' })
        set('TelescopeResultsVariable', { link = 'Identifier' })

        -- Lazy

        -- Mason

        -- Gitsigns

        ---@param sign 'Delete' | 'Change' | 'Add'
        local function set_gitsign(sign)
            set('GitSigns' .. sign, {
                tty = {
                    bg = get('SignColumn').tty.bg,
                    fg = Term.brighten(get('Diff' .. sign).tty.bg),
                },
            })
            set('GitSignsStaged' .. sign, {
                tty = {
                    bg = get('SignColumn').tty.bg,
                    fg = Term.darken(get('GitSigns' .. sign).tty.fg),
                },
                gui = {
                    bg = get('SignColumn').gui.bg,
                    fg = blend_accent(lookup(Term.darken(get('GitSigns' .. sign).tty.fg)), 30),
                },
            })
        end
        set_gitsign('Delete')
        set_gitsign('Change')
        set_gitsign('Add')
        set('GitSignsTopdelete', { link = 'GitSignsDelete' })
        set('GitSignsStagedTopdelete', { link = 'GitSignsStagedDelete' })
        set('GitSignsChangedelete', { link = 'GitSignsDelete' })
        set('GitSignsStagedChangedelete', { link = 'GitSignsStagedDelete' })

        -- Indent blankline

        set('IblIndent', {
            tty = {
                fg = Term.indexes.bright.black,
            },
        })
        set('IblScope', {
            tty = {
                fg = Term.indexes.normal.white,
            },
        })

        -- Notify

        ---@param kind 'ERROR' | 'WARN' | 'INFO' | 'TRACE' | 'Log'
        ---@param diagnostic 'Error' | 'Warn' | 'Info' | 'Hint' | 'Ok'
        local function set_notify(kind, diagnostic)
            set('Notify' .. kind .. 'Icon', { link = 'Diagnostic' .. diagnostic })
            set('Notify' .. kind .. 'Title', { link = 'Diagnostic' .. diagnostic })
            set('Notify' .. kind .. 'Body', { link = 'Pmenu' })
            set('Notify' .. kind .. 'Border', {
                tty = {
                    bg = get('Pmenu').tty.bg,
                    fg = get('Diagnostic' .. diagnostic).tty.fg,
                },
                gui = {
                    bg = get('Pmenu').gui.bg,
                    fg = get('Pmenu').gui.bg:blend(get('Diagnostic' .. diagnostic).gui.fg, 0.5),
                },
            })
        end
        set_notify('ERROR', 'Error')
        set_notify('WARN', 'Warn')
        set_notify('INFO', 'Ok')
        set_notify('TRACE', 'Hint')
        set_notify('Log', 'Info')
        set('NotifyBackground', { link = 'Pmenu' })

        -- Noice

        ---@param kind '' | 'Calculator' | 'Cmdline' | 'Search' | 'Rename' | 'Filter' | 'Input' | 'Help' | 'Lua'
        ---@param link string
        local function set_noice(kind, link)
            set('NoiceCmdlineIcon' .. kind, { link = link })
        end
        set('NoiceCmdlineIcon', { link = 'Special' })
        set('NoiceCmdlineIconCalculator', {
            tty = {
                fg = index('ui.command', true, true),
            },
        })
        set('NoiceCmdlineIconCmdline', {
            tty = {
                fg = index('ui.command'),
            },
        })
        set('NoiceCmdlineIconSearch', {
            tty = {
                fg = index('ui.search'),
            },
        })
        set('NoiceCmdlineIconRename', {
            tty = {
                fg = index('ui.replace'),
            },
        })
        set('NoiceCmdlineIconFilter', {
            tty = {
                fg = index('ui.command', true, true),
            },
        })
        set('NoiceCmdlineIconInput', {
            tty = {
                fg = index('ui.insert'),
            },
        })
        set('NoiceCmdlineIconHelp', {
            tty = {
                fg = index('ui.insert', true, true),
            },
        })
        set('NoiceCmdlineIconLua', {
            tty = {
                fg = index('ui.command', true, true),
            },
        })
        set('NoiceCmdlinePopup', { link = 'Pmenu' })
        set('NoiceCmdlinePopupTitle', { link = 'Special' })
        set('NoiceCmdlinePopupBorder', { link = 'FloatBorder' })
        set('NoiceCmdlinePopupBorderSearch', { link = 'NoiceCmdlinePopupBorder' })

        -- LuaLine

        ---@param kind 'normal' | 'insert' | 'visual' | 'command' | 'terminal' | 'replace' | 'inactive'
        ---@param color Term16
        local function set_lualine(kind, color)
            set('lualine_a_' .. kind, {
                tty = {
                    bg = Term.darken(color),
                    fg = Term.indexes.normal.black,
                    style = {
                        bold = false,
                    },
                },
                gui = {
                    bg = lookup(color),
                    fg = lookup(Term.indexes.normal.black),
                    style = {
                        bold = true,
                    },
                },
            }, true)
            set('lualine_b_' .. kind, {
                tty = {
                    bg = 'NONE',
                    fg = get('lualine_a_' .. kind).tty.bg,
                },
                gui = {
                    bg = blend_accent(lookup(Term.indexes.bright.black), 5),
                    fg = lookup(get('lualine_a_' .. kind).tty.bg),
                    style = {
                        bold = true,
                    },
                },
            }, true)
            set('lualine_c_' .. kind, {
                tty = {
                    bg = 'NONE',
                    fg = Term.indexes.normal.white,
                },
                gui = {
                    bg = lookup(Term.indexes.normal.black),
                    fg = lookup(Term.indexes.normal.white),
                },
            }, true)
        end
        set_lualine('normal', index_low('ui.normal'))
        set_lualine('insert', index_low('ui.insert'))
        set_lualine('visual', index_low('ui.visual'))
        set_lualine('command', index_low('ui.command'))
        set_lualine('terminal', index('ui.command', true, true))
        set_lualine('replace', index_low('ui.replace'))
        set_lualine('inactive', Term.indexes.normal.white)

        -- WhichKey

        set('WhichKey', { link = 'Special' })
        set('WhichKeyGroup', { link = 'Keyword' })
        set('WhichKeyDescription', { link = 'Identifier' })
        set('WhichKeySeparator', { link = 'Operator' })

        -- Todo

        ---@param kind 'FIX' | 'TODO' | 'HACK' | 'WARN' | 'PERF' | 'NOTE' | 'TEST'
        ---@param link string
        local function set_todo(kind, link)
            set('TodoBg' .. kind, {
                tty = {
                    fg = Term.indexes.normal.black,
                    bg = Term.darken(get(link).tty.fg),
                    style = {
                        bold = true,
                    },
                },
            })
            set('TodoFg' .. kind, {
                tty = {
                    fg = get(link).tty.fg,
                },
            })
            set('TodoSign' .. kind, { link = 'TodoFg' .. kind })
        end
        set_todo('FIX', 'DiagnosticError')
        set_todo('TODO', 'DiagnosticInfo')
        set_todo('HACK', 'DiagnosticOk')
        set_todo('WARN', 'DiagnosticWarn')
        set_todo('PERF', 'DiagnosticInfo')
        set_todo('NOTE', 'DiagnosticHint')
        set_todo('TEST', 'DiagnosticError')
        set('Todo', {
            tty = {
                fg = Term.darken(get('DiagnosticInfo').tty.fg),
                style = {
                    bold = true,
                },
            },
        })

        -- CMP and Drop bar

        set('DropBarCurrentContext', { link = 'Search' })
        set('DropBarMenuCurrentContext', { link = 'Search' })
        set('DropBarIconUIIndicator', { link = 'TelescopeNormal' })
        set('DropBarIconUISeparator', { link = 'WhichKeySeparator' })

        ---@param item string
        ---@param link string
        local function set_cmp(item, link)
            set('CmpItemKind' .. item, { link = link })
            set('DropBarIconKind' .. item, { link = link })
        end
        set_cmp('', 'Keyword')
        -- Keyword
        set_cmp('BreakStatement', 'Keyword')
        set_cmp('CaseStatement', 'Keyword')
        set_cmp('ContinueStatement', 'Keyword')
        set_cmp('Keyword', 'Keyword')
        set_cmp('Statement', 'Statement')
        set_cmp('IfStatement', 'Conditional')
        set_cmp('SwitchStatement', 'Conditional')
        set_cmp('DoStatement', 'Repeat')
        set_cmp('ForStatement', 'Repeat')
        set_cmp('WhileStatement', 'Repeat')
        set_cmp('Copilot', 'Macro')
        set_cmp('Macro', 'Macro')
        set_cmp('Snippet', 'Macro')
        -- Type
        set_cmp('Class', '@lsp.type.class')
        set_cmp('Enum', '@lsp.type.enum')
        set_cmp('EnumMember', '@lsp.type.enumMember')
        set_cmp('Interface', '@lsp.type.interface')
        set_cmp('Module', '@lsp.type.namespace')
        set_cmp('Namespace', '@lsp.type.namespace')
        set_cmp('Package', '@lsp.type.namespace')
        set_cmp('Object', '@lsp.type.struct')
        set_cmp('Struct', '@lsp.type.struct')
        set_cmp('Type', '@lsp.type.type')
        set_cmp('TypeParameter', '@lsp.type.typeParameter')
        -- Variables
        set_cmp('Array', 'Identifier')
        set_cmp('Identifier', 'Identifier')
        set_cmp('Key', 'Identifier')
        set_cmp('List', 'Identifier')
        set_cmp('Variable', 'Identifier')
        set_cmp('Property', '@property')
        set_cmp('Field', '@property')
        -- Constant
        set_cmp('Boolean', 'Boolean')
        set_cmp('Color', 'String')
        set_cmp('Constant', 'Constant')
        set_cmp('Value', 'Constant')
        set_cmp('Null', '@constant.builtin')
        set_cmp('Number', 'Number')
        set_cmp('Unit', 'Number')
        set_cmp('String', 'String')
        -- Function
        set_cmp('Call', 'Function')
        set_cmp('Event', 'Function')
        set_cmp('Function', 'Function')
        set_cmp('Constructor', '@constructor')
        set_cmp('Method', '@method')
        set_cmp('Reference', '@text.reference')
        -- Other
        set_cmp('Text', '@text')
        set_cmp('Folder', 'Directory')
        set_cmp('File', 'Directory')
        set_cmp('Operator', 'Operator')
        -- Idk
        set_cmp('Declaration', 'Keyword')
        set_cmp('Delete', 'Keyword')
        set_cmp('Log', 'Keyword')
        set_cmp('Lsp', 'Keyword')
        set_cmp('MarkdownH1', '@text.title.1')
        set_cmp('MarkdownH2', '@text.title.2')
        set_cmp('MarkdownH3', '@text.title.3')
        set_cmp('MarkdownH4', '@text.title.4')
        set_cmp('MarkdownH5', '@text.title.5')
        set_cmp('MarkdownH6', '@text.title.6')
        set_cmp('H1Marker', '@text.title.1')
        set_cmp('H2Marker', '@text.title.2')
        set_cmp('H3Marker', '@text.title.3')
        set_cmp('H4Marker', '@text.title.4')
        set_cmp('H5Marker', '@text.title.5')
        set_cmp('H6Marker', '@text.title.6')
        set_cmp('Pair', 'Struct')
        set_cmp('Repeat', 'Repeat')
        set_cmp('Scope', 'Keyword')
        set_cmp('Regex', 'String')
        set_cmp('Specifier', 'Keyword')
        set_cmp('Terminal', 'Keyword')

        --#endregion

        --#region Files

        set('Directory', {
            link = 'Keyword',
        })

        --#endregion

        --#region Text

        set('SpecialKey', { link = 'Keyword' })

        --#endregion

        -- Text
        set('Title', {
            tty = {
                fg = Term.indexes.normal.magenta,
            },
            gui = {
                fg = lookup(Term.indexes.normal.magenta),
                style = {
                    bold = true,
                },
            },
        })
        set('@text.emphasis', {
            tty = {
                fg = Term.indexes.normal.cyan,
            },
            gui = {
                fg = lookup(Term.indexes.normal.cyan),
                style = {
                    italic = true,
                },
            },
        })
        set('@text.strong', {
            tty = {
                fg = Term.indexes.normal.green,
            },
            gui = {
                fg = lookup(Term.indexes.normal.green),
                style = {
                    bold = true,
                },
            },
        })
        set('@text.strike', {
            tty = {
                fg = Term.indexes.normal.red,
            },
            gui = {
                fg = lookup(Term.indexes.normal.red),
                style = {
                    underdouble = true,
                },
            },
        })
        set('@text.reference', {
            tty = {
                fg = Term.indexes.normal.yellow,
            },
        })
        set('@text.uri', {
            tty = {
                fg = Term.indexes.bright.yellow,
            },
            gui = {
                fg = lookup(Term.indexes.bright.yellow),
                style = {
                    underline = true,
                },
            },
        })
        set('@text.quote', {
            tty = {
                fg = Term.indexes.bright.yellow,
            },
        })
        set('@text.literal', {
            tty = {
                fg = Term.indexes.normal.yellow,
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

        set('@lsp.type.comment')

        set('@function.macro', { link = 'Function' })

        set('@tag.attribute', { link = 'Constant' })
        set('@keyword.return', { link = 'Statement' })

        -- Keywords
        set('@punctuation.special', { link = 'Operator' })
        set('@lsp.type.keyword', { link = 'Keyword' })

        -- Variables
        set('@constant', { link = '@namespace' })
        set('@field', {
            tty = {
                fg = Term.brighten(get('Identifier').tty.fg),
            },
        })
        set('@lsp.type.property', { link = '@field' })

        set('@lsp.type.string', { link = 'String' })

        set('@type.builtin', {
            tty = {
                fg = Term.darken(get('Type').tty.fg),
            },
        })
        set('@type.qualifier', { link = 'Keyword' })
        set('@lsp.type.macro', { link = 'Type' })

        set('@text.todo.checked.markdown', {})
        set('@text.todo.unchecked.markdown', {})

        -- Namespaces
        set('@lsp.type.namespace', { link = '@namespace' })
        set('@namespace', { link = '@type.builtin' })

        -- Functions
        set('@function.builtin')
        set('@constructor', { link = 'Function' })

        -- Lua
        --set('@constructor.lua', { link = 'Operator' })
        set('@lsp.type.type.lua')
        set('@lsp.mod.global', { link = '@namespace' })

        -- JSON
        set('@label.json', { link = 'Identifier' })
        set('@field.yaml', { link = 'Identifier' })

        -- Rust
        set('@constant.builtin', { link = 'Constant' })

        -- Css
        set('@type.tag.css', { link = 'Keyword' })
        set('@property.class.css', { link = 'Type' })
        set('@property.id.css', { link = 'Function' })

        -- Python
        set('@string.documentation', { link = 'Comment' })

        -- Default highlights
        --[[
        -- Lua
        set('luaStatement', { link = 'Keyword' })
        set('luaTable', { link = '@constructor' })
        set('luaFunction', { link = 'Keyword' })
        set('luaFunc', { link = 'Function' })

        -- Cpp
        set('cppStructure', { link = 'Keyword' })
        set('cppAccess', { link = '@type.qualifier' })
        set('cType', { link = '@type.builtin' })
        set('cStatement', { link = 'Keyword' })

        -- Css
        set('cssPseudoClassId', { link = '@property.class.css' })
        set('cssCustomProp', { link = '@type.definition' })
        set('cssCustomProp', { link = '@type.definition' })
        set('cssTagName', { link = 'Keyword' })
        set('cssProp', { link = '@property.css' })
        set('cssUnitDecorators', { link = '@string' })
        set('cssAttributeSelector', { link = '@property' })
        set('cssClassName', { link = '@property.class.css' })
        set('cssClassNameDot', { link = '@punctuation.delimiter' })
        set('cssIdentifier', { link = '@property.id.css' })
        set('cssBraces', { link = '@punctuation.bracket' })
        set('cssSelectorOp', { link = 'Operator' })

        -- Html
        set('htmlTag', { link = '@tag.delimiter' })
        set('htmlTagName', { link = '@tag' })
        set('htmlArg', { link = '@tag.attribute' })
        set('htmlSpecialTagName', { link = 'HtmlTagName' })
        set('javaScript', {})

        -- Json
        set('jsonKeyword', { link = '@label.json' })

        -- Markdown
        set('markdownItalic', { link = '@text.emphasis' })
        set('markdownBold', { link = '@text.strong' })
        set(
            'markdownBoldItalic',
            (function()
                local style = vim.deepcopy(get('@text.strong'))
                style.gui.style =
                    vim.tbl_extend('force', style.gui.style, get('@text.emphasis').gui.style)
                return {
                    tty = style.tty,
                    gui = style.gui,
                }
            end)()
        )
        set('markdownStrike', { link = '@text.strike' })
        set('markdownH1Delimiter', { link = '@text.title.1' })
        set('markdownH2Delimiter', { link = '@text.title.2' })
        set('markdownH3Delimiter', { link = '@text.title.3' })
        set('markdownH4Delimiter', { link = '@text.title.4' })
        set('markdownH5Delimiter', { link = '@text.title.5' })
        set('markdownH6Delimiter', { link = '@text.title.6' })
        set('markdownListMarker', { link = '@punctuation.special' })
        set('markdownLinkText', { link = '@text.reference' })
        set('markdownUrl', { link = '@text.uri' })
        set('markdownBlockquote', { link = '@text.quote' })
        set('markdownCode', { link = '@text.literal' })
        set('markdownCodeDelimiter', { link = 'markdownCode' })
        set('markdownFootnote', { link = '@text.uri' })
        -- Rust
        set('rustType', { link = '@type.builtin' })
        set('rustStorage', { link = 'StorageClass' })
        set('rustIdentifier', { link = '@type' })
        set('rustMacro', { link = '@function.macro' })
        set('rustModPath', { link = '@namespace' })
        set('rustSigil', { link = 'Operator' })
        set('rustLifetime', { link = '@storageclass.lifetime' })
        -- Shell
        set('shDeref', { link = 'Identifier' })
        set('shArithRegion', { link = 'Operator' })
        set('shTestOpr', { link = 'Operator' })
        set('shSnglCase', { link = 'Operator' })
        set('shStatement', { link = 'Function' })
        set('shOption', { link = '@parameter' })
        set('shCmdSubRegion', { link = 'Operator' })
        set('shHereDoc01', { link = '@label' })
        -- Yaml
        set('yamlKeyValueDelimiter', { link = 'Delimiter' })
        set('yamlPlainScalar', { link = 'String' })
        set('yamlAnchor', { link = '@type' })
        ]]
    end)
end
