local sti = require"3rd.sti.sti"
local peachy = require"3rd.peachy"
local scene = require"scene"
local physicker = require"characters.physicker"
local borked = require"characters.borked_patient"
local textbox = require"ui.textbox"
local music = require"audio.music"

local navigation_scene = scene:new("navigation")
local font = love.graphics.newFont("assets/fonts/pixeldroidMenuRegular.ttf", 16)
local frog = borked:new(
    50, 50, 50,
    "assets/sprites/patients/frog.png",
    "assets/sprites/patients/frog.json",
    "y"
)
local cat = borked:new(
    200, 100, 50,
    "assets/sprites/patients/cat.png",
    "assets/sprites/patients/cat.json",
    "u"
)
-- create beds
local beds = {
    blue_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Blue_Unoccupied"),
    blue_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Blue_Occupied"),
    red_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Red_Unoccupied"),
    red_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Red_Occupied"),
    green_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Green_Unoccupied"),
    green_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Green_Occupied"),
}

function navigation_scene:load()
    -- Load map file
    Map = sti("assets/map/map_v2.lua", {"box2d"})
    Map:box2d_init(World)
    Map.layers.Walls.visible = false

    physicker:load()
    frog:load()
    cat:load()

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
    P1:update(dt)
    P2:update(dt)
    P3:update(dt)
    P4:update(dt)
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
    P1:draw()
    P2:draw()
    P3:draw()
    P4:draw()
    -- Draw beds
    if complete_1 then
        beds["green_oc"]:draw(223.0-beds["green_oc"]:getWidth()/2,
                              25.0-beds["green_oc"]:getHeight()/2)
    else
        beds["green_unoc"]:draw(223.0-beds["green_unoc"]:getWidth()/2,
                                25.0-beds["green_unoc"]:getHeight()/2)
    end
    if complete_2 then
        beds["green_oc"]:draw(221.0-beds["green_oc"]:getWidth()/2,
                                132.0-beds["green_oc"]:getHeight()/2)
    else
        beds["green_unoc"]:draw(221.0-beds["green_unoc"]:getWidth()/2,
                                132.0-beds["green_unoc"]:getHeight()/2)
    end
    if complete_3 then
        beds["blue_oc"]:draw(16.0-beds["blue_oc"]:getWidth()/2,
                             97.0-beds["blue_oc"]:getHeight()/2)
    else
        beds["blue_unoc"]:draw(16.0-beds["blue_unoc"]:getWidth()/2,
                               97.0-beds["blue_unoc"]:getHeight()/2)
    end
    if complete_4 then
        beds["red_oc"]:draw(16.0-beds["red_oc"]:getWidth()/2,
                            136.0-beds["red_oc"]:getHeight()/2)
    else
        beds["red_unoc"]:draw(16.0-beds["red_unoc"]:getWidth()/2,
                              136.0-beds["red_unoc"]:getHeight()/2)
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

return navigation_scene
