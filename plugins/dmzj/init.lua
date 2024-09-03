local http = require "utils.http"
local debug = require "utils.debug"

local M = {}

function M.gallery(act)
    local query = {
        version = "99.9.9"
    }

    local response = http.get("https://nnv3api.idmzj.com/recommend_new.json", {
        query = query,
    })

    local rets = {}

    if response.code ~= 200 then
        return rets
    end

    local data = dart_json.decode(response.content)
    for _, tag in ipairs(data) do
        if tag.data ~= nil then
            for _, item in ipairs(tag.data) do
                table.insert(rets, {
                    title = item.title,
                    cover = item.cover,
                    extra = item
                })
            end
        end
    end

    return rets
end

function M.get_detail(act)
    print('act', debug.debug_table(act))
    local url = 'https://v4api.'
        .. 'idmzj.com'
        .. '/comic/detail/'
        .. tostring(act.payload.extra.obj_id)
        .. '?uid=2665531'

    local response = http.get(url, {
        responseType = 'plain'
    })
    print('response', response)
    print('response.content', debug.debug_table(response))
    return {}
end

return M
