local class = require('./bin/classes/client')
local client = class:new({ token = '' }) 

client:on('raw', function(pkg)
		p(pkg)
end)

client:login()
