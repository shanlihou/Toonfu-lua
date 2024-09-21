local M = {}

local coroutine_pools = {}

---@return number
function M.gen_cb_id()
    local co = coroutine.running()
    local id = coroutine.id(co)
    coroutine_pools[id] = co
    return id
end


---@param id number
function M.resume_cb(id, ...)
    local co = coroutine_pools[id]
    if co then
        coroutine_pools[id] = nil
        local _, ret = coroutine.resume(co, ...)
        return ret
    end
end

return M
