local scene = require"scene"
local peachy = require"3rd.peachy"
local physicker = require"characters.physicker"
local patient = require"characters.patient"
local music = require"audio.music"
local tiled = require"utils.tiled"
local tilemap = require"assets.map.map"

local function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

local enterPatientsScene = scene:new("enter_patients")
local accumulator = 0.0

local patients = shuffle{1, 2, 3, 4}
local delays = shuffle{0.0, 3.0, 6.0, 9.0}
P1 = patient:new(patients[1], 1, delays[1])
P2 = patient:new(patients[2], 2, delays[2])
P3 = patient:new(patients[3], 3, delays[3])
P4 = patient:new(patients[4], 4, delays[4])
local complete_1, complete_2, complete_3, complete_4 = false, false, false, false
-- Create beds
Beds = {
    blue_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Blue_Unoccupied"),
    blue_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Blue_Occupied"),
    red_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Red_Unoccupied"),
    red_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Red_Occupied"),
    green_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Green_Unoccupied"),
    green_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Green_Occupied"),
}

function enterPatientsScene:load()
    -- Load map file
    Colliders = tiled.newColliderGroup(World, tilemap, "Colliders")

    physicker:load()
    -- I have no idea why I have to pass delay into patient:load as well here... 
    -- it appears to overwrite whats assigned in patient:new if I dont.
    P1:load(delays[1])
    P2:load(delays[2])
    P3:load(delays[3])
    P4:load(delays[4])
    -- tunez
    NavTheme = music:load("assets/audio/music/navigation_scene.ogg", "static")
end

function enterPatientsScene:update(dt, gamestate)
    World:update(dt)
    physicker:update(dt)
    physicker.locked = true
    P1:update(dt)
    P2:update(dt)
    P3:update(dt)
    P4:update(dt)

    -- Enter Patient 1
    if accumulator > P1.delay then
        if accumulator-P1.delay < 1.9 then
            P1.y = P1.y - P1.vel * dt
            P1.animationName = "walk_bwd"
        elseif accumulator-P1.delay < 3.0 then
            P1.animationName = "idle_bwd"
            P1.speak = true
        elseif accumulator-P1.delay < 4.1 then
            P1.x = P1.x + P1.vel * dt
            P1.animationName = "walk_side"
            P1.xDir = 1
            P1.xShift = 0
            P1.speak = false
        elseif accumulator-P1.delay < 5.15 then
            P1.y = P1.y - P1.vel * dt
            P1.animationName = "walk_bwd"
            if P1.y < 23.0 then
                P1.y = 23.0
            end
        elseif accumulator-P1.delay < 6.27 then
            -- Correct undershoot
            if P1.y > 23.0 then
                P1.y = 23.0
            end
            P1.x = P1.x + P1.vel * dt
            P1.animationName = "walk_side"
            P1.xDir = 1
            P1.xShift = 0
            -- Prevent overshoot
            if P1.x > 223.0 then
                P1.x = 223.0
            end
        else
            -- Correct undershoot
            if P1.x < 223.0 then
                P1.x = 223.0
            end
            P1.animationName = "idle_fwd"
            complete_1 = true
            -- Ensure proper ending spot
            P1.x = 223.0
            P1.y = 23.0
        end
    end
    

    -- Enter Patient 2
    if accumulator > P2.delay then
        if accumulator-P2.delay < 1.9 then
            P2.y = P2.y - P2.vel * dt
            P2.animationName = "walk_bwd"
        elseif accumulator-P2.delay < 3.0 then
            P2.animationName = "idle_bwd"
            P2.speak = true
        elseif accumulator-P2.delay < 4.1 then
            P2.x = P2.x + P2.vel * dt
            P2.animationName = "walk_side"
            P2.xDir = 1
            P2.xShift = 0
            P2.speak = false
        elseif accumulator-P2.delay < 5.2 then
            P2.y = P2.y + P2.vel * dt
            P2.animationName = "walk_fwd"
            -- Prevent overshoot
            if P2.y > 130.0 then
                P2.y = 130.0
            end
        elseif accumulator-P2.delay < 6.28 then
            -- Correct undershoot
            if P2.y < 130.0 then
                P2.y = 130.0
            end
            P2.x = P2.x + P2.vel * dt
            P2.animationName = "walk_side"
            P2.xDir = 1
            P2.xShift = 0
            -- Prevent overshoot
            if P2.x > 221.0 then
                P2.x = 221.0
            end
        else
            -- Correct undershoot
            if P2.x < 221.0 then
                P2.x = 221.0
            end
            P2.animationName = "idle_fwd"
            complete_2 = true
            -- Ensure proper ending spot
            P2.x = 221.0
            P2.y = 130.0
        end
    end
    

    -- Enter Patient 3
    if accumulator > P3.delay then
        if accumulator-P3.delay < 1.9 then
            P3.y = P3.y - P3.vel * dt
            P3.animationName = "walk_bwd"
        elseif accumulator-P3.delay < 3.0 then
            P3.animationName = "idle_bwd"
            P3.speak = true
        elseif accumulator-P3.delay < 3.3 then
            P3.y = P3.y - P3.vel * dt
            P3.animationName = "walk_bwd"
            P3.speak = false
        elseif accumulator-P3.delay < 4.5 then
            P3.x = P3.x - P3.vel * dt
            P3.animationName = "walk_side"
            P3.xDir = -1
            P3.xShift = P3.animation[P3.animationName]:getWidth()
        elseif accumulator-P3.delay < 5.175 then
            P3.y = P3.y + P3.vel * dt
            P3.animationName = "walk_fwd"
            -- Prevent overshoot
            if P3.y > 95.0 then
                P3.y = 95.0
            end
        elseif accumulator-P3.delay < 5.882 then
            -- Correct undershoot
            if P3.y < 95.0 then
                P3.y = 95.0
            end
            P3.x = P3.x - P3.vel * dt
            P3.animationName = "walk_side"
            P3.xDir = -1
            P3.xShift = P3.animation[P3.animationName]:getWidth()
            -- Prevent overshoot
            if P3.x < 16.0 then
                P3.x = 16.0
            end
        else
            -- Correct undershoot
            if P3.x > 16.0 then
                P3.x = 16.0
            end
            P3.animationName = "idle_fwd"
            complete_3 = true
            -- Ensure proper ending spot
            P3.x = 16.0
            P3.y = 95.0
        end
    end
    

    -- Enter Patient 4
    if accumulator > P4.delay then
        if accumulator-P4.delay < 1.9 then
            P4.y = P4.y - P4.vel * dt
            P4.animationName = "walk_bwd"
        elseif accumulator-P4.delay < 3.0 then
            P4.animationName = "idle_bwd"
            P4.speak = true
        elseif accumulator-P4.delay < 3.3 then
            P4.y = P4.y - P4.vel * dt
            P4.animationName = "walk_bwd"
            P4.speak = false
        elseif accumulator-P4.delay < 4.5 then
            P4.x = P4.x - P4.vel * dt
            P4.animationName = "walk_side"
            P4.xDir = -1
            P4.xShift = P4.animation[P4.animationName]:getWidth()
        elseif accumulator-P4.delay < 5.975 then
            P4.y = P4.y + P4.vel * dt
            P4.animationName = "walk_fwd"
            -- Prevent overshoot
            if P4.y > 134.0 then
                P4.y = 134.0
            end
        elseif accumulator-P4.delay < 6.685 then
            -- Correct undershoot
            if P4.y < 134.0 then
                P4.y = 134.0
            end
            P4.x = P4.x - P4.vel * dt
            P4.animationName = "walk_side"
            P4.xDir = -1
            P4.xShift = P4.animation[P4.animationName]:getWidth()
            -- Prevent overshoot
            if P4.x < 16.0 then
                P4.x = 16.0
            end
        else
            -- Correct undershoot
            if P4.x > 16.0 then
                P4.x = 16.0
            end
            P4.animationName = "idle_fwd"
            complete_4 = true
            -- Ensure proper ending spot
            P4.x = 16.0
            P4.y = 134.0
        end
    end
    

    accumulator = accumulator + dt

    if not NavTheme:isPlaying() then
        NavTheme:play()
    end
    if complete_1 and complete_2 and complete_3 and complete_4 then
        gamestate:setNavigationScene()
    end
end

function enterPatientsScene:draw(sx, sy)
    love.graphics.push()
    love.graphics.scale(sx, sy)
    love.graphics.draw(Background)
    physicker:draw()
    P1:draw()
    P2:draw()
    P3:draw()
    P4:draw()
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
end

return enterPatientsScene

