-- the main character, Mr. Physicker

local peachy = require("3rd/peachy/peachy")

-- only one physicker, so no metatable shenanigans here
local physicker = {
    x = 0,
    y = 0,
    xVel = 0,
    yVel = 0,
}

function physicker:load()
    local spritesheet = love.graphics.newImage("assets/sprites/patient_1.png")
    local aseprite_meta = "assets/sprites/patient_1.json"
    self.animation = {
        idle_fwd = peachy.new(aseprite_meta, spritesheet, "Idle_Fwd"),
        walk_fwd = peachy.new(aseprite_meta, spritesheet, "Walk_Fwd"),
        idle_bwd = peachy.new(aseprite_meta, spritesheet, "Idle_Bwd"),
        walk_bwd = peachy.new(aseprite_meta, spritesheet, "Walk_Bwd"),
        idle_side = peachy.new(aseprite_meta, spritesheet, "Idle_Side"),
        walk_side = peachy.new(aseprite_meta, spritesheet, "Walk_Side"),
    }
end

function physicker:draw()
    self.animation["walk_fwd"]:draw(self.x, self.y)
end

function physicker:update(dt)
    self:move(dt)
    self.animation["walk_fwd"]:update(dt)
end

function physicker:move(dt)
    if love.keyboard.isDown("w") then
        self.y = self.y - self.yVel * dt
    end
    if love.keyboard.isDown("a") then
        self.x = self.x - self.xVel * dt
    end
    if love.keyboard.isDown("s") then
        self.y = self.y + self.yVel * dt
    end
    if love.keyboard.isDown("d") then
        self.x = self.x + self.xVel * dt
    end
end

return physicker