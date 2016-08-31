local EnemyBase = Class("EnemyBase", Entity)

local vector = require 'hump.vector-light'

function EnemyBase:initialize(x, y, scene)
	Entity.initialize(self,x,y,scene)
	self.dx = 0
	self.dy = 0
	self.destroyed = false
end



function EnemyBase:distanceTo(obj)
	return vector.len(self.x-obj.x, self.y-obj.y)
end

function EnemyBase:distanceToPlayer()
	return self:distanceTo(self.scene.player)
end

function EnemyBase:destroy()
	if false == self.destroyed then
		self.destroy_tween = 1
		self.destroyed = true
		Timer.tween(1, self, {destroy_tween = 0}, 'in-back', function() self:kill() end)
	end
end

return EnemyBase
