local RocketLauncher = Class("RocketLauncher", Entity)

local RemoteRocket = require 'entities/RemoteRocket'

function RocketLauncher:initialize(scene)
	Entity.initialize(self,x,y,scene)

	self.rocket = nil

end

function RocketLauncher:update(dt)
	if self.rocket ~= nil then
		if not self.rocket.alive  then
			self.rocket = nil
		end
	end
end

function RocketLauncher:shoot(px,py,x,y,rot,momentum)
	if self.rocket == nil then
      self.rocket = self.scene:addEntity(RemoteRocket:new(px,py,x,y,rot,momentum,self.scene),self.scene.layers.objects)
	end
end


function RocketLauncher:draw()

end

return RocketLauncher
