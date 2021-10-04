local peachy = require("3rd/peachy/peachy")
local textbox = require"textbox"

Patient = {}

function Patient:new(n, bed, delay)
<<<<<<< HEAD
=======
    
>>>>>>> dce7644f3c201e6f1b3dc82e927d7c3aeae06e35
    print("Patient is #"..tostring(n).." going to bed #1 after "..tostring(delay).." seconds!")
    self.spritesheet = love.graphics.newImage("assets/sprites/patients/patient_" .. tostring(n) .. ".png")
    self.asepriteMeta = "assets/sprites/patients/patient_" .. tostring(n) .. ".json"
    self.n = n
    self.x = 112
    self.y = 171
    self.delay = delay
    self.bed = bed
    self.accumulator = 0
    self.vel = 50  -- default velocity to apply to xVel or yVel
    self.animationName = "idle_bwd"
    self.xShift = 0  -- so turning around doesn't look jumpy
    self.xDir = 1
    self.greeting = textbox("Hello Mr. Physicker!")
<<<<<<< HEAD
    self.speak = false
=======
    self.greeting.load()
    self.speak = false

>>>>>>> dce7644f3c201e6f1b3dc82e927d7c3aeae06e35
    self.__index = self
    return setmetatable({}, self)
end

function Patient:load()
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
<<<<<<< HEAD
    self.greeting.load()
=======
>>>>>>> dce7644f3c201e6f1b3dc82e927d7c3aeae06e35
end

function Patient:draw()
    self.animation[self.animationName]:draw(
        self.x + self.xShift - self.width / 2, self.y - self.height / 2,
        0, self.xDir, 1
    )
    if self.speak then
        love.graphics.pop()
        self.greeting.draw(self.x, self.y)
        love.graphics.push()
        love.graphics.scale(GlobalScale, GlobalScale)
    end
end

function Patient:update(dt)
    self:move(dt)
    self.animation[self.animationName]:update(dt)
    self.greeting.update(dt)
end

function Patient:move(dt)
<<<<<<< HEAD
    self.x = self.x + self.x * self.vel
    self.y = self.y + self.y * self.vel
=======
    -- print(self.accumulator-self.delay)
    --if self.accumulator - self.delay > 0 then
        if self.bed == 1 then
            if self.accumulator < 1.9 then
                self.y = self.y - self.vel * dt
                self.animationName = "walk_bwd"
            elseif self.accumulator < 3.0 then
                self.animationName = "idle_bwd"
                self.speak = true
            elseif self.accumulator < 4.1 then
                self.x = self.x + self.vel * dt
                self.animationName = "walk_side"
                self.xDir = 1
                self.xShift = 0
                self.speak = false
            elseif self.accumulator < 5.15 then
                self.y = self.y - self.vel * dt
                self.animationName = "walk_bwd"
            elseif self.accumulator < 6.27 then
                self.x = self.x + self.vel * dt
                self.animationName = "walk_side"
                self.xDir = 1
                self.xShift = 0
            else
                self.animationName = "idle_fwd"
            end
        elseif self.bed == 2 then
            if self.accumulator < 1.9 then
                self.y = self.y - self.vel * dt
                self.animationName = "walk_bwd"
            elseif self.accumulator < 3.0 then
                self.animationName = "idle_bwd"
                self.speak = true
            elseif self.accumulator < 4.1 then
                self.x = self.x + self.vel * dt
                self.animationName = "walk_side"
                self.xDir = 1
                self.xShift = 0
                self.speak = false
            elseif self.accumulator < 5.2 then
                self.y = self.y + self.vel * dt
                self.animationName = "walk_fwd"
            elseif self.accumulator < 6.28 then
                self.x = self.x + self.vel * dt
                self.animationName = "walk_side"
                self.xDir = 1
                self.xShift = 0
            else
                self.animationName = "idle_fwd"
            end
        elseif self.bed == 3 then
            if self.accumulator < 1.9 then
                self.y = self.y - self.vel * dt
                self.animationName = "walk_bwd"
            elseif self.accumulator < 3.0 then
                self.animationName = "idle_bwd"
                self.speak = true
            elseif self.accumulator < 3.3 then
                self.y = self.y - self.vel * dt
                self.animationName = "walk_bwd"
                self.speak = false
            elseif self.accumulator < 4.5 then
                self.x = self.x - self.vel * dt
                self.animationName = "walk_side"
                self.xDir = -1
                self.xShift = self.animation[self.animationName]:getWidth()
            elseif self.accumulator < 5.175 then
                self.y = self.y + self.vel * dt
                self.animationName = "walk_fwd"
            elseif self.accumulator < 5.882 then
                self.x = self.x - self.vel * dt
                self.animationName = "walk_side"
                self.xDir = -1
                self.xShift = self.animation[self.animationName]:getWidth()
            else
                self.animationName = "idle_fwd"
            end
        elseif self.bed == 4 then
            if self.accumulator < 1.9 then
                self.y = self.y - self.vel * dt
                self.animationName = "walk_bwd"
            elseif self.accumulator < 3.0 then
                self.animationName = "idle_bwd"
                self.speak = true
            elseif self.accumulator < 3.3 then
                self.y = self.y - self.vel * dt
                self.animationName = "walk_bwd"
                self.speak = false
            elseif self.accumulator < 4.5 then
                self.x = self.x - self.vel * dt
                self.animationName = "walk_side"
                self.xDir = -1
                self.xShift = self.animation[self.animationName]:getWidth()
            elseif self.accumulator < 5.975 then
                self.y = self.y + self.vel * dt
                self.animationName = "walk_fwd"
            elseif self.accumulator < 6.685 then
                self.x = self.x - self.vel * dt
                self.animationName = "walk_side"
                self.xDir = -1
                self.xShift = self.animation[self.animationName]:getWidth()
            else
                self.animationName = "idle_fwd"
            end
        end
    --end
    
    self.accumulator = self.accumulator + dt
    
>>>>>>> dce7644f3c201e6f1b3dc82e927d7c3aeae06e35
end

return Patient