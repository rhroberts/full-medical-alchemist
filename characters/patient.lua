local peachy = require"3rd/peachy/peachy"
local textbox = require"ui/textbox"

Patient = {}

function Patient:new(n, bed, delay)
    self.n = n
    self.delay = delay
    self.bed = bed
    self.x = 112
    self.y = 171
    self.accumulator = 0
    self.vel = 50  -- default velocity to apply to xVel or yVel
    self.animationName = "idle_bwd"
    self.xShift = 0  -- so turning around doesn't look jumpy
    self.xDir = 1
    self.greeting = textbox("Hello Mr. Physicker!")
    self.speak = false
    self.spritesheet = love.graphics.newImage("assets/sprites/patients/patient_" .. tostring(self.n) .. ".png")
    self.asepriteMeta = "assets/sprites/patients/patient_" .. tostring(self.n) .. ".json"
    self.__index = self
    return setmetatable({}, self)
end

function Patient:load(delay)
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
    self.delay = delay
    self.greeting.load()
    -- print("Patient is #"..tostring(self.n).." going to bed #"..tostring(self.bed).." after "..tostring(self.delay).." seconds!")
end

function Patient:draw()
    self.animation[self.animationName]:draw(
        self.x + self.xShift - self.width / 2, self.y - self.height / 2,
        0, self.xDir, 1
    )
    if self.speak then
        love.graphics.pop()
        self.greeting.draw(self.x*GlobalScale + self.width, self.y*GlobalScale - GlobalScale*self.height*1.2)
        love.graphics.push()
        love.graphics.scale(GlobalScale, GlobalScale)
    end
end

function Patient:update(dt)
    self.animation[self.animationName]:update(dt)
    self.greeting.update(dt)
end

return Patient