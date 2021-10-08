-- the main character, Mr. Physicker

local peachy = require("3rd/peachy/peachy")

-- only one physicker, so no metatable shenanigans here
local physicker = {
    x = 112,
    y = 30,
    xVel = 0,
    yVel = 0,
    vel = 50,  -- default velocity to apply to xVel or yVel
    animationName = "idle_fwd",
    xShift = 0,  -- so turning around doesn't look jumpy
    xDir = 1,
    spritesheet = love.graphics.newImage("assets/sprites/physicker/physicker.png"),
    asepriteMeta = "assets/sprites/physicker/physicker.json",
    locked = false
}

function physicker:load()
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
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.soundEffects = {
        walking = love.audio.newSource("assets/audio/effects/walking.ogg", "static")
    }
end

function physicker:draw()
    self.animation[self.animationName]:draw(
        self.x + self.xShift - self.width / 2, self.y - self.height / 2,
        0, self.xDir, 1
    )
end

function physicker:update(dt)
    if not pause then
        self.locked = false
    end
    if not self.locked then
        self:move(dt)
        self.animation[self.animationName]:play()
    else
        self.yVel = 0
        self.xVel = 0
        self.animation[self.animationName]:pause()
    end
    self.animation[self.animationName]:update(dt)
    self:syncPhysics()
end

function physicker:syncPhysics()
	self.x, self.y = self.physics.body:getPosition()
	self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function physicker:move(dt)
    -- Set upward animations
    if love.keyboard.isDown("w") then
        self.yVel = -self.vel
        -- self.y = self.y - self.vel * dt
        self.animationName = "walk_bwd"
    -- Set downward animations
    elseif love.keyboard.isDown("s") then
        self.yVel = self.vel
        -- self.y = self.y + self.vel * dt
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
        self.xVel = -self.vel
        -- self.x = self.x - self.vel * dt
        self.animationName = "walk_side"
        self.xDir = -1
        self.xShift = self.animation[self.animationName]:getWidth()
    -- Set right animations
    elseif love.keyboard.isDown("d") then
        self.xVel = self.vel
        -- self.x = self.x + self.vel * dt
        self.animationName = "walk_side"
        self.xDir = 1
        self.xShift = 0
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

function physicker:beginContact(a, b, collision)
    -- side effects go here
end

function physicker:endContact(a, b, collision)
    -- side effects go here
end

function physicker:collide(collision)
    -- self.currentCollision = collision
    -- self.colliding = false
end

return physicker