---@class HighlightBuilder Highlight builder module.
---@field gui_to_cterm fun(gui: HighlightGUI): HighlightFull
---@field get_colors fun(regenerate: boolean): ColorTable
---@field mix_colors fun(color_1: string, color_2: string, factor: number): string
---@field find_closest_color fun(color: string): integer, string

---@class HighlightCTerm Font modifiers avaiable in notermguicolors.
---@field bold boolean Bold.
---@field underline boolean Underline.
---@field undercurl boolean Curly underline.
---@field underdouble boolean Double underline.
---@field underdotted boolean Dotted underline.
---@field underdashed boolean Dashed underline.
---@field strikethrough boolean Strike through.
---@field reverse boolean Reverse background and foreground colors.
---@field italic boolean Italicize.

---@alias CTermColor nil | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 'NONE' | 'Black' | 'DarkRed' | 'DarkGreen' | 'DarkYellow' | 'DarkBlue' | 'DarkMagenta' | 'DarkCyan' | 'Gray' | 'DarkGray' | 'Red' | 'Green' | 'Yellow' | 'Blue' | 'Magenta' | 'Cyan' | 'White' Terminal Color.

---@class HighlightGUI Highlight properties available in termguicolors.
---@field fg string GUI text color ('#RRGGBB' or color name).
---@field bg string GUI background color ('#RRGGBB' or color name).
---@field sp string GUI special color ('#RRGGBB' or color name).
---@field bold boolean Bold.
---@field underline boolean Underline.
---@field undercurl boolean Curly underline.
---@field underdouble boolean Double underline.
---@field underdotted boolean Dotted underline.
---@field underdashed boolean Dashed underline.
---@field strikethrough boolean Strike through.
---@field reverse boolean Reverse background and foreground colors.
---@field italic boolean Italicize.

---@class HighlightFull All highlight properties available.
---@field ctermfg CTermColor Terminal text color.
---@field ctermbg CTermColor Terminal background color.
---@field cterm HighlightCTerm Terminal font modifiers.
---@field fg string GUI text color ('#RRGGBB' or color name).
---@field bg string GUI background color ('#RRGGBB' or color name).
---@field sp string GUI special color ('#RRGGBB' or color name).
---@field bold boolean Bold.
---@field underline boolean Underline.
---@field undercurl boolean Curly underline.
---@field underdouble boolean Double underline.
---@field underdotted boolean Dotted underline.
---@field underdashed boolean Dashed underline.
---@field strikethrough boolean Strike through.
---@field reverse boolean Reverse background and foreground colors.
---@field italic boolean Italicize.


---@class ColorTablePrimary Most basic colors from the color scheme.
---@field background string Background.
---@field foreground string Text color.

---@class ColorTableColors A colored block of colors.
---@field black string Black.
---@field red string Red.
---@field green string Green.
---@field yellow string Yellow.
---@field blue string Blue.
---@field magenta string Magenta.
---@field cyan string Cyan.
---@field White string White.

---@class ColorTable Colors that the terminal suppors.
---@field primary ColorTablePrimary Most basic colors from the colorscheme.
---@field normal ColorTableColors 8 dim colors.
---@field bright ColorTableColors 8 bright colors.
---@field indexed string[] 256 other colors.


---@class HighlightOptions Both CTerm and GUI highlights separately.
---@field cterm HighlightCTerm Notermguicolors highlights.
---@field gui HighlightGUI Termguicolors highlights.

