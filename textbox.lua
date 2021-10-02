-- a module for interactive textboxes!

local function textBox(text, font, fontSize, fontColor, sound)
    -- text is a string
    -- fontSize is a number (pixels)
    -- font color is an RGB table, e.g. {0, 1, 0} for the color green
    -- font from love.graphics.newFont
    -- sound from love.audio.newSource

    local function numPages(_text, _fontSize, _boxWidth)
        -- figure out how many pages the text needs to fit
        return(math.ceil(_fontSize * string.len(_text) / _boxWidth))
    end

    if not text then
        error("You need to provide text for the textbox!")
    end

    local windowWidth, WindowHeight = love.graphics.getWidth(), love.graphics.getHeight()

    -- keep track of state
    local state = {
        page = 1,
    }

    -- attributes I don't expect to change after initializing object
    local attrs = {
        x = 0,
        y = 0,
        boxWidth = 300,  -- textbox width
        fontSize = fontSize or 24,
        color = fontColor or {1, 0, 0},
        -- totalPages = ...
    }

    -- static assets
    local assets = {
        text = text,
        sound = sound or nil,
        font = font or love.graphics.newFont("assets/fonts/pixeldroidMenuRegular.ttf", attrs.fontSize)
    }

    local function loadTextBox()
        attrs.totalPages = numPages(assets.text, attrs.fontSize, attrs.boxWidth)
    end

    local function drawTextBox(x, y)
        x = x or state.x
        x = y or state.y
        love.graphics.rectangle("line", x, y, attrs.boxWidth, 300, 5, 5)
        love.graphics.printf(
            {attrs.color, assets.text}, assets.font, x, y, attrs.boxWidth, "center"
        )
    end

    local function updateTextBox(dt)
    end

    print(numPages())

    return {
        load = loadTextBox,
        draw = drawTextBox,
        update = updateTextBox
    }
end

return textBox