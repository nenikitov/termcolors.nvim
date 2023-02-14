local lualine_status, lualine = pcall(require, 'lualine')

return function ()
    if lualine_status then
        lualine.setup {
            options = {
                theme = {
                    normal = {
                        a = 'LuaLineNormalA',
                        b = 'LuaLineNormalB',
                        c = 'LuaLineNormalC',
                    },
                    insert = {
                        a = 'LuaLineInsertA',
                        b = 'LuaLineInsertB',
                        c = 'LuaLineInsertC',
                    },
                    visual = {
                        a = 'LuaLineVisualA',
                        b = 'LuaLineVisualB',
                        c = 'LuaLineVisualC',
                    },
                    replace = {
                        a = 'LuaLineReplaceA',
                        b = 'LuaLineReplaceB',
                        c = 'LuaLineReplaceC',
                    },
                    command = {
                        a = 'LuaLineCommandA',
                        b = 'LuaLineCommandB',
                        c = 'LuaLineCommandC',
                    },
                    inactive = {
                        a = 'LuaLineInactiveA',
                        b = 'LuaLineInactiveB',
                        c = 'LuaLineInactiveC',
                    },
                }
            }
        }
    end
end

