local class = require('./bin/classes/shard')
local shard = class:new()

shard:establish()
print(p(shard))