
-- The scene interface. A scene must implement
-- the standard love callbacks.

local Scene = {}

function Scene:new(name)
    local new = {
        name = name
    }
    setmetatable(new, {__index = self})
    return new
end

function Scene:draw()
    assert(false, "A Scene must implement draw")
end


function Scene:load()
    assert(false, "A Scene must implement load")
end

function Scene:update()
    assert(false, "A Scene must implement update")

end

return Scene