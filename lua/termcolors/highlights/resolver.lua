return function()
    ---@type {[string]: SeparatedHighlight | fun(): SeparatedHighlight}
    local highlights = {}

    ---@param name string
    ---@return SeparatedHighlight
    local function resolve_highlight(name)
        if type(highlights[name]) == 'function' then
            highlights[name] = highlights[name]()
        end
        -- Is converted to the correct type by the if above
        ---@diagnostic disable-next-line: return-type-mismatch
        return highlights[name]
    end

    --- Resolve and get all highlights.
    ---@return {[string]: SeparatedHighlight} resolved Resolved highlights.
    local function resolve_all_highlights()
        for name, _ in pairs(highlights) do
            highlights[name] = resolve_highlight(name)
        end
        -- Is converted to the correct type by the calls above
        ---@diagnostic disable-next-line: return-type-mismatch
        return highlights
    end

    --- Copy and merge highlights in order of importance.
    ---@param ... string | SeparatedHighlight Name of the highlight group or highlight parameters.
    ---@return fun(): SeparatedHighlight highlight Function to call to generate the highlight.
    local function copy_merge_highlight(...)
        local args = { ... }
        return function()
            local result = {}
            for _, v in ipairs(args) do
                local current
                if type(v) == 'string' then
                    current = resolve_highlight(v)
                elseif type(v) == 'table' then
                    current = v
                end
                assert(current ~= nil, 'Invalid highlight for ' .. vim.inspect(v))
                result = vim.tbl_deep_extend('force', result, current)
            end
            return result
        end
    end

    --- Add new highlights.
    ---@param new_highlights {[string]: SeparatedHighlightOrLink | fun(): SeparatedHighlight} Highlights to add.
    local function set_highlights(new_highlights)
        for k, v in pairs(new_highlights) do
            highlights[k] = v
        end
    end

    return {
        copy_merge = copy_merge_highlight,
        get = resolve_all_highlights,
        set = set_highlights
    }
end

