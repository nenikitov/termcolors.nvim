---@class HighlightBuilder Highlight builder module.
---@field gui_to_cterm fun(gui: GuiHighlight): TermHighlight
---@field cterm_to_gui fun(cterm: TermHighlight): GuiHighlight
---@field get_colors fun(regenerate: boolean | nil): GuiColorTable
---@field mix_colors fun(color_1: string, color_2: string, factor: number): string
---@field find_closest_color fun(color: string): integer, string


---@alias TermColor number | nil | 'NONE' | 'Black' | 'DarkRed' | 'DarkGreen' | 'DarkYellow' | 'DarkBlue' | 'DarkMagenta' | 'DarkCyan' | 'Gray' | 'DarkGray' | 'Red' | 'Green' | 'Yellow' | 'Blue' | 'Magenta' | 'Cyan' | 'White'


---@class TermFontModifier Font modifiers available for terminal.
---@field bold boolean Bold.
---@field underline boolean Underline.
---@field undercurl boolean Curly underline.
---@field underdouble boolean Double underline.
---@field underdotted boolean Dotted underline.
---@field underdashed boolean Dashed underline.
---@field strikethrough boolean Strike through.
---@field reverse boolean Reverse background and foreground colors.
---@field italic boolean Italicize.


---@class TermHighlight Highlight properties for terminal.
---@field ctermfg TermColor Text color.
---@field ctermbg TermColor Background color.
---@field cterm TermFontModifier Font modifiers.

---@class GuiHighlight Highlight properties for GUI.
---@field fg string Text color.
---@field bg string Background color.
---@field sp string Non-text color (underlines).
---@field bold boolean Bold.
---@field underline boolean Underline.
---@field undercurl boolean Curly underline.
---@field underdouble boolean Double underline.
---@field underdotted boolean Dotted underline.
---@field underdashed boolean Dashed underline.
---@field strikethrough boolean Strike through.
---@field reverse boolean Reverse background and foreground colors.
---@field italic boolean Italicize.

---@class FullHighlight Highlight properties combined.
---@field ctermfg TermColor Text color.
---@field ctermbg TermColor Background color.
---@field cterm TermFontModifier Font modifiers.
---@field fg string Text color.
---@field bg string Background color.
---@field bold boolean Bold.
---@field underline boolean Underline.
---@field undercurl boolean Curly underline.
---@field underdouble boolean Double underline.
---@field underdotted boolean Dotted underline.
---@field underdashed boolean Dashed underline.
---@field strikethrough boolean Strike through.
---@field reverse boolean Reverse background and foreground colors.
---@field italic boolean Italicize.

---@class SeparatedHighlight Highlight properties separaged.
---@field cterm TermHighlight Highlights for terminal.
---@field gui GuiHighlight Highlights for GUI.


---@class TermColorTablePrimary Basic section of colors for terminal.
---@field background TermColor Background color.
---@field foreground TermColor Text color.

---@class TermColorTableColorBlock Colorful section of colors for terminal.
---@field black TermColor Black.
---@field red TermColor Red.
---@field green TermColor Green.
---@field yellow TermColor Yellow.
---@field blue TermColor Blue.
---@field magenta TermColor Magenta.
---@field cyan TermColor Cyan.
---@field white TermColor White.

---@class TermColorTable All available colors for the terminal.
---@field primary TermColorTablePrimary Most basic colors from the colorscheme.
---@field normal TermColorTableColorBlock 8 dim colors.
---@field bright TermColorTableColorBlock 8 bright colors.
---@field indexed TermColor[] 256 other colors.


---@class GuiColorTablePrimary Basic section of colors for GUI.
---@field background string Background color.
---@field foreground string Text color.

---@class GuiColorTableColorBlock Colorful section of colors for GUI.
---@field black string Black.
---@field red string Red.
---@field green string Green.
---@field yellow string Yellow.
---@field blue string Blue.
---@field magenta string Magenta.
---@field cyan string Cyan.
---@field white string White.

---@class GuiColorTable All available colors for the GUI.
---@field primary GuiColorTablePrimary Most basic colors from the colorscheme.
---@field normal GuiColorTableColorBlock 8 dim colors.
---@field bright GuiColorTableColorBlock 8 bright colors.
---@field indexed string[] 256 other colors.
