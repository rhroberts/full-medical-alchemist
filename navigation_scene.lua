Scene = require "scene"

local sti = require "3rd/sti/sti"
local physicker = require"physicker"
local frog = require"frog"
local textbox = require"textbox"

local nav_scene = Scene:new("navigation")

function nav_scene:load() 
    -- Load map file
    Map = sti("assets/map/map_test.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(BeginContact, EndContact)
    Map:box2d_init(World)
    Map.layers.Walls.visible = false

    physicker:load()
    frog:load()
    Greeting = textbox(
        "Move around, bro! Work the room. Explore this beautiful world."
    )
    Greeting:load()
end

function nav_scene:update(dt)
    World:update(dt)
    physicker:update(dt)
    frog:update(dt)
end

function nav_scene:draw(sx, sy)
    love.graphics.push()
    love.graphics.scale(sx, sy)
    Map:draw(0, 0, sx, sy)
    physicker:draw()
    frog:draw()
    love.graphics.pop()
end

function BeginContact(a, b, collision)
    physicker:beginContact(a, b, collision)
    frog:beginContact(a, b, collision)
end

function EndContact(a, b, collision)
    physicker:endContact(a, b, collision)
    frog:endContact(a, b, collision)
end

return nav_scene
