---@alias Color 'black' | 'red' | 'green' | 'yellow' | 'blue' | 'magenta' | 'cyan' | 'white'


---@class Options
---@field cterm_mode 8 | 16 | 256
---@field token_highlight_swaps {[Color]: Color}
---@field highlight_overrides {[string]: HighlightTable | HighlightLink}

---@type Options
local options = {
    cterm_mode = 16,
    token_highlight_swaps = {
        black   = 'black',
        red     = 'red',
        green   = 'green',
        yellow  = 'yellow',
        blue    = 'blue',
        magenta = 'magenta',
        cyan    = 'cyan',
        white   = 'white'
    },
    highlight_overrides = {
    }
}

return options

