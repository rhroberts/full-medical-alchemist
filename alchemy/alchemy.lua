json = require("../3rd/json/json")

local Alchemy = {}
local AlchemicalIngredient = {}
local AlchemicalConcoction = {
    shader = love.graphics.newShader("humor.frag")
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
        -- os.execute("cd")
        print(v.relative_sprite_path)
        -- ingredients[k].sprite = love.graphics.newImage(v.relative_sprite_path)
        ingredients[k].sprite = love.graphics.newImage("assets/sprites/ingredients/lavender.png")
        setmetatable(ingredients[k], {__index = AlchemicalIngredient})
    end

    return ingredients
end

function Alchemy:load_concoctions()
    local f = assert(io.open("alchemy/concoctions.json", "rb"))
    local concotions_json = f:read("*all")
    f:close()

    local concoctions = json.decode(concoctions_json)

    for k, v in pairs(concoctions) do
        concoctions[k].sprite = love.graphics.Image()
        concoctions[k].sprite_mask = love.graphics.Image()
        setmetatable(concoctions[k], {__index = AlchemicalConcoction})
    end

    return concoctions
end

function Alchemy:get_ingredient(name)
    -- introduce some randomness?
    return self.ingredients[name]
end

function Alchemy:get_concoction(name)
    return self.concoctions[name]
end


function AlchemicalIngredient:draw(x, y)
    love.graphics.draw(this.sprite, x, y)
end


function AlchemicalConcoction:draw(x, y)
    love.graphics.setShader(self.shader)
    -- self.shader:send()
    love.graphics.draw(this.sprite, x, y)
    love.graphics.setShader() -- unset?
end


function Alchemy.mix_two(one, two)
    -- mix effects
    -- return new concoction based on propensities
end


function Alchemy.mix_three(one, two, three)
    -- mix effects
    -- return new concoction based on propensities
end

return Alchemy
