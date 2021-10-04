local scene = require "scene"

local sti = require "3rd/sti/sti"
local physicker = require"physicker"
local frog = require"frog"
local cat = require"cat"
local patient = require"patient"
local textbox = require"textbox"
local utils = require"utils"

local navigation_scene = scene:new("navigation")
local font = love.graphics.newFont("assets/fonts/pixeldroidMenuRegular.ttf", 16)

function navigation_scene:load()
    -- Load map file
    Map = sti("assets/map/map_test.lua", {"box2d"})
    World = love.physics.newWorld(0, 0)
    World:setCallbacks(BeginContact, EndContact)
    Map:box2d_init(World)
    Map.layers.Walls.visible = false

    physicker:load()
    frog:load()
    cat:load()
    -- p1:load()
    -- p2:load()
    -- p3:load()
    -- p4:load()


    -- add an example text box
    Greeting = textbox(
[[Oh no! We couldn't finish our  game! We hope you faired better. Happy LD49 : )
PS: Try pressing 'y' and 'u'.]]
    )
    Greeting.load()
    -- tunez
    NavTheme = love.audio.newSource("assets/audio/music/navigation_scene.ogg", "static")
end
  

function navigation_scene:update(dt, gamestate)
    World:update(dt)
    physicker:update(dt)
    frog:update(dt)
    cat:update(dt)
    -- p1:update(dt)
    -- p2:update(dt)
    -- p3:update(dt)
    -- p4:update(dt)
    if love.keyboard.isDown("e") then
        gamestate:setAlchemyScene()
    end
    if love.keyboard.isDown("t") then
        if NavTheme:isPlaying() then
            NavTheme:stop()
        end
        Greeting.resetTextBox()
        gamestate:setTitleScene()
        return
    end
    if not NavTheme:isPlaying() then
        NavTheme:play()
    end
    Greeting.update(dt)
end

function navigation_scene:draw(sx, sy)
    love.graphics.push()
    love.graphics.scale(sx, sy)
    Map:draw(0, 0, sx, sy)
    physicker:draw()
    frog:draw()
    cat:draw()
    -- p1:draw()
    -- p2:draw()
    -- p3:draw()
    -- p4:draw()
    love.graphics.pop()
    Greeting.draw()
    -- hardcode instruction cuz we're outta time
    local tShift = 300
    love.graphics.printf(
        {{0, 0, 0}, "Press 'e' to open your alchemy set"}, font,
        WindowWidth - tShift - 12, 0, tShift, "right"
    )
    love.graphics.printf(
        {{0, 0, 0}, "Press 'p' to page through text"}, font,
        WindowWidth - tShift - 12, 12, tShift, "right"
    )
    love.graphics.printf(
        {{0, 0, 0}, "Press 't' to return to title screen"}, font,
        WindowWidth - tShift - 12, 24, tShift, "right"
    )
end

function BeginContact(a, b, collision)
    physicker:beginContact(a, b, collision)
    frog:beginContact(a, b, collision)
    cat:beginContact(a, b, collision)
end

function EndContact(a, b, collision)
    physicker:endContact(a, b, collision)
    frog:endContact(a, b, collision)
    cat:endContact(a, b, collision)
end

return navigation_scene
