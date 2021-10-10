local scene = require "scene"

local sti = require "3rd/sti/sti"
local physicker = require"physicker"
local frog = require"frog"
local cat = require"cat"
local patient = require"patient"
local textbox = require"textbox"
local utils = require"utils"
local peachy = require("3rd/peachy/peachy")

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

    -- Load beds
    beds = {
        blue_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Blue_Unoccupied"),
        blue_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Blue_Occupied"),
        red_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Red_Unoccupied"),
        red_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Red_Occupied"),
        green_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Green_Unoccupied"),
        green_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Green_Occupied"),
    }

    -- Load controls
    self.controls = peachy.new("assets/ui/controls.json", love.graphics.newImage("assets/ui/controls.png"), "Idle")
    self.e = peachy.new("assets/ui/keys.json", love.graphics.newImage("assets/ui/keys.png"), "E")
    self.q = peachy.new("assets/ui/keys.json", love.graphics.newImage("assets/ui/keys.png"), "Q")
    self.esc = peachy.new("assets/ui/keys.json", love.graphics.newImage("assets/ui/keys.png"), "ESC")
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
    self.controls:update(dt)
    self.e:update(dt)
    self.q:update(dt)
    self.esc:update(dt)
end

function navigation_scene:draw(sx, sy)
    love.graphics.push()
    love.graphics.scale(sx, sy)
    Map:draw(0, 0, sx, sy)

    physicker:draw()
    frog:draw()
    cat:draw()
    p1:draw()
    p2:draw()
    p3:draw()
    p4:draw()
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
    -- Process pause event
    if pause then
        physicker.locked = true
        love.graphics.setColor(0, 0, 0, 0.80)
        love.graphics.rectangle("fill", 0, 0, WindowWidth, WindowHeight)
        love.graphics.setColor(1, 1, 1, 1)
        -- love.graphics.rectangle("fill", WindowWidth/4, WindowHeight/4, WindowWidth/2, WindowHeight/2)
        self.controls:draw(WindowWidth/2 - self.controls:getWidth()/2,
                           40,
                            0, sx, sy)
        love.graphics.print("Movement", WindowWidth/5, 90, 0, 2, 2)
        self.e:draw(WindowWidth/2 - self.controls:getWidth()/2,
                    180,
                    0, sx, sy)
        love.graphics.print("Interact", WindowWidth/5, 190, 0, 2, 2)
        self.q:draw(WindowWidth/2 - self.controls:getWidth()/2,
                    260,
                    0, sx, sy)
        love.graphics.print("Exit Interact", WindowWidth/5, 270, 0, 2, 2)
        self.esc:draw(WindowWidth/2 - self.controls:getWidth()/2,
                      340,
                      0, sx, sy)
        love.graphics.print("Pause", WindowWidth/5, 350, 0, 2, 2)
    else
        physicker.locked = false
    end
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
