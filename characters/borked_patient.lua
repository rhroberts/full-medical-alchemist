-- a class for patients that get turned into things that run around randomly
-- so far just the frog and the cat
local peachy = require("3rd.peachy")

-- attributes common to all borked patients
local borked = {
    anim = "idle_fwd",
    yVel = 0,
    xVel = 0,
    xshift = 0,
    xdir = 1,
    duration = math.random()*2.0,
    accumulator = 0.0,
    direction = math.random(4),
    directions = {"w", "s", "a", "d"},
    action = false,
}

function borked:new(x0, y0, vel, spritesheetPath, metadataPath, keypress)
    -- unique attributes of borked patients
    local tbl = {
        x = x0,
        y = y0,
        vel = vel,
        spritesheetPath = spritesheetPath,
        metadataPath = metadataPath,
        keypress = keypress,  -- make borked patient appear manually
    }
    self.__index = self
    return setmetatable(tbl, self)
end

function borked:load()
    math.randomseed(os.time())
    self.spritesheet = love.graphics.newImage(self.spritesheetPath)
    self.animation = {
        idle_fwd = peachy.new(self.metadataPath, self.spritesheet, "Idle_Fwd"),
        walk_fwd = peachy.new(self.metadataPath, self.spritesheet, "Walk_Fwd"),
        idle_bwd = peachy.new(self.metadataPath, self.spritesheet, "Idle_Bwd"),
        walk_bwd = peachy.new(self.metadataPath, self.spritesheet, "Walk_Bwd"),
        idle_side = peachy.new(self.metadataPath, self.spritesheet, "Idle_Side"),
        walk_side = peachy.new(self.metadataPath, self.spritesheet, "Walk_Side"),
    }
    self.width = self.animation["idle_fwd"]:getWidth()
    self.height = self.animation["idle_fwd"]:getHeight()
    self.physics = {
        body = love.physics.newBody(World, self.x, self.y, "dynamic"),
        shape = love.physics.newRectangleShape(self.width, self.height)
    }
    self.physics.body:setFixedRotation(true)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.meow = love.audio.newSource("assets/audio/effects/cat.ogg", "static")
end

function borked:draw()
    if self.spawn then
        self.animation[self.anim]:draw(
            self.x + self.xshift - width / 2, self.y - height / 2, 0, self.xdir, 1
        )
    end
end

function borked:syncPhysics()
	self.x, self.y = self.physics.body:getPosition()
	self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function borked:update(dt)
    -- Spawn the cat
    if love.keyboard.isDown(self.keypress) then
        self.spawn = true
        if not self.meow:isPlaying() then
            self.meow:play()
        end
    end
    -- Process time accumulation
    if self.spawn then
        self:syncPhysics()
        self.accumulator = self.accumulator + dt
        if self.accumulator > self.duration then
            self.direction = math.random(4)
            self.accumulator = 0
            self.duration = math.random()*2.0
            self.action = not self.action
        end
        self:move(dt)
        self.animation[self.anim]:update(dt)
    end
end

function borked:move(dt)
    -- Define current direction
    local dir = self.directions[self.direction]
    -- Set upward animations
    if dir == "w" and self.action then
        self.yVel = -self.vel
        self.anim = "walk_bwd"
    -- Set downward animations
    elseif dir == "s" and self.action then
        self.yVel = self.vel
        self.anim = "walk_fwd"
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
    if dir == "a" and self.action then
        self.xVel = -self.vel
        self.anim = "walk_side"
        self.xdir = -1
        self.xshift = self.animation[self.anim]:getWidth()
    -- Set right animations
    elseif dir == "d" and self.action then
        self.xVel = self.vel
        self.anim = "walk_side"
        self.xdir = 1
        self.xshift = 0
    -- Set idle animations
    else
        self.xVel = 0
        if self.anim == "walk_side" then
            self.anim = "idle_side"
        end
    end
end

return borked