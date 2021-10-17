-- a wrapper for playing music (not sound effects) that abstracts out any
-- non-game-related logic for playing or not playing music
-- For now, it just checks for the FMA_MUSIC envvar before playing
-- And doesn't yet wrap the whole of love.audio.Source

local music = {}

function music:load(filepath, audioType)
    local new = {
        source = love.audio.newSource(filepath, audioType)
    }
    setmetatable(new, {__index = self})
    return new
end

function music:play()
    if Env.FMA_MUSIC.value then
        self.source:play()
    end
end

function music:stop()
    self.source:stop()
end

function music:isPlaying()
    return self.source:isPlaying()
end

return music