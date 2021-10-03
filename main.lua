-- Full Medical Alchemist

-- In the criminal justice system, sexually based offenses are considered especially heinous.
-- In New York City, the dedicated detectives who investigate these vicious felonies are members 
-- of an elite squad known as the Special Victims Unit. 
-- These are their stories.

-- Load Modules / Libraries
local sti = require "3rd/sti/sti"
local physicker = require"physicker"
local frog = require"frog"

-- Declare Global Parameters Here
WindowWidth = love.graphics.getWidth()
WindowHeight = love.graphics.getHeight()

-- Define Local Parameters Here

-- A primary callback of LÖVE that is called only once
function love.load()
    -- Load map file
    Map = sti("assets/map/map_test.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(BeginContact, EndContact)
    Map:box2d_init(World)
    Map.layers.Walls.visible = false

    physicker:load()
    frog:load()
end

-- A primary callback of LÖVE that is called continuously
function love.update(dt)
    World:update(dt)
    physicker:update(dt)
    frog:update(dt)
end

-- A primary callback of LÖVE that is called continuously
function love.draw()
    Map:draw(0, 0, 3, 3)
    -- Map:box2d_draw(0, 0, 3, 3)
    physicker:draw()
    frog:draw()
end

function BeginContact(a, b, collision)
    physicker:beginContact(a, b, collision)
    frog:beginContact(a, b, collision)
end

function EndContact(a, b, collision)
    physicker:endContact(a, b, collision)
    frog:endContact(a, b, collision)
end
