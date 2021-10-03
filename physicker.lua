-- the main character, Mr. Physicker

local peachy = require("3rd/peachy/peachy")

-- only one physicker, so no metatable shenanigans here
local physicker = {
    x = 40,
    y = 100,
    xVel = 0,
    yVel = 0,
    vel = 50,
    animationName = "idle_fwd",
    xShift = 0,
    yShift = 0,
    xColliding = false,
    yColliding = false,
    xDirection = 1,
    spritesheet = love.graphics.newImage("assets/sprites/patients/patient_1.png"),
    asepriteMeta = "assets/sprites/patients/patient_1.json"
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
end

function physicker:draw()
    love.graphics.push()
	love.graphics.scale(3, 3)
    self.animation[self.animationName]:draw(
        self.x + self.xShift - self.width / 2, self.y - self.yShift - self.height / 2,
        0, self.xDir, 1
    )
    love.graphics.pop()
end

function physicker:update(dt)
    self:move(dt)
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
    -- Set idle animations
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
    
end

function physicker:beginContact(a, b, collision)
    if self.yColliding == true then return end
    local _, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:collide(collision)
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:collide(collision)
        end
    end
end

function physicker:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentYCollision == collision then
            self.yColliding = false
        end
    end
end

function physicker:collide(collision)
    self.currentYCollision = collision
    self.yColliding = true
end

return physicker