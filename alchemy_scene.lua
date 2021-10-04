local peachy = require"3rd/peachy/peachy"
local scene = require"scene"

local alchemy_scene = scene:new("alchemy")

function alchemy_scene:load()
    self.background = love.graphics.newImage("assets/alchemy_screen/alchemy_background.png")
    self.background_meta = "assets/alchemy_screen/alchemy_background.json"
    self.background_animation = peachy.new(self.background_meta, self.background, "Idle")
end


function alchemy_scene:update(dt, gamestate)
    self.background_animation:update(dt)

    if love.keyboard.isDown("q") then
        gamestate:setNavigationScene()
    end
end

function alchemy_scene:draw(sx, sy)
    love.graphics.push()
    love.graphics.scale(sx, sy)
    self.background_animation:draw()
    love.graphics.pop()
end

return alchemy_scene
