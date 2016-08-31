local Main = Class("Main", Scene)

function Main:initialize()
	Scene:initialize()

end

function Main:defineLayers()
	self:addLayer("bg")
	self:addLayer("objects")
end

function Main:update(dt)
	Scene.update(dt)
end

function Main:draw()
	Scene.draw(self)
end


function Main:gamepadpressed(joystick,button)
	Scene.gamepadpressed(self,joystick,button)
end

function Main:keypressed( key,scancode,isrepeat )
	Scene.keypressed(self,key,scancode,isrepeat)
end

function TestScene:keyreleased(key,scancode)
	Scene.keyreleased(self,key,scancode)
end

return TestScene