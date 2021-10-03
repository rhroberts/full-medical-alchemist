-- Full Medical Alchemist

-- In the criminal justice system, sexually based offenses are considered especially heinous.
-- In New York City, the dedicated detectives who investigate these vicious felonies are members 
-- of an elite squad known as the Special Victims Unit. 
-- These are their stories.
love.graphics.setDefaultFilter("nearest", "nearest")

-- Load Modules / Libraries
local physicker = require"physicker"
local frog = require"frog"
local Alchemy = require"alchemy/alchemy"

-- Declare Global Parameters Here
WindowWidth = love.graphics.getWidth()
WindowHeight = love.graphics.getHeight()

-- Define Local Parameters Here

-- A primary callback of LÖVE that is called only once
function love.load()
    Alchemy:load()
    physicker:load()
    frog:load()

    lavender = Alchemy:get_ingredient("lavender")
    salve = Alchemy:mix_two(lavender, lavender)
    -- salve = Alchemy:get_concoction("salve")
end

-- A primary callback of LÖVE that is called continuously
function love.update(dt)
    physicker:update(dt)
    frog:update(dt)
    lavender:update(dt)
    -- salve:update(dt)
end

-- A primary callback of LÖVE that is called continuously
function love.draw()
    love.graphics.push()
    love.graphics.scale(3, 3)
    physicker:draw()
    frog:draw()

    lavender:draw(50, 10)
    salve:draw(50, 30)
    love.graphics.pop()
end
