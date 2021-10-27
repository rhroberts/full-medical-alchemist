--[[
    Utils for environment variables

    For development, it is nice to be able to skip to a particular scene,
    or turn off the music, etc. Setting environment variables outside of
    the code itself seems like a clean way to handle this.

    TODO: enforce the options parameter in getEnv()
]]
local privacy = require"utils.privacy"
local set = require"utils.set"

local envVars = {
    FMA_PROD = {
        name = "FMA_PROD",
        type = "boolean",
        options = set:new{true, false},
        default = false,
        description = "If `true`, ignore all other environment variables. This is 'normal' gameplay."
    },
    FMA_MUSIC = {
        name = "FMA_MUSIC",
        type = "boolean",
        options = set:new{true, false},
        default = true,
        description = "Whether or not to play game music."
    },
    FMA_SCENE = {
        name = "FMA_SCENE",
        type = "string",
        options = set:new{
            "TitleScene", "EnterPatientsScene", "NavigationScene", "AlchemyScene"
        },
        default = "TitleScene",
        description = "Which scene to start the game on."
    },
    FMA_DEBUG = {
        name = "FMA_DEBUG",
        type = "boolean",
        options = set:new{true, false},
        default = false,
        description = "Enable some debugging features."
    },
}

local function stringToBool(s)
    s = string.lower(s)
    if s == "true" then
        return true
    elseif s == "false" then
        return false
    end
end

-- Get environment variable values from OS, add to envVars table
local function getEnv()
    for _, var in pairs(envVars) do
        local ev = os.getenv(var.name)
        if not ev then
            var.value = var.default
        elseif var.type == "boolean" then
           var.value = stringToBool(ev)
        else
            var.value = ev
        end
    end

    -- return a readonly table of env vars (or empty table for production environment)
    if envVars.FMA_PROD.value then
        return privacy.readOnly{}
    end
    return privacy.readOnly(envVars)
end

return getEnv()