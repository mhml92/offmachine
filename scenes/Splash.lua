local Splash = Class("Splash", Scene)

local FM = require "managers/FontManager"

function Splash:initialize()
	Scene:initialize()
end

local lg = love.graphics
function Splash:draw()
	Scene.draw(self)
	local x, y = FM.getScreenCenteringCoordinates("Game Title", 0, 0)
	lg.print("Game Title", x, y)
end

function Splash:gamepadpressed(joystick,button)
	Scene.gamepadpressed(self,joystick,button)
	StateManager.setScene("Menu")
end

return Splash