local ws = require('coro-websocket')
local endp = require('../attribs/endpoints')
local socket = {}

socket.__index = socket

function socket:new()
    return setmetatable({}, socket)
end

function socket:connect()
    local opt = ws.parseUrl(endp.gate)
    local pass, err, read, write = ws.connect(opt)

    if pass then
        self._read = read
        self._write = write

        for m in self._read do
            self._shard:handle(m)
        end
    else
        error('websocket connection failed: %s', err)
    end
end

return socket