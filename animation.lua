local function animation(pathToSpriteSheet, frameWidth, frameHeight, numFrames)

    local spriteSheet = love.graphics.newImage(pathToSpriteSheet)
    local frames = {}  -- table of love.graphics.Quad objects
    local state = {
        currentFrame = 1,
        timer = 0
    }

    -- load, draw, and update closures that alter animation state
    local loadAnimation = function ()
        for i = 0, numFrames do
            frames[i + 1] = love.graphics.newQuad(
                frameWidth * i, 0, frameWidth, frameHeight, spriteSheet:getDimensions()
            )
        end
    end

    local drawAnimation = function (x, y)
        love.graphics.draw(spriteSheet, frames[state.currentFrame], x, y)
    end

    local updateAnimation = function (rate, dt)
        state.timer = state.timer + dt
        if state.timer > 1 / (rate * numFrames) then
            state.currentFrame = state.currentFrame + 1 < numFrames and state.currentFrame + 1 or 1
            state.timer = 0
        end
    end

    -- public functions
    return {
        load = loadAnimation,
        draw = drawAnimation,
        update = updateAnimation
    }

end

return animation