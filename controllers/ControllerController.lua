local ControllerController = Class("ControllerController")

function ControllerController:initialize()
	local joysticks = love.joystick.getJoysticks()
	for i, joystick in ipairs(joysticks) do
		print(joystick:getName())
	end
	self.joystick = joysticks[1]
end

function ControllerController:jump()
	if self.joystick:isGamepadDown("a") then
		print("JUMPING!!!")
	end
end

function love.gamepadpressed(joystick, button)
	print("Joystick: "..joystick:getName()..", Button: "..button)
end