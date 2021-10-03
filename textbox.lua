-- a module for interactive textboxes!

local function textBox(text, font, fontSize, fontColor, sound)
    -- text is a string
    -- fontSize is a number (pixels)
    -- font color is an RGB table, e.g. {0, 1, 0} for the color green
    -- font from love.graphics.newFont
    -- sound from love.audio.newSource

    local bwidth, bheight = 150, 50
    local windowWidth, windowHeight = love.graphics.getWidth(), love.graphics.getHeight()

    local function numPages(_text, _fontSize, _boxWidth)
        -- figure out how many pages the text needs to fit
        return(math.ceil(_fontSize * string.len(_text) / _boxWidth) / GlobalScale)
    end

    if not text then
        error("You need to provide text for the textbox!")
    end


    -- keep track of state
    local state = {
        page = 1,
    }

    -- attributes I don't expect to change after initializing object
    local attrs = {
        x = windowWidth - bwidth,
        y = windowHeight - bheight,
        boxWidth = bwidth,  -- textbox width
        fontSize = fontSize or 24,
        color = fontColor or {0, 0, 0},
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
        print(attrs.totalPages)
    end

    local function drawTextBox(x, y)
        x = x or attrs.x
        y = y or attrs.y
        love.graphics.rectangle("fill", x, y, attrs.boxWidth, 50, 5, 5)
        love.graphics.printf(
            {attrs.color, assets.text}, assets.font, x, y, attrs.boxWidth, "center"
        )
    end

    local function updateTextBox(dt)
    end

    return {
        load = loadTextBox,
        draw = drawTextBox,
        update = updateTextBox
    }
end

return textBox