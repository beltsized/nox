local meta   = {}
local format = string.format
local insert = table.insert
local objs   = setmetatable({}, {
    __mode   = 'kv'
})

return setmetatable({}, {
    __call = function(mt, name, ...)
        local class = setmetatable({}, {
						__call = function(t, ...)
								local obj = setmetatable({}, t)

								insert(objs, obj)

								obj:init(...)

								return obj
						end
				end})
		
        local bases   = {...}
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

        class.__name    = name
        class.__bases   = bases
        class.__getters = getters
        class.__setters = setters

        function class:__index(k)
            if getters[k] then
                return getters[k](self)
            else
                return class[k]
            end
        end

        function class:__newindex(k, v)
            if setters[k] then
                return setters[k](self, v)
            else
                return rawset(self, k, v)
            end
        end
        
        function class:__tostring()
            return format('class: %s', self.__name)
        end

        return class, getters, setters
    end
})
