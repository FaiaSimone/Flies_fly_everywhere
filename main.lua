--Test di gioco con interfaccia e meccanica semplice
--Utilizza piccolo framework per menù iniziale
--Variabili
local menuengine = require "menuengine"
local settings = require("menuengine")
local text = "Nothing was selected"
local mouse_X = 0
local mouse_y = 0
local keyPress = "None"
local gameStart = false
local optionMenu = false
local mainmenu
--Implementazione bottoni custom
function love.mousepressed(x, y, button, istouch)
    if button == 1 then --checks which button was pressed, refer to [url=https://love2d.org/wiki/love.mousepressed]wiki[/url]
        if x >= 1080 and x <= 1080 + 80 and y >= 540 and y <= 540 + 20 then
            love.window.setMode(640, 480)
        end
    end
end

function love.fpsChange(x, y, button, istouch)
    if button == 1 then --checks which button was pressed, refer to [url=https://love2d.org/wiki/love.mousepressed]wiki[/url]
        if x >= 1100 and x <= 1100 + 80 and y >= 600 and y <= 600 + 20 then
            min_dt = 1/30 --fps
        end
    end
end
--Queste tre funzioni riguardano il menù iniziale
local function start_game()
    text = "Start selected"
    gameStart = true
end

local function options()
    text = "Options selected!"
    optionMenu = true
end

local function quit()
    text = "Quit selected!"
    love.event.quit()
end
--Queste tre funzioni riguardano le impostazioni
local function Resolution()
    text = "Resolution changed"
    -- oltre alla risoluzione aggiungere v-sinc e fullscreen
    -- la risoluzione cambia ma non è responsive da implementare
    love.mousepressed(1080,540)
    -- res_2 = love.window.setMode(1280,720)
    -- res_3 = love.window.setMode(1920,1080)
end

local function FPS()
    text = "FPS cap changed"
    love.mousepressed(1100,600)
end

local function Back()
    text = "Back to menù"
    
end

--Qui la schermata di gioco viene caricata
function love.load()
    love.window.setMode(1920,1080)
    love.graphics.setFont(love.graphics.newFont(20))
    min_dt = 1/60 --fps
    next_time = love.timer.getTime()
    
    mainmenu = menuengine.new(960,540)
    mainmenu:addEntry("Start game",start_game)
    mainmenu:addEntry("Options", options)
    mainmenu:addSep()
    mainmenu:addEntry("Quit", quit)

    settings = menuengine.new(960,540)
    settings:addEntry("Resolution : ",Resolution)
    settings:addSep()
    settings:addEntry("FPS: ", FPS)
    settings:addSep()
    settings:addEntry("Back", Back)

    x = 100
    
end

function love.update(dt)
    --Posizione mouse su schermo
    mouse_X = love.mouse.getX()
    mouse_y = love.mouse.getY()
    --Implementazione lock 60 fps
    next_time = next_time + min_dt
    FPS = love.timer.getFPS()
    if gameStart then
        x = x + 5
    elseif optionMenu then
        settings:update()
    else
        mainmenu:update()
    end

end

function love.draw()
    love.graphics.clear()
    love.graphics.print(text)
    love.graphics.print(FPS,0,30)
    love.graphics.print(mouse_X,0,60)
    love.graphics.print(mouse_y,75,60)

    local cur_time = love.timer.getTime()
   if next_time <= cur_time then
      next_time = cur_time
      return
   end
   love.timer.sleep(next_time - cur_time)
   
    if gameStart then
        love.graphics.rectangle("line", x, 50, 200, 150)
    elseif optionMenu then
        settings:draw()
        --Bottone risoluzione 640x480 non è responsive
        love.graphics.rectangle("line", 1080, 540, 80, 20)
        love.graphics.rectangle("line", 1100, 600, 80, 20)
    else
        mainmenu:draw()
    end
    -- love.graphics.print(keyPress,0,60)
end

function love.keypressed(key, scancode, isrepeat)
    menuengine.keypressed(scancode)

    if scancode == "escape" then
        love.event.quit()
    end
end

function love.mousemoved(x, y, dx, dy, istouch)
    menuengine.mousemoved(x, y)
end