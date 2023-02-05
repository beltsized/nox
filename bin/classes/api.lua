local api = {}
local endp = require('../attribs/endpoints')
local http = require('coro-http')
local base = 'https://discord.com/api/v10'
local format = string.format

api.__index = api

function api:new(token)
    return setmetatable({_token = token}, api)
end

function api:send(method, endpoint)
    return http.request(method, format('%s/%s', base, endpoint), {
        {'Authorization', format('Bot %s', self._token)}
    })
end

function api:getbotgateway()
    return http.request('GET', endp.gateway_bot)
end

return api