-- Full Medical Alchemist

-- In the criminal justice system, sexually based offenses are considered especially heinous.
-- In New York City, the dedicated detectives who investigate these vicious felonies are members 
-- of an elite squad known as the Special Victims Unit. 
-- These are their stories.

-- Load Modules / Libraries

-- Declare Global Parameters Here
WindowWidth = love.graphics.getWidth()
WindowHeight = love.graphics.getHeight()

-- Define Local Parameters Here
local navigation_scene = require"navigation_scene"
local alchemy_scene = require"alchemy_scene"

-- levels or scenes in our game.
local GameState = {
    current = navigation_scene,
    scenes = {
        navigation_scene = navigation_scene,
        alchemy_scene = alchemy_scene
    },
    sx = 3,
    sy = 3
}

-- hooks for updating state. free to call from within
-- a scene.

function GameState:setNavigationScene()
    self.current = self.scenes.navigation_scene
end

function GameState:setAlchemyScene()
    self.current = self.scenes.alchemy_scene
end

-- A primary callback of LÖVE that is called only once
function love.load()
    GameState.current:load()
    for name, scene in pairs(GameState.scenes) do
        scene:load()
    end
end

-- A primary callback of LÖVE that is called continuously
function love.update(dt)
    GameState.current:update(dt, GameState)
end

-- A primary callback of LÖVE that is called continuously
function love.draw()
    -- print(GameState.current.name)
    GameState.current:draw(GameState.sx, GameState.sy)
end
