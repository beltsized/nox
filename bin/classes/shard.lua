local shard = {}
local socket = require('./socket')
local cc = require('../class')
local shard = cc('shard', socket)

function shard:init(id, client)
    socket.init(self, client)

    self._id = id
    self._client = client
end

function shard:handle()
end

return shard
