local MouseController = Class("MouseController")

function MouseController:initialize()
end

function MouseController:jump()
	if love.mouse.isDown(1) then
		print("JUMPING!!!")
	end
end

function love.mousepressed(x, y, button, istouch)
	print("Mouse, Button: "..button)
end

return MouseController