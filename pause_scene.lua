local scene = require"scene"

local pauseScene = scene:new("pauseScene")

function pauseScene:load()
end

function pauseScene:update(dt, gameState)

    if not NavTheme:isPlaying() then
        NavTheme:play()
    end
end

function pauseScene:draw(sx, sy)
    love.graphics.push()
    love.graphics.scale(sx, sy)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,1,1,1)
    love.graphics.pop()
end

return pauseScene