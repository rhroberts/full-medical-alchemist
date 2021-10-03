local peachy = require("3rd/peachy/peachy")

Scene = require "scene"

local alchemy_scene = Scene:new("alchemy")

function alchemy_scene:load()
    self.background = love.graphics.newImage("assets/alchemy_screen/alchemy_background.png")
    self.background_meta = "assets/alchemy_screen/alchemy_background.json"
    self.background_animation = peachy.new(self.background_meta, self.background, "Idle")
end


function alchemy_scene:update(dt)
    self.background_animation:update(dt)
end

function alchemy_scene:draw(sx, sy)
    love.graphics.push()
    love.graphics.scale(sx, sy)
    self.background_animation:draw()
    love.graphics.pop()
end

return alchemy_scene
