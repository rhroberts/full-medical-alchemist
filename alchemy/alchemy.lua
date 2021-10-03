json = require("../3rd/json/json")

local Alchemy = {}
local AlchemicalIngredient = {}
local AlchemicalConcoction = {
    shader = love.graphics.newShader("alchemy/humor.frag")
}

function Alchemy:load() 
    self.ingredients = self.load_ingredients()
    self.concoctions = self.load_concoctions()
end


function Alchemy:load_ingredients()
    local f = assert(io.open("alchemy/ingredients.json", "rb"))
    local ingredients_json = f:read("*all")
    f:close()

    local ingredients = json.decode(ingredients_json)

    -- iterate through table and read in assets, set draw prototype
    for k, v in pairs(ingredients) do
        ingredients[k].sprite = love.graphics.newImage(v.relative_sprite_path)
        setmetatable(ingredients[k], {__index = AlchemicalIngredient})
    end

    return ingredients
end

function Alchemy:load_concoctions()
    local f = assert(io.open("alchemy/concoctions.json", "rb"))
    local concoctions_json = f:read("*all")
    f:close()

    local concoctions = json.decode(concoctions_json)


    for k, v in pairs(concoctions) do
        concoctions[k].sprite = love.graphics.newImage(v.relative_sprite_path)
        concoctions[k].sprite_mask = love.graphics.newImage(v.relative_mask_texture_path)
        setmetatable(concoctions[k], {__index = AlchemicalConcoction})
    end

    return concoctions
end

function Alchemy:get_ingredient(name)
    -- introduce some randomness?
    local new = {}
    setmetatable(new, {__index = self.ingredients[name]})
    return new
    -- return self.ingredients[name]
end

function Alchemy:get_concoction(name, properties)
    local new = {}
    setmetatable(new, {__index = self.concoctions[name]})
    new.base_properties = {
        blood = properties.blood,
        yellow_bile = properties.yellow_bile,
        black_bile = properties.black_bile,
        phlegm = properties.phlegm
    }
    return new
end


function AlchemicalIngredient:draw(x, y)
    love.graphics.draw(self.sprite, x, y)
end


function AlchemicalConcoction:draw(x, y)
    love.graphics.setShader(self.shader)
    self.shader:send("blood", self.base_properties.blood)
    love.graphics.draw(self.sprite, x, y)
    love.graphics.setShader() -- unset?
end


function Alchemy:mix_two(one, two)
    -- salve_propensity = one.concoction_propensities.salve + two.concoction_propensities.salve

    -- assume salve. mix effects
    result = self:get_concoction("salve", {
        blood = one.base_properties.blood + two.base_properties.blood,
        yellow_bile = one.base_properties.yellow_bile + two.base_properties.yellow_bile,
        black_bile = one.base_properties.black_bile + two.base_properties.black_bile,
        phlegm = one.base_properties.phlegm + two.base_properties.phlegm
    })
    
    return result
end


function Alchemy.mix_three(one, two, three)
    -- mix effects
    -- return new concoction based on propensities
end

return Alchemy
