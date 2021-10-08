-- Full Medical Alchemist

-- In the medicinal alchemy world, humoralism based treatments are considered especially unstable.
-- In Ballurdia, the dedicated physickers who investigate these dangerous practices are members 
-- of an elite group known as the Full Medical Alchemists. These are their stories.

-- Load Modules / Libraries

-- Declare Global Parameters Here
WindowWidth = love.graphics.getWidth()
WindowHeight = love.graphics.getHeight()
love.graphics.setDefaultFilter("nearest", "nearest")

-- Define Local Parameters Here
local navigationScene = require"navigation_scene"
local alchemyScene = require"alchemy_scene"
local titleScene = require"title_scene"
local enterPatientScene = require"enter_patients_scene"
local pauseScene = require"pause_scene"

-- levels or scenes in our game.
local GameState = {
    current = titleScene,
    scenes = {
        titleScene = titleScene,
        enterPatientScene = enterPatientScene,
        navigationScene = navigationScene,
        alchemyScene = alchemyScene,
        pauseScene = pauseScene
    },
    sx = 3,
    sy = 3
}

-- hooks for updating state. free to call from within
-- a scene.

function GameState:setTitleScene()
    self.current = self.scenes.titleScene
end

function GameState:setPauseScene()
    self.current = self.scenes.pauseScene
end

function GameState:setEnterPatientScene()
    self.current = self.scenes.enterPatientScene
end

function GameState:setNavigationScene()
    self.current = self.scenes.navigationScene
end

function GameState:setAlchemyScene()
    self.current = self.scenes.alchemyScene
end

-- A primary callback of LÖVE that is called only once
function love.load()
    pause = false
    GameState.current:load()
    for _, scene in pairs(GameState.scenes) do
        scene:load()
    end
end

-- A primary callback of LÖVE that is called continuously
function love.update(dt)
    GameState.current:update(dt, GameState)
end

function love.keyreleased(key)
    if key == "escape" then
        pause = not pause
    end
end

-- A primary callback of LÖVE that is called continuously
function love.draw()
    -- print(GameState.current.name)
    GameState.current:draw(GameState.sx, GameState.sy)
    
    -- Only for debugging
    -- With (36, 24) grids are 20 pixels by 20 pixels
    -- 720/36 = 20 pixels and 480/24 = 20 pixels
    -- debugGrid(36, 24)
end

-- Draws a grid over the window for debugging
function debugGrid(i, j)
    ww, wh = love.graphics.getDimensions()
    love.graphics.setColor(0,0,0, 0.2)
    for k = 1, i do
        for l = 1, j do
            love.graphics.rectangle("line", (k-1)*ww/i, (l-1)*wh/j, ww/i, wh/j)
        end
    end
    love.graphics.setColor(1,1,1,1)
end