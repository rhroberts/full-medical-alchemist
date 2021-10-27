-- Draws a grid over the window for debugging
local function debugGrid(i, j)
    local ww, wh = love.graphics.getDimensions()
    love.graphics.setColor(0,0,0, 0.2)
    for k = 1, i do
        for l = 1, j do
            love.graphics.rectangle("line", (k-1)*ww/i, (l-1)*wh/j, ww/i, wh/j)
        end
    end
    love.graphics.setColor(1,1,1,1)
end

return {
    debugGrid = debugGrid
}