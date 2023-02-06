local class = require('./bin/classes/client')
local client = class:new({ token = '' })

client:login()
