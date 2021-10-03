-- a module for interactive textboxes!
local peachy = require"3rd/peachy/peachy"

local function textBox(text, font, fontSize, fontColor, sound)
    -- text is a string
    -- fontSize is a number (pixels)
    -- font color is an RGB table, e.g. {0, 1, 0} for the color green
    -- font from love.graphics.newFont
    -- sound from love.audio.newSource

    assert("You need to provide text for the textbox!")

    local bwidth, bheight = 150, 50
    local windowWidth, windowHeight = love.graphics.getWidth(), love.graphics.getHeight()
    local boxImagePath = "assets/ui/player_textbox.png"
    local arrowImagePath = "assets/ui/textbox_arrow.png"
    local arrowMetaPath = "assets/ui/textbox_arrow.json"

    local function numPages(_text, _fontSize, _boxWidth)
        -- figure out how many pages the text needs to fit
        return(math.floor(_fontSize * string.len(_text) / _boxWidth / 2))
    end

    local function sliceTextToPage(_text, _page, _charsPerPage)
        return(
            _text:sub(
                (_page - 1) * _charsPerPage,
                _page * _charsPerPage - 1
            )
        )
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
        boxHeight = bheight,
        fontSize = fontSize or 18,
        color = fontColor or {0, 0, 0},
        -- totalPages = ...
    }

    -- static assets
    local assets = {
        text = text,
        -- sound
        -- font
        -- boxImage
        arrowImg = love.graphics.newImage(arrowImagePath)
        -- arrowAnim
    }

    local function loadTextBox()
        attrs.charsPerPage = math.floor(bwidth / attrs.fontSize) * 3
        attrs.totalPages = numPages(assets.text, attrs.fontSize, attrs.boxWidth)
        assets.font = font or love.graphics.newFont(
            "assets/fonts/pixeldroidMenuRegular.ttf", attrs.fontSize
        )
        assets.boxImg = love.graphics.newImage(boxImagePath)
        assets.arrowAnim = peachy.new(arrowMetaPath, assets.arrowImg, "Idle")
    end

    local function drawTextBox(x, y)
        x = x or attrs.x
        y = y or attrs.y
        -- love.graphics.rectangle("fill", x, y, attrs.boxWidth, 50, 5, 5)
        love.graphics.draw(assets.boxImg, x, y)
        love.graphics.printf(
            {attrs.color, sliceTextToPage(assets.text, state.page, attrs.charsPerPage)},
            assets.font, x, y, attrs.boxWidth, "center"
        )
        if state.page ~= attrs.totalPages then
            assets.arrowAnim:draw(
                x + attrs.boxWidth - assets.arrowImg:getWidth() * 0.75,
                y + attrs.boxHeight - assets.arrowImg:getHeight() * 2
            )
        end
    end

    local function nextPage()
        if state.page < attrs.totalPages then
            state.page = state.page + 1
        end
    end

    local function updateTextBox(dt)
        assets.arrowAnim:update(dt)
    end

    function love.keypressed(key)
        if key == "e" then
            nextPage()
        end
    end

    return {
        load = loadTextBox,
        draw = drawTextBox,
        update = updateTextBox,
        nextPage = nextPage
    }
end

return textBox