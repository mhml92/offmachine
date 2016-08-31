local Main = Class("Main", Scene)

function Main:initialize()
	Scene:initialize()
	self.stars_map = resmgr:getImg("stars.png")
end

function Main:defineLayers()
	self:addLayer("bg")
	self:addLayer("objects")
end

function Main:update(dt)
	Scene.update(self, dt)
end

function Main:draw()
	Scene.draw(self)
	love.graphics.draw(self.stars_map, 0, 0, 0, 2, 2)
end


function Main:gamepadpressed(joystick,button)
	Scene.gamepadpressed(self,joystick,button)
end

function Main:keypressed( key,scancode,isrepeat )
	Scene.keypressed(self,key,scancode,isrepeat)
end

function Main:keyreleased(key,scancode)
	Scene.keyreleased(self,key,scancode)
end

return Main