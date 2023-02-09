local shard     = {}
local websocket = require('./websocket')
local class     = require('../class')
local shard     = class('shard', websocket)

function shard:init(id, client)
    websocket.init(self, client)

    self._id = id
    self._seq = nil
end

function shard:identify()
end

function shard:startheart()
end

function shard:stopheart()
end

function shard:heartbeat()
    
end

function shard:acknowledge(pl)
    p(pl)
end

return shard