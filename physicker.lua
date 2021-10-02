-- the main character, Mr. Physicker

local peachy = require("3rd/peachy/peachy")

-- only one physicker, so no metatable shenanigans here
local physicker = {
    x = 0,
    y = 0,
    xVel = 50,
    yVel = 50,
    anim = "idle_fwd",
}
local keypress = "d"
local xshift = 0
local xdir = 1

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
    love.graphics.push()
	love.graphics.scale(3, 3)
    self.animation[self.anim]:draw(self.x+xshift, self.y, 0, xdir, 1)
    love.graphics.pop()
end

function physicker:update(dt)
    self:move(dt)
    self.animation[self.anim]:update(dt)
end

function physicker:move(dt)
    -- Set upward animations
    if love.keyboard.isDown("w") then
        self.y = self.y - self.yVel * dt
        self.anim = "walk_bwd"
        keypress = "w"
    -- Set left animations
    elseif love.keyboard.isDown("a") then
        self.x = self.x - self.xVel * dt
        self.anim = "walk_side"
        keypress = "a"
        xdir = -1
        xshift = self.animation[self.anim]:getWidth()
    -- Set downward animations
    elseif love.keyboard.isDown("s") then
        self.y = self.y + self.yVel * dt
        self.anim = "walk_fwd"
        keypress = "s"
    -- Set right animations
    elseif love.keyboard.isDown("d") then
        self.x = self.x + self.xVel * dt
        self.anim = "walk_side"
        keypress = "d"
        xdir = 1
        xshift = 0
    -- Set idle animations
    else
        if self.anim == "walk_fwd" then
            self.anim = "idle_fwd"
        elseif self.anim == "walk_bwd" then
            self.anim = "idle_bwd"
        elseif self.anim == "walk_side" then
            self.anim = "idle_side"
        end
    end
    
end

return physicker