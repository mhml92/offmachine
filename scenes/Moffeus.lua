local Moffeus = Class("Moffeus", Scene)

function Moffeus:initialize()
	Scene:initialize()
	self.stars_map = resmgr:getImg("stars.png")
end

function Moffeus:defineLayers()
	self:addLayer("bg")
	self:addLayer("objects")
end

function Moffeus:update(dt)
	Scene.update(self, dt)
end

function Moffeus:draw()
	Scene.draw(self)
	love.graphics.draw(self.stars_map, 0, 0, 0, 2, 2)
end


function Moffeus:gamepadpressed(joystick,button)
	Scene.gamepadpressed(self,joystick,button)
end

function Moffeus:keypressed( key,scancode,isrepeat )
	Scene.keypressed(self,key,scancode,isrepeat)
end

function Moffeus:keyreleased(key,scancode)
	Scene.keyreleased(self,key,scancode)
end

return Moffeus
