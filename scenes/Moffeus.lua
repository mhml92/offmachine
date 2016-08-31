local Moffeus = Class("Moffeus", Scene)

local Stars = require "entities/Stars"

function Moffeus:initialize()
	Scene.initialize(self)
	
	self:addEntity(Stars:new(0,0,self), self.layers.bg)
end

function Moffeus:defineLayers()
	self:addLayer("bg")
end

function Moffeus:update(dt)
	Scene.update(self, dt)
end

function Moffeus:draw()
	Scene.draw(self)
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
