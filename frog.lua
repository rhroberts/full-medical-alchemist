-- the main character, Mr. frog

local peachy = require("3rd/peachy/peachy")

-- only one frog, so no metatable shenanigans here
local frog = {
    spawn = false,
    x = 50,
    y = 50,
    xVel = 50,
    yVel = 50,
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

function frog:load()
    local spritesheet = love.graphics.newImage("assets/sprites/patients/frog.png")
    local aseprite_meta = "assets/sprites/patients/frog.json"
    self.animation = {
        idle_fwd = peachy.new(aseprite_meta, spritesheet, "Idle_Fwd"),
        walk_fwd = peachy.new(aseprite_meta, spritesheet, "Walk_Fwd"),
        idle_bwd = peachy.new(aseprite_meta, spritesheet, "Idle_Bwd"),
        walk_bwd = peachy.new(aseprite_meta, spritesheet, "Walk_Bwd"),
        idle_side = peachy.new(aseprite_meta, spritesheet, "Idle_Side"),
        walk_side = peachy.new(aseprite_meta, spritesheet, "Walk_Side"),
    }
    math.randomseed(os.time())
end

function frog:draw()
    if self.spawn then
        love.graphics.push()
        love.graphics.scale(3, 3)
        self.animation[self.anim]:draw(self.x+xshift, self.y, 0, xdir, 1)
        love.graphics.pop()
    end
    love.graphics.print("Duration: ", 400, 25)
	love.graphics.print(duration, 500, 25)
    love.graphics.print("Accumulator: ", 400, 50)
	love.graphics.print(accumulator, 500, 50)
    love.graphics.print("Action: ", 400, 75)
	love.graphics.print(tostring(action), 500, 75)
end

function frog:update(dt)
    -- Spawn the frog
    if love.keyboard.isDown("y") then
        self.spawn = true
    end
    -- Process time accumulation
    if self.spawn then
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

function frog:move(dt)
    -- Define current direction
    local dir = directions[direction]
    -- Set upward animations
    if dir == "w" and action then
        self.y = self.y - self.yVel * dt
        self.anim = "walk_bwd"
        keypress = "w"
    -- Set downward animations
    elseif dir == "s" and action then
        self.y = self.y + self.yVel * dt
        self.anim = "walk_fwd"
        keypress = "s"
    -- Set idle animations
    else
        if self.anim == "walk_fwd" then
            self.anim = "idle_fwd"
        elseif self.anim == "walk_bwd" then
            self.anim = "idle_bwd"
        end
    end
    -- Set left animations
    if dir == "a" and action then
        self.x = self.x - self.xVel * dt
        self.anim = "walk_side"
        keypress = "a"
        xdir = -1
        xshift = self.animation[self.anim]:getWidth()
    -- Set right animations
    elseif dir == "d" and action then
        self.x = self.x + self.xVel * dt
        self.anim = "walk_side"
        keypress = "d"
        xdir = 1
        xshift = 0
    -- Set idle animations
    else
        if self.anim == "walk_side" then
            self.anim = "idle_side"
        end
    end
    
end

return frog