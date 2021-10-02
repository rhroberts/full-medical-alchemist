-- The background of the game. 

local peachy = require"3rd/peachy"

-- Only one background, so no metatable shenanigans here
local background = {
    x = 120,
    y = 80,
}

function background:load()
    self.sprite = peachy.new("assets/map/background.png")
end

function background:draw()
end

function background:update(dt)
end

return background