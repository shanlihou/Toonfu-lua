local M = {}


---@param plugin_name string
---@return string
function M.get_plugin_pwd(plugin_name)
    return dart_utils.cwd() .. '/lua/plugins/' .. plugin_name
end

return M
