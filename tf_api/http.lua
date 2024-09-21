local CoroutinePools = require "tf_api.coroutine_pools"

local M = {}


---@param url string
---@param kwargs table
---@return table {code: number, content: string}
function M.get(url, kwargs)
    local cbid = CoroutinePools.gen_cb_id()
    dart_http.get(cbid, url, kwargs)
    local ret = coroutine.yield()
    return ret
end


return M
