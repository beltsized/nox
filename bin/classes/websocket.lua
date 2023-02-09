local json      = require('json')
local ws        = require('coro-websocket')
local class     = require('../class')
local websocket = class('websocket')

local wsparse, connect = ws.parseUrl, ws.connect

function websocket:init(client)
    self._client = client
end

function websocket:connect(url)
    local opt               = wsparse(url)
    local info, read, write = connect(opt)

    self._read  = read
    self._write = write

    for m in self._read do
        local pload = json.decode(m.payload)

        self._client:emit('raw', pload)
        self:acknowledge(pload)
    end
end

function websocket:disconnect()
    self._write()

    self._read = nil
    self._write = nil
end

return websocket
