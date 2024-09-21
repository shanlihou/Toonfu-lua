local M = {}

function M.debug_table(t, max_deep, deep)
    local ret = ''
    if deep == nil then
        deep = 0
    end

    if max_deep == nil then
        max_deep = 3
    end

    if deep > max_deep then
        return ''
    end

    for k, v in pairs(t) do
        if type(v) == 'table' then
            ret = ret .. string.rep(' ', deep * 4) .. k .. ':\n' .. M.debug_table(v, max_deep, deep + 1)
        else
            ret = ret .. string.rep(' ', deep * 4) .. k .. ': ' .. tostring(v) .. '\n'
        end
    end

    return ret
end

return M
