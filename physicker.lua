-- the main character, Mr. Physicker

local peachy = require("3rd/peachy/peachy")

-- only one physicker, so no metatable shenanigans here
local physicker = {
    x = 40,
    y = 100,
    xVel = 0,
    yVel = 0,
    vel = 50,
    anim = "idle_fwd",
}
local keypress = "d"
local xshift = 0
local xdir = 1

function physicker:load()
    local spritesheet = love.graphics.newImage("assets/sprites/patients/patient_1.png")
    local aseprite_meta = "assets/sprites/patients/patient_1.json"
    self.animation = {
        idle_fwd = peachy.new(aseprite_meta, spritesheet, "Idle_Fwd"),
        walk_fwd = peachy.new(aseprite_meta, spritesheet, "Walk_Fwd"),
        idle_bwd = peachy.new(aseprite_meta, spritesheet, "Idle_Bwd"),
        walk_bwd = peachy.new(aseprite_meta, spritesheet, "Walk_Bwd"),
        idle_side = peachy.new(aseprite_meta, spritesheet, "Idle_Side"),
        walk_side = peachy.new(aseprite_meta, spritesheet, "Walk_Side"),
    }
    width = self.animation["idle_fwd"]:getWidth()
    height = self.animation["idle_fwd"]:getHeight()
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.shape = love.physics.newRectangleShape(width, height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function physicker:draw()
    love.graphics.push()
	love.graphics.scale(3, 3)
    self.animation[self.anim]:draw(self.x+xshift-width/2, self.y-height/2, 0, xdir, 1)
    love.graphics.pop()
end

function physicker:update(dt)
    self:syncPhysics()
    self:move(dt)
    self.animation[self.anim]:update(dt)
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
        self.anim = "walk_bwd"
        keypress = "w"
    -- Set downward animations
    elseif love.keyboard.isDown("s") then
        self.yVel = self.vel
        -- self.y = self.y + self.vel * dt
        self.anim = "walk_fwd"
        keypress = "s"
    -- Set idle animations
    else
        self.yVel = 0
        if self.anim == "walk_fwd" then
            self.anim = "idle_fwd"
        elseif self.anim == "walk_bwd" then
            self.anim = "idle_bwd"
        end
    end
    -- Set left animations
    if love.keyboard.isDown("a") then
        self.xVel = -self.vel
        -- self.x = self.x - self.vel * dt
        self.anim = "walk_side"
        keypress = "a"
        xdir = -1
        xshift = self.animation[self.anim]:getWidth()
    -- Set right animations
    elseif love.keyboard.isDown("d") then
        self.xVel = self.vel
        -- self.x = self.x + self.vel * dt
        self.anim = "walk_side"
        keypress = "d"
        xdir = 1
        xshift = 0
    -- Set idle animations
    else
        self.xVel = 0
        if self.anim == "walk_side" then
            self.anim = "idle_side"
        end
    end
    
end

function physicker:beginContact(a, b, collision)
    if self.ygrounded == true then return end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        end
    end
end

function physicker:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentYCollision == collision then
            self.ygrounded = false
        end
    end
end

function physicker:land(collision)
    self.currentYCollision = collision
    self.ygrounded = true
end

return physicker