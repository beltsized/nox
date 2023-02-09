local http   = require('coro-http')
local json   = require('json')
local format = string.format
local insert = table.insert
local class  = require('../class')
local api    = class('api')

local API_VERSION = 10
local ENDPOINTS   = require('../attribs/endpoints')
local USER_AGENT  = 'DiscordClient (nox, 1.0.0)'
local BASE_URL    = format('https://discord.com/api/v%d', API_VERSION)

function api:init(client)
    self._client = client
    self._token  = client._token
end

function api:verify()
    return self:getclientuser()
end

function api:deliver(data)
    local method   = data.method or 'GET'
    local endpoint = data.endpoint
    local headers  = data.headers or {}
    local body     = data.body

    insert(headers, {'Authorization', format('Bot %s', self._token)})

    local origin, res = http.request(method, format('%s%s', BASE_URL, endpoint), headers, body)

    return json.decode(res), origin
end

function api:getclientgateway()
    local res = self:deliver({
        endpoint = ENDPOINTS.GATEWAY_CLIENT
    })

    return format('%s/?v=%d&encoding=json', res.url, API_VERSION)
end

function api:getclientuser()
    return self:deliver({
        endpoint = ENDPOINTS.CLIENT_USER
    })
end

return api
