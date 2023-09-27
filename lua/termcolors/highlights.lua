local build = require('highlight_builder').build

local palette = require('highlight_builder').palette.custom({
    primary = {
        fg = '#B4BFC5',
        bg = '#14161E',
    },
    dark = {
        black = '#20232B',
        red = '#ED3A66',
        green = '#70B74B',
        yellow = '#F89861',
        blue = '#26B1E4',
        magenta = '#B570EB',
        cyan = '#3CAEB2',
        white = '#A6ACB0',
    },
    bright = {
        black = '#5F656F',
        red = '#F3848A',
        green = '#B9D583',
        yellow = '#F2CBA5',
        blue = '#AED1FC',
        magenta = '#D39FED',
        cyan = '#89DACC',
        white = '#DDEBF2',
    },
}, true)

---@param options Options
---@return {[string]: HighlightCompiled}
return function(options)
    return build(palette, function(get, set)
        -- Menus
        set('Normal', {
            term = {
                bg = 'NONE',
                fg = 'NONE',
            },
        })
        set('PMenu', {
            term = {
                bg = 0,
                fg = get('Normal').term.fg,
            },
        })

        -- Lines and columns
        set('CursorLine', {
            term = {
                bg = 0,
            },
        })
        set('CursorColumn', { link = 'CursorLine' })
        set('SignColumn', {
            term = {
                bg = get('Normal').term.bg,
                fg = 7
            }
        })
        set('FoldColumn', { link = 'SignColumn' })
        set('LineNr', {
            term = {
                fg = 7
            }
        })
        set('CursorLineNr', {
            term = {
                bg = get('CursorLine').term.bg
            }
        })

        -- Diagnostics
        set('DiagnosticError', {
            term = {
                fg = 9
            }
        })
        set('DiagnosticWarn', {
            term = {
                fg = 11
            }
        })
        set('DiagnosticInfo', {
            term = {
                fg = 12
            }
        })
        set('DiagnosticHint', {
            term = {
                fg = 13
            }
        })
        set('DiagnosticOk', {
            term = {
                fg = 10
            }
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
                    undercurl = true
                }
            }
        })
        set('DiagnosticUnderlineWarn', {
            gui = {
                sp = get('DiagnosticWarn').gui.fg,
                style = {
                    undercurl = true
                }
            }
        })
        set('DiagnosticUnderlineInfo', {
            gui = {
                sp = get('DiagnosticInfo').gui.fg,
                style = {
                    undercurl = true
                }
            }
        })
        set('DiagnosticUnderlineHint', {
            gui = {
                sp = get('DiagnosticHint').gui.fg,
                style = {
                    undercurl = true
                }
            }
        })
        set('DiagnosticUnderlineOk', {
            gui = {
                sp = get('DiagnosticOk').gui.fg,
                style = {
                    undercurl = true
                }
            }
        })
        set('DiagnosticVirtualTextError', {
            term = {
                fg = get('DiagnosticError').term.fg,
                bg = get('DiagnosticError').term.fg - 8,
            }
        })
        set('DiagnosticVirtualTextWarn', {
            term = {
                fg = get('DiagnosticWarn').term.fg,
                bg = get('DiagnosticWarn').term.fg - 8,
            }
        })
        set('DiagnosticVirtualTextInfo', {
            term = {
                fg = get('DiagnosticInfo').term.fg,
                bg = get('DiagnosticInfo').term.fg - 8,
            }
        })
        set('DiagnosticVirtualTextHint', {
            term = {
                fg = get('DiagnosticHint').term.fg,
                bg = get('DiagnosticHint').term.fg - 8,
            }
        })
        set('DiagnosticVirtualTextOk', {
            term = {
                fg = get('DiagnosticOk').term.fg,
                bg = get('DiagnosticOk').term.fg - 8,
            }
        })

        -- Diff
        set('DiffDelete', {
            term = {
                bg = get('DiagnosticError').term.fg - 8
            }
        })
        set('DiffChange', {
            term = {
                bg = get('DiagnosticWarn').term.fg - 8
            }
        })
        set('DiffText', {
            term = {
                bg = get('DiagnosticHint').term.fg - 8
            }
        })
        set('DiffAdd', {
            term = {
                bg = get('DiagnosticOk').term.fg - 8
            }
        })

        -- Git
        set('GitSignsDelete', {
            term = {
                fg = get('DiffDelete').term.bg + 8
            }
        })
        set('GitSignsChange', {
            term = {
                fg = get('DiffChange').term.bg + 8
            }
        })
        set('GitSignsAdd', {
            term = {
                fg = get('DiffAdd').term.bg + 8
            }
        })
    end)
end
