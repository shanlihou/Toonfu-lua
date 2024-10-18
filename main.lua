local coroutine_pools = require "tf_api.coroutine_pools"
local base = require "tf_api.base"
local debug = require "tf_api.debug"

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
                local co = coroutine_pools.create(data)

                local _, ret = coroutine_pools.resume(co, func, data)

                if ret ~= nil then
                    table.insert(rets, ret)
                end
            else
                print('plugin method not found', data.plugin, data.type)
                table.insert(rets, {
                    retId = data.retId,
                    data = {}
                })
            end
        elseif data.coId ~= 0 then
            local _, ret = coroutine_pools.resume_cb(data.coId, data.payload)

            if ret ~= nil then
                table.insert(rets, ret)
            end
        else
            local func = base[data.type]
            if func then
                local ret = func(data)
                table.insert(rets, {
                    retId = data.retId,
                    data = ret
                })
            end
        end
    end

    return rets
end

-- test.test()
