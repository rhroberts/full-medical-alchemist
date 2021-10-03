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
    Greeting = textbox("move around, bro")
    Greeting:load()
end

function nav_scene:update(dt)
    World:update(dt)
    physicker:update(dt)
    frog:update(dt)
end

function nav_scene:draw()
    Map:draw(0, 0, 3, 3)
    -- Map:box2d_draw(0, 0, 3, 3)
    physicker:draw()
    frog:draw()
    Greeting.draw()
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
