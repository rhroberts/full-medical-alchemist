local scene = require"scene"
local peachy = require"3rd.peachy"
local physicker = require"characters.physicker"
local cat = require"characters.cat"
local patient = require"characters.patient"
local music = require"audio.music"
local tiled = require"utils.tiled"
local tilemap = require"assets.map.map"

local enterPatientsScene = scene:new("enter_patients")
local accumulator = 0.0
local complete = 0

function enterPatientsScene:load()
    -- Load map file
    World = love.physics.newWorld(0, 0)
    Colliders = tiled.newColliderGroup(World, tilemap, "Colliders")

    physicker:load()
    cat:load()
    local patients = {1, 2, 3, 4}
    shuffle(patients)
    local delays = {0.0, 3.0, 6.0, 9.0}
    shuffle(delays)
    -- I have no idea why I have to pass delay into patient:load as well here... 
    -- it appears to overwrite whats assigned in patient:new if I dont.
    p1 = patient:new(patients[1], 1, delays[1])
    p1:load(delays[1])
    p2 = patient:new(patients[2], 2, delays[2])
    p2:load(delays[2])
    p3 = patient:new(patients[3], 3, delays[3])
    p3:load(delays[3])
    p4 = patient:new(patients[4], 4, delays[4])
    p4:load(delays[4])
    -- Load beds
    Beds = {
        blue_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Blue_Unoccupied"),
        blue_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Blue_Occupied"),
        red_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Red_Unoccupied"),
        red_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Red_Occupied"),
        green_unoc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Green_Unoccupied"),
        green_oc = peachy.new("assets/map/furniture/bed_cover.json", love.graphics.newImage("assets/map/furniture/bed_cover.png"), "Green_Occupied"),
    }
    -- tunez
    NavTheme = music:load("assets/audio/music/navigation_scene.ogg", "static")
end

function shuffle(t)
    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end


function enterPatientsScene:update(dt, gamestate)
    World:update(dt)
    physicker:update(dt)
    physicker.locked = true
    cat:update(dt)
    p1:update(dt)
    p2:update(dt)
    p3:update(dt)
    p4:update(dt)

    -- Enter Patient 1
    if accumulator > p1.delay then
        if accumulator-p1.delay < 1.9 then
            p1.y = p1.y - p1.vel * dt
            p1.animationName = "walk_bwd"
        elseif accumulator-p1.delay < 3.0 then
            p1.animationName = "idle_bwd"
            p1.speak = true
        elseif accumulator-p1.delay < 4.1 then
            p1.x = p1.x + p1.vel * dt
            p1.animationName = "walk_side"
            p1.xDir = 1
            p1.xShift = 0
            p1.speak = false
        elseif accumulator-p1.delay < 5.15 then
            p1.y = p1.y - p1.vel * dt
            p1.animationName = "walk_bwd"
            if p1.y < 23.0 then
                p1.y = 23.0
            end
        elseif accumulator-p1.delay < 6.27 then
            -- Correct undershoot
            if p1.y > 23.0 then
                p1.y = 23.0
            end
            p1.x = p1.x + p1.vel * dt
            p1.animationName = "walk_side"
            p1.xDir = 1
            p1.xShift = 0
            -- Prevent overshoot
            if p1.x > 223.0 then
                p1.x = 223.0
            end
        else
            -- Correct undershoot
            if p1.x < 223.0 then
                p1.x = 223.0
            end
            p1.animationName = "idle_fwd"
            complete_1 = true
            -- Ensure proper ending spot
            p1.x = 223.0
            p1.y = 23.0
        end
    end
    

    -- Enter Patient 2
    if accumulator > p2.delay then
        if accumulator-p2.delay < 1.9 then
            p2.y = p2.y - p2.vel * dt
            p2.animationName = "walk_bwd"
        elseif accumulator-p2.delay < 3.0 then
            p2.animationName = "idle_bwd"
            p2.speak = true
        elseif accumulator-p2.delay < 4.1 then
            p2.x = p2.x + p2.vel * dt
            p2.animationName = "walk_side"
            p2.xDir = 1
            p2.xShift = 0
            p2.speak = false
        elseif accumulator-p2.delay < 5.2 then
            p2.y = p2.y + p2.vel * dt
            p2.animationName = "walk_fwd"
            -- Prevent overshoot
            if p2.y > 130.0 then
                p2.y = 130.0
            end
        elseif accumulator-p2.delay < 6.28 then
            -- Correct undershoot
            if p2.y < 130.0 then
                p2.y = 130.0
            end
            p2.x = p2.x + p2.vel * dt
            p2.animationName = "walk_side"
            p2.xDir = 1
            p2.xShift = 0
            -- Prevent overshoot
            if p2.x > 221.0 then
                p2.x = 221.0
            end
        else
            -- Correct undershoot
            if p2.x < 221.0 then
                p2.x = 221.0
            end
            p2.animationName = "idle_fwd"
            complete_2 = true
            -- Ensure proper ending spot
            p2.x = 221.0
            p2.y = 130.0
        end
    end
    

    -- Enter Patient 3
    if accumulator > p3.delay then
        if accumulator-p3.delay < 1.9 then
            p3.y = p3.y - p3.vel * dt
            p3.animationName = "walk_bwd"
        elseif accumulator-p3.delay < 3.0 then
            p3.animationName = "idle_bwd"
            p3.speak = true
        elseif accumulator-p3.delay < 3.3 then
            p3.y = p3.y - p3.vel * dt
            p3.animationName = "walk_bwd"
            p3.speak = false
        elseif accumulator-p3.delay < 4.5 then
            p3.x = p3.x - p3.vel * dt
            p3.animationName = "walk_side"
            p3.xDir = -1
            p3.xShift = p3.animation[p3.animationName]:getWidth()
        elseif accumulator-p3.delay < 5.175 then
            p3.y = p3.y + p3.vel * dt
            p3.animationName = "walk_fwd"
            -- Prevent overshoot
            if p3.y > 95.0 then
                p3.y = 95.0
            end
        elseif accumulator-p3.delay < 5.882 then
            -- Correct undershoot
            if p3.y < 95.0 then
                p3.y = 95.0
            end
            p3.x = p3.x - p3.vel * dt
            p3.animationName = "walk_side"
            p3.xDir = -1
            p3.xShift = p3.animation[p3.animationName]:getWidth()
            -- Prevent overshoot
            if p3.x < 16.0 then
                p3.x = 16.0
            end
        else
            -- Correct undershoot
            if p3.x > 16.0 then
                p3.x = 16.0
            end
            p3.animationName = "idle_fwd"
            complete_3 = true
            -- Ensure proper ending spot
            p3.x = 16.0
            p3.y = 95.0
        end
    end
    

    -- Enter Patient 4
    if accumulator > p4.delay then
        if accumulator-p4.delay < 1.9 then
            p4.y = p4.y - p4.vel * dt
            p4.animationName = "walk_bwd"
        elseif accumulator-p4.delay < 3.0 then
            p4.animationName = "idle_bwd"
            p4.speak = true
        elseif accumulator-p4.delay < 3.3 then
            p4.y = p4.y - p4.vel * dt
            p4.animationName = "walk_bwd"
            p4.speak = false
        elseif accumulator-p4.delay < 4.5 then
            p4.x = p4.x - p4.vel * dt
            p4.animationName = "walk_side"
            p4.xDir = -1
            p4.xShift = p4.animation[p4.animationName]:getWidth()
        elseif accumulator-p4.delay < 5.975 then
            p4.y = p4.y + p4.vel * dt
            p4.animationName = "walk_fwd"
            -- Prevent overshoot
            if p4.y > 134.0 then
                p4.y = 134.0
            end
        elseif accumulator-p4.delay < 6.685 then
            -- Correct undershoot
            if p4.y < 134.0 then
                p4.y = 134.0
            end
            p4.x = p4.x - p4.vel * dt
            p4.animationName = "walk_side"
            p4.xDir = -1
            p4.xShift = p4.animation[p4.animationName]:getWidth()
            -- Prevent overshoot
            if p4.x < 16.0 then
                p4.x = 16.0
            end
        else
            -- Correct undershoot
            if p4.x > 16.0 then
                p4.x = 16.0
            end
            p4.animationName = "idle_fwd"
            complete_4 = true
            -- Ensure proper ending spot
            p4.x = 16.0
            p4.y = 134.0
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
end

return enterPatientsScene

