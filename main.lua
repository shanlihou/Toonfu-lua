package.path = package.path .. ';./lua/?.lua;./lua/?/init.lua'

local dmzj = require "plugins.dmzj"

print('hello im in main')

local coroutine_pools = {}

function loop_once(data)
    print(data)
    return ""
end
