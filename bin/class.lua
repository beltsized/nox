local names = {}
local format = string.format

return setmetatable({}, {
    __call = function(mt, name, child)
        if names[name] then
            error(format('class %s already exists', name))
        end
    end
})