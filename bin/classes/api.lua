local api = {}
local endp = require('../attribs/endpoints')
local http = require('coro-http')
local json = require('json')
local base = 'https://discord.com/api/v10'
local format = string.format
local insert = table.insert

api.__index = api

function api:new(token)
    return setmetatable({
        _token = token
    }, api)
end

function api:send(method, endpoint, headers, body)
    insert(headers, {'Authorization', format('Bot %s', self._token)})

    return http.request(method, format('%s/%s', base, endpoint), headers, body)
end

function api:getbotgateway()
    return self:send('GET', endp.gateway_bot, {})
end

return api
