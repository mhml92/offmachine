local Menu = Class("Menu", Scene)

function Menu:initialize()
	Scene:initialize()
end

local lg = love.graphics
function Menu:draw()
	Scene.draw(self)
	lg.print("MENU", 20, 20)
end

function Menu:gamepadpressed(joystick,button)
	Scene.gamepadpressed(self,joystick,button)
	StateManager.setScene("TestScene")
end

return Menu