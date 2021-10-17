-- utils for keeping it on the dl

-- make a table effectively "read-only"
local function readOnly(tbl)
    local mt = {
      __newindex = function ()
          error("Attempted to update a read-only table!", 2)
      end
    }
    setmetatable(tbl, mt)
    return tbl
end

return {
    readOnly = readOnly
}