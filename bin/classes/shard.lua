local shard = {}
local socket = require('./socket')

shard.__index = shard

function shard:new()
    local inst = setmetatable({
        _ws = socket:new()
    }, shard)
    
    inst._ws._shard = inst

    return inst
end

function shard:establish()
    self._ws:connect()
end

function shard:handle()
end

return shard