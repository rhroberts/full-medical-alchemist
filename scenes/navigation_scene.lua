local peachy = require"3rd.peachy"
local scene = require"scene"
local tiled = require"utils.tiled"
local tilemap = require"assets.map.map"
local physicker = require"characters.physicker"
local frog = require"characters.frog"
local cat = require"characters.cat"
local textbox = require"ui.textbox"
local music = require"audio.music"

local navigation_scene = scene:new("navigation")
local font = love.graphics.newFont("assets/fonts/pixeldroidMenuRegular.ttf", 16)

function navigation_scene:load()
    -- Load map file
    Background = love.graphics.newImage("assets/map/background.png")
    World = love.physics.newWorld(0, 0)
    Colliders = tiled.newColliderGroup(World, tilemap, "Colliders")

    physicker:load()
    frog:load()
    cat:load()

    -- Load beds
    Beds = {
        blue_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Blue_Unoccupied"),
        blue_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Blue_Occupied"),
        red_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Red_Unoccupied"),
        red_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Red_Occupied"),
        green_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Green_Unoccupied"),
        green_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Green_Occupied"),
    }

    -- add an example text box
    Greeting = textbox(
[[Oh no! We couldn't finish our  game! We hope you faired better. Happy LD49 : )
PS: Try pressing 'y' and 'u'.]]
    )
    Greeting.load()
    -- tunez
    NavTheme = music:load("assets/audio/music/navigation_scene.ogg", "static")
end
  

function navigation_scene:update(dt, gamestate)
    World:update(dt)
    physicker:update(dt)
    physicker.locked = false
    frog:update(dt)
    cat:update(dt)
    p1:update(dt)
    p2:update(dt)
    p3:update(dt)
    p4:update(dt)
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
    love.graphics.draw(Background)
    physicker:draw()
    frog:draw()
    cat:draw()
    p1:draw()
    p2:draw()
    p3:draw()
    p4:draw()
    -- Draw beds
    if complete_1 then
        Beds["green_oc"]:draw(223.0-Beds["green_oc"]:getWidth()/2,
                              25.0-Beds["green_oc"]:getHeight()/2)
    else
        Beds["green_unoc"]:draw(223.0-Beds["green_unoc"]:getWidth()/2,
                                25.0-Beds["green_unoc"]:getHeight()/2)
    end
    if complete_2 then
        Beds["green_oc"]:draw(221.0-Beds["green_oc"]:getWidth()/2,
                                132.0-Beds["green_oc"]:getHeight()/2)
    else
        Beds["green_unoc"]:draw(221.0-Beds["green_unoc"]:getWidth()/2,
                                132.0-Beds["green_unoc"]:getHeight()/2)
    end
    if complete_3 then
        Beds["blue_oc"]:draw(16.0-Beds["blue_oc"]:getWidth()/2,
                             97.0-Beds["blue_oc"]:getHeight()/2)
    else
        Beds["blue_unoc"]:draw(16.0-Beds["blue_unoc"]:getWidth()/2,
                               97.0-Beds["blue_unoc"]:getHeight()/2)
    end
    if complete_4 then
        Beds["red_oc"]:draw(16.0-Beds["red_oc"]:getWidth()/2,
                            136.0-Beds["red_oc"]:getHeight()/2)
    else
        Beds["red_unoc"]:draw(16.0-Beds["red_unoc"]:getWidth()/2,
                              136.0-Beds["red_unoc"]:getHeight()/2)
    end
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

-- function BeginContact(a, b, collision)
--     physicker:beginContact(a, b, collision)
--     frog:beginContact(a, b, collision)
--     cat:beginContact(a, b, collision)
-- end
-- 
-- function EndContact(a, b, collision)
--     physicker:endContact(a, b, collision)
--     frog:endContact(a, b, collision)
--     cat:endContact(a, b, collision)
-- end

return navigation_scene
