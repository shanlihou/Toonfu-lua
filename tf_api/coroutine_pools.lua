local M = {}

---@class CoroutineContext
---@field id number
---@field co thread
---@field ret_id number
---@field create_time number

---@type table<number, CoroutineContext>
local coroutine_pools = {}

---@return number
function M.gen_cb_id()
    local co = coroutine.running()
    local id = coroutine.id(co)

    if coroutine_pools[id] == nil then
        dart_utils.log('gen_cb_id id invalid')
    end

    return id
end


---@class ActResult
---@field retId number
---@field data any

---@param func function
---@param data Action
---@return ActResult
local function func_wrapper(func, data)
    local ret = func(data)
    local id = coroutine.id(coroutine.running())
    coroutine_pools[id] = nil
    return {
        retId = data.retId,
        data = ret
    }
end

---@param data Action
---@return thread
function M.create(data)
    local co = coroutine.create(func_wrapper)
    local id = coroutine.id(co)
    coroutine_pools[id] = {
        create_time = os.time(),
        id = id,
        co = co,
        ret_id = data.retId
    }
    return co
end

---@param co thread
---@param func function
---@param data Action
---@return boolean, ActResult?
function M.resume(co, func, data)
    local id = coroutine.id(co)
    local success, ret = coroutine.resume(co, func, data)
    if not success then
        dart_utils.log('loop_once do func error:' .. tostring(ret))
        ret = {
            retId = coroutine_pools[id].ret_id,
            data = ret
        }
        coroutine_pools[id] = nil
    end
    return success, ret
end


---@param id number
---@return boolean, ActResult?
function M.resume_cb(id, ...)
    local ctx = coroutine_pools[id]
    if ctx then
        local success, ret = coroutine.resume(ctx.co, ...)
        if not success then
            dart_utils.log('resume_cb do func error:' .. tostring(ret))
            ret = {
                retId = ctx.ret_id,
                data = ret
            }
            coroutine_pools[id] = nil
        end
        return success, ret
    end

    return false, nil
end

function M.clear_timeout()
    local now = os.time()
    for id, ctx in pairs(coroutine_pools) do
        if now - ctx.create_time > 60 then
            dart_utils.log('coroutine timeout:' .. tostring(id))
            coroutine_pools[id] = nil
        end
    end
end

return M
