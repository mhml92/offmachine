local KeyboardController = Class("KeyboardController")

function KeyboardController:initialize()
end

function KeyboardController:jump()
	if love.keyboard.isDown(" ") then
		print("JUMPING!!!")
	end
end

function love.keypressed(key, scancode, isrepeat)
	print("Keyboard, key: "..key)
end