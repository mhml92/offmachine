local ControllerController = Class("ControllerController")

function ControllerController:initialize()
	local joysticks = love.joystick.getJoysticks()
	if joysticks ~= nil then
		for i, joystick in ipairs(joysticks) do
			print(i..": "..joystick:getName())
		end
		self.joystick = joysticks[2]
	end
end

function ControllerController:jump()
	if self.joystick:isGamepadDown("a") then
		print("JUMPING!!!")
	end
end

function love.gamepadpressed(joystick, button)
	print("Joystick: "..joystick:getName()..", Button: "..button)
end

return ControllerController