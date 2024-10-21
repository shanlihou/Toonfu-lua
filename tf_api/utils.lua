local CoroutinePools = require "tf_api.coroutine_pools"
local M = {}


---@param plugin_name string
---@return string
function M.get_plugin_pwd(plugin_name)
    return dart_utils.cwd() .. '/' .. dart_utils.plugin_dir() .. '/' .. plugin_name
end

function M.init_plugin(plugin_name)
    local plugin_dir = dart_utils.plugin_dir()

    package.path = package.path
        .. ';'
        .. './' .. plugin_dir .. '/' .. plugin_name .. '/?.lua;'
        .. './' .. plugin_dir .. '/' .. plugin_name .. '/?/init.lua'
end

---@param delay_ms number
---@return table {}
function M.delay(delay_ms)
    local cbid = CoroutinePools.gen_cb_id()
    dart_os_ext.delay(cbid, delay_ms)
    local ret = coroutine.yield()
    return ret
end

return M
