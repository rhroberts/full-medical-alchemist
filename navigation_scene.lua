Scene = require "scene"

local sti = require "3rd/sti/sti"
local physicker = require"physicker"
local frog = require"frog"
local textbox = require"textbox"

local navigation_scene = Scene:new("navigation")

function navigation_scene:load() 
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
    Greeting.load()
end

function navigation_scene:update(dt, gamestate)
    World:update(dt)
    physicker:update(dt)
    frog:update(dt)
    if love.keyboard.isDown("e") then
        gamestate:setAlchemyScene()
    end
    Greeting.update(dt)
end

function navigation_scene:draw(sx, sy)
    love.graphics.push()
    love.graphics.scale(sx, sy)
    Map:draw(0, 0, sx, sy)
    physicker:draw()
    frog:draw()
    love.graphics.pop()
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

return navigation_scene
