-- the main character, Mr. Physicker

local peachy = require("3rd.peachy")

-- only one physicker, so no metatable shenanigans here
local physicker = {
    x = 75,
    y = 30,
    xVel = 0,
    yVel = 0,
    vel = 50,
    animationName = "idle_fwd",
    xShifted = false,
    xDir = 1,
    spritesheetPath = "assets/sprites/physicker/physicker.png",
    asepriteMeta = "assets/sprites/physicker/physicker.json",
    locked = false,
    isLoaded = false  -- ensure physicker is only loaded once
}

function physicker:load()
    if not self.isLoaded then
        self.spritesheet = love.graphics.newImage(self.spritesheetPath)
        self.animation = {
            idle_fwd = peachy.new(self.asepriteMeta, self.spritesheet, "Idle_Fwd"),
            walk_fwd = peachy.new(self.asepriteMeta, self.spritesheet, "Walk_Fwd"),
            idle_bwd = peachy.new(self.asepriteMeta, self.spritesheet, "Idle_Bwd"),
            walk_bwd = peachy.new(self.asepriteMeta, self.spritesheet, "Walk_Bwd"),
            idle_side = peachy.new(self.asepriteMeta, self.spritesheet, "Idle_Side"),
            walk_side = peachy.new(self.asepriteMeta, self.spritesheet, "Walk_Side"),
        }
        self.width = self.animation[self.animationName]:getWidth()
        self.height = self.animation[self.animationName]:getHeight()
        -- physics
        self.body = love.physics.newBody(World, self.x, self.y, "dynamic")
        self.body:setFixedRotation(true)
        self.shape = love.physics.newRectangleShape(self.width, self.height)
        self.fixture = love.physics.newFixture(self.body, self.shape)
        -- sound effects
        self.soundEffects = {
            walking = love.audio.newSource("assets/audio/effects/walking.ogg", "static")
        }
        self.isLoaded = true
    end
end

function physicker:draw()
    local shift = self.xShifted and self.width or 0
    self.animation[self.animationName]:draw(
        self.body:getX() + shift - self.width / 2,
        self.body:getY() - self.height / 2,
        0, self.xDir, 1
    )
    -- draw the physics body (for debugging)
    if Env.FMA_DEBUG.value then
        love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
    end
end

function physicker:update(dt)
    if not self.locked then
        self:move()
    end
    self.animation[self.animationName]:update(dt)
    self:syncPhysics()
end

function physicker:move()
    -- Set upward animations
    if love.keyboard.isDown("w") then
        self.yVel = -self.vel
        self.animationName = "walk_bwd"
    -- Set downward animations
    elseif love.keyboard.isDown("s") then
        self.yVel = self.vel
        self.animationName = "walk_fwd"
    else
        self.yVel = 0
        if self.animationName == "walk_fwd" then
            self.animationName = "idle_fwd"
        elseif self.animationName == "walk_bwd" then
            self.animationName = "idle_bwd"
        end
    end
    -- Set left animations
    if love.keyboard.isDown("a") then
        if not self.xShifted then
            self.xShifted = true
        end
        self.xVel = -self.vel
        self.animationName = "walk_side"
        self.xDir = -1
    -- Set right animations
    elseif love.keyboard.isDown("d") then
        if self.xShifted then
            self.xShifted = false
        end
        self.xVel = self.vel
        self.animationName = "walk_side"
        self.xDir = 1
    -- Set idle animations
    else
        self.xVel = 0
        if self.animationName == "walk_side" then
            self.animationName = "idle_side"
        end
    end
    if (self.xVel ~= 0 or self.yVel ~= 0) and not self.soundEffects.walking:isPlaying() then
        self.soundEffects.walking:play()
    elseif self.xVel == 0 and self.yVel == 0 then
        self.soundEffects.walking:stop()
    end
end

function physicker:syncPhysics()
    self.body:setLinearVelocity(self.xVel, self.yVel)
    self.x, self.y = self.body:getPosition()
end

return physicker