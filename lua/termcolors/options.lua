---@alias Color 'black' | 'red' | 'green' | 'yellow' | 'blue' | 'magenta' | 'cyan' | 'white'


---@class Options
---@field high_color_cterm boolean
---@field token_highlight_swaps {[Color]: Color}

---@type Options
local options = {
    high_color_cterm = true,
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
}

return options

