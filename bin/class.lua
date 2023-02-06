local meta = {}
local format = string.format
local objs = setmetatable({}, {__mode = 'k'})

function meta:new(...)
    local obj = setmetatable({}, self)
    
    objs[obj] = true

    obj:init(...)
    
    return obj
end

function meta:tostring()
    return format('class %s', self.__name)
end

return setmetatable({}, {
    __call = function(mt, name, ...)
        local class = setmetatable({}, meta)
        local bases = {...}
        local getters = {}
        local setters = {}

        for i, b in ipairs(bases) do
            for n, f in pairs(b) do
                class[n] = f

                for k, v in pairs(b.__getters) do
                    getters[k] = v
                end

                for k, v in pairs(b.__setters) do
                    setters[k] = v
                end
            end
        end

        class.__name = name
        class.__bases = bases
        class.__getters = getters
        class.__setters = setters

        function class:__index(k)
            if getters[k] then
                return getters[k]
            else
                return class[k]
            end
        end

        function class:__newindex(k, v)
            if setters[k] then
                return setters[k](self, v)
            elseif class[k] or getters[k] then
                return error(format('cannot change protected property "%s.%s"', name, k))
            end
        end

        return class, getters, setters
    end
})