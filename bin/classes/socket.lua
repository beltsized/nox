-- libraries
local ws = require('coro-websocket')
local json = require('json')
local cc = require('../class')

-- Socket class
local socket = cc('socket')

p(socket)

function socket:init(client)
    self._client = client
end

function socket:connect(url)
    local opt = ws.parseUrl(url)
    local info, read, write = ws.connect(opt)

    self._read = read
    self._write = write

    for m in self._read do
        local pload = json.decode(m.payload)

        self._shard:handle(m)
    end
end

return socket
