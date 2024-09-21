package.path = package.path .. ';./lua/?.lua;./lua/?/init.lua'

local coroutine_pools = require "tf_api.coroutine_pools"

---@class HttpResonse
---@field content string


---@class Gallery

---@class Action
---@field type string
---@field coId number
---@field retId number
---@field payload Gallery | HttpResonse
---@field plugin string

---@param data_list Action[]
function loop_once(data_list)
    local rets = {}

    for _, data in ipairs(data_list) do
        if data.plugin ~= '' then
            local plugin = require("plugins." .. data.plugin)
            local func = plugin[data.type]
            if func then
                local co = coroutine.create(function (_data)
                    local ret = func(_data)
                    return {
                        retId = _data.retId,
                        data = ret
                    }
                end)
                local _, ret = coroutine.resume(co, data)

                if ret ~= nil then
                    table.insert(rets, ret)
                end
            end
        elseif data.coId ~= 0 then
            local ret = coroutine_pools.resume_cb(data.coId, data.payload)

            if ret ~= nil then
                table.insert(rets, ret)
            end
        end
    end
    return rets
end

-- test.test()
