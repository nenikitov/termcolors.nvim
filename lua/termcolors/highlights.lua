local Color = require('highlight_builder').color.Gui
local Term = require('highlight_builder').color.Term
local indexes = Term.indexes

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

---@param accent Color.Gui
---@param brightness number | nil
---@return Color.Gui color
local function blend_accent(accent, brightness)
    if not brightness then
        brightness = 10
    end

    local _, _, b_v = lookup(indexes.normal.black):to_hsv()
    local a_h, a_s, _ = accent:to_hsv()
    return Color.from_hsv(a_h, a_s, b_v):brighten(brightness)
end

---@param options Options
---@return {[string]: HighlightCompiled}
return function(options)
    return build(palette, function(get, set)
        --#region UI

        -- Main
        set('Normal', {
            tty = {
                bg = indexes.primary.bg,
                fg = indexes.primary.fg,
            },
        })
        set('NormalNC', {
            tty = get('Normal').tty,
            gui = {
                bg = palette.primary.bg:darken(0.25),
            },
        })
        set('Visual', {
            tty = {
                bg = indexes.normal.white,
                fg = 0,
            },
            gui = {
                bg = blend_accent(lookup(indexes.normal.blue), 15),
            },
        })
        set('Error', { link = 'DiagnosticError' })
        set('ErrorMsg', { link = 'DiagnosticError' })
        set('WarningMsg', { link = 'DiagnosticWarn' })

        -- Splits
        set('VertSplit', {
            tty = {
                fg = indexes.bright.black,
            },
        })

        -- Floating menus
        set('Pmenu', {
            tty = {
                bg = indexes.normal.black,
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
                bg = indexes.normal.black,
            },
        })
        set('CursorColumn', { link = 'CursorLine' })
        set('Cursor', { link = 'TermCursor' })

        -- Gutter
        set('SignColumn', {
            tty = {
                fg = indexes.normal.white,
            },
        })
        set('FoldColumn', { link = 'SignColumn' })
        set('LineNr', { link = 'Comment' })
        set('CursorLineNr', {})
        set('WildMenu', { link = 'Visual' })

        -- Status line
        set('StatusLine', {
            tty = {
                bg = indexes.normal.white,
                fg = indexes.normal.black,
            },
            gui = {
                bg = lookup(indexes.bright.black),
                fg = lookup(indexes.bright.white),
            },
        })
        set('StatusLineNC', {
            tty = {
                bg = indexes.normal.black,
                fg = indexes.normal.white,
            },
        })
        set('TabLineFill', { link = 'StatusLineNC' })
        set('TabLine', { link = 'StatusLineNC' })
        set('TabLineSel', { link = 'StatusLine' })

        -- Other
        set('Search', {
            tty = {
                bg = indexes.normal.yellow,
            },
            gui = {
                bg = blend_accent(lookup(indexes.normal.yellow), 15),
            },
        })
        set('ColorColumn', {
            tty = {
                bg = indexes.normal.magenta,
            },
            gui = {
                bg = blend_accent(lookup(indexes.normal.magenta), 15),
            },
        })
        set('MatchParen', {
            tty = {
                fg = indexes.normal.magenta,
                style = {
                    bold = true,
                },
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
            set('DiagnosticSign' .. diagnostic, { link = 'Diagnostic' .. diagnostic })
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
                    fg = get('Diagnostic' .. diagnostic).tty.fg,
                    bg = get('CursorLine').tty.bg,
                },
                gui = {
                    fg = get('Diagnostic' .. diagnostic).gui.fg,
                    bg = blend_accent(lookup(get('Diagnostic' .. diagnostic).tty.fg)),
                },
            })
        end
        set_diagnostic('Error', indexes.normal.red)
        set_diagnostic('Warn', indexes.normal.yellow)
        set_diagnostic('Info', indexes.normal.blue)
        set_diagnostic('Hint', indexes.normal.magenta)
        set_diagnostic('Ok', indexes.normal.green)
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

        -- Constants
        set('Constant', {
            tty = {
                fg = indexes.normal.green,
            },
        })
        set('String', {
            tty = {
                fg = Term.brighten(get('Constant').tty.fg),
            },
        })

        -- Code
        set('Identifier', {
            tty = {
                fg = indexes.normal.red,
            },
        })
        set('Function', {
            tty = {
                fg = indexes.normal.cyan,
            },
        })

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

        -- Macros
        set('PreProc', { link = 'Keyword' })

        -- Types
        set('Type', {
            tty = {
                fg = indexes.bright.yellow,
            },
        })
        set('StorageClass', { link = 'Keyword' })

        -- Special
        set('Special', { link = 'Function' })
        set('Tag', { link = 'Identifier' })
        set('Delimiter', {
            tty = {
                fg = indexes.bright.black,
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
        set('TelescopeMatching', { link = 'IncSearch' })
        set('TelescopePromptPrefix', { link = 'TelescopePromptTitle' })
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
                    fg = Term.brighten(get('Diff' .. sign).tty.bg),
                },
            })
            set('GitSignsStaged' .. sign, {
                tty = {
                    fg = Term.darken(get('GitSigns' .. sign).tty.fg),
                },
                gui = {
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
                fg = indexes.bright.black,
            },
        })
        set('IblScope', {
            tty = {
                fg = indexes.normal.white,
            },
        })

        -- Notify

        ---@param kind 'ERROR' | 'WARN' | 'INFO' | 'TRACE' | 'Log'
        ---@param diagnostic 'Error' | 'Warn' | 'Info' | 'Hint' | 'Ok'
        local function set_notify(kind, diagnostic)
            set('Notify' .. kind .. 'Icon', { link = 'DiagnosticSign' .. diagnostic })
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
        set_noice('', 'Special')
        set_noice('Calculator', 'DiagnosticOk')
        set_noice('Cmdline', 'Special')
        set_noice('Search', 'DiagnosticWarn')
        set_noice('Rename', 'DiagnosticError')
        set_noice('Filter', 'Keyword')
        set_noice('Input', 'Special')
        set_noice('Help', 'DiagnosticOk')
        set('NoiceCmdlineIconLua', {
            tty = {
                fg = indexes.normal.blue,
            },
        })
        set('NoiceCmdlinePopup', { link = 'Pmenu' })
        set('NoiceCmdlinePopupTitle', { link = 'Special' })
        set('NoiceCmdlinePopupBorder', { link = 'FloatBorder' })
        set('NoiceCmdlinePopupBorderSearch', { link = 'NoiceCmdlinePopupBorder' })

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
                    fg = indexes.normal.black,
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
        set('NonText', {
            tty = {
                fg = indexes.bright.black,
            },
        })

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
    end)
end
