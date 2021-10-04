local scene = require"scene"
local patient = require"patient"

local enterPatientsScene = scene:new("enter_patients")

function enterPatientsScene:load()
end

function enterPatientsScene:update(dt)
end

function enterPatientsScene:draw()
end

return enterPatientsScene

--[[
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
]]