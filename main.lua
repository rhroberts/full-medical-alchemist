-- Full Medical Alchemist

-- In the criminal justice system, sexually based offenses are considered especially heinous.
-- In New York City, the dedicated detectives who investigate these vicious felonies are members 
-- of an elite squad known as the Special Victims Unit. 
-- These are their stories.

-- Load Modules / Libraries
-- local background = require"background"
local sti = require"3rd/sti/sti"
local physicker = require"physicker"
local frog = require"frog"

-- Declare Global Parameters Here
WindowWidth = love.graphics.getWidth()
WindowHeight = love.graphics.getHeight()

-- Define Local Parameters Here
local map = sti("assets/map/map.lua", {"box2d"})

-- A primary callback of LÖVE that is called only once
function love.load()
    World = love.physics.newWorld(0, 0)
    love.physics.setMeter(32)
    map:box2d_init(World)
    physicker:load()
    frog:load()
end

-- A primary callback of LÖVE that is called continuously
function love.update(dt)
    map:update(dt)
    physicker:update(dt)
    frog:update(dt)
end

-- A primary callback of LÖVE that is called continuously
function love.draw()
    map:drawTileLayer("Background")
    map:box2d_draw()
    physicker:draw()
    frog:draw()
end
