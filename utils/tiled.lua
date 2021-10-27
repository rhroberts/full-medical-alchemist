local pprint = require"3rd.pprint"

local function newColliderGroup(world, tilemap, colliderLayer)
    --[[
        NOTE: I'm not sure how lua docstrings are meant to look yet

        Create the necessary shapes, bodies, and fixtures, and add them to the world
        Args:
            world [World]: A world object from love.physics.newWorld
            tilemap [table]: An exported tilemap from tiled (require the *.lua file)
            colliderLayer [string]: Name of the tiled layer with collidable objects
        Returns:
            colliderGroup [table]: A sequence of colliders (tables), each with a
                                   shape, body, and fixture
    ]]

    -- find collidable objects in tilemap
    local colliders
    for _, layer in pairs(tilemap.layers) do
        if layer.name == colliderLayer then
            colliders = layer.objects
        end
    end
    assert(colliders, "No collidable objects found!")
    -- create shapes, bodies, fixtures
    local colliderGroup = {}
    for _, collider in pairs(colliders) do
        local body = love.physics.newBody(
            world,
            collider.x + collider.width / 2,  -- origin at center of body
            collider.y + collider.height / 2,  -- origin at center of body
            "static"
        )
        local shape
        if collider.shape == "rectangle" then
            shape = love.physics.newRectangleShape(
                collider.width, collider.height
            )
        elseif collider.shape == "polygon" then
            local vertices = {}
            for _, xy in pairs(collider.polygon) do
                for _, i in pairs(xy) do
                    table.insert(vertices, i)
                end
            end
            shape = love.physics.newPolygonShape(vertices)
        else
            error("Collidable must be either a rectangle or polygon! (for now...)")
        end
        table.insert(
            colliderGroup, {
                shape = shape,
                body = body,
                -- not sure about the fixture density yet... set to 1 for now
                -- does it matter if it's a static body?
                fixture = love.physics.newFixture(body, shape)
            }
        )
    end
    return colliderGroup
end

local function drawColliders(colliderGroup)
    --[[
        For debugging purposes. Draw visible shapes corresponding to the
        colliders.
    ]]
    for _, collider in pairs(colliderGroup) do
        love.graphics.polygon("fill", collider.body:getWorldPoints(collider.shape:getPoints()))
    end
end

return {
    newColliderGroup = newColliderGroup,
    drawColliders = drawColliders,
}