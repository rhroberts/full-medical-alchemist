--[[

Full Medical Alchemist ("FMA")

In the medicinal alchemy world, humoralism based treatments are considered especially unstable.
In Ballurdia, the dedicated physickers who investigate these dangerous practices are members
of an elite group known as the Full Medical Alchemists. These are their stories.

]]

-- make pixels look pixely; call this at the top, before loading scenes!
love.graphics.setDefaultFilter("nearest", "nearest")

local graphicsUtils = require"utils.graphics"

-- Load Modules / Libraries
NavigationScene = require"scenes.navigation_scene"
AlchemyScene = require"scenes.alchemy_scene"
TitleScene = require"scenes.title_scene"
EnterPatientsScene = require"scenes.enter_patients_scene"

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
        EnterPatientsScene = EnterPatientsScene,
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
    self.current = self.scenes.EnterPatientsScene
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
    -- TODO: Should we load all scenes at the outset, or only as needed?
    for _, scene in pairs(GameState.scenes) do
        scene:load()
    end
end

-- A primary callback of LÖVE that is called continuously
function love.update(dt)
    World:update(dt)
    GameState.current:update(dt, GameState)
end

-- A primary callback of LÖVE that is called continuously
function love.draw()
    GameState.current:draw(GameState.sx, GameState.sy)

    if Env.FMA_DEBUG.value then
        -- With (36, 24) grids are 20 pixels by 20 pixels
        -- 720/36 = 20 pixels and 480/24 = 20 pixels
        graphicsUtils.debugGrid(36, 24)
    end
end