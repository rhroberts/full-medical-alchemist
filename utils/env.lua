--[[
    Utils for environment variables

    For development, it is nice to be able to skip to a particular scene,
    or turn off the music, etc. Setting environment variables outside of
    the code itself seems like a clean way to handle this.
]]
local privacy = require"utils.privacy"
local set = require"utils.set"

-- available environment variables
local availEnvVars = {
    "FMA_PROD",   -- bool: if true, no other env vars will be used
    "FMA_SCENE",  -- string: name of scene to begin game on
    "FMA_MUSIC",  -- bool: whether to play game music
}

-- Get any relevant OS environment variables
local function getEnv()
    -- in "production", i.e. normal gameplay,
    -- don't use any existing env vars for FMA
    if string.lower(os.getenv("FMA_PROD") or "") == "prod" then
        return privacy.readOnly{}
    end

    local env = {}
    for _, var in pairs(availEnvVars) do
        env[var] = os.getenv(var)
    end

    -- return a readonly table of env vars and their values
    ---return privacy.readOnly(env)
    return privacy.readOnly(env)
end

return getEnv()