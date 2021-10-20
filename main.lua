--[[

Full Medical Alchemist ("FMA")

In the medicinal alchemy world, humoralism based treatments are considered especially unstable.
In Ballurdia, the dedicated physickers who investigate these dangerous practices are members
of an elite group known as the Full Medical Alchemists. These are their stories.

]]

-- make pixels look pixel-y; call this before loading scenes!
love.graphics.setDefaultFilter("nearest", "nearest")

-- Load Modules / Libraries
NavigationScene = require"scenes.navigation_scene"
AlchemyScene = require"scenes.alchemy_scene"
TitleScene = require"scenes.title_scene"
EnterPatientScene = require"scenes.enter_patients_scene"

-- Declare Global Parameters Here
WindowWidth = love.graphics.getWidth()
WindowHeight = love.graphics.getHeight()
Env = require"utils.env"

-- levels or scenes in our game.
local GameState = {
    -- start at title unless otherwise specified in Env
    current = Env.FMA_SCENE.value and _G[Env.FMA_SCENE.value] or TitleScene,
    -- current = TitleScene,
    scenes = {
        TitleScene = TitleScene,
        EnterPatientScene = EnterPatientScene,
        NavigationScene = NavigationScene,
        AlchemyScene = AlchemyScene
    },
    sx = 3,  -- x scale
    sy = 3   -- y scale
}

-- hooks for updating state. free to call from within
-- a scene.

function GameState:setTitleScene()
    self.current = self.scenes.TitleScene
end

function GameState:setEnterPatientScene()
    self.current = self.scenes.EnterPatientScene
end

function GameState:setNavigationScene()
    self.current = self.scenes.NavigationScene
end

function GameState:setAlchemyScene()
    self.current = self.scenes.AlchemyScene
end

-- A primary callback of LÖVE that is called only once
function love.load()
    World = love.physics.newWorld(0, 0)
    for _, scene in pairs(GameState.scenes) do
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
    
    -- Only for debugging
    -- With (36, 24) grids are 20 pixels by 20 pixels
    -- 720/36 = 20 pixels and 480/24 = 20 pixels
    -- debugGrid(36, 24)
end

-- Draws a grid over the window for debugging
local function debugGrid(i, j)
    local ww, wh = love.graphics.getDimensions()
    love.graphics.setColor(0,0,0, 0.2)
    for k = 1, i do
        for l = 1, j do
            love.graphics.rectangle("line", (k-1)*ww/i, (l-1)*wh/j, ww/i, wh/j)
        end
    end
    love.graphics.setColor(1,1,1,1)
end
