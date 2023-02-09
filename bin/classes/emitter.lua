local class          = require('../class')
local emitter        = class('emitter')
local insert, remove = table.insert, table.remove
local wrap           = coroutine.wrap

function register(self, data)
    local name   = data.name
    local events = self._events[name]

    if not events then
        self._events[name] = {}
    end

    insert(self._events[name], data)

    return data.fn
end

function emitter:init()
    self._events = {}
end

function emitter:on(name, fn)
    return register(self, {
        name = name,
        fn = fn,
        once = false
    })
end

function emitter:once(name, fn)
    return register(self, {
        name = name,
        fn = fn,
        once = true
    })
end

function emitter:emit(name, ...)
    local events = self._events[name]

    if not events then
        return
    end

    for i = 1, #events do
        local event = events[i]

        if event then
            if event.once then
                remove(events, i)
            end

            wrap(event.fn)(...)
        end
    end
end

return emitter
