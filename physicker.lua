-- the main character, Mr. Physicker

local peachy = require"3rd/peachy"

-- only one physicker, so no metatable shenanigans here
local physicker = {
    x = 0,
    y = 0,
    xVel = 0,
    yVel = 0,
}

function physicker:load()
    self.sprite = peachy.new("assets/sprites/patient_1_fwd.json")
end

function physicker:draw()
end

function physicker:update(dt)
end

function physicker:move(dt)
end

return physicker