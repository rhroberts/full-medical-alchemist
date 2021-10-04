-- the main character, Mr. cat

local peachy = require("3rd/peachy/peachy")

-- only one cat, so no metatable shenanigans here
local cat = {
    -- spawn = true,
    x = 200,
    y = 100,
    xVel = 0,
    yVel = 0,
    vel = 50,
    anim = "idle_fwd",
}
local keypress = "d"
local xshift = 0
local xdir = 1
local duration = math.random()*2.0
local accumulator = 0.0
local direction = math.random(4)
local directions = {"w", "s", "a", "d"}
local action = false

function cat:load()
    local spritesheet = love.graphics.newImage("assets/sprites/patients/cat.png")
    local aseprite_meta = "assets/sprites/patients/cat.json"
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
    math.randomseed(os.time())
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.shape = love.physics.newRectangleShape(width, height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.meow = love.audio.newSource("assets/audio/effects/cat.ogg", "static")
end

function cat:draw()
    if self.spawn then
        self.animation[self.anim]:draw(self.x+xshift-width/2, self.y-height/2, 0, xdir, 1)
    end
    love.graphics.print("Duration: ", 400, 25)
	love.graphics.print(duration, 500, 25)
    love.graphics.print("Accumulator: ", 400, 50)
	love.graphics.print(accumulator, 500, 50)
    love.graphics.print("Action: ", 400, 75)
	love.graphics.print(tostring(action), 500, 75)
end

function cat:syncPhysics()
	self.x, self.y = self.physics.body:getPosition()
	self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function cat:update(dt)
    -- Spawn the cat
    if love.keyboard.isDown("u") then
        self.spawn = true
        if not self.meow:isPlaying() then
            self.meow:play()
        end
    end
    -- Process time accumulation
    if self.spawn then
        self:syncPhysics()
        accumulator = accumulator + dt
        if accumulator > duration then
            direction = math.random(4)
            accumulator = 0
            duration = math.random()*2.0
            action = not action
        end
        self:move(dt)
        self.animation[self.anim]:update(dt)
    end
end

function cat:move(dt)
    -- Define current direction
    local dir = directions[direction]
    -- Set upward animations
    if dir == "w" and action then
        self.yVel = -self.vel
        -- self.y = self.y - self.yVel * dt
        self.anim = "walk_bwd"
        keypress = "w"
    -- Set downward animations
    elseif dir == "s" and action then
        self.yVel = self.vel
        -- self.y = self.y + self.yVel * dt
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
    if dir == "a" and action then
        self.xVel = -self.vel
        -- self.x = self.x - self.xVel * dt
        self.anim = "walk_side"
        keypress = "a"
        xdir = -1
        xshift = self.animation[self.anim]:getWidth()
    -- Set right animations
    elseif dir == "d" and action then
        self.xVel = self.vel
        -- self.x = self.x + self.xVel * dt
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

function cat:beginContact(a, b, collision)
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

function cat:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentYCollision == collision then
            self.ygrounded = false
        end
    end
end

function cat:land(collision)
    self.currentYCollision = collision
    self.ygrounded = true
end

return cat