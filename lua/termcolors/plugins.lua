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
                        transitional_lualine_a_normal_to_lualine_b = 'LuaLineNormalAB',
                        transitional_lualine_b_normal_to_lualine_c = 'LuaLineNormalBC',
                    },
                    insert = {
                        a = 'LuaLineInsertA',
                        b = 'LuaLineInsertB',
                        c = 'LuaLineInsertC',
                        transitional_lualine_a_insert_to_lualine_b = 'LuaLineInsertAB',
                        transitional_lualine_b_insert_to_lualine_c = 'LuaLineInsertBC',
                    },
                    visual = {
                        a = 'LuaLineVisualA',
                        b = 'LuaLineVisualB',
                        c = 'LuaLineVisualC',
                        transitional_lualine_a_visual_to_lualine_b = 'LuaLineVisualAB',
                        transitional_lualine_b_visual_to_lualine_c = 'LuaLineVisualBC',
                    },
                    replace = {
                        a = 'LuaLineReplaceA',
                        b = 'LuaLineReplaceB',
                        c = 'LuaLineReplaceC',
                        transitional_lualine_a_replace_to_lualine_b = 'LuaLineReplaceAB',
                        transitional_lualine_b_replace_to_lualine_c = 'LuaLineReplaceBC',
                    },
                    command = {
                        a = 'LuaLineCommandA',
                        b = 'LuaLineCommandB',
                        c = 'LuaLineCommandC',
                        transitional_lualine_a_command_to_lualine_b = 'LuaLineCommandAB',
                        transitional_lualine_b_command_to_lualine_c = 'LuaLineCommandBC',
                    },
                    inactive = {
                        a = 'LuaLineInactiveA',
                        b = 'LuaLineInactiveB',
                        c = 'LuaLineInactiveC',
                        transitional_lualine_a_inactive_to_lualine_b = 'LuaLineInactiveAB',
                        transitional_lualine_b_inactive_to_lualine_c = 'LuaLineInactiveBC',
                    },
                }
            }
        }
    end
end

