local client = {}
local api = require('./api')
local shard = require('./shard')
local insert = table.insert

client.__index = client

function client:new(meta)
    self.token = meta.token
    
    self._shardcount = meta.shardcount
    self._api = api:new(self.token)
    self._shards = {}

    for i = 0, self._shardcount do
        insert(self._shards, shard:new())
    end

    print('shards loaded')

    for i,v in ipairs(self._shards) do
        v:connect()
    end

    return setmetatable({}, client)
end

return client