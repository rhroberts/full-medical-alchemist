local pprint = require"3rd/pprint"
local tilemap = require("assets/map/map_v2")

-- get collidable objects from tilemap
-- NOTE: should enforce layer name, but not 'Walls'
for _, layer in pairs(tilemap.layers) do
    if layer.name == "Walls" then
        Collidables = layer.objects
    end
end

assert(Collidables, "No collidable objects found!")

-- NOTE: need to create love.physics.body, ..shape, and ..fixtures for each
-- collidable I think

-- TODO: implement all the shapes supported bu both tiled and love.physics
local function newPolygonShape()
end

local function newRectangleShape()
end

local function newCircleShape()
end

pprint(Collidables)