local endp = require('../attribs/endpoints')
local http = require('coro-http')
local json = require('json')
local base = 'https://discord.com/api/v10'
local format = string.format
local insert = table.insert
local cc = require('../class')
local api = cc('api')

function api:init(client)
    self._client = client
    self._token = client.token
end

function api:send(data)
    local method = data.method or 'GET'
    local endpoint = data.endpoint
    local headers = data.headers or {}
    local body = data.body

    insert(headers, {'Authorization', format('Bot %s', self._token)})

    local origin, res = http.request(method, format('%s/%s', base, endpoint), headers, body)

    return json.decode(res), origin
end

function api:getbotgateway()
    return self:send({
        endpoint = endp.gateway_bot
    })
end

return api
