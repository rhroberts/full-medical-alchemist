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
local nav_scene = require"navigation_scene"
local alchemy_scene = require"alchemy_scene"

-- levels or scenes in our game.
local GameState = {
    current = nav_scene,
    scenes = {
        nav_scene,
        alchemy_scene
    },
    sx = 3,
    sy = 3

    -- TODO: callbacks for setting other scenes
}

-- A primary callback of LÖVE that is called only once
function love.load()
    GameState.current:load()
    for name, scene in pairs(GameState.scenes) do
        scene:load()
    end
end

-- A primary callback of LÖVE that is called continuously
function love.update(dt)
    GameState.current:update(dt)
end

-- A primary callback of LÖVE that is called continuously
function love.draw()
    GameState.current:draw(GameState.sx, GameState.sy)
end
