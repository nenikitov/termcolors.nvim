---@alias Color 'black' | 'red' | 'green' | 'yellow' | 'blue' | 'magenta' | 'cyan' | 'white'


---@class Options
---@field cterm_mode nil | 8 | 16 | 256
---@field color_swaps {[Color]: Color}
---@field highlight_overrides {[string]: HighlightTable | HighlightLink}

---@type Options
local options = {
    cterm_mode = nil,
    color_swaps = {
        black = 'black',
        red = 'red',
        green = 'green',
        yellow = 'yellow',
        blue = 'blue',
        magenta = 'magenta',
        cyan = 'cyan',
        white = 'white'
    },
    highlight_overrides = {
    }
}

return options

