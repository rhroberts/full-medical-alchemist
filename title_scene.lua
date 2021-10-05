local peachy = require"3rd/peachy/peachy"
local scene = require"scene"

local titleScene = scene:new("titleScene")

function titleScene:load()
    self.SpriteSheet = love.graphics.newImage("assets/ui/title_screen.png")
    self.SpriteSheetMeta = "assets/ui/title_screen.json"
    self.animation = peachy.new(self.SpriteSheetMeta, self.SpriteSheet, "Default")
    self.startInstructions = {
        text = "Press [enter] to start!",
        font = love.graphics.newFont("assets/fonts/pixeldroidMenuRegular.ttf", 24)
    }
    self.titleTheme = love.audio.newSource("assets/audio/music/title_scene.ogg", "static")
end

function titleScene:update(dt, gameState)
    self.animation:update(dt)

    print(self.titleTheme:isPlaying())
    if not self.titleTheme:isPlaying() then
        self.titleTheme:play()
    end
    if love.keyboard.isDown("return") then
        if self.titleTheme:isPlaying() then
            local fade = 150
            for i=1, fade do
                self.titleTheme:setVolume(1 - i / fade)
                love.timer.sleep(0.01)
            end
            self.titleTheme:stop()
        end
        gameState:setNavigationScene()
    end
end

function titleScene:draw(sx, sy)
    love.graphics.push()
    love.graphics.scale(sx, sy)
    self.animation:draw()
    love.graphics.pop()
    love.graphics.printf(
        {{0, 0, 0}, self.startInstructions.text},
        self.startInstructions.font,
        WindowWidth - 120,
        WindowHeight - 90, 5 * string.len(self.startInstructions.text),
        "center"
    )
end

return titleScene