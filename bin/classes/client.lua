local api     = require('./api')
local shard   = require('./shard')
local class   = require('../class')
local emitter = require('./emitter')
local client  = class('client', emitter)

local insert  = table.insert
local wrap    = coroutine.wrap

local ENDPOINTS = require('../attribs/endpoints')

function client:init(data)
    emitter.init(self)
    
    self._token      = data.token
    self._shardcount = 1
    self._api        = api(self)
    self._shards     = {}
end

function client:login()
    for i = 1, self._shardcount do
        local newshard = shard(i, self)

        insert(self._shards, newshard)
    end

    print('shards loaded')

    local gateway = self._api:getclientgateway()

    if gateway:find('nil') then
        error('bad token')
    end

    for _, s in ipairs(self._shards) do
        wrap(s.connect)(s, gateway)
    end

    print('shards established')
end

return client
