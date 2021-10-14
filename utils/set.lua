-- building blocks for a basic set implementation
local set = {
    _items = {}
}

function set:add(item)
    self._items[item] = true
end

function set:addMany(t)
    assert(type(t) == "table", "Argument must be a table!")
    for _, val in pairs(t) do
        self:add(val)
    end
end

function set:remove(item)
    self._items[item] = nil
end

function set:removeMany(t)
    assert(type(t) == "table", "Argument must be a table!")
    for _, val in pairs(t) do
        self:remove(val)
    end
end

function set:contains(item)
    return self._items[item] ~= nil
end

function set:new(t)
    if t then
        assert(type(t) == "table", "Argument must be a table!")
    end

    -- function used when `print(set)` is called
    local function toString()
        local str, first = "{ ", true
        for key, _ in pairs(self._items) do
            if first then
                str = str .. tostring(key)
                first = false
            else
                str = str .. ", " .. tostring(key)
            end
        end
        str = str .. " }"
        return str
    end

    self:addMany(t or {})
    self.__index = self
    self.__tostring = toString
    return setmetatable({}, self)
end

return set