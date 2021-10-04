-- nice-to-have functions
local pprint = require"3rd/pprint/pprint"

local function inSequence(val, seq)
    for _, v in pairs(seq) do
        if v == val then return true end
    end
    return false
end

local function randomlyOrderedSequence(n)
    math.randomseed(os.time())
    local i, seq = 1, {}
    while i < n do
        local val = math.random(1, n)
        if not inSequence(val, seq) then
            table.insert(seq, val)
        end
        print(#seq)
        i = #seq
    end
    return seq
end

return {
    inSequence = inSequence,
    randomlyOrderedSequence = randomlyOrderedSequence
}