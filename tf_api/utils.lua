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

return M
