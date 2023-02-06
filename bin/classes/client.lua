local client = {}
local endp = require('../attribs/endpoints')
local api = require('./api')
local shard = require('./shard')
local insert = table.insert

client.__index = client

function client:new(meta)
    self.token = meta.token

    self._shardcount = 1
    self._api = api:new(self.token)
    self._shards = {}

    for i = 1, self._shardcount do
        local newshard = shard:new()

        newshard.id = i

        insert(self._shards, newshard)
    end

    print('shards loaded')

    return setmetatable({}, client)
end

function client:login()
    local gateway = self._api:getbotgateway()
    local url = gateway.url .. endp.encoding

    for i, v in ipairs(self._shards) do
        v:connect(url)
    end

    print('shards established')
end

return client
